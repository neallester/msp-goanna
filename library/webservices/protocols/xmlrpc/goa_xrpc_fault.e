indexing
	description: "Objects that represent an XML-RPC fault."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "XML-RPC"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class GOA_XRPC_FAULT

inherit
	
	GOA_XRPC_ELEMENT
	
create
	
	make, make_with_detail, unmarshall
	
feature -- Initialisation

	make (new_code: INTEGER) is
			-- Initialise 
		do
			code := new_code
			string := fault_code_string (code)
			unmarshall_ok := True
		end
	
	make_with_detail (new_code: INTEGER; detail: STRING) is
			-- Initialise with fault code and detailed message
			-- Fault code message and detail message will be concatenated
		do
			code := new_code
			string := fault_code_string (code) + detail
			unmarshall_ok := True
		end
		
	unmarshall (node: XM_ELEMENT) is
			-- Initialise XML-RPC call from DOM element.
		local
			value: GOA_XRPC_STRUCT_VALUE
			member_value: GOA_XRPC_SCALAR_VALUE
			value_elem, fault_elem: XM_ELEMENT
			int_ref: INTEGER_REF
		do
			unmarshall_ok := True
			-- can assume that the <fault> element exists
			-- get fault value and attempt to unmarshall
			fault_elem ?= node.first
			value_elem ?= fault_elem.first
			if value_elem /= Void then
				value ?= Value_factory.unmarshall (value_elem)
				-- check that it was a struct
				if value /= Void then
					-- get faultCode
					if value.value.has (Fault_code_member) then
						member_value ?= value.value.item (Fault_code_member) 
						if member_value /= Void then
							int_ref ?= member_value.value
							if int_ref /= Void then
								code := int_ref.item
								-- get faultString
								if value.value.has (Fault_string_member) then
									member_value ?= value.value.item (Fault_string_member)
									if member_value /= Void then
										string ?= member_value.value
										if string = Void then
											unmarshall_ok := False
											unmarshall_error_code := Invalid_fault_string					
										end	
									else
										unmarshall_ok := False
										unmarshall_error_code := Invalid_fault_string	
									end				
								end
							else
								unmarshall_ok := False
								unmarshall_error_code := Invalid_fault_code	
							end	
						else
							unmarshall_ok := False
							unmarshall_error_code := Invalid_fault_code	
						end	
					else
						unmarshall_ok := False
						unmarshall_error_code := Fault_code_member_missing	
					end
				else
					unmarshall_ok := False
					unmarshall_error_code := Invalid_fault_value
				end
			else
				unmarshall_ok := False
				unmarshall_error_code := Fault_value_element_missing
			end
		end
	
feature -- Access

	code: INTEGER
			-- Fault code

	string: STRING
			-- Fault string

feature -- Status setting

	set_code (new_code: INTEGER) is
			-- Set new fault code
		do
			code := new_code
		end

	set_string (new_string: STRING) is
			-- Set new fault string
		do
			string := new_string
		end

feature -- Marshalling

	marshall: STRING is
			-- Serialize this fault to XML format
		do
			create Result.make (200)
			Result.append ("<?xml version=%"1.0%"?><methodResponse><fault><value><struct><member><name>faultCode</name><value><int>")
			Result.append (code.out)
			Result.append ("</int></value></member><member><name>faultString</name><value><string>")
			Result.append (string)
			Result.append ("</string></value></member></struct></value></fault></methodResponse>")
		end

invariant
	
	string_exists: string /= Void
	
end -- class GOA_XRPC_FAULT

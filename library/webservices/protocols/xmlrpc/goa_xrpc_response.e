note
	description: "Objects that represent an XML-RPC response."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "XML-RPC"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class GOA_XRPC_RESPONSE

inherit
	
	GOA_XRPC_ELEMENT
	
create
	
	make, make_with_value, unmarshall
	
feature -- Initialisation

	make (new_param: GOA_XRPC_PARAM)
			-- Initialise response with given 'value'. Parameter may be Void.
		do
			value := new_param
			unmarshall_ok := True
		end

	make_with_value (new_value: GOA_XRPC_VALUE)
			-- Initialise response with given 'value'. Routine will create 
			-- required parameter object. Value may be Void.
		local
			param: GOA_XRPC_PARAM
		do
			if new_value /= Void then
				create param.make (new_value)
				value := param
			end
			unmarshall_ok := True
		end
		
	unmarshall (node: XM_ELEMENT)
			-- Initialise XML-RPC call from DOM element.
		local
			params, pvalue: XM_ELEMENT
		do
			unmarshall_ok := True
			if not node.is_empty then
				params ?= node.first
				if params /= Void then
					if not params.is_empty then
						pvalue ?= params.first
						check
							value_is_element: pvalue /= Void
						end
						create value.unmarshall (pvalue)
						if not value.unmarshall_ok then
							unmarshall_ok := False
							unmarshall_error_code := value.unmarshall_error_code
						end	
					else
						unmarshall_ok := False
						unmarshall_error_code := Response_value_missing
					end		
				end	
			end
		end
	
feature -- Access
	
	value: GOA_XRPC_PARAM
			-- Result

feature -- Status setting

	set_value (new_value: GOA_XRPC_PARAM)
			-- Set the value to 'new_value'. Value may be Void.
		do
			value := new_value
		end
	
feature -- Marshalling

	marshall: STRING
			-- Serialize this response to XML format
		do
			create Result.make (300)
			Result.append ("<?xml version=%"1.0%"?><methodResponse>")
			if value /= Void then
				Result.append ("<params>")
				Result.append (value.marshall)
				Result.append ("</params>")
			end
			Result.append ("</methodResponse>")
		end
	
end -- class GOA_XRPC_RESPONSE

indexing
	description: "Objects that represent a SOAP Fault Subcode element."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "SOAP"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Colin Adams <colin@colina.demon.co.uk>"
	copyright: "Copyright (c) 2005 Colin Adams and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class GOA_SOAP_FAULT_SUBCODE

inherit
	
	GOA_SOAP_ELEMENT
		redefine
			validate
		end

	GOA_SOAP_FAULTS
		undefine
			copy, is_equal
		end

	GOA_SOAP_SUBCODES
		undefine
			copy, is_equal
		end

create

	make_last, construct

feature -- Initialisation

	construct (a_parent: GOA_SOAP_ELEMENT; a_value: STRING) is
			-- Establish invariant.
		require
			parent_not_void: a_parent /= Void
			value_is_qname: a_value /= Void and is_qname (a_value)
		local
			a_namespace: XM_NAMESPACE
		do
			create a_namespace.make (Ns_prefix_env, Ns_name_env)
			make_last (a_parent, Fault_subcode_element_name, a_namespace)
			create value.construct (Current, a_value) 
		end

feature -- Access

	value: GOA_SOAP_FAULT_VALUE
			-- Value

feature -- Status setting

	validate (an_identity: UT_URI) is
			-- Validate `Current'.
		local
			child_elements: DS_LIST [XM_ELEMENT]
		do
			Precursor (an_identity)
			validation_complete := False
			if value = Void then
				child_elements := elements
				if child_elements.count = 0 then
					set_validation_fault (Sender_fault, "Missing env:Value child from env:Subcode element", an_identity)
				elseif child_elements.count > 2 then
					set_validation_fault (Sender_fault, "Too many child elements for env:Subcode element", an_identity)
				elseif is_valid_element (child_elements.item (1), Fault_value_element_name) then
					value ?= child_elements.item (1)
					if child_elements.count = 2 then
						if not is_valid_element (child_elements.item (2), Fault_subcode_element_name) then
							set_validation_fault (Sender_fault, "Second child element of env:Subcode is not env:Subcode", an_identity)
						else
							sub_code ?= child_elements.item (2)
						end
					end
				else
					set_validation_fault (Sender_fault, "First child element of env:Subcode is not env:Value", an_identity)
				end
			end
			validation_complete := True
		end

invariant

	correct_name: is_valid_element (Current, Fault_subcode_element_name)
	value_not_void: validation_complete and then validated implies value /= Void

end -- class GOA_SOAP_FAULT_SUBCODE

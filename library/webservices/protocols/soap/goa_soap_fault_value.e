note
	description: "Objects that represent a SOAP Fault Node."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "SOAP"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Colin Adams <colin@colina.demon.co.uk>"
	copyright: "Copyright (c) 2005 Colin Adams and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class GOA_SOAP_FAULT_VALUE

inherit
	
	GOA_SOAP_ELEMENT
		redefine
			validate
		end

	XM_UNICODE_CHARACTERS_1_0
		undefine
			copy, is_equal
		end
	
create

	make_last, construct

feature {NONE} -- Initialisation

	construct (a_parent: GOA_SOAP_ELEMENT; a_value: STRING)
			-- Establish invariant.
		require
			parent_not_void: a_parent /= Void
			value_is_qname: a_value /= Void and then is_qname (a_value)
		local
			a_namespace: XM_NAMESPACE
			a_text: XM_CHARACTER_DATA
		do
			create a_namespace.make (Ns_prefix_env, Ns_name_env)
			make_last (a_parent, Fault_value_element_name, a_namespace)
			create a_text.make_last (Current, a_value)
		end
		
feature -- Status setting

	validate (an_identity: UT_URI)
			-- Validate `Current'.
		local
			a_text, a_prefix, a_local_name: STRING
			a_splitter: ST_SPLITTER
			qname_parts: DS_LIST [STRING]
			a_fault_code: GOA_SOAP_FAULT_CODE
		do
			Precursor (an_identity)
			a_text := text
			if a_text = Void then
				set_validation_fault (Sender_fault, STRING_.concat (element_name, " must have a text-node child"), an_identity)
			elseif a_text.is_empty or else not is_qname (a_text) then
				set_validation_fault (Sender_fault, STRING_.concat (element_name, " is must be of type xs:QName"), an_identity)
			else
				a_fault_code ?= parent
				if a_fault_code /= Void then
					create a_splitter.make
					a_splitter.set_separators (prefix_separator)
					STRING_.left_adjust (a_text);STRING_.right_adjust (a_text);
					qname_parts := a_splitter.split (a_text)
					if qname_parts.count = 1 then
						a_prefix := ""; a_local_name := qname_parts.item (1)
					else
						a_prefix := qname_parts.item (1); a_local_name := qname_parts.item (2)
					end
					if STRING_.same_string (prefix_to_namespace (a_prefix), Ns_name_env) then
						if not is_valid_fault_name (a_local_name) then
							set_validation_fault (Sender_fault, "Fault code must be of type env:faultCodeEnum", an_identity)
						end
					else
						set_validation_fault (Sender_fault, "Fault code must be of type env:faultCodeEnum", an_identity)
					end
				end
			end
		end

invariant
	
	correct_name: is_valid_element (Current, Fault_value_element_name)

end -- class GOA_SOAP_FAULT_VALUE

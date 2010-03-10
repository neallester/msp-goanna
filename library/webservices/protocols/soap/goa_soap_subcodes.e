indexing
	description: "Objects that can have a SOAP Subcode child element."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "SOAP"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Colin Adams <colin@colina.demon.co.uk>"
	copyright: "Copyright (c) 2005 Colin Adams and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class GOA_SOAP_SUBCODES

inherit

	GOA_SOAP_CONSTANTS

	XM_UNICODE_CHARACTERS_1_0
	
feature -- Access

	sub_code: GOA_SOAP_FAULT_SUBCODE
			-- Sub-code

feature -- Element change

	add_sub_code (a_parent: GOA_SOAP_ELEMENT; a_value: STRING) is
			--  Add a sub-code.
		require
			no_existing_sub_code: sub_code = Void
			value_is_qname: a_value /= Void and is_qname (a_value)
			parent_is_current: True -- a_parent = Current
		local
			a_namespace: XM_NAMESPACE	
		do
			create a_namespace.make (Ns_prefix_env, Ns_name_env)
			create sub_code.make_last (a_parent, Fault_subcode_element_name, a_namespace)
		ensure
			sub_code_exists: sub_code /= Void
		end

end -- class GOA_SOAP_SUBCODES

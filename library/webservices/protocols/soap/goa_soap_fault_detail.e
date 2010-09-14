note
	description: "Objects that represent a SOAP Fault Detail element."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "SOAP"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Colin Adams <colin@colina.demon.co.uk>"
	copyright: "Copyright (c) 2005 Colin Adams and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class GOA_SOAP_FAULT_DETAIL

inherit
	
	GOA_SOAP_ELEMENT

create

	make_last, construct

feature -- Initialisation

	construct (a_fault: GOA_SOAP_FAULT)
			-- Establish invariant.
		require
			fault_not_void: a_fault /= Void
		local
			a_namespace: XM_NAMESPACE
		do
			create a_namespace.make (Ns_prefix_env, Ns_name_env)
			make_last (a_fault, Fault_detail_element_name, a_namespace)
		end

invariant
	
	correct_name: is_valid_element (Current, Fault_detail_element_name)

end -- class GOA_SOAP_FAULT_DETAIL

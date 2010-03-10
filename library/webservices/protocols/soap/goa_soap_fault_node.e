indexing
	description: "Objects that represent a SOAP Fault Node."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "SOAP"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Colin Adams <colin@colina.demon.co.uk>"
	copyright: "Copyright (c) 2005 Colin Adams and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class GOA_SOAP_FAULT_NODE

inherit
	
	GOA_SOAP_ELEMENT
		redefine
			validate
		end

create

	make_last, construct

feature -- Initialisation

	construct (a_fault: GOA_SOAP_FAULT; a_node: like node) is
			-- Establish invariant.
		require
			fault_not_void: a_fault /= Void
			node_not_void: a_node /= Void
		local
			a_namespace: XM_NAMESPACE
			a_text: XM_CHARACTER_DATA
		do
			create a_namespace.make (Ns_prefix_env, Ns_name_env)
			make_last (a_fault, Fault_node_element_name, a_namespace)
			node := a_node
			create a_text.make_last (Current, node.full_reference)
		ensure
			node_set: node = a_node
		end
		
feature -- Access

	node: UT_URI
			-- Node identity

feature -- Status setting

		validate (an_identity: UT_URI) is
			-- Validate `Current'.
		local
			a_text: STRING
		do
			Precursor (an_identity)
			a_text := text
			if a_text = Void then
				set_validation_fault (Sender_fault, STRING_.concat (element_name, " must have a text-node child"), an_identity)
			elseif node = Void then
				if a_text.is_empty or else Url_encoding.has_excluded_characters (a_text) then
					set_validation_fault (Sender_fault, STRING_.concat (element_name, " is must be of type xs:anyURI"), an_identity)
				else
					create node.make (a_text)
				end
			end
		end

invariant
	
	node_not_void: validation_complete and then validated implies node /= Void
	correct_name: is_valid_element (Current, Fault_node_element_name)

end -- class GOA_SOAP_FAULT_NODE

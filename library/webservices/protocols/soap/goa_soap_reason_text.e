indexing
	description: "Objects that represent a SOAP Fault Reason Text."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "SOAP"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Colin Adams <colin@colina.demon.co.uk>"
	copyright: "Copyright (c) 2005 Colin Adams and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class GOA_SOAP_REASON_TEXT

inherit
	
	GOA_SOAP_ELEMENT
		redefine
			validate
		end

create

	make_last, construct

feature -- Initialisation

	construct (a_reason: GOA_SOAP_FAULT_REASON; a_text, a_language: STRING) is
			-- Establish invariant.
		require
			reason_not_void: a_reason /= Void
			text_not_empty: a_text /= Void and then not a_text.is_empty
			language_not_empty: a_language /= Void and then not a_language.is_empty
		local
			a_namespace: XM_NAMESPACE
			an_attribute: XM_ATTRIBUTE
			a_text_node: XM_CHARACTER_DATA
		do
			create a_namespace.make (Ns_prefix_env, Ns_name_env)
			make_last (a_reason, Reason_text_element_name, a_namespace)
			create a_namespace.make (Xml_prefix, Xml_prefix_namespace)
			create an_attribute.make_last (Xml_lang, a_namespace, a_language, Current)
			create a_text_node.make_last (Current, a_text)
		end

feature -- Status setting

	validate (an_identity: UT_URI) is
			-- Validate `Current'.
		do
			Precursor (an_identity)
			if not has_attribute_by_qualified_name (Xml_prefix_namespace, Xml_lang) then
				set_validation_fault (Sender_fault, "No xml:lang attribute on env:Text element", an_identity)
			end
		end

invariant

	correct_name: is_valid_element (Current, Reason_text_element_name)

end -- class GOA_SOAP_REASON_TEXT

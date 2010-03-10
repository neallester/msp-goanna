indexing
	description: "Objects that represent a SOAP Fault Reason."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "SOAP"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Colin Adams <colin@colina.demon.co.uk>"
	copyright: "Copyright (c) 2005 Colin Adams and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class GOA_SOAP_FAULT_REASON

inherit
	
	GOA_SOAP_ELEMENT
		redefine
			validate
		end

create

	make_last, construct

feature -- Initialisation

	construct (a_fault: GOA_SOAP_FAULT; a_text, a_language: STRING) is
			-- Establish invariant.
		require
			fault_not_void: a_fault /= Void
			text_not_empty: a_text /= Void and then not a_text.is_empty
			language_not_empty: a_language /= Void and then not a_language.is_empty
		local
			a_namespace: XM_NAMESPACE
		do
			create a_namespace.make (Ns_prefix_env, Ns_name_env)
			make_last (a_fault, Fault_reason_element_name, a_namespace)
			add_text (a_text, a_language)
		end

feature -- Status setting

	validate (an_identity: UT_URI) is
			-- Validate `Current'.
		local
			a_cursor: DS_LIST_CURSOR [XM_ELEMENT]
			a_reason_text: GOA_SOAP_REASON_TEXT
		do
			scan_attributes (an_identity, False)
			check_encoding_style_attribute (an_identity)
			from
				a_cursor := elements.new_cursor; a_cursor.start
			until
				a_cursor.after
			loop
				a_reason_text ?= a_cursor.item
				if a_reason_text = Void then
					set_validation_fault (Sender_fault, "Children of env:Reason must be env:Text elements", an_identity)
					a_cursor.go_after
				else
					a_reason_text.validate (an_identity); validated := a_reason_text.validated
					if validated then
						a_cursor.forth
					else
						validation_fault := a_reason_text.validation_fault
						a_cursor.go_after
					end
				end
			end
		end

feature -- Element change

	add_text (a_text, a_language: STRING) is
			-- Add a Text element child.
		require
			text_not_empty: a_text /= Void and then not a_text.is_empty
			language_not_empty: a_language /= Void and then not a_language.is_empty
		local
			a_reason_text: GOA_SOAP_REASON_TEXT
		do
			create a_reason_text.construct (Current, a_text, a_language)
		end

invariant
	
	correct_name: is_valid_element (Current, Fault_reason_element_name)

end -- class GOA_SOAP_FAULT_REASON

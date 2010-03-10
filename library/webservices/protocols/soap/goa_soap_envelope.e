indexing
	description: "Objects that represent a SOAP envelope."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "SOAP"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class	GOA_SOAP_ENVELOPE

inherit
	
	GOA_SOAP_ELEMENT
		redefine
			validate
		end

creation
	
	make_root
	
feature -- Access

	header: GOA_SOAP_HEADER
			-- Envelope header. `Void' if no header
			
	body: GOA_SOAP_BODY
			-- Envelope body

	unique_identifiers: DS_HASH_TABLE [GOA_SOAP_ELEMENT, STRING]
			-- Document-wide unique indentiers of elements

	encoding_styles: DS_HASH_SET [STRING]
			-- Names of encoding styles used

	is_fault_message: BOOLEAN is
			-- Is this a SOAP Fault message?
		require
			validated: validation_complete and then validated
		do
			Result := body.is_fault_message
		end

feature -- Status Setting

	set_header (a_header: like header) is
			-- Set 'header' to 'a_header'
		require
			new_header_exists: a_header /= Void
		do
			header := a_header
		ensure
			header_set: header = a_header
		end
		
	set_body (a_body: like body) is
			-- Set 'body' to 'a_body'
		require
			new_body_exists: a_body /= Void
		do
			body := a_body
		ensure
			body_set: body = a_body
		end

	validate (an_identity: UT_URI) is
			-- Validate `Current'.
		local
			child_elements: DS_LIST [XM_ELEMENT]
			a_count: INTEGER
		do
			create unique_identifiers.make_with_equality_testers (10, Void, string_equality_tester)
			create encoding_styles.make_default; encoding_styles.set_equality_tester (string_equality_tester)
			scan_attributes (an_identity, True)
			if validated then check_encoding_style_attribute (an_identity) end
			if validated then
				child_elements := elements
				a_count := child_elements.count
				if a_count = 0 then
					set_validation_fault (Sender_fault, "Missing env:Body element", an_identity)
				elseif a_count > 2 then
					set_validation_fault (Sender_fault, "Too many child elements in env:Envelope", an_identity)
				elseif a_count = 2 then
					header ?= elements.item (1)
					if header = Void then
						set_validation_fault (Sender_fault, "First child element of env:Envelope is not env:Header", an_identity)
					else
						body ?= elements.item (2)
						if body = Void then
							set_validation_fault (Sender_fault, "Second child element of env:Envelope is not env:Body", an_identity)
						end
					end
				else
					body ?= elements.item (1)
					if body = Void then
						set_validation_fault (Sender_fault, "Sole child element of env:Envelope is not env:Body", an_identity)
					end
				end
				if validated then
					if header /= Void then
						header.validate (an_identity)
						if not header.validated then
							validated := False; validation_fault := header.validation_fault
						end
					end
				end
				if validated then
					body.validate (an_identity)
					if not body.validated then
						validated := False; validation_fault := body.validation_fault
					end
				end
			end
			validation_complete := True
			post_validate (an_identity)
		end

	post_validate (an_identity: UT_URI) is
			-- Perform post-validation checks on `Current'.
		require
			identity_not_void: an_identity /= Void
		local
			a_validator: GOA_SOAP_ELEMENT_VALIDATOR
			a_cursor: DS_HASH_SET_CURSOR [STRING]
		do
			from
				a_cursor := encoding_styles.new_cursor; a_cursor.start
			until not validated or else a_cursor.after loop
				create a_validator.make (unique_identifiers, encodings.get (a_cursor.item), an_identity)
				a_validator.process_document (root_node)
				if not a_validator.validated then
					validated := False; validation_fault := a_validator.validation_fault
				end
				a_cursor.forth
			end
		end


invariant

	correct_name: is_valid_element (Current, Envelope_element_name)
	body_exists: validation_complete and then validated implies body /= Void
	unique_identifiers_not_void: validated implies unique_identifiers /= Void
	encoding_styles_not_void: validated implies encoding_styles /= Void
	
end -- class GOA_SOAP_ENVELOPE

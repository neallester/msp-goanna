indexing
	description: "Objects that hold essence of a SOAP Fault"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "SOAP"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Colin Adams <colin@colina.demon.co.uk>"
	copyright: "Copyright (c) 2005 Colin Adams and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class	GOA_SOAP_FAULT_INTENT

inherit

	GOA_SOAP_FAULTS

create

	make

feature {NONE} -- Initialization

	make (a_code: INTEGER; a_text, a_language: STRING; a_node_uri, a_role_uri: UT_URI) is
			-- Establish invariant.
		require
			text_not_empty: a_text /= Void and then not a_text.is_empty
			language_not_empty: a_language /= Void and then not a_language.is_empty
			valid_code: is_valid_fault_code (a_code)
			node_uri_not_void: a_role_uri /= Void and then not STRING_.same_string (a_role_uri.full_reference, Role_ultimate_receiver) implies a_node_uri /= Void
		do
			code := a_code
			reason_text := a_text
			language := a_language
			node_uri := a_node_uri
			role_uri := a_role_uri
		ensure
			code_set: code = a_code
			reason_set: reason_text = a_text
			language_set: language = a_language
			node_set: node_uri = a_node_uri
			role_set: role_uri = a_role_uri
		end

feature -- Access

	code: INTEGER
			-- Fault code

	reason_text: STRING
			-- Reason

	language: STRING
			-- Language code for `reason_text'

	node_uri: UT_URI
			-- Node which created `Current'

	role_uri: UT_URI
			-- Operating role when `Current' was created

	sub_code: STRING
			-- First-level sub-code (optional)

	not_understood_headers: DS_LINKED_LIST [GOA_SOAP_HEADER_BLOCK]
			-- Mandatory headers which were not understood

feature -- Creation

	new_fault: GOA_SOAP_FAULT is
			-- Fault created from `Current'
		require
			not_understood: code = Must_understand_fault implies not_understood_headers /= Void
		local
			an_envelope: GOA_SOAP_ENVELOPE
			a_body: GOA_SOAP_BODY
			an_upgrade: GOA_SOAP_UPGRADE
			a_header: GOA_SOAP_HEADER
			a_cursor: DS_LINKED_LIST_CURSOR [GOA_SOAP_HEADER_BLOCK]
			a_not_understood: GOA_SOAP_NOT_UNDERSTOOD
		do
			an_envelope := new_envelope
			if code = Version_mismatch_fault then
				a_header := new_header (an_envelope, node_uri)
				create an_upgrade.construct (a_header)
			elseif code = Must_understand_fault then
				a_header := new_header (an_envelope, node_uri)
				from a_cursor := not_understood_headers.new_cursor; a_cursor.start until a_cursor.after loop
					create a_not_understood.construct (a_header, a_cursor.item)
					a_cursor.forth
				end
			end
			a_body := new_body (an_envelope, node_uri)
			create Result.construct (a_body, code, reason_text, language, node_uri, role_uri, sub_code)
			an_envelope.validate (node_uri)
		ensure
			valid_fault: Result /= Void and then Result.validated and then Result.validation_complete
		end

feature -- Element change

	set_sub_code (a_sub_code: STRING) is
			-- Set `sub_code'.
		do
			sub_code := a_sub_code
		ensure
			sub_code_set: sub_code = a_sub_code
		end

	set_not_understood_headers (some_not_understood_headers: DS_LINKED_LIST [GOA_SOAP_HEADER_BLOCK]) is
			-- Set not_understodd_headers.
		require
			must_understand_fault: code = Must_understand_fault
			header_list_not_empty: some_not_understood_headers /= Void and then not some_not_understood_headers.is_empty
		do
			not_understood_headers := some_not_understood_headers
		ensure
			not_understood_headers_set: not_understood_headers = some_not_understood_headers
		end
	
invariant

	valid_code: is_valid_fault_code (code)
	reason_not_empty: reason_text /= Void and then not reason_text.is_empty
	language_not_empty: language /= Void and then not language.is_empty
	node_uri_not_void: role_uri /= Void and then not STRING_.same_string (role_uri.full_reference, Role_ultimate_receiver) implies node_uri /= Void
	understood: code /= Must_understand_fault implies not_understood_headers = Void

end -- class GOA_SOAP_FAULT_INTENT

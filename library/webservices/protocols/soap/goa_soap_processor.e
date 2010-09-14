note
	description: "Objects that process SOAP messages"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "SOAP"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Colin Adams <colin@colina.demon.co.uk>"
	copyright: "Copyright (c) 2005 Colin Adams and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

deferred class	GOA_SOAP_PROCESSOR

inherit

	GOA_SOAP_FAULTS

	XM_EIFFEL_PARSER_FACTORY

	XM_SHARED_CATALOG_MANAGER

	KL_IMPORTED_STRING_ROUTINES

	KL_SHARED_STANDARD_FILES

	UC_SHARED_STRING_EQUALITY_TESTER

	GOA_SHARED_QNAME_TESTER

feature {NONE} -- Initialization

	initialize_structures
			-- Establish invariant.
		do
			initialize_roles
			create recognised_headers.make_default
			recognised_headers.set_equality_tester (qname_tester)
		end

	initialize_roles
			-- Setup known and active roles.
		do
			create known_roles.make_default
			known_roles.set_equality_tester (string_equality_tester)
			known_roles.put_new (Role_next)
			add_additional_known_roles
			create active_roles.make_default
			active_roles.set_equality_tester (string_equality_tester)
		end

feature -- Template routines

	send_build_failure_message (a_message: STRING)
			-- Send a build-failure message.
		require
			message_not_empty: a_message /= Void and then not a_message.is_empty
		deferred
		end

	add_additional_known_roles
			-- Add non-standard roles.
		deferred
		end

	determine_active_roles
			-- Determine in which roles we will act.
		require
			no_build_error: is_build_sucessful
			valid: is_valid
		deferred
		end

	examine_header_for_roles (a_header: GOA_SOAP_HEADER_BLOCK)
			-- Examine `a_header' to determine roles in which `Current' will act.
		require
			header_block_not_void: a_header /= Void
			no_build_error: is_build_sucessful
			valid: is_valid
		deferred
		end

	is_header_understood (a_header: GOA_SOAP_HEADER_BLOCK): BOOLEAN
			-- Do we understand `a_header'?
		require
			header_exists: a_header /= Void
		local
			a_qname: GOA_EXPANDED_QNAME
		do
			create a_qname.make_from_node (a_header)
			Result := recognised_headers.has (a_qname)
		end
								 
	examine_body_for_active_roles
			-- Examine message body to determine roles in which `Current' will act.
		deferred
		end

	process_headers
			-- Process all mandatory headers (and optionally, non-mandatory headers) targetted at `Current'.
		require
			all_mandatory_headers_understood: are_all_mandatory_headers_understood
		deferred
		end

	process_header (a_header:  GOA_SOAP_HEADER_BLOCK)
			-- Process `_header'
		require
			header_exists: a_header /= Void
		deferred
		end

	process_body
			-- Process message body.
		require
			ultimate_receiver: is_ultimate_receiver
			no_header_faults: not is_header_fault
		deferred
		end

	create_and_send_must_understand_fault
			-- Send a MustUnderstand fault.
		require
			some_headers_not_understood: not_understood_headers /= Void and then not_understood_headers.count > 0
		deferred
		end

	create_and_send_fault (a_fault_intent: GOA_SOAP_FAULT_INTENT)
			-- Create and send a fault_message.
		require
			fault_intent_not_void: a_fault_intent /= Void
		deferred
		end

	send_message (an_envelope: GOA_SOAP_ENVELOPE)
			-- Send a SOAP message.
		require
			envelope_not_void: an_envelope /= Void
		deferred
		end

	relay_message
			-- TODO
		deferred
		end

feature -- Access

	node: UT_URI
			-- Identity of this SOAP node

	known_roles: DS_HASH_SET [STRING]
			-- Roles in which `Current' may act

	active_roles: DS_HASH_SET [STRING]
			-- Roles in which `Current' acts while processing current message

	mandatory_headers: DS_LINKED_LIST [GOA_SOAP_HEADER_BLOCK]
			-- Mandatory headers of current message

	not_understood_headers: DS_LINKED_LIST [GOA_SOAP_HEADER_BLOCK]
			-- Mandatory headers of current message which are not understood

	recognised_headers: DS_HASH_SET [GOA_EXPANDED_QNAME]
			-- Names of headers recognised by `Current'

	is_relaying: BOOLEAN
			-- Are we relaying messages?

	envelope: GOA_SOAP_ENVELOPE
			-- Parsed envelope
		require
			no_build_error: is_build_sucessful
		do
			Result ?= tree_builder.document.root_element
		ensure
			envelope_not_void: Result /= Void
		end

feature -- Status report

	is_header_fault: BOOLEAN
			-- Has a header_fault_occurred?

	are_optional_headers_processed: BOOLEAN
			-- Do we process optional headers targetted at us?

	is_build_sucessful: BOOLEAN
			-- Was the envelope built without error?
		do
			Result := tree_builder /= Void and then not tree_builder.error.has_error and then not tree_builder.tree_filter.is_error
		end

	is_valid: BOOLEAN
			-- Did `envelope' validate?
		require
			no_build_error: is_build_sucessful
		do
			Result := envelope.validated
		end

	validation_fault: GOA_SOAP_FAULT_INTENT
			-- Fault from validation
		require
			no_build_error: is_build_sucessful
			no_valid: not is_valid
		do
			Result := envelope.validation_fault
		ensure
			fault_not_void: Result /= Void
		end

	is_ultimate_receiver: BOOLEAN
			-- Are we acting as the ultimate receiver for the next or current call to `process'?
		do
			Result := known_roles.has (Role_ultimate_receiver)
		end

feature -- Setting

	set_ultimate_receiver (yes_or_no: BOOLEAN)
			-- Determine if we are to act as the ultimate receiver for the next call to `process'.
		do
			if yes_or_no then
				if not is_ultimate_receiver then
					known_roles.force_new (Role_ultimate_receiver)
				end
			else
				if is_ultimate_receiver then
					known_roles.remove (Role_ultimate_receiver)
				end
			end
		end

	set_process_optional_headers  (yes_or_no: BOOLEAN)
			-- Determine if we process optional headers targetted at us.
		do
			are_optional_headers_processed := yes_or_no
		ensure
			set: are_optional_headers_processed = yes_or_no
		end

	recognise_header (a_qname: GOA_EXPANDED_QNAME)
			-- Recognise headers identified by `a_qname'.
			-- TODO: Logic for processing a recognised header? 
		require
			qname_not_void: a_qname /= Void
			not_already_recognised: not recognised_headers.has (a_qname)
		do
			recognised_headers.force (a_qname)
		ensure
			header_recognised: recognised_headers.has (a_qname)
		end
		
feature -- Process

	process (a_message: STRING; a_base_uri: UT_URI)
			-- Process message.
		require
			message_not_void: a_message /= Void
		do
			parse_xml (a_message, a_base_uri)
			if tree_builder.error.has_error then
				send_build_failure_message (tree_builder.error.last_error)
			elseif tree_builder.tree_filter.is_error then
				if tree_builder.tree_filter.no_envelope then
					send_version_mismatch_fault
				elseif tree_builder.tree_filter.is_parse_error then
					send_build_failure_message (STRING_.concat ("Error parsing SOAP message: ",tree_builder.tree_filter.last_parse_error))
				elseif tree_builder.tree_filter.invalid_standalone then
					send_build_failure_message ("Standalone cannot be 'no' in a SOAP message")
				elseif tree_builder.tree_filter.dtd_seen then
					send_build_failure_message ("DTD is not allowed in a SOAP message")
				elseif tree_builder.tree_filter.pi_seen then
					send_build_failure_message ("Processing instructions are not allowed in a SOAP message")
				elseif tree_builder.tree_filter.invalid_comment then
					send_build_failure_message ("Comments are not allowed outside of the SOAP Envelope")
				end
			else
				envelope.validate (node)
				if is_valid then
					determine_active_roles
					identify_mandatory_headers
					if are_all_mandatory_headers_understood then
						process_headers
						if is_ultimate_receiver then
							if is_header_fault then process_body end
						else
							if is_relaying then relay_message end
						end
					else
						create_and_send_must_understand_fault
					end
				else
					create_and_send_fault (envelope.validation_fault)
				end
			end
		end

	identify_mandatory_headers
			-- Identify all mandatory headers.
		require
			no_build_error: is_build_sucessful
			valid: is_valid
		local
			a_cursor: DS_LINKED_LIST_CURSOR [GOA_SOAP_HEADER_BLOCK]
		do
			create mandatory_headers.make_default
			create not_understood_headers.make_default
			if envelope.header /= Void then
				a_cursor := envelope.header.header_blocks.new_cursor
				from a_cursor.start until a_cursor.after loop
					if is_mandatory_header (a_cursor.item) then
						mandatory_headers.force_last (a_cursor.item)
					end
					a_cursor.forth
				end
			end
		end

	are_all_mandatory_headers_understood: BOOLEAN
			-- Are all of `mandatory_headers' understood by `Current'?
		require
			mandatory_headers_not_void: mandatory_headers /= Void
			not_understood_headers_not_void: not_understood_headers /= Void
		local
			a_cursor: DS_LINKED_LIST_CURSOR [GOA_SOAP_HEADER_BLOCK]
		do
			from a_cursor := mandatory_headers.new_cursor; a_cursor.start until a_cursor.after loop
				if not is_header_understood (a_cursor.item) then
					not_understood_headers.force_last (a_cursor.item)
				end
				a_cursor.forth
			end
			Result := not_understood_headers.is_empty
		end

feature {NONE} -- Implementation

	tree_builder: GOA_SOAP_TREE_BUILDER
			-- Tree constructor

	is_mandatory_header (a_header: GOA_SOAP_HEADER_BLOCK): BOOLEAN
			-- Is `a_header' mandatory?
		require
			header_not_void: a_header /= Void
		do
			if a_header.must_understand then
				Result := is_targetted_header (a_header)
			end
		end

	is_targetted_header (a_header: GOA_SOAP_HEADER_BLOCK): BOOLEAN
			-- Is `a_header' targetted at us?
		require
			header_not_void: a_header /= Void
		local
			a_cursor: DS_HASH_SET_CURSOR [STRING]
			a_role: UT_URI
		do
			a_role := a_header.role
			if a_role = Void then
				Result := is_ultimate_receiver
			elseif STRING_.same_string (Role_none, a_role.full_reference) then
				Result := False
			else
				a_cursor := active_roles.new_cursor
				from a_cursor.start until
					a_cursor.after
				loop
					if STRING_.same_string (a_cursor.item, a_role.full_reference) then
						Result := True; a_cursor.go_after
					else
						a_cursor.forth
					end
				end
			end
		end

	parse_xml (an_xml: STRING; a_base_uri: UT_URI)
			-- Parse xml source.
		require
			xml_not_void: an_xml /= Void
		local
			a_resolver: XM_CATALOG_RESOLVER
			a_parser: XM_PARSER
			a_stop_parser: XM_PARSER_STOP_ON_ERROR_FILTER
		do
			create tree_builder.make
			a_parser := new_eiffel_parser
			create a_stop_parser.make (a_parser)
			tree_builder.last.set_next (a_stop_parser)
			a_parser.set_callbacks (tree_builder.start)
			a_parser.set_dtd_callbacks (tree_builder.dtd_target)
			create a_resolver.make
			a_parser.set_resolver (a_resolver)
			if a_base_uri /= Void then
				shared_catalog_manager.bootstrap_resolver.uri_scheme_resolver.push_uri (a_base_uri)
			end
			a_parser.parse_from_string (an_xml)
		ensure
			tree_builder_created: tree_builder /= Void
		end

	send_version_mismatch_fault
			-- Send a versionMismatch fault.
		local
			a_fault_intent: GOA_SOAP_FAULT_INTENT
		do
			create a_fault_intent.make (Version_mismatch_fault, "Version mismatch", "en", node, Void)
			create_and_send_fault (a_fault_intent)
		end

invariant

	node_not_void: node /= Void
	known_roles_not_void: known_roles /= Void
	active_roles_not_void: active_roles /= Void

end -- class GOA_SOAP_PROCESSOR

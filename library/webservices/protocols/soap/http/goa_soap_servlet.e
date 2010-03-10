	description: "Objects that process SOAP messages"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "SOAP"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Colin Adams <colin@colina.demon.co.uk>"
	copyright: "Copyright (c) 2005 Colin Adams and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class	GOA_SOAP_SERVLET

inherit
	
	GOA_SOAP_PROCESSOR

	GOA_SOAP_RPC

	GOA_HTTP_SERVLET
		redefine
			do_get, do_post, init
		end
	
	GOA_SHARED_SERVICE_REGISTRY
		export
			{NONE} all
		end

	GOA_SHARED_ENCODING_REGISTRY
		export
			{NONE} all
		end

create

	init
	
feature {NONE} -- Initialisation

	init (config: SERVLET_CONFIG) is
			-- Initialise encoding registry and set node identity.
		local
			an_encoding: GOA_SOAP_XML_ENCODING
		do
			Precursor (config)

			-- We use `config.document_root' for the node URI

			create node.make (config.document_root)
			create an_encoding
			encodings.register (an_encoding, Ns_uri_soap_enc)
			initialize_structures
		end
		
feature -- Basic operations

	do_get (a_req: GOA_HTTP_SERVLET_REQUEST; a_resp: GOA_HTTP_SERVLET_RESPONSE) is
			-- Process SOAP Response Message Exchange Pattern.
		local
			a_role: UT_URI
		do
			set_ultimate_receiver (True)
			create web_method.make (Get_method)
			create a_role.make (Responding_soap_node_role)
			create {GOA_SOAP_RESPONSE_MEP}.make (a_role)
			do_common (a_req, a_resp)
		end
	
	do_post (a_req: GOA_HTTP_SERVLET_REQUEST; a_resp: GOA_HTTP_SERVLET_RESPONSE) is
			-- Process SOAP Request-Response Message Exchange Pattern.
		local
			a_role: UT_URI
		do
			create web_method.make (Post_method)
			create a_role.make (Responding_soap_node_role)
			create {GOA_SOAP_REQUEST_RESPONSE_MEP}.make (a_role)
			do_common (a_req, a_resp)
		end

feature -- Access

	mep: GOA_SOAP_MESSAGE_EXCHANGE_PATTERN
			-- Message exchange pattern in use

	web_method: GOA_SOAP_WEB_METHOD_FEATURE
			-- Web method

	base_uri: UT_URI
			-- Base URI

	action: GOA_SOAP_ACTION_FEATURE
			-- Action

	current_response: HTTP_SERVLET_RESPONSE
			-- Response for current message

feature -- Status report

	is_http_1_1: BOOLEAN
			-- Is the protocol HTTP/1.1?

	last_media_type: UT_MEDIA_TYPE
			-- Contents of last seen "Content-Type" header

	bad_media_type: BOOLEAN
			-- Is media-type other than "application/soap+xml"?

feature -- Template routines

	add_additional_known_roles is
			-- Add non-standard roles.
		do
			known_roles.put_new (Role_ultimate_receiver)
		end

	send_build_failure_message (a_message: STRING) is
			-- Send a build-failure message.
		do
			check
				current_response_not_void: current_response /= Void
			end
			current_response.send_error_message (Sc_bad_request, a_message)
		end

	send_message (an_envelope: GOA_SOAP_ENVELOPE) is
			-- Send a SOAP message.
		local
			a_formatter: GOA_SOAP_NODE_FORMATTER
			a_stream: KL_STRING_OUTPUT_STREAM
		do
			check
				current_response_not_void: current_response /= Void
			end
			create a_stream.make_empty
			create a_formatter.make
			a_formatter.set_output (a_stream)
			a_formatter.process_document (an_envelope.root_node)
			current_response.set_content_length (a_stream.string.count)
			current_response.set_content_type ("application/soap+xml")
			current_response.send (a_stream.string)
		end

	create_and_send_must_understand_fault is
			-- Send a MustUnderstand fault.
		local
			a_fault_intent: GOA_SOAP_FAULT_INTENT
		do
			check
				current_response_not_void: current_response /= Void
			end
			current_response.set_status (Sc_internal_server_error)
			create a_fault_intent.make (Must_understand_fault, "At least one mandatory header was not understood", "en", node, Void)
			a_fault_intent.set_not_understood_headers (not_understood_headers)
			send_message (new_fault_message (a_fault_intent))
		end

	create_and_send_fault (a_fault_intent: GOA_SOAP_FAULT_INTENT) is
			-- Create and send a fault_message.
		require
			fault_intent_not_void: a_fault_intent /= Void
		local
			an_envelope: GOA_SOAP_ENVELOPE
		do
			check
				current_response_not_void: current_response /= Void
			end
			if a_fault_intent.code = Sender_fault then
				current_response.set_status (Sc_bad_request)
			else
				current_response.set_status (Sc_internal_server_error)
			end
			an_envelope := new_fault_message (a_fault_intent)
			send_message (an_envelope)
		end
	
	relay_message is
			-- Relay not used in HTTP 1.1 binding.
		do
		end

	determine_active_roles is
			-- Determine in which roles we will act.
		local
			a_cursor: DS_LINKED_LIST_CURSOR [GOA_SOAP_HEADER_BLOCK]
		do
			active_roles.wipe_out
			if envelope.header /= Void then
				a_cursor := envelope.header.header_blocks.new_cursor
				from a_cursor.start until a_cursor.after loop
					examine_header_for_roles (a_cursor.item)
					a_cursor.forth
				end
			end
			examine_body_for_active_roles
			if is_ultimate_receiver and then not active_roles.has (Role_ultimate_receiver) then
				active_roles.force_new (Role_ultimate_receiver)
			end
		end

	examine_header_for_roles (a_header: GOA_SOAP_HEADER_BLOCK) is
			-- Examine `a_header' to determine roles in which `Current' will act.
		local
			a_candidate_role: STRING
		do
			if a_header.role /= Void then
				a_candidate_role := a_header.role.full_reference
				if known_roles.has (a_candidate_role) and then not active_roles.has (a_candidate_role) then
					active_roles.force_new (a_candidate_role)
				end
			end
		end

	process_headers is
			-- Process all mandatory headers (and optionally, non-mandatory headers) targetted at `Current'.
		local
			a_cursor: DS_LINKED_LIST_CURSOR [GOA_SOAP_HEADER_BLOCK]
		do
			is_header_fault := False
			if envelope.header /= Void then
				a_cursor := envelope.header.header_blocks.new_cursor
				from a_cursor.start until a_cursor.after loop
					if is_mandatory_header (a_cursor.item) then
						process_header (a_cursor.item)
					elseif are_optional_headers_processed and then is_targetted_header (a_cursor.item) then
						process_header (a_cursor.item)
					end
					a_cursor.forth
				end
			end
		end

	process_body is
			-- Process message body.
		local
			a_formatter: GOA_SOAP_NODE_FORMATTER
		do
			check
				current_response_not_void: current_response /= Void
			end
			call (envelope)
		end
			
feature -- Messages

	send_rpc_response (a_response: GOA_SOAP_ENVELOPE) is
			-- Send `a_response' to the requester.
		local
			a_fault: GOA_SOAP_FAULT
		do
			check
				current_response_not_void: current_response /= Void
			end
			if a_response.is_fault_message then
				a_fault ?= a_response.body.body_block.item (1)
				check
					fault: a_fault /= Void
					-- guarenteed by `is_fault_message'
				end
				if a_fault.code = Sender_fault then
					a_resp.send_error (Sc_bad_request)
				else
					a_resp.send_error (Sc_internal_server_error)
				end
				send_message (a_response)
			else
				current_response.set_status (Sc_ok)
			end
		end

feature {NONE} -- Implementation

	Content_location: STRING is "Content-Location"
	Content_type: STRING is "Content-Type"

	use_mep_role is
			-- Add role set in `mep' to known roles.
		local
			a_role: UT_URI
		do
			initialize_roles
			create a_role.make (mep.name.value)
			create a_role.make_resolve (a_role, mep.role.value)
			known_roles.put_new (a_role.full_reference)
		end

	parse_request (a_req: GOA_HTTP_SERVLET_REQUEST) is
			-- Parse HTTP request as a SOAP request.
		require
			request_not_void: a_req /= Void
		local
			a_location: STRING
		do
			last_media_type := Void
			a_location := " "
			if a_req.has_header (Content_location) then
				a_location := a_req.get_header (Content_location)
			end
			if not STRING_.same_string_case_insensitive (a_location.substring (1,1), "h") then
				a_location := request_uri (a_req)
			end
			create base_uri.make (a_location)
			if STRING_.same_string (protocol, "HTTP/1.1") then
				is_http_1_1 := True
			end
			if a_req.has_header (Content_type) then
				parse_content_type (a_req.has_header (Content_type))
			end
		end

	request_uri (a_req: GOA_HTTP_SERVLET_REQUEST): STRING is
			-- Constructed request URI;
			-- We don't get this directly from CGI, so it's all a big bodge
		require
			request_not_void: a_req /= Void
		local
			a_port: STRING
		do
			Result := scheme + "//" + a_req.get_header ("SERVER_NAME")
			a_port := a_req.get_header ("SERVER_PORT")
			if a_port.to_integer /= 80 then
				Result := Result + ":" + a_port
			end
			Result := Result + servlet_path + path_info
		ensure
			result_not_empty: Result /= Void and then not Result.is_empty
		end

	parse_content_type (a_content_type: STRING) is
			-- Parse "Content-Type" header.
		require
			content_type_exists: a_content_type /= Void
		local
			a_splitter: ST_SPLITTER
			some_parameters, a_parameter_pair, some_components: DS_LIST [STRING]
			a_media_type: STRING
			a_cursor: DS_LIST_CURSOR [STRING]
		do
			create a_splitter.make
			a_splitter.set_separators (";")
			some_parameters := a_splitter.split (a_parameter_string)
			a_media_type := some_parameters.item (1)
			a_splitter.set_separators ("/")
			some_components := a_splitter.split (a_media_type)
			if some_components.count /= 2 then
				set_last_error ("Content-type must contain exactly one /")
			else
				create last_media_type.make (some_components.item (1), some_components.item (2))
				if some_parameters.count > 1 then
					some_parameters.remove_first
					from
						a_splitter.set_separators ("=")
						a_cursor := some_parameters.new_cursor; a_cursor.start
					variant
						some_parameters.count + 1 - a_cursor.index
					until
						a_cursor.after
					loop
						a_parameter_pair := a_splitter.split (a_cursor.item)
						if a_parameter_pair.count /= 2 then
							set_last_error (a_cursor.item + " is not valid syntax for a Content-type parameter.")
							a_cursor.go_after
						else
							last_media_type.add_parameter (a_parameter_pair.item (1), a_parameter_pair.item (2))
							a_cursor.forth
						end
					end
				end
			end
		end

	check_media_type is
			-- Check media type.
		local
			an_action: UT_URI
			an_encoding: STRING
		do
			bad_media_type := True; action := Void
			if last_media_type /= Void then
				if STRING_.same_string (last_media_type.type, "application")
					and then STRING_.same_string (last_media_type.subtype, "soap+xml") then
					bad_media_type := False
				end
			end
			if not bad_media_type then
				if last_media_type.has_parameter ("charset") then
					an_encoding := last_media_type.parameter ("charset")
					if not (STRING_.same_case_insensitive (an_encoding, Encoding_latin_1)
							  or STRING_.same_case_insensitive (an_encoding, Encoding_us_ascii)
							  or STRING_.same_case_insensitive (an_encoding, Encoding_utf_8)
							  or STRING_.same_case_insensitive (an_encoding, Encoding_utf_16))
					 then
						bad_media_type := True
					end
				end
				if last_media_type.has_parameter ("action") then
					create an_action.make (last_media_type.parameter ("action"))
					create action.make (an_action)
				end
			end
		end

	
	do_common (a_req: GOA_HTTP_SERVLET_REQUEST; a_resp: GOA_HTTP_SERVLET_RESPONSE) is
			-- Process SOAP Message Exchange Patterns
		require
			request_exists: a_req /= Void
			response_exists: a_resp /= Void
		do
			use_mep_role
			parse_request (a_req)
			if is_http_1_1 then
				check_media_type
				if bad_media_type then
					a_resp.send_error (Sc_unsupported_media_type)
				else

					-- TODO: This is nonsense, as get request won't have any content!
					
					if a_req.content /= Void then
						current_response := a_resp
						process (a_req.content, base_uri)
					else
						a_resp.send_error (Sc_bad_request)
					end
				end
			else
				a_resp.send_error (Sc_http_version_not_supported)
			end
		end
	

end -- class GOA_SOAP_SERVLET

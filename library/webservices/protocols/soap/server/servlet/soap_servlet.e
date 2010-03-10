indexing
	description: "SOAP RPC/Messaging Servlet"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "SOAP"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	SOAP_SERVLET

inherit

	HTTP_SERVLET
		redefine
			do_get, do_post, init
		end
	
	SHARED_SERVICE_REGISTRY
		export
			{NONE} all
		end
	
	SHARED_ENCODING_REGISTRY
		export
			{NONE} all
		end
		
	SOAP_CONSTANTS
		export
			{NONE} all
		end
		
creation

	init
	
feature -- Initialisation

	init (config: SERVLET_CONFIG) is
			-- Initialise encoding registry
		do
			Precursor (config)
			encodings.register (create {SOAP_XML_ENCODING}, Ns_uri_soap_enc)
		end
		
feature -- Basic operations

	do_get (req: HTTP_SERVLET_REQUEST; resp: HTTP_SERVLET_RESPONSE) is
			-- Process GET request
		do			
			resp.set_content_type("text/html");
			resp.send ("<html><head><title>SOAP_SERVLET</title></head>");
			resp.send ("<body><h1>SOAP Servlet</h1>");
			resp.send ("<p>Cannot call using method GET. Call with method POST.");
			resp.send ("</p></body></html>");
		end
	
	do_post (req: HTTP_SERVLET_REQUEST; resp: HTTP_SERVLET_RESPONSE) is
			-- Process POST request
		local
			service_name, action: STRING
			response: STRING
			agent_service: SERVICE_PROXY
			parameters: TUPLE [ANY]
			first: DOM_ELEMENT
		do
			debug ("soap")
				print ("SOAP_SERVLET.do_post%R%N")
			end
			-- get SOAP action header
			parse_envelope (req)
			if valid_envelope then	
				-- extract call information from envelope
				first := envelope.body.entries.first
				service_name := extract_service_name (first)
				action := extract_action_name (first)
				if valid_envelope then
					-- retrieve service and execute call
					if registry.has (service_name) then
						agent_service := registry.get (service_name)
						parameters := extract_parameters (envelope.body.entries.first, action)
						-- check validity of parameters
						if are_parameters_valid and then agent_service.has (action) then
							agent_service.call (action, parameters)
						else
							-- construct fault response for invalid service action
							create fault.make
							fault.set_fault_code (Fault_code_client)
							fault.set_fault_string ("Service action '" + action + "' for service '" + service_name + "' not found")
							response := build_fault_response
						end
					else
						-- construct fault response for invalid service
						create fault.make
						fault.set_fault_code (Fault_code_client)
						fault.set_fault_string ("Service '" + service_name + "' not found")
						response := build_fault_response
					end
				
					-- process result
					if agent_service.process_ok then
						response := build_response (service_name, action, agent_service.last_result)
					end
				else
					-- construct fault response for invalid parameter
					create fault.make
					fault.set_fault_code (Fault_code_client)
					fault.set_fault_string (last_error)
					response := build_fault_response
				end
			else
				-- construct fault response and send
				response := build_fault_response
			end
			resp.set_content_type (Headerval_content_type)
			resp.set_content_length (response.count)
			resp.send (response)
		end

feature {NONE} -- Implementation

	envelope: SOAP_ENVELOPE
			-- SOAP envelope. Void on unmarshall error.
		
	valid_envelope: BOOLEAN
			-- Did the request contain a valid envelope?
	
	request_schema_version: INTEGER
			-- Xsi version. This is used to send the reponse using the same 
			-- schema version.
			
	Xsi_1999: INTEGER is 1
	Xsi_2001: INTEGER is 2
	
	last_error: STRING
			-- Last error message
			
	fault: SOAP_FAULT
			-- Fault element created for an error. Void if no error.

	Soap_service: STRING is "service"
	Soap_action: STRING is "action"
	
	parse_envelope (req: HTTP_SERVLET_REQUEST) is
			-- Parse SOAP envelope from request data. Will set 'valid_envelope' 
			-- if the request contained a valid SOAP envelope. If an error is
			-- detected then a SOAP_FAULT element will be created that represents
			-- the problem encountered.
		local
			parser: DOM_TREE_BUILDER
		do
			valid_envelope := True
			validate_request_header (req)
			if valid_envelope then
				create parser.make
				parser.parse_from_string (req.content)
				if parser.is_correct then
					debug ("soap")
						print (serialize_dom_tree (parser.document))
					end
					create envelope.unmarshall (parser.document.document_element)
				else
					valid_envelope := False
					envelope := Void
				end	
			end
		ensure
			fault_exists_if_invalid: not valid_envelope implies fault /= Void
		end
		
	build_response (service_name, action: STRING; last_result: ANY): STRING is
			-- Build response for 'action' called on 'service_name' with
			-- the result 'last_result'.
		require
			request_envelope_exists: envelope /= Void
		local
			impl: DOM_IMPLEMENTATION
			doc: DOM_DOCUMENT
			env, body, response, return: DOM_ELEMENT
			discard: DOM_NODE
			xsi, xsd: DOM_STRING
		do
			create {DOM_IMPLEMENTATION_IMPL} impl
			-- create XML document and envelope element with appropriate namespace attributes
			doc := impl.create_document (create {DOM_STRING}.make_from_string (Ns_uri_soap_env), 
				create {DOM_STRING}.make_from_string (Ns_pre_soap_env + ":" + Elem_envelope), Void)
			env := doc.document_element
			env.set_attribute_ns (create {DOM_STRING}.make_from_string (""),
				create {DOM_STRING}.make_from_string (Ns_pre_xmlns + ":" + Ns_pre_soap_env),
				create {DOM_STRING}.make_from_string (Ns_uri_soap_env))
			-- check request schema version and create appropriate response versions
			if request_schema_version = Xsi_2001 then
				create xsi.make_from_string (Ns_uri_schema_xsi_2001)
				create xsd.make_from_string (Ns_uri_schema_xsd_2001)
			elseif request_schema_version = Xsi_1999 then
				create xsi.make_from_string (Ns_uri_schema_xsi_1999)
				create xsd.make_from_string (Ns_uri_schema_xsd_1999)
			end
			env.set_attribute_ns (create {DOM_STRING}.make_from_string (""),
				create {DOM_STRING}.make_from_string (Ns_pre_xmlns + ":" + Ns_pre_schema_xsi), xsi)
			env.set_attribute_ns (create {DOM_STRING}.make_from_string (""),
				create {DOM_STRING}.make_from_string (Ns_pre_xmlns + ":" + Ns_pre_schema_xsd), xsd)
			-- create body element	
			body := doc.create_element_ns (create {DOM_STRING}.make_from_string (Ns_uri_soap_env), 
				create {DOM_STRING}.make_from_string (Ns_pre_soap_env + ":" + Elem_body))
			discard := env.append_child (body)
			-- create fault element
			response := doc.create_element_ns (create {DOM_STRING}.make_from_string (service_name), 
				create {DOM_STRING}.make_from_string ("ns1:" + action + "Response"))
			response.set_attribute_ns (create {DOM_STRING}.make_from_string (""),
				create {DOM_STRING}.make_from_string (Ns_pre_xmlns + ":ns1"),
				create {DOM_STRING}.make_from_string (service_name))
			response.set_attribute_ns (create {DOM_STRING}.make_from_string (""),
				create {DOM_STRING}.make_from_string (Ns_pre_soap_env + ":" + Attr_encoding_style),
				create {DOM_STRING}.make_from_string (Ns_uri_soap_enc))		
			discard := body.append_child (response)
			-- create result element
			-- only add parameter elements if the result was not Void
			if last_result /= Void then
				return := marshall_return_element (doc, last_result)
				discard := response.append_child (return)
			end
			debug ("soap")
				print (serialize_dom_tree (doc))
			end
			Result := serialize_dom_tree (doc)
		end
		
	build_fault_response: STRING is
			-- Build fault response
		require
			fault_exists: fault /= Void
		local
			impl: DOM_IMPLEMENTATION
			doc: DOM_DOCUMENT
			env, body, fault_elem, code, string: DOM_ELEMENT
			discard: DOM_NODE
		do
			create {DOM_IMPLEMENTATION_IMPL} impl
			-- create XML document and envelope element with appropriate namespace attributes
			doc := impl.create_document (create {DOM_STRING}.make_from_string (Ns_uri_soap_env), 
				create {DOM_STRING}.make_from_string (Ns_pre_soap_env + ":" + Elem_envelope), Void)
			env := doc.document_element
			env.set_attribute_ns (create {DOM_STRING}.make_from_string (""),
				create {DOM_STRING}.make_from_string (Ns_pre_xmlns + ":" + Ns_pre_soap_env),
				create {DOM_STRING}.make_from_string (Ns_uri_soap_env))
--			env.set_attribute_ns (create {DOM_STRING}.make_from_string (""),
--				create {DOM_STRING}.make_from_string (Ns_pre_xmlns + ":" + Ns_pre_schema_xsi),
--				create {DOM_STRING}.make_from_string (Ns_uri_schema_xsi))
--			env.set_attribute_ns (create {DOM_STRING}.make_from_string (""),
--				create {DOM_STRING}.make_from_string (Ns_pre_xmlns + ":" + Ns_pre_schema_xsd),
--				create {DOM_STRING}.make_from_string (Ns_uri_schema_xsd))
			-- create body element	
			body := doc.create_element_ns (create {DOM_STRING}.make_from_string (Ns_uri_soap_env), 
				create {DOM_STRING}.make_from_string (Ns_pre_soap_env + ":" + Elem_body))
			discard := env.append_child (body)
			-- create fault element
			fault_elem := doc.create_element_ns (create {DOM_STRING}.make_from_string (Ns_uri_soap_env), 
				create {DOM_STRING}.make_from_string (Ns_pre_soap_env + ":" + Elem_fault))	
			discard := body.append_child (fault_elem)
			-- create fault code element
			code := doc.create_element (create {DOM_STRING}.make_from_string (Elem_fault_code))
			discard := code.append_child (doc.create_text_node (create {DOM_STRING}.make_from_string (fault.fault_code)))
			discard := fault_elem.append_child (code)
			-- create fault string element
			string := doc.create_element (create {DOM_STRING}.make_from_string (Elem_fault_string))
			discard := string.append_child (doc.create_text_node (create {DOM_STRING}.make_from_string (fault.fault_string)))
			discard := fault_elem.append_child (string)
			debug ("soap")
				print (serialize_dom_tree (doc))
			end
			Result := serialize_dom_tree (doc)
		end
		
	serialize_dom_tree (document: DOM_DOCUMENT): STRING is
			-- Display dom tree to standard out.
		require
			document_exists: document /= Void	
		local
			writer: DOM_SERIALIZER
			string_stream: IO_STRING
		do
			create string_stream.make (1024)
			writer := serializer_factory.serializer_for_document (document)
			writer.set_output (string_stream)
			writer.serialize (document)		
			Result := string_stream.to_string
		end
	
	serializer_factory: DOM_SERIALIZER_FACTORY is
		once
			create Result
		end

	extract_service_name (first: DOM_ELEMENT): STRING is
			-- Find the service name in the envelope's first body entry. Void if not found.
		require
			first_exists: first /= Void
		do
			Result := first.namespace_uri.out
		end
		
	extract_action_name (first: DOM_ELEMENT): STRING is
			-- Find the action name in the envelope's first body entry. Void if not found.
		require
			first_exists: first /= Void
		do
			Result := first.local_name.out
		end
	
	extract_parameters (body_elem: DOM_ELEMENT): TUPLE [ANY] is
			-- Unserialize parameters from the envelope body and construct
			-- appropriate argument tuple for the agent call.
		require
			first_exists: body_elem /= Void
			valid_envelope: valid_envelope
		local
			elements: DOM_NODE_LIST
			element: DOM_ELEMENT
			name, scheme, type, value: STRING
			i: INTEGER
			q_name: Q_NAME
			xsi_uri, xsi_type_attr: DOM_STRING
		do
			create Result.make
			-- check that the element has parameter children
			if body_elem.has_child_nodes then
				-- locate encoding style
				scheme := find_encoding_style (body_elem)
				if scheme /= Void and then encodings.has (scheme) then
					elements := body_elem.child_nodes
					Result.resize (1, elements.length)
					from
						i := 0
					until
						i >= elements.length or not valid_envelope
					loop
						element ?= elements.item (i)
						check element /= Void end
						name := element.local_name.out
						-- check that we dealing with a simple type
						if not element.first_child.has_child_nodes then
							value := element.first_child.node_value.out
							-- check for both 1999 and 2001 XML Schema instance namespaces
							create xsi_uri.make_from_string (Ns_uri_schema_xsi_2001)
							create xsi_type_attr.make_from_string (Attr_type)
							if element.has_attribute_ns (xsi_uri, xsi_type_attr) then
								type := element.get_attribute_ns (xsi_uri, xsi_type_attr).out
								-- save schema version for response
								request_schema_version := xsi_2001
							else
								create xsi_uri.make_from_string (Ns_uri_schema_xsi_1999)
								if element.has_attribute_ns (xsi_uri, xsi_type_attr) then
									type := element.get_attribute_ns (xsi_uri, xsi_type_attr).out
									-- save schema version for response
									request_schema_version := xsi_1999
								end
							end
							-- check that a type attribute was found
							if type /= Void then
								create q_name.make_from_qname (type)
								if encodings.valid_type (scheme, q_name.local_name) then
									Result.force (encodings.unmarshall (scheme, type, value), i + 1)
									i := i + 1	
								else
									valid_envelope := False
									last_error := "Unknown type " + type + " in encoding scheme " + scheme
								end	
							else
								valid_envelope := False
								last_error := "Parameter type must be specified"
							end
						else
							valid_envelope := False
							last_error := "Composite types not supported yet"
						end
					end
				else
					valid_envelope := False
					if scheme = Void then
						last_error := "Unspecified encoding scheme"
					else
						last_error := "Unknown encoding scheme " + scheme
					end
				end
			end
		end		
		
	marshall_return_element (doc: DOM_DOCUMENT; last_result: ANY): DOM_ELEMENT is
			-- Determine type of 'last_result' and create return element
			-- with appropriate xsi:type and marshalled value.
		require
			doc_exists: doc /= Void
			last_result_not_void: last_result /= Void
		local
			value_node: DOM_TEXT
			discard: DOM_NODE
			type: DOM_ATTR
			value_pair: DS_PAIR [STRING, STRING]
		do
			-- create return element
			Result := doc.create_element (create {DOM_STRING}.make_from_string ("return"))
			type := doc.create_attribute (create {DOM_STRING}.make_from_string (Ns_pre_schema_xsi + ":" + Attr_type))
			discard := Result.set_attribute_node (type)
			value_pair := encodings.marshall (Ns_uri_soap_enc, last_result)
			type.set_node_value (create {DOM_STRING}.make_from_string (value_pair.first))
			value_node := doc.create_text_node (create {DOM_STRING}.make_from_string (value_pair.second))
			discard := Result.append_child (value_node)
		end
	
	find_encoding_style (body_elem: DOM_ELEMENT): STRING is
			-- Search 'body_elem' and its parents for encoding style attribute
		require
			first_exists: body_elem /= Void
			valid_envelope: valid_envelope
		local
			element: DOM_ELEMENT
			ns, attr_name: DOM_STRING
		do
			create ns.make_from_string (Ns_uri_soap_env)
			create attr_name.make_from_string (Attr_encoding_style)
			from	
				element := body_elem
			until
				element = Void or Result /= Void
			loop
				if element.has_attribute_ns (ns, attr_name) then
					Result := element.get_attribute_ns (ns, attr_name).out
				else
					element ?= element.parent_node
				end
			end
		end
		
	Soap_action_header: STRING is "HTTP_SOAPACTION"

	validate_request_header (req: HTTP_SERVLET_REQUEST) is
			-- Validate the HTTP request for valid header elements for a 
			-- SOAP request.
		require
			req_exists: req /= Void
		do
			if not req.has_header (Soap_action_header) then
				valid_envelope := False
				create fault.make
				fault.set_fault_code (Fault_code_client)
				fault.set_fault_string ("SOAPAction HTTP header not found")
			end
		end
		
end -- class SOAP_SERVLET

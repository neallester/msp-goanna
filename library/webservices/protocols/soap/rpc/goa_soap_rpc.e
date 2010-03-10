	description: "SOAP Remote Procedure Calls"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "SOAP"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Colin Adams <colin-adams@users.sourceforge.net>"
	copyright: "Copyright (c) 2005 Colin Adams and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

deferred class	GOA_SOAP_RPC

inherit

	XM_XPATH_NAME_UTILITIES

	GOA_SHARED_SERVICE_REGISTRY
		export
			{NONE} all
		end

feature -- Status report

	extracted_parameters: TUPLE
			-- Set by `extract_parameters'
	
feature -- Basic Operations

	call (an_envelope: GOA_SOAP_ENVELOPE; a_node_identity: UT_URI; a_role: UT_URI) is
			-- Call RPC encoded within `an_envelope'.
		require
			envelope_exists: an_envelope /= Void
			envelope_is_validated: an_envelope.validation_complete and then an_envelope.validate
			node_uri_not_void: a_role /= Void and then not STRING_.same_string (a_role.full_reference, Role_ultimate_receiver) implies a_node_uri /= Void
		local
			a_body: GOA_SOAP_BODY
			a_request: GOA_SOAP_ELEMENT
			a_service_name, a_method_name: STRING
			a_service_agent: GOA_SERVICE_PROXY
			some_parameters: TUPLE
		do
			a_body := an_envelope.body
			if a_body.body_blocks.count = 0 then
				send_no_request_in_body_message (a_node_identity)
			else
				a_request := a_body.body_blocks.item (1)
				if a_request.has_namespace then
					a_service_name := a_request.namespace.uri
					a_method_name := a_request.name
					if registry.has (a_service_name) then
						a_service_agent := registry.get (a_service_name)
						if a_service_agent.has (a_method_name) then
							extract_parameters (a_request, a_service_agent, a_method_name)
							if is_valid_parameters then
								a_service_agent.call (a_method_name, extracted_parameters)
								send_rpc_response (rpc_response (a_service_name, a_method_name, a_service_agent.last_result, extracted_parameters, a_node_identity, a_role))
							else
								send_invalid_parameters_response (a_node_identity, a_role)
							end
						else
							send_unknown_service_message (a_request.block_name, a_node_identity, a_role)
						end
					else
						send_unknown_service_message (a_request.block_name, a_node_identity, a_role)
					end
				else
					send_unknown_service_message (a_request.block_name, a_node_identity, a_role)
				end
			end
		end

			
feature -- Messages

	send_rpc_response (a_response: GOA_SOAP_ENVELOPE) is
			-- Send `a_response' to the requester.
		require
			envelope_exists: an_envelope /= Void
			envelope_is_validated: an_envelope.validation_complete and then an_envelope.validate
		deferred

			-- N.B. Implementations can detect if the response is a SOAP fault
			--  or not, and if so, if it's an env:Sender fault (HTTP 1.1 binding needs to do this),
			--  by inspecting the envelope.

		end

feature {NONE} -- Implementation

	rpc_response (a_service_name, a_method_name: STRING; a_result_value: ANY; some_parameters: TUPLE; a_node_identity: UT_URI; a_role: UT_URI): GOA_SOAP_ENVELOPE is
			-- SOAP response Envelope.
		require
			service_name_not_empty: a_service_name /= Void and then not a_service_name.is_empty
			method_name_not_empty: a_method_name /= Void and then not a_method_name.is_empty
			node_uri_not_void: a_role /= Void and then not STRING_.same_string (a_role.full_reference, Role_ultimate_receiver) implies a_node_uri /= Void
		deferred
		ensure
			response_envelope_built: Result /= Void 
		end

	send_unknown_service_message (a_service_name: STRING; a_node_identity: UT_URI; a_role: UT_URI) is
			-- Build and send an unknown service message.
		require
			service_name_not_empty: a_service_name /= Void and then is_valid_expanded_qname (a_service_name)
			node_uri_not_void: a_role /= Void and then not STRING_.same_string (a_role.full_reference, Role_ultimate_receiver) implies a_node_uri /= Void
		local
			a_fault_intent: GOA_SOAP_FAULT_INTENT
			a_fault: GOA_SOAP_FAULT
		do
			create a_fault_intent.make (Sender_fault, STRING_.concat ("Unknown service: ", a_service_name), "en", a_node_identity, a_role)
			a_fault := a_fault_intent.new_fault
			a_fault.envelope.validate (a_node_identity)
			check
				valid_envelope: a_fault.envelope.validation_complete and then a_fault.envelope.validated
			end
			send_rpc_response (a_fault.envelope)
		end

	send_invalid_parameters_response (a_node_identity: UT_URI; a_role: UT_URI) is
			-- Build and send an invalid-parameters message.
		require
			node_uri_not_void: a_role /= Void and then not STRING_.same_string (a_role.full_reference, Role_ultimate_receiver) implies a_node_uri /= Void
		local
			a_fault_intent: GOA_SOAP_FAULT_INTENT
			a_fault: GOA_SOAP_FAULT
		do
			create a_fault_intent.make (Sender_fault, "Parameters to RPC were not valid", "en", a_node_identity, a_role)
			a_fault := a_fault_intent.new_fault
			a_fault.envelope.validate (a_node_identity)
			check
				valid_envelope: a_fault.envelope.validation_complete and then a_fault.envelope.validated
			end
			send_rpc_response (a_fault.envelope)
		end
			
	send_no_request_in_body_message (a_node_identity: UT_URI; a_role: UT_URI) is
			-- Build and send an empty-body message.
		require
			node_uri_not_void: a_role /= Void and then not STRING_.same_string (a_role.full_reference, Role_ultimate_receiver) implies a_node_uri /= Void
		local
			a_fault_intent: GOA_SOAP_FAULT_INTENT
			a_fault: GOA_SOAP_FAULT
		do
			create a_fault_intent.make (Sender_fault, "Request Body was empty", "en", a_node_identity, a_role)
			a_fault := a_fault_intent.new_fault
			a_fault.envelope.validate (a_node_identity)
			check
				valid_envelope: a_fault.envelope.validation_complete and then a_fault.envelope.validated
			end
			send_rpc_response (a_fault.envelope)
		end

	extract_parameters (a_request: GOA_SOAP_ELEMENT; a_service: GOA_SERVICE_PROXY; an_action: STRING) is
			-- Convert params to a tuple suitable for passing to an agent.
		require
			service_exists: a_service /= Void
			action_exists: an_action /= Void and then a_service.has (an_action)
			request_exists: a_request /= Void
		local
			c: DS_LINKED_LIST_CURSOR [GOA_XRPC_PARAM]
			i: INTEGER
			an_object: ANY
		do
			are_parameters_valid := True
			Result := a_service.new_tuple (an_action)
			if not params.is_empty then				
				from
					c := params.new_cursor
					c.start
					i := 1
				until
					not are_parameters_valid or else c.off
				loop
					if Result.valid_index (i) then
						an_object := c.item.value.as_object
						if Result.valid_type_for_index (an_object, i) then
							Result.put (an_object, i)
						else
							are_parameters_valid := False
						end
						c.forth
						i := i + 1
					else
						are_parameters_valid := False
					end
				end
			end
		ensure
			param_tuple_exists: Result /= Void
			valid_number_of_params: Result.count = params.count
		end

end -- class GOA_SOAP_RPC

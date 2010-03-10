indexing
	description: "XML RPC/Messaging Servlet"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "XML-RPC"
	date: "$Date: 2008-03-06 13:50:41 -0800 (Thu, 06 Mar 2008) $"
	revision: "$Revision: 604 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class	GOA_XMLRPC_SERVLET

inherit

	GOA_HTTP_SERVLET
		redefine
			do_get, do_post
		end

	GOA_SHARED_SERVICE_REGISTRY
		export
			{NONE} all
		end

	GOA_XRPC_CONSTANTS
		export
			{NONE} all
		end

	KL_EXCEPTIONS
		export
			{NONE} all
		end

	GOA_HTTPD_LOGGER
		export
			{NONE} all
			{ANY} set_custom_log_file
		end

creation

	init

feature -- Basic operations

	do_get (req: GOA_HTTP_SERVLET_REQUEST; resp: GOA_HTTP_SERVLET_RESPONSE) is
			-- Process GET request
		local
			response_text: STRING
		do
			create fault.make (Unsupported_method_fault_code)
			response_text := fault.marshall
			-- send response
			resp.set_content_type (Headerval_content_type)
			resp.set_content_length (response_text.count)
			resp.send (response_text)
		end

	do_post (req: GOA_HTTP_SERVLET_REQUEST; resp: GOA_HTTP_SERVLET_RESPONSE) is
			-- Process POST request
		local
			response_text: STRING
			service_name, action: STRING
			agent_service: GOA_SERVICE_PROXY
			parameters: TUPLE
			result_value: GOA_XRPC_VALUE
			failed: BOOLEAN
		do
			if not failed then
				-- reset
				call := Void
				response := Void
				fault := Void
				-- process call
				parse_call (req)
				if valid_call then
					-- extract service details
					service_name := call.extract_service_name.out
					action := call.extract_action.out

					-- retrieve service and execute call
					if registry.has (service_name) then
						agent_service := registry.get (service_name)
						if agent_service.has (action) then
							parameters := call.extract_parameters (agent_service, action)
							if call.are_parameters_valid and then agent_service.valid_operands (action, parameters) then
								log_method_entry(call.method_name, parameters)
								agent_service.call (action, parameters)
								if agent_service.process_ok then
										-- if a fault occured, send it back
									if agent_service.last_fault /= Void then
										create fault.make_with_detail (user_fault, agent_service.last_fault)
										response_text := fault.marshall
										-- check for a result, if so pack it up to send back
									elseif agent_service.last_result /= Void then
										result_value := Value_factory.build (agent_service.last_result)
										if result_value /= Void then
											create response.make (create {GOA_XRPC_PARAM}.make (result_value))
											response_text := response.marshall
										else
											-- construct fault response for invalid return type
											create fault.make (Invalid_action_return_type)
											response_text := fault.marshall
										end
									else
										-- no return value
										create response.make (Void)
										response_text := response.marshall
									end
								else
									-- construct fault response for failed call
									create fault.make_with_detail (Unable_to_execute_service_action, " " + call.method_name.out)
									response_text := fault.marshall
								end
							else
								-- construct fault response for invalid action operands
								create fault.make_with_detail (Invalid_operands_for_service_action, " " + make_invalid_operands_detail_msg)
								response_text := fault.marshall
							end
						else
							-- construct fault response for invalid service action
							create fault.make_with_detail (Action_not_found_for_service, " " + call.method_name.out)
							response_text := fault.marshall
						end
					else
						-- construct fault response for invalid service
						create fault.make_with_detail (Service_not_found, " " + service_name)
						response_text := fault.marshall
					end
				else
					response_text := fault.marshall
				end
			end

			-- send response
			resp.set_content_type (Headerval_content_type)
			resp.set_content_length (response_text.count)
			resp.send (response_text)

			if fault /= Void then
				-- log failure
				if call = Void then
						-- invalid call
					log_hierarchy.logger (Xmlrpc_category).error ("Call failed (invalid call): " + fault.string)
				else
						-- other error
					log_hierarchy.logger (Xmlrpc_category).error ("Call (" + call.method_name + ") failed: " + fault.string)
				end
			else
				-- log return value
				log_method_exit (call.method_name, agent_service.last_result)
			end
		rescue
			if not failed then
				-- check for an assertion failure and respond with an appropriate fault
				-- otherwise fail as normal
				if assertion_violation then
					build_assertion_fault
					response_text := fault.marshall
					failed := True
					retry
				end
			end
		end

feature {NONE} -- Implementation

	valid_call: BOOLEAN
			-- Flag indicating whether the request contains a valid
			-- XMLRPC call.

	parse_call (req: GOA_HTTP_SERVLET_REQUEST) is
			-- Parse XMLRPC call from request data. Will set 'valid_call' 
			-- if the request contained a valid XMLRPC call. If an error is
			-- detected then an GOA_XRPC_FAULT element will be created that represents
			-- the problem encountered.
		local
			parser: XM_EIFFEL_PARSER
			tree_pipe: GOA_TREE_CALLBACKS_PIPE
		do
			valid_call := True
			create parser.make
			create tree_pipe.make
			parser.set_callbacks (tree_pipe.start)
			parser.parse_from_string (req.content)
			if parser.is_correct then
				create call.unmarshall (tree_pipe.document.root_element)
				if not call.unmarshall_ok then
					valid_call := False
					create fault.make (call.unmarshall_error_code)
					call := Void
				end
			else
				valid_call := False
				-- create fault
				create fault.make (Bad_payload_fault_code)
				call := Void
			end
		ensure
			fault_exists_if_invalid: not valid_call implies fault /= Void
		end

	call: GOA_XRPC_CALL
			-- Received call

	response: GOA_XRPC_RESPONSE
			-- Response to send to client. Void if a fault occurred.

	fault: GOA_XRPC_FAULT
			-- Fault to send to client. Void if a valid response was generated.

	build_assertion_fault is
			-- Initialise 'fault' to explain current assertion violation
		require
			assertion_violation: assertion_violation
		local
			detail: STRING
		do
			create detail.make (100)
			detail.append (": ")
			detail.append (meaning (exception))
			detail.append (" class: '")
			detail.append (class_name)
			detail.append ("' routine: '")
			detail.append (recipient_name)
			detail.append ("' tag: '")
			detail.append (tag_name)
			detail.append_character ('%'')
			create fault.make_with_detail (Assertion_failure, detail)
		ensure
			fault_initialised: fault /= Void and then fault.code = Assertion_failure
		end

feature {NONE} -- Logging

	limit: INTEGER is
			-- The nr. of characters of the return value's string representation that are logged
			-- in `log_method_exit' (the rest is truncated)
		once
			Result := 50
		end

	log_method_entry (method_name: STRING; params: TUPLE) is
			-- Logs an xml rpc method call with debug level INFO
			-- Example output: "Calling foo ('abc': STRING, '133': INTEGER)"
		require
			valid_method_name: method_name /= void
		local
			param: ANY
			logger: L4E_LOGGER
			logging_string: STRING
			i: INTEGER
		do
			logger := log_hierarchy.logger (Xmlrpc_category)
			if (logger.is_enabled_for (info_p)) then
				create logging_string.make_from_string ("Calling " + method_name + " (")

				-- create method params debug string
				from
					i := 1
				until
					i > params.count
				loop
					param := params.item(i)
					logging_string.append ("'" + param.out + "': " + param.generating_type)

					-- add param separator if necessary
					if (i < params.count) then
						logging_string.append (", ")
					end

					i := i + 1
				end

				logging_string.append (")")
				logger.info (logging_string)
			end
		end

	log_method_exit (method_name: STRING; return_value: ANY) is
			-- Logs an xml rpc method return with debug level DEBUG
			-- `return_value' is Void if the method has no return value.
			-- Only `limit' characters of the return value's string representation are logged.
			-- Example output: "Leaving foo (result = 'test': STRING)"
		require
			valid_method_name: method_name /= Void
		local
			logger: L4E_LOGGER
			logging_string: STRING
			out_string: STRING
		do
			logger := log_hierarchy.logger (Xmlrpc_category)

			if (logger.is_enabled_for (debug_p)) then
				create logging_string.make_from_string ("Leaving " + method_name)

				-- Log return value
				if (return_value /= Void) then
					logging_string.append (" (Result= '")

					out_string := return_value.out
					if (out_string.count > limit) then
						-- Truncate return value string
						logging_string.append(out_string.substring (1, limit))
						logging_string.append ("(...)")
					else
						logging_string.append (out_string)
					end

					logging_string.append ("': " + return_value.generating_type + ")")
				end

				logger.debugging (logging_string)
			end
		end

	make_invalid_operands_detail_msg: STRING is
			-- Creates the detailed message to be used for a fault of type `Invalid_operands_for_service_action'
		do
			Result := call.method_name.out + " (" + call.last_error_msg + ", parameters: "
			from
				call.params.start
			until
				call.params.after
			loop
				Result.append ("'")
				Result.append (call.params.item_for_iteration.value.as_object.out)
				Result.append ("': ")
				Result.append (call.params.item_for_iteration.value.type)
				Result.append (", ")
				call.params.forth
			end

			Result.remove_tail (2)
			Result.append (")")
		end

end -- class GOA_XMLRPC_SERVLET

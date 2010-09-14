note
	description: "Introspection services for XML-RPC servers."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "XML-RPC"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class GOA_XRPC_SYSTEM

inherit
	
	GOA_SERVICE

	GOA_XRPC_CONSTANTS
		rename
			Double_type as Xrpc_double_type
		export
			{NONE} all
		end
		
	GOA_SHARED_SERVICE_REGISTRY
		export
			{NONE} all
		end
	
	GOA_HTTPD_LOGGER
		export
			{NONE} all
		end
	
create

	make
	
feature -- Access

	list_methods: ARRAY [STRING]
			-- List all available methods
		local
			service_cursor: DS_HASH_TABLE_CURSOR [GOA_SERVICE_PROXY, STRING]
			method_cursor: DS_HASH_TABLE_CURSOR [ROUTINE [ANY, TUPLE], STRING]
			service: GOA_SERVICE_PROXY
			names: DS_LINKED_LIST [STRING]
			name: STRING
		do
			create names.make_default
			from
				service_cursor := registry.elements.new_cursor
				service_cursor.start
			until
				service_cursor.off
			loop
				service := service_cursor.item
				from
					method_cursor := service.elements.new_cursor
					method_cursor.start
				until
					method_cursor.off
				loop
					create name.make (service_cursor.key.count + 1 + method_cursor.key.count)
					name.append (service_cursor.key)
					name.append (".")
					name.append (method_cursor.key)
					names.force_last (name)
					method_cursor.forth
				end
				service_cursor.forth
			end
			-- convert to array
			Result := names.to_array
		ensure
			method_list_exists: Result /= Void
		end
	
	method_signature (method_name: STRING): ARRAY [ARRAY [STRING]]
			-- List the signatures for the method named 'method_name'.
			-- TIt returns an array of possible signatures for this method. 
			-- A signature is an array of types. The first of these types is 
			-- the return type of the method, the rest are parameters.
			--
			-- Multiple signatures (ie. overloading) are permitted: this is the 
			-- reason that an array of signatures are returned by this method.
			-- 
			-- Signatures themselves are restricted to the top level parameters 
			-- expected by a method. For instance if a method expects one array of 
			-- structs as a parameter, and it returns a string, its signature is simply 
			-- "string, array". If it expects three integers, its signature 
			-- is "string, int, int, int".
		require
			method_name_exists: method_name /= Void
			method_registered: has_method (method_name).item
		do
			-- TODO: this wasn't implemented. Is it necessary? review.
		ensure
			signature_exists: Result /= Void
		end
	
	method_help (method_name: STRING): STRING
			-- Return the documentation for the named method.
		require
			method_name_exists: method_name /= Void
			method_registered: has_method (method_name).item
		local
			service, method: STRING
			i: INTEGER
		do
			i := method_name.index_of ('.', 1)
			service := method_name.substring (1, i - 1)
			method := method_name.substring (i + 1, method_name.count)
			Result := registry.get (service).help (method)
		ensure
			help_exists: Result /= Void
		end
		
	has_method (method_name: STRING): BOOLEAN_REF
			-- Is a service registered with the name 'method_name'?
			-- This routine is a non-standard extension to the XML-RPC 
			-- introspection API.
		require
			method_name_exists: method_name /= Void
			method_name_size: method_name.count >= 3
			valid_method_name: method_name.index_of ('.', 1) > 0
		local
			service, method: STRING
			i: INTEGER
		do
			i := method_name.index_of ('.', 1)
			service := method_name.substring (1, i - 1)
			method := method_name.substring (i + 1, method_name.count)
			create Result
			if registry.has (service) then
				Result.set_item (registry.get (service).has (method))
			end
		ensure
			result_exists: Result /= Void
		end
		
	multi_call (calls: ARRAY [ANY]): ARRAY [ANY]
			-- Execute all 'calls' and return results in an array.
		require
			calls_exist: calls /= Void
		local
			i: INTEGER
			sub_call: GOA_XRPC_CALL
			fault: GOA_XRPC_FAULT
			result_table: DS_HASH_TABLE [ANY, STRING]
			result_array: ARRAY [ANY]
			service_name, action: STRING
			agent_service: GOA_SERVICE_PROXY
			parameters: TUPLE
			result_value: GOA_XRPC_VALUE
		do
			create Result.make (calls.lower, calls.upper)
			from
				i := calls.lower
			until
				i > calls.upper
			loop
				fault := Void
				result_value := Void
				result_table := Void
				result_array := Void
				create sub_call.unmarshall_for_multi_call (calls.item (i))
				if sub_call.unmarshall_ok then
					-- check for recursion attempt
					if sub_call.method_name.is_equal (System_multicall_member) then
						create fault.make (Multi_call_recursion)
					else
						-- call as normal and process result
						service_name := sub_call.extract_service_name.out
						action := sub_call.extract_action.out
						log_hierarchy.logger (Xmlrpc_category).info ("Multicall calling: " + sub_call.method_name.out)
						-- retrieve service and execute call
						if registry.has (service_name) then
							agent_service := registry.get (service_name)
							if agent_service.has (action) then
								parameters := sub_call.extract_parameters (agent_service, action)
								if sub_call.are_parameters_valid and then agent_service.valid_operands (action, parameters) then
									agent_service.call (action, parameters)
									if agent_service.process_ok then
										-- check for a result, if so pack it up to send back
										if agent_service.last_result /= Void then
											result_value := Value_factory.build (agent_service.last_result)
											if result_value = Void then	
												-- construct fault response for invalid return type
												create fault.make (Invalid_action_return_type)
											end
										end
									else
										-- construct fault response for failed call
										create fault.make_with_detail (Unable_to_execute_service_action, " " + sub_call.method_name.out)
									end	
								else
									-- construct fault response for invalid action operands
									create fault.make_with_detail (Invalid_operands_for_service_action, " " + sub_call.method_name.out)
								end
							else
								-- construct fault response for invalid service action
								create fault.make_with_detail (Action_not_found_for_service, " " + sub_call.method_name.out)
							end
						else
							-- construct fault response for invalid service
							create fault.make_with_detail (Service_not_found, " " + service_name)
						end	
					end
				else
					-- call unmarshall fault
					create fault.make (sub_call.unmarshall_error_code)
				end
				-- construct result_table
				if fault /= Void then
					create result_table.make (2)
					result_table.force (fault.code, "faultCode")
					result_table.force (fault.string, "faultString")
					Result.force (result_table, i)
				else
					-- TODO: handle empty result
					create result_array.make (1, 1)
					result_array.force (result_value, 1)
					Result.force (result_array, i)
				end
				i := i + 1
			end
		ensure
			results_exist: Result /= Void
			correct_result_count: Result.count = calls.count
		end

feature -- Creation

	new_tuple (a_name: STRING): TUPLE
			--	Tuple of default-valued arguments to pass to call `a_name'.
		local
			a_tuple: TUPLE []
			a_string_tuple: TUPLE [STRING]
			an_array_tuple: TUPLE [ARRAY [ANY]]
		do
			if a_name.is_equal (List_methods_name) then
				create a_tuple; Result := a_tuple				
			elseif a_name.is_equal (Method_help_name) then
				create a_string_tuple; Result := a_string_tuple
			elseif a_name.is_equal (Has_method_name) then
				create a_string_tuple; Result := a_string_tuple
			elseif a_name.is_equal (Multi_call_name) then
				create an_array_tuple; Result := an_array_tuple
			end
		end

feature {NONE} -- Implementation

	List_methods_name: STRING = "listMethods"
			-- Name of `list_methods' service

	Method_help_name: STRING = "methodHelp"
			-- Name of `method_help' service

	Has_method_name: STRING = "hasMethod"
			-- Name of `has_method' service

	Multi_call_name: STRING = "multiCall"
			-- Name of `multi_call' service
				
feature {NONE} -- Initialisation

	self_register
			-- Register all actions for this service
		do		
			register_with_help (agent list_methods, List_methods_name, "Enumerate all methods implemented by this server")
--			register_with_help (agent method_signature, "methodSignature", "Return the possible signatures for the named method")
			register_with_help (agent method_help, Method_help_name, "Return the documentation string for the named method")
			register_with_help (agent has_method, Has_method_name, "Determine if a named method implemented by this server")
			register_with_help (agent multi_call, Multi_call_name, "Execute multiple calls")
		end

end -- class GOA_XRPC_SYSTEM

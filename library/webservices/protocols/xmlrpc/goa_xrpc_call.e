note
	description: "Objects that represent an XML-RPC call."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "XML-RPC"
	date: "$Date: 2008-03-06 13:50:41 -0800 (Thu, 06 Mar 2008) $"
	revision: "$Revision: 604 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class GOA_XRPC_CALL

inherit

	GOA_XRPC_ELEMENT

create

	make, make_from_string, unmarshall

create {GOA_XRPC_SYSTEM}

	unmarshall_for_multi_call

feature -- Initialisation

	make (new_method: STRING)
			-- Initialise
		require
			new_method_exists: new_method /= Void
		do
			method_name := new_method
			create params.make_default
			unmarshall_ok := True
		end

	make_from_string (new_method: STRING)
			-- Initialise
		require
			new_method_exists: new_method /= Void
		do
			create method_name.make_from_string (new_method)
			create params.make_default
			unmarshall_ok := True
		end

	unmarshall (node: XM_ELEMENT)
			-- Initialise XML-RPC call from DOM element.
		local
			method_name_elem, params_elem, next_param: XM_ELEMENT
			param_set_cursor: DS_BILINEAR_CURSOR [XM_NODE]
			param: GOA_XRPC_PARAM
		do
			unmarshall_ok := True
			create params.make_default
			method_name_elem := get_named_element (node, Method_name_element)
			if method_name_elem /= Void then
				-- set method name
				method_name := method_name_elem.text
				-- check for parameters
				params_elem := get_named_element (node, Params_element)
				if params_elem /= Void then
					-- unmarshall all parameters
					if not params_elem.is_empty then
						param_set_cursor := params_elem.new_cursor
						-- unmarshall each parameter
						from
							param_set_cursor.start
						until
							param_set_cursor.off or not unmarshall_ok
						loop
							next_param ?= param_set_cursor.item
							if next_param /= Void then
								create param.unmarshall (next_param)
								if param.unmarshall_ok then
									params.force_last (param)
								else
									unmarshall_ok := False
									unmarshall_error_code := param.unmarshall_error_code
								end
							else
								unmarshall_ok := False
								unmarshall_error_code := param.unmarshall_error_code
							end
							param_set_cursor.forth
						end
					end
				end
			else
				unmarshall_ok := False
				unmarshall_error_code := Method_name_element_missing
			end
		end

feature {GOA_XRPC_SYSTEM} -- Initialisation

	unmarshall_for_multi_call (struct: ANY)
			-- Initialise XML-RPC call from struct containing methodName and param members.
			-- Used by multiCall.
		require
			struct_exists: struct /= Void
		local
			table: DS_HASH_TABLE [ANY, STRING]
			param_array: ARRAY [ANY]
			param_value: GOA_XRPC_VALUE
			i: INTEGER
		do
			unmarshall_ok := True
			table ?= struct
			if table /= Void then
				method_name ?= table.item (Method_name_element)
				if method_name /= Void then
					param_array ?= table.item (Params_element)
					if param_array /= Void then
						from
							i := param_array.lower
							create params.make
						until
							i > param_array.upper
						loop
							param_value := Value_factory.build (param_array.item (i))
							params.force_last (create {GOA_XRPC_PARAM}.make (param_value))
							i := i + 1
						end
					else
						unmarshall_ok := False
						unmarshall_error_code := Invalid_multi_call_params
					end
				else
					unmarshall_ok := False
					unmarshall_error_code := Invalid_multi_call_method_name
				end
			else
				unmarshall_ok := False
				unmarshall_error_code := Invalid_multi_call_params
			end
		end

feature -- Access

	method_name: STRING
			-- Name of method to call

	params: DS_LINKED_LIST [GOA_XRPC_PARAM]
			-- Call parameters

	extract_service_name: STRING
			-- Extract the service name from the call's 'method_name'. The 'method_name'
			-- should be in the form 'service.action', where 'service' is the service name.
			-- If a '.' does not exist in the 'method_name' then the service name is returned
			-- as an empty string.
		require
			method_name_exists: method_name /= Void
		local
			i: INTEGER
		do
			i := method_name.index_of ('.', 1)
			if i = 0 or (i - 1) <= 0 then
				create Result.make (0)
			else
				Result := method_name.substring (1, i - 1)
			end
		ensure
			empty_service_name_if_no_dot: method_name.index_of ('.', 1) = 0 implies Result.is_equal ("")
		end

	extract_action: STRING
			-- Extract the service name from the call's 'method_name'. The 'method_name'
			-- should be in the form 'service.action', where 'action' is the action to be invoked.
			-- If a '.' does not exist in the 'method_name' then the action is returned
			-- as an empty string.
		require
			method_name_exists: method_name /= Void
		local
			i: INTEGER
		do
			i := method_name.index_of ('.', 1)
			if i = 0 or (i + 1) >= method_name.count then
				create Result.make (0)
			else
				Result := method_name.substring (i + 1, method_name.count)
			end
		ensure
			empty_action_if_no_dot: method_name.index_of ('.', 1) = 0 implies Result.is_equal ("")
		end

	extract_parameters (a_service: GOA_SERVICE_PROXY; an_action: STRING): TUPLE
			-- Convert params to a tuple suitable for passing to an agent.
		require
			service_exists: a_service /= Void
			action_exists: an_action /= Void and then a_service.has (an_action)
			params_exists: params /= Void
		local
			c: DS_LINKED_LIST_CURSOR [GOA_XRPC_PARAM]
			i: INTEGER
			an_object: ANY
		do
			are_parameters_valid := True
			last_error_msg := Void

			Result := a_service.new_tuple (an_action)
			if Result.count /= params.count then
					-- Nr of parameters does not match
				are_parameters_valid := False
				last_error_msg := "Params count is off: Expected: " + Result.count.out + " but got " + params.count.out
			end

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
							-- Expected and actual types do not match
							are_parameters_valid := False
							last_error_msg := "Wrong type for param nr." + i.out
						end
						c.forth
						i := i + 1
					else
							-- should never occur
						are_parameters_valid := False
						last_error_msg := "No param with index " + i.out
					end
				end
			end
		ensure
			param_tuple_exists: Result /= Void
			valid_number_of_params: Result.count = params.count
		end

feature -- Status report

	are_parameters_valid: BOOLEAN
			-- Did `extract_parameters' return a TUPLE of valid parameters?

	last_error_msg: STRING
			-- Contains the last error message if not `are_parameters_valid', otherwise `Void'

feature -- Status setting

	set_method_name (new_name: STRING)
			-- Set method to call to 'new_name'
		require
			new_name_exists: new_name /= Void
		do
			method_name := new_name
		end

	add_param (new_param: GOA_XRPC_PARAM)
			-- Add 'new_param' to the list of parameters to send
			-- with this call.
		require
			new_param_exists: new_param /= Void
		do
			params.force_last (new_param)
		end

feature -- Marshalling

	marshall: STRING
			-- Serialize this call to XML format
		local
			c: DS_LINKED_LIST_CURSOR [GOA_XRPC_PARAM]
		do
			create Result.make (300)
			Result.append ("<?xml version=%"1.0%"?><methodCall><methodName>")
			Result.append (method_name.out)
			Result.append ("</methodName>")
			if not params.is_empty then
				Result.append ("<params>")
				from
					c := params.new_cursor
					c.start
				until
					c.off
				loop
					Result.append (c.item.marshall)
					c.forth
				end
				Result.append ("</params>")
			end
			Result.append ("</methodCall>")
		end

invariant

	method_name_set: unmarshall_ok implies method_name /= Void
	params_exists: unmarshall_ok implies params /= Void

end -- class GOA_XRPC_CALL

indexing
	description: "XMLRPC Example Client."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "examples xmlrpc"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class XRPC_CLIENT

inherit
		
	KL_SHARED_ARGUMENTS
		export
			{NONE} all
		end
		
	DT_SHARED_SYSTEM_CLOCK
		export
			{NONE} all
		end
	
	GOA_XRPC_CONSTANTS
		export
			{NONE} all
		end
		
create

	make

feature -- Initialization

	make is
			-- Create and initialise a new HTTP server that will listen for connections
			-- on 'port' and serving documents from 'doc_root'.
			-- Start the server
		do
			parse_arguments
			if argument_error then
				print_usage
			else
				create client.make (host, port, "/servlet/xmlrpc")
				create factory.make
				perform_echo_tests
				perform_introspection_tests
				perform_multicall_tests
			end
		end

feature {NONE} -- Implementation

	host: STRING
			-- Connect host
			
	port: INTEGER
			-- Connect port
			
	argument_error: BOOLEAN
			-- Did an error occur parsing arguments?
			
	parse_arguments is
			-- Parse the command line arguments and store appropriate settings
		do
			if Arguments.argument_count < 2 then
				argument_error := True
			else
				-- parse host
				host := Arguments.argument (1)
				-- parse port
				if Arguments.argument (2).is_integer then
					port := Arguments.argument (2).to_integer
				else
					argument_error := True
				end
			end
		end

	print_usage is
			-- Display usage information
		do
			print ("Usage: test <host> <port-number>%R%N")
		end
	
	client: GOA_XRPC_LITE_CLIENT
			-- XML-RPC client
	
	factory: GOA_XRPC_VALUE_FACTORY
			-- Value factory

	perform_echo_tests is
			-- Perform all echo tests
		local
			encoder: GOA_BASE64_ENCODER
			date_time: DT_DATE_TIME
			array: ARRAY [STRING]
			struct: DS_HASH_TABLE [ANY, STRING]
		do				
			-- basic types
			execute_test ("test.echoInt", 123, 123)
			execute_test ("test.echoBool", True, True)
			execute_test ("test.echoString", "this is a test", "this is a test")
			execute_test ("test.echoDouble", 123.5, 123.5)
			
			-- base 64
			create encoder
			execute_test ("test.echoBase64", encoder.encode ("this is a test"), encoder.encode ("this is a test"))
			execute_test ("test.echoDecodedBase64", encoder.encode ("this is a test"), "this is a test")
			
			-- date time
			date_time := System_clock.date_time_now
			execute_test ("test.echoDateTime", date_time, date_time)
			
			-- array
			create array.make (1, 4)
			array.force ("entry 1", 1)
			array.force ("entry 2", 2)
			array.force ("entry 3", 3)
			array.force ("entry 4", 4)
			execute_test ("test.echoArray", array, array)
			
			-- struct
			create struct.make_default
			struct.force ("entry 1", "key 1")
			struct.force ("entry 2", "key 2")
			struct.force ("entry 3", "key 3")
			struct.force ("entry 4", "key 4")
			execute_test ("test.echoStruct", struct, struct)
		end
	
	perform_introspection_tests is
			-- Call introspection methods
		local
			call: GOA_XRPC_CALL
			param: GOA_XRPC_PARAM
			methods: ARRAY [ANY]
		do
			create call.make_from_string ("system.listMethods")
			execute_call (call)
			
			create call.make_from_string ("system.methodSignature")
			create param.make (factory.build ("system.methodHelp"))
			call.add_param (param)
			execute_call (call)
			
			create call.make_from_string ("system.methodHelp")
			create param.make (factory.build ("system.listMethods"))
			call.add_param (param)
			execute_call (call)

			create call.make_from_string ("system.hasMethod")
			create param.make (factory.build ("system.listMethods"))
			call.add_param (param)
			execute_call (call)	
		end
		
	perform_multicall_tests is
			-- Call multicall methods
		local
			multi_call: GOA_XRPC_MULTI_CALL
			call: GOA_XRPC_CALL
			param: GOA_XRPC_PARAM
			methods: ARRAY [ANY]
		do		
			create multi_call.make
			
			create call.make_from_string ("system.methodHelp")
			create param.make (factory.build ("system.listMethods"))
			call.add_param (param)
			multi_call.add_call (call)

			create call.make_from_string ("system.hasMethod")
			create param.make (factory.build ("system.listMethods"))
			call.add_param (param)
			multi_call.add_call (call)
			
			execute_multi_call (multi_call)
		end
		
	execute_call (call: GOA_XRPC_CALL) is
			-- Invoke call and check result
		require
			call_exists: call /= Void
		do
			client.invoke (call)
			if client.invocation_ok then
				display_success (call.method_name.out)
			else
				display_fail (call.method_name.out, "Fault received: (" + client.fault.code.out + ") " + client.fault.string.out)
			end
		end
		
	execute_multi_call (multi_call: GOA_XRPC_MULTI_CALL) is
			-- Invoke call and check result
		require
			call_exists: multi_call /= Void
		do
			client.invoke (multi_call)
			if client.invocation_ok then
				display_success (multi_call.method_name.out)
			else
				display_fail (multi_call.method_name.out, "Fault received: (" + client.fault.code.out + ") " + client.fault.string.out)
			end
		end
		
	execute_test (name: STRING; arg: ANY; expected_result: ANY) is
			-- Execute call for test named 'name' and report successful result or fault.
			-- Pass 'arg' as the sole parameter.
			-- Compare result to 'expected_result'.
		require
			name_exists: name /= Void
			arg_exists: arg /= Void
		local
			call: GOA_XRPC_CALL
			param: GOA_XRPC_PARAM
			response_param: GOA_XRPC_PARAM
			obj: ANY
			array: ARRAY [ANY]
			struct: DS_HASH_TABLE [ANY, STRING]
		do
			create call.make_from_string (name)
			create param.make (factory.build (arg))
			call.add_param (param)
			client.invoke (call)
			if client.invocation_ok then
				response_param := client.response.value
				if response_param = Void then
					if expected_result = Void then
						display_success (name)
					else
						display_fail (name, "Invalid result: expected '" + expected_result.out + "' got Void")
					end
				else
					obj := response_param.value.as_object
					array ?= obj
					if array /= Void then
						compare_array (name, obj, expected_result)
					else
						struct ?= obj
						if struct /= Void then
							compare_struct (name, obj, expected_result)
						else
							compare_scalar (name, obj, expected_result)
						end
					end
				end
			else	
				display_fail (name, "Fault received: (" + client.fault.code.out + ") " + client.fault.string)
			end
		end

	compare_scalar (name: STRING; obj: ANY; expected: ANY) is
			-- Compare scalar values and report result
		require
			name_exists: name /= Void
		do
			if obj.is_equal (expected) then	
				display_success (name)
			else
				if expected = Void then
					display_fail (name, "Invalid result: expected Void received '" + obj.out + "'") 
				else
					display_fail (name, "Invalid result: expected '" + expected.out + "' received '" + obj.out + "'")
				end
			end
		end
		
	compare_array (name: STRING; arg: ANY; expected: ANY) is
			-- Compare scalar values and report result
		require
			name_exists: name /= Void
		local
			array: ARRAY [ANY]
			expected_array: ARRAY [ANY]
			ok: BOOLEAN
			i: INTEGER
		do
			array ?= arg
			if expected.conforms_to (array) then
				expected_array ?= expected
				if array.count = expected_array.count then
					from
						i := array.lower
						ok := True
					until
						i > array.upper or not ok
					loop
						if not array.item (i).is_equal (expected_array.item (i)) then
							ok := False
						end
						i := i + 1
					end
				else
					ok := False
				end
				if ok then	
					display_success (name)
				else
					if expected = Void then
						display_fail (name, "Invalid result: expected Void received '" + arg.out + "'") 
					else
						display_fail (name, "Invalid result: expected '" + expected.out + "' received '" + arg.out + "'")
					end
				end
			else
				display_fail (name, "Invalid result: expected '" + expected.out + "' received " + arg.out) 	
			end
		end
		
	compare_struct (name: STRING; arg: ANY; expected: ANY) is
			-- Compare struct values and report result
		require
			name_exists: name /= Void
		local
			struct: DS_HASH_TABLE [ANY, STRING]
			expected_struct: DS_HASH_TABLE [ANY, STRING]
			ok: BOOLEAN
			c1, c2: DS_HASH_TABLE_CURSOR [ANY, STRING]
		do
			ok := True
			struct ?= arg
			if expected.conforms_to (struct) then
				expected_struct ?= expected
				if struct.count = expected_struct.count then
					from
						c1 := struct.new_cursor
						c1.start
						c2 := expected_struct.new_cursor
						c2.start
					until
						c1.off or not ok
					loop
						if not c1.key.is_equal (c2.key) then
							ok := False
						else
							if not c1.item.is_equal (c2.item) then
								ok := False
							end
						end
						c1.forth
						c2.forth
					end
				else
					ok := False
				end
				if ok then	
					display_success (name)
				else
					if expected = Void then
						display_fail (name, "Invalid result: expected Void received '" + arg.out + "'") 
					else
						display_fail (name, "Invalid result: expected '" + expected.out + "' received '" + arg.out + "'")
					end
				end
			else
				display_fail (name, "Invalid result: expected '" + expected.out + "' received " + arg.out) 	
			end
		end
		
	display_success (name: STRING) is
			-- Display success message for test named 'name'
		require
			name_exists: name /= Void
		do
			print ("Test '" + name + "' successful%N")
		end
		
	display_fail (name, reason: STRING) is
			-- Display failure message for test named 'name'. Display 'reason'
			-- with message
		require
			name_exists: name /= Void
			reason_exists: reason /= Void
		do
			print ("Test '" + name + "' FAILED: " + reason + "%N")
		end	
		
end -- class XRPC_CLIENT

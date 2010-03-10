indexing
	description: "Test service. Provides test calls for all types"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "XMLRPC examples test"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class	TEST

inherit
	
	GOA_SERVICE
		
create
	
	make
			
feature -- Access
			
	echo_int (arg: INTEGER_REF): INTEGER_REF is
			-- Echo an integer argument
		do
			Result := arg
		end
	
	echo_bool (arg: BOOLEAN_REF): BOOLEAN_REF is
			-- Echo a boolean argument
		do
			Result := arg
		end
		
	echo_string (arg: STRING): STRING is
			-- Echo a string argument
		do
			Result := arg
		end
		
	echo_double (arg: DOUBLE_REF): DOUBLE_REF is
			-- Echo a double argument
		do
			Result := arg
		end
		
	echo_date_time (arg: DT_DATE_TIME): DT_DATE_TIME is
			-- Echo a date/time argument
		do
			Result := arg
		end
	
	echo_base64 (arg: STRING): STRING is
			-- Echo a base64 string.
		do
			Result := arg
		end
		
	echo_decoded_base64 (arg: STRING): STRING is
			-- Echo a base64 string. Return the string decoded.
		local
			encoder: GOA_BASE64_ENCODER
		do
			create encoder
			Result := encoder.decode (arg)
		end
		
	echo_array (arg: ARRAY [ANY]): ARRAY [ANY] is
			-- Echo an array.
		do
			Result := arg
		end
		
	echo_struct (arg: DS_HASH_TABLE [ANY, STRING]): DS_HASH_TABLE [ANY, STRING] is
			-- Echo a struct
		do
			Result := arg
		end	

feature -- Creation

	new_tuple (a_name: STRING): TUPLE is
			--	Tuple of default-valued arguments to pass to call `a_name'.
		local
			an_int_tuple: TUPLE [INTEGER_REF]
			a_bool_tuple: TUPLE [BOOLEAN_REF]
			a_string_tuple: TUPLE [STRING]
			a_double_tuple: TUPLE [DOUBLE_REF]
			a_date_time_tuple: TUPLE [DT_DATE_TIME]
			an_array_tuple: TUPLE [ARRAY [ANY]]
			a_struct_tuple: TUPLE [DS_HASH_TABLE [ANY, STRING]]
		do
			if a_name.is_equal (Echo_int_name) then
				create an_int_tuple; Result := an_int_tuple
			elseif a_name.is_equal (Echo_bool_name) then
				create a_bool_tuple; Result := a_bool_tuple
			elseif a_name.is_equal (Echo_string_name) then
				create a_string_tuple; Result := a_string_tuple
			elseif a_name.is_equal (Echo_double_name) then
				create a_double_tuple; Result := a_double_tuple
			elseif a_name.is_equal (Echo_date_time_name) then
				create a_date_time_tuple; Result := a_date_time_tuple
			elseif a_name.is_equal (Echo_base64_name) then
				create a_string_tuple; Result := a_string_tuple
			elseif a_name.is_equal (Echo_decoded_base64_name) then
				create a_string_tuple; Result := a_string_tuple
			elseif a_name.is_equal (Echo_array_name) then
				create an_array_tuple; Result := an_array_tuple				
			elseif a_name.is_equal (Echo_struct_name) then
				create a_struct_tuple; Result := a_struct_tuple				
			end
		end

feature {NONE} -- Implementation

	Echo_int_name: STRING is "echoInt"
			-- Name of `echo_int' service

	Echo_bool_name: STRING is "echoBool"
			-- Name of `echo_bool' service

	Echo_string_name: STRING is "echoString"
			-- Name of `echo_string' service

	Echo_double_name: STRING is "echoDouble"
			-- Name of `echo_double' service

	Echo_date_time_name: STRING is "echoDateTime"
			-- Name of `echo_date_time' service

	Echo_base64_name: STRING is "echoBase64"
			-- Name of `echo_base64' service

	Echo_decoded_base64_name: STRING is "echoDecodedBase64"
			-- Name of `echo_decoded_base64' service

	Echo_array_name: STRING is "echoArray"
			-- Name of `echo_array' service

	Echo_struct_name: STRING is "echoStruct"
			-- Name of `echo_struct' service

feature {NONE} -- Initialisation

	self_register is
			-- Register all actions for this service
		do	
			register (agent echo_int, 	Echo_int_name)
			register (agent echo_bool, Echo_bool_name)
			register (agent echo_string, Echo_string_name)
			register (agent echo_double, Echo_double_name)
			register (agent echo_date_time, Echo_date_time_name)
			register (agent echo_base64, Echo_base64_name)
			register (agent echo_decoded_base64, Echo_decoded_base64_name)
			register (agent echo_array, Echo_array_name)
			register (agent echo_struct, Echo_struct_name)			
		end

end -- class TEST

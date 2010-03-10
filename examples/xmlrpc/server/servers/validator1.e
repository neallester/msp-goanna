indexing
	description: "XML-RPC Validation services. Called by the XML-RPC Validation suite (http://www.xmlrpc.com)"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "XMLRPC examples validator"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class	VALIDATOR1

inherit
	
	GOA_SERVICE
		
create
	
	make
			
feature -- Access
			
	array_of_structs_test (arg: ARRAY [ANY]): INTEGER_REF is
			-- This handler takes a single parameter, an array of structs, 
			-- each of which contains at least three elements named moe, larry and curly, 
			-- all <i4>s. Yout handler must add all the struct elements named 
			-- curly and returns the result.
		local
			struct: DS_HASH_TABLE [ANY, STRING]
			i_ref: INTEGER_REF
			i: INTEGER
		do
			create Result
			from
				i := arg.lower
			until
				i > arg.upper
			loop
				struct ?= arg.item (i)
				if struct.has ("curly") then
					i_ref ?= struct.item ("curly")
					Result := Result + i_ref
				end
				i := i + 1
			end
		end

	count_the_entities (arg: STRING): DS_HASH_TABLE [ANY, STRING] is
			-- This handler takes a single parameter, a string, that contains 
			-- any number of predefined entities, namely <, >, &, ' and ".
			--
			-- Your handler must return a struct that contains five fields, 
			-- all numbers: ctLeftAngleBrackets, ctRightAngleBrackets, ctAmpersands, 
			-- ctApostrophes, ctQuotes. 
			--
			-- To validate, the numbers must be correct.
		local
			left_angle, right_angle, amper, apos, quot: INTEGER_REF
			i: INTEGER
		do
			create left_angle
			create right_angle
			create amper
			create apos
			create quot
			from
				i := 1
			until
				i > arg.count
			loop
				inspect arg.item (i)
				when '<' then
					left_angle := left_angle + 1
				when '>' then
					right_angle := right_angle + 1
				when '&' then
					amper := amper + 1
				when '%'' then
					apos := apos + 1
				when '"' then
					quot := quot + 1
				else
					-- normal character, ignore
				end
				i := i + 1
			end
			create Result.make (5)
			Result.force (left_angle, "ctLeftAngleBrackets")
			Result.force (right_angle, "ctRightAngleBrackets")
			Result.force (amper, "ctAmpersands")
			Result.force (apos, "ctApostrophes")
			Result.force (quot, "ctQuotes")
		end
	
	easy_struct_test (arg: DS_HASH_TABLE [ANY, STRING]): INTEGER_REF is
			-- This handler takes a single parameter, a struct, containing at 
			-- least three elements named moe, larry and curly, all <i4>s. Your 
			-- handler must add the three numbers and return the result.
		local
			c: DS_HASH_TABLE_CURSOR [ANY, STRING]
			int_ref: INTEGER_REF
		do
			create Result
			from
				c := arg.new_cursor
				c.start
			until
				c.off
			loop
				int_ref ?= c.item
				Result := Result + int_ref
				c.forth
			end
		end
	
	echo_struct_test (arg: DS_HASH_TABLE [ANY, STRING]): DS_HASH_TABLE [ANY, STRING] is
			-- This handler takes a single parameter, a struct. 
			-- Your handler must return the struct.
		do
			Result := arg
		end
	
	many_types_test (number: INTEGER_REF; boolean: BOOLEAN_REF; string: STRING;
		double: DOUBLE_REF; date_time: DT_DATE_TIME; base64: STRING): ARRAY [ANY] is
			-- This handler takes six parameters, and returns an array 
			-- containing all the parameters.
		do
			create Result.make (1, 6)
			Result.force (number, 1)
			Result.force (boolean, 2)
			Result.force (string , 3)
			Result.force (double, 4)
			Result.force (date_time, 5)
			Result.force (base64, 6)
		end
			
	moderate_size_array_check (arg: ARRAY [ANY]): STRING is
			-- This handler takes a single parameter, which is an array 
			-- containing between 100 and 200 elements. Each of the items is a string, 
			-- your handler must return a string containing the concatenated text of 
			-- the first and last elements.
		local
			str: STRING
		do
			create Result.make (100)
			str ?= arg.item (arg.lower)
			Result.append (str)
			str ?= arg.item (arg.upper)
			Result.append (str)
		end

	nested_struct_test (arg: DS_HASH_TABLE [ANY, STRING]): INTEGER_REF is
			-- This handler takes a single parameter, a struct, that models a daily 
			-- calendar. At the top level, there is one struct for each year. Each 
			-- year is broken down into months, and months into days. Most of the 
			-- days are empty in the struct you receive, but the entry for 
			-- April 1, 2000 contains a least three elements named moe, larry and 
			-- curly, all <i4>s. Your handler must add the three numbers and return 
			-- the result.
			--
			-- Ken MacLeod: "This description isn't clear, I expected '2000.April.1' 
			-- when in fact it's '2000.04.01'. Adding a note saying that month and 
			-- day are two-digits with leading 0s, and January is 01 would help." Done.
		local
			year, month, day: DS_HASH_TABLE [ANY, STRING]
			int_ref: INTEGER_REF
			c: DS_HASH_TABLE_CURSOR [ANY, STRING]
		do
			create Result
			year ?= arg.item ("2000")
			month ?= year.item ("04")
			day ?= month.item ("01")
			from
				c := day.new_cursor
				c.start
			until
				c.off
			loop
				int_ref ?= c.item
				Result := Result + int_ref
				c.forth
			end
		end
	
	simple_struct_return_test (arg: INTEGER_REF): DS_HASH_TABLE [ANY, STRING] is
			-- This handler takes one parameter, and returns a struct containing three elements, 
			-- times10, times100 and times1000, the result of multiplying the number by 10, 100 
			-- and 1000.
		do
			create Result.make (3)
			Result.force (arg * 10, "times10")
			Result.force (arg * 100, "times100")
			Result.force (arg * 1000, "times1000")
		end

feature -- Creation

	new_tuple (a_name: STRING): TUPLE is
			--	Tuple of default-valued arguments to pass to call `a_name'.
		local
			an_int_tuple: TUPLE [INTEGER_REF]
			a_string_tuple: TUPLE [STRING]
			an_array_tuple: TUPLE [ARRAY [ANY]]
			a_struct_tuple: TUPLE [DS_HASH_TABLE [ANY, STRING]]
			a_multi_tuple: TUPLE [INTEGER_REF, BOOLEAN_REF, STRING, DOUBLE_REF, DT_DATE_TIME, STRING]
		do
			if a_name.is_equal (Array_of_structs_test_name) then
				create an_array_tuple; Result := an_array_tuple	
			elseif a_name.is_equal (Count_the_entities_name) then
				create a_string_tuple; Result := a_string_tuple
			elseif a_name.is_equal (Easy_struct_test_name) then
				create a_struct_tuple; Result := a_struct_tuple
			elseif a_name.is_equal (Echo_struct_test_name) then
				create a_struct_tuple; Result := a_struct_tuple
			elseif a_name.is_equal (Many_types_test_name) then
				create a_multi_tuple; Result := a_multi_tuple
			elseif a_name.is_equal (Moderate_size_array_check_name) then
				create an_array_tuple; Result := an_array_tuple
			elseif a_name.is_equal (Nested_struct_test_name) then
				create a_struct_tuple; Result := a_struct_tuple
			elseif a_name.is_equal (Simple_struct_return_test_name) then
				create an_int_tuple; Result := an_int_tuple
			end
		end

feature {NONE} -- Implementation

	Array_of_structs_test_name: STRING is "arrayOfStructsTest"
			-- Name of `array_of_structs_test' service

	Count_the_entities_name: STRING is "countTheEntities"
			-- Name of `count_the_entities' service

	Easy_struct_test_name: STRING is "easyStructTest"
			-- Name of `easy_struct_test' service

	Echo_struct_test_name: STRING is "echoStructTest"
			-- Name of `echo_struct_test' service

	Many_types_test_name: STRING is "manyTypesTest"
			-- Name of `many_types_test' service

	Moderate_size_array_check_name: STRING is "moderateSizeArrayCheck"
			-- Name of `moderate_size_array_check' service

	Nested_struct_test_name: STRING is "nestedStructTest"
			-- Name of `nested_struct_test' service

	Simple_struct_return_test_name: STRING is "simpleStructReturnTest"
			-- Name of `simple_struct_return_test' service
		
feature {NONE} -- Initialisation

	self_register is
			-- Register all actions for this service
		do	
			register (agent array_of_structs_test, Array_of_structs_test_name)
			register (agent count_the_entities, Count_the_entities_name)	
			register (agent easy_struct_test, Easy_struct_test_name)
			register (agent echo_struct_test, Echo_struct_test_name)
			register (agent many_types_test, Many_types_test_name)
			register (agent moderate_size_array_check, Moderate_size_array_check_name)
			register (agent nested_struct_test, Nested_struct_test_name)
			register (agent simple_struct_return_test, Simple_struct_return_test_name)
		end

end -- class VALIDATOR1

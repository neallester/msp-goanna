indexing



	description: "Test features of class STRING_MANIPULATION"

	library:    "Goanna Utility Test Harnesses"

	author:     "Glenn Maughan <glennmaughan@optushome.com.au>"

	copyright:  "Copyright (c) 2001, Glenn Maughan and others"

	license:    "Eiffel Forum Freeware License v1 (see forum.txt)"

	date:       "$Date: 2010-02-26 11:12:53 -0800 (Fri, 26 Feb 2010) $"

	revision:   "$Revision: 624 $"



deferred class UTILITY_TEST_STRING_MANIPULATION



inherit



	TS_TEST_CASE



	GOA_STRING_MANIPULATION

		export

			{NONE} all

		end



feature -- Test



	test_last_index_of is

		local

			str: STRING

		do

			str := "test.one.two"

			assert_integers_equal ("two_positions", last_index_of (str, '.', str.count), 9)

			str := "test.one"

			assert_integers_equal ("one_position", last_index_of (str, '.', str.count), 5)

			str := "test"

			assert_integers_equal ("no_positions", last_index_of (str, '.', str.count), 0)

			str := "test."

			assert_integers_equal ("at_end", last_index_of (str, '.', str.count), 5)

			str := "test.one.two"

			assert_integers_equal ("start_before_end", last_index_of (str, '.', 8), 5)

			str := "."

			assert_integers_equal ("one_char", last_index_of (str, '.', str.count), 1)

		end

	test_as_16_bit_string is
		do
			assert_equal ("16448.as_16_bit_string", "@@", as_16_bit_string (16448))
			assert_equal ("5.as_16_bit_string.count", 2, as_16_bit_string (5).count)
		end


	test_as_32_bit_string is
		do
			assert_equal ("1077952576.as_32_bit_string", "@@@@", as_32_bit_string (1077952576))
			assert_equal ("5.as_16_bit_string.count", 4, as_32_bit_string (5).count)
		end



end -- class UTILITY_TEST_STRING_MANIPULATION


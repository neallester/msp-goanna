indexing

	description: "Test features of class BASE64_ENCODER"
	library:    "Goanna Utility Test Harnesses"
	author:     "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright:  "Copyright (c) 2001, Glenn Maughan and others"
	license:    "Eiffel Forum Freeware License v1 (see forum.txt)"
	date:       "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision:   "$Revision: 491 $"

deferred class UTILITY_TEST_BASE64_ENCODER

inherit

	TS_TEST_CASE

feature -- Test

	test_encoding is
			-- Test standard encoding features of GOA_BASE64_ENCODER
		local
			encoder: GOA_BASE64_ENCODER
		do
			!! encoder
			assert_equal ("empty", "", encoder.encode(""))
			assert_equal ("Hello there!","SGVsbG8gdGhlcmUh", encoder.encode ("Hello there!"))
			assert_equal ("Hello there!x", "SGVsbG8gdGhlcmUheA==", encoder.encode ("Hello there!x"))
			assert_equal ("Hello there!xx", "SGVsbG8gdGhlcmUheHg=", encoder.encode ("Hello there!xx"))
		end

	test_session_id_encoding is
			-- Test session ID encoding features of BASE^$_ENCODER
		local
			encoder: GOA_BASE64_ENCODER
		do
			!! encoder
			assert_equal ("Hello there!", "SGVsbG8gdGhlcmUh", encoder.encode_for_session_key ("Hello there!"))
			assert_equal ("Hello there!x", "SGVsbG8gdGhlcmUheA..", encoder.encode_for_session_key ("Hello there!x"))
			assert_equal ("Hello there!xx", "SGVsbG8gdGhlcmUheHg.", encoder.encode_for_session_key ("Hello there!xx"))
		end

	test_decoding is
			-- Test standard encoding features of GOA_BASE64_ENCODER
		local
			encoder: GOA_BASE64_ENCODER
		do
			!! encoder
			assert_equal ("empty", "", encoder.encode(""))
			assert_equal ("Hello there!", "Hello there!", encoder.decode ("SGVsbG8gdGhlcmUh"))
			assert_equal ("Hello there!x", "Hello there!x", encoder.decode ("SGVsbG8gdGhlcmUheA=="))
			assert_equal ("Hello there!xx", "Hello there!xx", encoder.decode ("SGVsbG8gdGhlcmUheHg="))
		end

end -- class UTILITY_TEST_BASE64_ENCODER

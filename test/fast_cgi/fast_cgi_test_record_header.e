indexing



	description: "Test features of class FAST_CGI_RECORD_HEADER"

	library:    "Goanna Fast_Cgi Test Harnesses"

	author:     "Glenn Maughan <glennmaughan@optushome.com.au>"

	copyright:  "Copyright (c) 2001, Glenn Maughan and others"

	license:    "Eiffel Forum Freeware License v1 (see forum.txt)"

	date:       "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"

	revision:   "$Revision: 491 $"



deferred class FAST_CGI_TEST_RECORD_HEADER



inherit



	TS_TEST_CASE



feature -- Test



	test_as_fast_cgi_string is
		local
			a_record_header: GOA_FAST_CGI_RECORD_HEADER
			version, request_id, type, content_length, padding_length: INTEGER
			as_string: STRING
		do
			version := 15
			request_id := 15
			type := 15
			content_length := 15
			padding_length := 15
			create a_record_header.make (version, request_id, type, content_length, padding_length)
			as_string := a_record_header.as_fast_cgi_string
			assert_equal ("as_fast_cgi_string length 1", 8, as_string.count)
			create a_record_header.make (1, 0, 0, 0, 0)
			a_record_header.process_header_bytes (as_string)
			assert_equal ("version 1", version, a_record_header.version)
			assert_equal ("request_id 1", request_id, a_record_header.request_id)
			assert_equal ("type 1", type, a_record_header.type)
			assert_equal ("content_length 1", content_length, a_record_header.content_length)
			assert_equal ("padding_length 1", padding_length, a_record_header.padding_length)

			version := 7
			request_id := 29846
			type := 45
			content_length := 31425
			padding_length := 200
			create a_record_header.make (version, request_id, type, content_length, padding_length)
			as_string := a_record_header.as_fast_cgi_string
			assert_equal ("as_fast_cgi_string length 2", 8, as_string.count)
			create a_record_header.make (1, 0, 0, 0, 0)
			a_record_header.process_header_bytes (as_string)
			assert_equal ("version 2", version, a_record_header.version)
			assert_equal ("request_id 2", request_id, a_record_header.request_id)
			assert_equal ("type 2", type, a_record_header.type)
			assert_equal ("content_length 2", content_length, a_record_header.content_length)
			assert_equal ("padding_length 2", padding_length, a_record_header.padding_length)

		end



end -- class FAST_CGI_TEST_RECORD_HEADER


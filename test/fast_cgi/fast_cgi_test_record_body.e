indexing
	description: "Objects that test GOA_FAST_CGI_RECORD_BODY and descendents"
	author: "Neal Lester"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	FAST_CGI_TEST_RECORD_BODY

inherit

	TS_TEST_CASE

feature

	test_begin_request_body is
		local
			begin_request_body: GOA_FAST_CGI_BEGIN_REQUEST_BODY
			role, flags: INTEGER
			as_string: STRING
		do
			role := 4
			flags := 4
			create begin_request_body
			begin_request_body.set_role (role)
			begin_request_body.set_flags (flags)
			as_string := begin_request_body.as_fast_cgi_string
			assert_equal ("as_string length 1", 8, as_string.count)
			create begin_request_body
			begin_request_body.set_raw_content_data (as_string)
			begin_request_body.process_body_fields
			assert_equal ("role 1", role, begin_request_body.role)
			assert_equal ("flags 1", flags, begin_request_body.flags)
			role := 20452
			flags := 200
			create begin_request_body
			begin_request_body.set_role (role)
			begin_request_body.set_flags (flags)
			as_string := begin_request_body.as_fast_cgi_string
			assert_equal ("as_string length 2", 8, as_string.count)
			create begin_request_body
			begin_request_body.set_raw_content_data (as_string)
			begin_request_body.process_body_fields
			assert_equal ("role 2", role, begin_request_body.role)
			assert_equal ("flags 2", flags, begin_request_body.flags)

		end

	test_end_request_body is
		do

		end

end

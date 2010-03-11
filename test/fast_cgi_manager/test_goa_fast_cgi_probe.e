indexing
	description: "Summary description for {TEST_GOA_FAST_CGI_PROBE}."
	author: "Neal Lester"
	date: "$Date$"
	revision: "$Revision$"
	License: "Eiffel Forum License Version 2 (see forum.txt)"

deferred class

	TEST_GOA_FAST_CGI_PROBE

inherit

	TS_TEST_CASE
	APPLICATION_CONFIGURATION

feature -- tests

	test_probe is
		local
			probe: GOA_FAST_CGI_PROBE
		do
			create probe.make_local_host (port, fast_cgi_directory)
			assert ("probe 1", not probe.is_connected)
			assert_equal ("probe 1 exception", 24, probe.last_exception)
			assert_equal ("probe 1 developer_exception_name", "Connection refused", probe.last_developer_exception)
		end

	server: FAST_CGI_TEST_APPLICATION_SERVER


end

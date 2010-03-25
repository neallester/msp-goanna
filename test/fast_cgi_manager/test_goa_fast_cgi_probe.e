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
	GOA_SHARED_APPLICATION_CONFIGURATION
	SHARED_SERVLETS
	THREAD_CONTROL

feature -- tests

	test_probe is
		local
			probe: GOA_FAST_CGI_PROBE
			response, shut_down_response: STRING

			delayed_thread: A_DELAYED_TRHEAD
			mutex: MUTEX
		do
			create mutex.make
			mutex.lock
			io.put_string ("Locked%N")
			create delayed_thread.make (mutex)
			delayed_thread.launch
			mutex.unlock
			io.put_string ("unlockedLocked%N")
			io.put_string ("a_result: " + delayed_thread.a_result.out + "%N")
			create active_configuration
			touch_configuration
			create probe.make_local_host (configuration.port, configuration.fast_cgi_directory)
			--create probe.make (<<192, 168, 1, 35>> , port, fast_cgi_directory)
			assert ("probe 1", not probe.is_connected)
			assert_equal ("probe 1 exception", 24, probe.last_exception)
			assert_equal ("probe 1 developer_exception_name", "Connection refused", probe.last_developer_exception)
			create server.application_make
			server.launch
			server.mutex.lock
			server.mutex.unlock
			probe.connect
			assert ("probe 2", probe.is_connected)
			assert_equal ("probe 2 ping", "OK", probe.get (ping_servlet.name))
			assert_equal ("probe 3 ping", "OK", probe.get (ping_servlet.name))
			--shut_down_response := probe.get (shut_down_server_servlet.name)
			server.mutex.lock
			shut_down_response := probe.get (shut_down_server_servlet.name)
			server.mutex.unlock
			join_all
			server := Void
			--join_all
		end

	server: FAST_CGI_TEST_APPLICATION_SERVER


end

indexing
	description: "Application Server Used For Testing"
	author: "Neal Lester"
	date: "$Date$"
	revision: "$Revision$"

class

	FAST_CGI_TEST_APPLICATION_SERVER

inherit

	GOA_APPLICATION_SERVER
		redefine
			application_make, execute
		select
			warn
		end
	GOA_FAST_CGI_SERVLET_APP
		rename
			warn as fcg_warn,
			meaning as exceptions_meaning,
			class_name as exceptions_class_name,
			host as epx_host
		undefine
			initialise_logger, all_servlets_registered
		redefine
			initialize_listening
		end
	THREAD

create

	application_make

feature

	command_line_ok: BOOLEAN is True

	register_servlets is
		do
		end

	mutex: MUTEX

feature {NONE} -- Creation

	application_make is
		do
			create mutex
			mutex.lock
		end

	execute is
		do
			create active_configuration
			touch_configuration
			fast_cgi_app_make (configuration.host, configuration.port, 10)
			Precursor
			shut_down_server_servlet.set_mutex (Void)
			mutex.unlock
			--mutex.destroy
			mutex := Void
			-- mutex.destroy
			-- io.put_string ("Server shutting down%N")
			-- exit
			--yield
		end


	initialize_listening is
		do
			Precursor
			shut_down_server_servlet.set_mutex (mutex)
			mutex.unlock
		end


end

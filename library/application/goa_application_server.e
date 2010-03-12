indexing
	description: "Root class for Goanna Server Applications"
	author: "Neal L Lester <neallester@users.sourceforge.net>"
	date: "$Date: 2007-10-19 07:42:31 -0700 (Fri, 19 Oct 2007) $"
	revision: "$Revision: 595 $"
	copyright: "(c) Neal L Lester"
	License: "Eiffel Forum License Version 2 (see forum.txt)"

deferred class
	GOA_APPLICATION_SERVER

inherit

	GOA_SERVLET_APPLICATION
		redefine
			all_servlets_registered
		end
	GOA_SHARED_SERVLET_MANAGER
	GOA_SHARED_HTTP_SESSION_MANAGER
	GOA_HTTP_SESSION_EVENT_LISTENER
	GOA_HTTP_UTILITY_FUNCTIONS
	GOA_SHARED_VIRTUAL_DOMAIN_HOSTS
	KL_SHARED_EXCEPTIONS
	L4E_SHARED_HIERARCHY
	L4E_SYSLOG_APPENDER_CONSTANTS
	SHARED_SERVLETS
	GOA_APPLICATION_EXCEPTION_HANDLING

feature

	application_make is
		do
			execute
-- TODO Troubleshoot issue with detach
--			if command_line_ok and then configuration.test_mode then
--				execute
--			elseif command_line_ok then
--				detach
--			end
		end

	initialise_logger is
			-- Set logger appenders
		local
			syslog: L4E_APPENDER
			layout: L4E_LAYOUT
			application_log: L4E_FILE_APPENDER
			application_layout: L4E_PATTERN_LAYOUT
		do

			create {L4E_SYSLOG_APPENDER} syslog.make ("Syslog", "localhost", Log_user)
			create {L4E_PATTERN_LAYOUT} layout.make ("@d [@-6p] port: " + configuration.port.out + " @c - @m%N")
			syslog.set_layout (layout)
			log_hierarchy.logger ("goanna").add_appender (syslog) -- This is used by Goanna itself.
			log_hierarchy.logger ("goanna").set_priority (None_p) -- Change to Debug_p or whatever to get these.
			create application_log.make (configuration.log_file_name, True)
			create application_layout.make ("@d [@-6p] @c - @m%N")
			application_log.set_layout (application_layout)
			log_hierarchy.logger (configuration.application_log_category).add_appender (application_log)
			log_hierarchy.logger (configuration.application_log_category).set_priority (info_p)
			log_hierarchy.logger (configuration.application_security_log_category).add_appender (application_log)
			log_hierarchy.logger (configuration.application_security_log_category).set_priority (info_p)
		end


	execute is
			-- Create and initialise a new FAST_CGI server that will listen for connections
			-- on 'port' and serving documents from 'doc_root'.
			-- Start the server
		local
			snoop_servlet: GOA_SNOOP_SERVLET
			exception_occurred: BOOLEAN
		do
			if command_line_ok and not exception_occurred then
				-- create a server listening for 'host:port'
				make (configuration.host, configuration.port, 10)
				-- Register built in servlets
				register_servlet (go_to_servlet)
				register_servlet (shut_down_server_servlet)
				register_servlet (secure_redirection_servlet)
				register_servlet (ping_servlet)
				register_servlets
				if configuration.install_snoop_servlet then
					create snoop_servlet.init (configuration.servlet_configuration)
					servlet_manager.register_servlet (snoop_servlet, configuration.snoop_servlet_name)
				end
				session_manager.register_event_listener (Current)
				-- start to processe requests
				run
			end
		rescue
			-- We are passed trying to rescue at this point
			exception_occurred := True
			log_hierarchy.logger (configuration.application_log_category).info ("Exception in GOA_APPLICATION_SERVER.execute; goodbye")
			retry
		end

    expiring (session: GOA_HTTP_SESSION) is
            -- 'session' is about to be expired.
            -- Descendents may redefine to clean-up any open resources
		do
        	-- Nothing
        end

    expired (session: GOA_HTTP_SESSION) is
            -- 'session' has expired and has been removed from
            -- the active list of sessions
        do
        	-- Nothing
        end

    created (session: GOA_HTTP_SESSION) is
            -- 'session' has been created
		local
			session_status: SESSION_STATUS
		do
			create session_status.make
			session.set_attribute (configuration.session_status_attribute_name, session_status)
		ensure then
			session_status_set: session.has_attribute (configuration.session_status_attribute_name)
        end

    attribute_bound (session: GOA_HTTP_SESSION; name: STRING; attribute: ANY) is
            -- 'attribute' has been bound in 'session' to 'name'
		do
			-- Nothing
        end

    attribute_unbound (session: GOA_HTTP_SESSION; name: STRING; attribute: ANY) is
            -- 'attribute' has been unbound in 'session' from 'name'
		do
			-- Nothing
        end

	register_servlet (servlet: GOA_APPLICATION_SERVLET) is
			-- Register servlet
		require
			valid_servlet: servlet /= Void
			not_has_servlet: not servlet_manager.has_registered_servlet (servlet.name)
		do
			servlet_manager.register_servlet (servlet, servlet.name)
		end

	command_line_ok: BOOLEAN is
			-- Command line has been parsed and is valid
			-- First create (or assign an existing object to) application_configuration.
			-- Then call touch_configuration.
			-- Then register at least one VIRTUAL_DOMAIN_HOST using register_virtual_domain_host
			-- with the name matching
			-- APPLICATION_CONFIGURATION.default_virtual_host_lookup_string
			-- command_line_ok should be implemented with a once function as it will
			-- Be called twice if in test mode
		deferred
		ensure
			valid_configuration: configuration /= Void
		end

	field_exception: BOOLEAN is
			-- Should we attempt to retry?
		do
			if exceptions.is_developer_exception_of_name (configuration.bring_down_server_exception_description) then
				log_hierarchy.logger (configuration.application_log_category).info ("Application Ending per Request")
				set_end_application
				Result := True
			elseif unable_to_listen then
				log_hierarchy.logger (configuration.application_log_category).error ("Unable to open listening socket; is the socket in use?")
				end_listening
			else
				if log_uncaught_exception_trace then
					log_hierarchy.logger (configuration.application_log_category).info ("Exception Occurred:%N" + exceptions.exception_trace)
				end
				Result := True
			end
		ensure
			bring_down_implies_false: exceptions.is_developer_exception_of_name (configuration.bring_down_server_exception_description) implies not Result
			unable_to_listen_implies_false: unable_to_listen implies not Result
		end

	initialize_listening is
		deferred
		end

	end_listening is
		deferred
		end

	set_end_application is
		deferred
		end



	log_uncaught_exception_trace: BOOLEAN is
			-- An uncaught exception has occured; should we log the trace?
		once
			Result := True
		end

	unable_to_listen: BOOLEAN is
			-- Is the application in a state where it cannot listen for requests?
		deferred
		end

	none_p: L4E_PRIORITY is
			-- Prioty designates no events
		once
			create Result.make (1000000, "NONE")
		end

	all_servlets_registered: BOOLEAN is
		local
			has_this_servlet: BOOLEAN
		do
			Result := 	servlet_by_name.has (go_to_servlet.name_without_extension) and then
						servlet_manager.has_registered_servlet (go_to_servlet.name) and then
						servlet_by_name.has (secure_redirection_servlet.name_without_extension) and then
						servlet_manager.has_registered_servlet (secure_redirection_servlet.name) and then
						servlet_by_name.has (shut_down_server_servlet.name_without_extension) and then
						servlet_manager.has_registered_servlet (shut_down_server_servlet.name)
			if not Result then
				log_hierarchy.logger (configuration.application_log_category).error ("Missing A Standard Goanna Application Servlet (See GOA_APPLICATION_SERVER.all_servlets_registered)")
			end
			from
				servlet_by_name.start
			until
				servlet_by_name.after
			loop
				has_this_servlet := servlet_manager.has_registered_servlet (servlet_by_name.item_for_iteration.name)
				Result := Result and has_this_servlet
				if not has_this_servlet then
					log_hierarchy.logger (configuration.application_log_category).error ("Servlet " + servlet_by_name.key_for_iteration + " is not registered with GOA_APPLICATION_SERVER.servlet_manager")
				end
				servlet_by_name.forth
			end
		end




end -- class GOA_APPLICATION_SERVER

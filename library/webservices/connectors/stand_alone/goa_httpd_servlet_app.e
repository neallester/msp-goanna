note
	description: "HTTP Servlet application."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "tools httpd"
	date: "$Date: 2006-12-19 11:49:12 -0800 (Tue, 19 Dec 2006) $"
	revision: "$Revision: 523 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

deferred class GOA_HTTPD_SERVLET_APP

inherit GOA_SERVLET_APPLICATION

	GOA_SHARED_SERVLET_MANAGER
		export
			{NONE} all
		end

	EPX_SOCKET_MULTIPLEXER_SINGLETON
		export
			{NONE} all
		end

	STDC_BASE
		export
			{NONE} all
		end

	GOA_HTTPD_LOGGER
		export
			{NONE} all
		end

feature {NONE} -- Initialization

	make (new_host: STRING; port, a_backlog: INTEGER)
			-- Set up the server
		local
			a_hp: EPX_HOST_PORT
			a_host: EPX_HOST
			a_service: EPX_SERVICE
		do
			-- default action is not to use the excepten error handling of eposix
			security.error_handling.disable_exceptions

			-- prepare the socket
			create a_host.make_from_ip4_any
			create a_service.make_from_port (port, "tcp")
			create a_hp.make (a_host, a_service)

			create server_socket.listen_by_address_and_backlog (a_hp, a_backlog)

			socket_multiplexer.add_read_socket (server_socket)
			log_hierarchy.logger (Internal_category).info ("Goanna HTTPD Server. Version 1.0")
			log_hierarchy.logger (Internal_category).info ("Copyright (C) 2001 Glenn Maughan.")
			debug ("status_output")
				print ("Waiting for connections...%N")
				print ("----------Legend:---------------------%N")
				print ("#       : new client%N")
				print ("?       : received data from a client%N")
				print ("&       : send data to client%N")
				print ("!       : multiplexed%N")
				print (".       : idle%N")
				print ("/       : interrupted%N")
				print ("(n,e,c) : socket error (n), extended error (c), read count (c)%N")
				print ("--------------------------------------%N")
			end
		end

feature {NONE} -- Implementation

	server_socket: GOA_HTTPD_SERVER_SOCKET
			-- Socket for accepting of new connections

	run
			-- Start serving requests
		do
			from
				socket_multiplexer.errno.clear_all
			until
				socket_multiplexer.errno.is_not_ok
				-- TODO  error_code = sock_err_select
			loop
				socket_multiplexer.multiplex
				if socket_multiplexer.number_of_fired_callbacks = 0 then

					if socket_multiplexer.errno.is_not_ok then
						log_hierarchy.logger (Internal_category).error ("Socket error: " + socket_multiplexer.errno.first_value.out)
						-- socket_multiplexer.errno.clear
					elseif socket_multiplexer.is_interrupted then
						io.put_character ('/') -- interrupted
					else
						debug ("status_output")
							io.put_character ('.')
						end
					end
				else
					debug ("status_output")
						io.put_character ('!') -- multiplexed
					end
				end
			end

			socket_multiplexer.errno.clear_first

		end

end -- class GOA_HTTPD_SERVLET_APP

note
	description: "Objects that can process FastCGI requests"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI protocol"
	date: "$Date: 2007-06-17 13:27:42 -0700 (Sun, 17 Jun 2007) $"
	revision: "$Revision: 583 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class GOA_FAST_CGI

inherit

	GOA_FAST_CGI_DEFS
		export
			{NONE} all
		end

	GOA_FAST_CGI_VARIABLES
		export
			{NONE} all
		end

	KL_SHARED_EXECUTION_ENVIRONMENT
		export
			{NONE} all
		end

	L4E_SHARED_HIERARCHY
		rename
			warn as log_warn
		export
			{NONE} all
		end
	POSIX_CONSTANTS
	GOA_APPLICATION_EXCEPTION_HANDLING

feature -- Initialisation

	make (new_host: STRING; port, backlog: INTEGER)
			-- Initialise this FCGI application to listen on 'port' with room for 'backlog'
			-- For new_host, use 'localhost' to listen only to requests from local machine (domain socket)
   			-- Use IP Address of host running the GOA_APPLICATION_SERVER if server
   			-- must accept requests from other machines
   		require
			valid_host: new_host /= Void and then new_host /= Void
				-- Host should be "localhost"
			positive_port: port >= 0
			positive_backlog: backlog >= 0
		do
			create host.make_from_name (new_host)
			svr_port := port
			host_name := new_host
			initialise_logger
			server_backlog := backlog
			set_valid_peer_addresses
		end

feature -- FGCI interface

	initialize_listening
			-- Set up port to listen for requests from the web server
		local
			service: EPX_SERVICE
			host_port: EPX_HOST_PORT
			l_has_ended_listening, l_is_closing: BOOLEAN
			l_retry_count: INTEGER
		do
			if unable_to_listen and not l_has_ended_listening then
				l_has_ended_listening := True
				end_listening
			elseif not unable_to_listen then
				create service.make_from_port (svr_port, "tcp")
				create host_port.make (host, service)
				if srv_socket /= Void then
					l_is_closing := True
					srv_socket.close
					l_is_closing := False
				end
				create srv_socket.listen_by_address (host_port)
				request := Void
				srv_socket.errno.clear_all
			end
		rescue
			if l_is_closing then
				srv_socket := Void
			end
			l_retry_count := l_retry_count + 1
			if l_retry_count > 5 then
				unable_to_listen := True
			else
				ise_execution_environment.sleep (10000000)
			end
			Retry
		end

	ise_execution_environment: expanded EXECUTION_ENVIRONMENT
			-- Access to `sleep'

	unable_to_listen: BOOLEAN
		-- True if the application is unable to listen on host_port

	end_listening
			-- Take down socket used to listen for requests from the server
		local
			l_exception_occurred: BOOLEAN
		do
			if srv_socket /= Void and then srv_socket.is_owner and then srv_socket.is_open and then not l_exception_occurred then
				srv_socket.close
			end
		rescue
			l_exception_occurred := True
			Retry
		end

	finish
			-- Finish the current request from the HTTP server. The
			-- current request was started by the most recent call to
			-- 'accept'.
		do
			debug ("fcgi_interface")
				print (generator + ".finish%R%N")
			end
			if request /= Void and then request.socket /= Void then
				-- complete the current request
				request.end_request
			end
			request := Void
			debug ("fcgi_interface")
				print (generator + ".finish - finished%R%N")
			end
		rescue
			request := Void
			retry
		end

	flush
			-- Flush output and error streams.
		do
		end

	putstr (str: STRING)
			-- Print 'str' to standard output stream.
		require
			request_exists: request /= Void
		do
			request.write_stdout (str)
		end

	warn (str: STRING)
			-- Print 'str' to standard error stream.
		require
			request_exists: request /= Void
		do
			request.write_stderr (str)
		end

	getstr (amount: INTEGER): STRING
			-- Read 'amount' characters from standard input stream.
		require
			request_exists: request /= Void
		local
			bytes_to_read: INTEGER
			read_ok: BOOLEAN
		do
			from
				Result := ""
				read_ok := True
				bytes_to_read := amount
			until
				bytes_to_read <= 0 or not read_ok
			loop
				request.socket.read_string (amount)
				Result.append (request.socket.last_string)
				bytes_to_read := bytes_to_read - request.socket.last_read
				read_ok := request.socket.last_read > 0
			end
		end

	getline (amount: INTEGER): STRING
			-- Read up to 'amount' characters from the input stream
			-- Stops before 'amount' characters have been read
			-- if '%N' or EOF is read.

			-- SCL
			-- should the %N be part of the result??
		require
			request_exists: request /= Void
		local
			i: INTEGER
			end_of_line: BOOLEAN
			c: CHARACTER
		do
			create Result.make (amount)
			from
				i := 0
			until
				i >= amount or end_of_line
			loop
				request.socket.read_character
				c := request.socket.last_character
				Result.append_character (c)
				i := i+1
				if request.socket.eof or else c='%N' then
					end_of_line := true
				end
			end
		end

	getparam (name: STRING): STRING
			-- Get the value of the named environment variable.
		require
			request_exists: request /= Void
		do
			if request.parameters.has (name) then
				Result := request.parameters.item (name).twin
			end
		end

	getparam_integer(name: STRING): INTEGER
			-- Fetch and convert environment variable
	 		-- Returns 0 on failure.
		require
			request_exists: request /= Void
		local
			str: STRING
		do
			if request.parameters.has (name) then
				str := request.parameters.item (name)
				if str.is_integer then
					Result := str.to_integer
				end
			end
		end

feature -- Access

	request: GOA_FAST_CGI_REQUEST
		-- Current request being processed. Void if none.

feature {NONE} -- Implementation

	host: EPX_HOST
		-- Host that is listening for requests


	accept_called: BOOLEAN
		-- Has accept been called?

	srv_socket: EPX_TCP_SERVER_SOCKET
		-- The server socket that this applications listens for requests on.

	svr_port: INTEGER
		-- The port to listen on.

	host_name: STRING
		-- Name of the host

	server_backlog: INTEGER
		-- The number of requests that can remain outstanding.

	valid_peer_addresses: DS_LINKED_LIST [STRING]
		-- Peer addresses that are allowed to connect to this server as defined
		-- in environment variable FCGI_WEB_SERVER_ADDRS.
		-- Void if all peers can connect.

	Fcgi_web_server_addrs: STRING = "FCGI_WEB_SERVER_ADDRS"

	set_valid_peer_addresses
			-- Collect valid peer addresses
		local
			addrs, address: STRING
			tokenizer: GOA_STRING_TOKENIZER
		do
			addrs := Execution_environment.variable_value (Fcgi_web_server_addrs)
			if addrs /= Void and then not addrs.is_empty then
				create valid_peer_addresses.make
				create tokenizer.make (addrs, ";")
				from
					tokenizer.start
				until
					tokenizer.off
				loop
					address := tokenizer.item
					address.right_adjust
					address.left_adjust
					valid_peer_addresses.force_last (address)
					info (Servlet_app_log_category, "Web server address " + address + " added to ACL")
					tokenizer.forth
				end
			end
		end

	accept_request: BOOLEAN
			-- Wait for a request to be received; Returns true if request was successfully read
		require
			void_request: request = Void
		local
			request_read, failed: BOOLEAN
		do
			-- setup the request and its connection.
			create request.make
			-- setup request connection and read request.
			from
			until
				request_read or failed
			loop
				if request.socket = Void then
					-- accept new connection (blocking)
					request.set_socket(srv_socket.accept)
					request.socket.set_continue_on_error
					request.socket.errno.set_value (0)
					request.socket.errno.clear_all
				end
				-- check peer address for allowed server addresses
				-- if peer_address_ok (peer) then
				-- attempt to read the request. If this fails and it was an old
				-- connection then the server probably closed it; try making a new connection
				-- before giving up.
				request.read
				if not request.read_ok then
					failed := True
					error (Servlet_app_log_category, "GOA_FAST_CGI.request.read failed in accept_request")
				else
					request_read := True
				end
			end
			Result := request_read
		end

	peer_address_ok (peer_address: STRING): BOOLEAN
			-- Does 'perr_address' appear in the allowable peer addresses for
			-- this server as defined in the environment variable FCGI_WEB_SERVER_ADDRS?
		require
			peer_address_exists: peer_address /= Void and then not peer_address.is_empty
		do
			if valid_peer_addresses = Void then
				Result := True
			else
				-- search for address
				from
					valid_peer_addresses.start
				until
					valid_peer_addresses.off or Result
				loop
					if peer_address.is_equal (valid_peer_addresses.item_for_iteration) then
						Result := True
					else
						valid_peer_addresses.forth
					end
				end
			end
		end

	Servlet_app_log_category: STRING = "servlet.app"

	initialise_logger
			-- Set logger appenders
		local
			appender: L4E_APPENDER
			layout: L4E_LAYOUT
		do
			create {L4E_FILE_APPENDER} appender.make ("log" + svr_port.out + ".txt", True)
			create {L4E_PATTERN_LAYOUT} layout.make ("@d [@-6p] @c - @m%N")
			appender.set_layout (layout)
			log_hierarchy.logger (Servlet_app_log_category).add_appender (appender)
		end

end -- class GOA_FAST_CGI


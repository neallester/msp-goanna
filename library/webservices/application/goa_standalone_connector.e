indexing
	description: "Servlet connector for connecting to standalone servers"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "Servlet API"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class GOA_STANDALONE_CONNECTOR

inherit
	
	GOA_CONNECTOR

	SOCKET_ERRORS
		export
			{NONE} all
		undefine
			default_create
		end
		
create 

	make

feature -- Initialisation

	make (new_port, new_backlog: INTEGER; document_root, servlet_mapping_prefix: STRING) is
			-- Initialise
		require
			document_root_exists: document_root /= Void
			prefix_exists: servlet_mapping_prefix /= Void
		do
			default_create
			port := new_port
			backlog := new_backlog
			doc_root := document_root
			servlet_prefix := servlet_mapping_prefix
			info (generator, "Listening on port: " + port.out)
		end
	
feature -- Basic operations

	read_request is
			-- Read a request from the service. Indicate success of read by
			-- setting 'last_operation_ok'.
		local
			http_request: GOA_HTTPD_REQUEST
			httpd_response: GOA_HTTPD_SERVLET_RESPONSE
			request: STRING
			socket: TCP_SOCKET
		do
			if server_socket = Void or else not server_socket.is_valid then
				create server_socket.make (port, backlog)
				check_socket_error (server_socket)
			end
			if socket_ok then
				info (generator, "accepting new request")
				socket := server_socket.wait_for_new_connection
				check_socket_error (socket)
				if socket_ok then
					info (generator, "new request received")
					request := receive_request (socket)
					if socket_ok then
						create http_request.make_standard_socket (socket, request, port, doc_root, servlet_prefix)
						-- create request and response objects from request buffer
						create httpd_response.make (request, socket)
						last_response := httpd_response
						create {GOA_HTTPD_SERVLET_REQUEST} last_request.make (http_request, httpd_response)
						last_operation_ok := True
					else
						last_operation_ok := False
					end
				else
					last_operation_ok := False
					error (generator, "error accepting new request")
				end
			else
				last_operation_ok := False
				error (generator, "error accepting new request")
			end
		end

feature -- Implementation

	port: INTEGER 
			-- Listen port
			
	backlog: INTEGER
			-- Number of requests allowed in back log 
		
	doc_root: STRING
			-- Document root
			
	servlet_prefix: STRING
			-- Servlet mapping prefix
			
	server_socket: TCP_SERVER_SOCKET
	
	socket_ok: BOOLEAN
			-- Was last socket operation successful?
			
	receive_request (socket: TCP_SOCKET): STRING is
			-- Receive request from client
		require
			socket_exists: socket /= Void
		local
			buffer: STRING
			done: BOOLEAN
		do
			create Result.make (8192)
			if socket_ok then
				-- read until complete request has been read 
				content_length_found := False
				content_length := -1
				end_header_index := -1
				from
					create buffer.make (8192)
					buffer.fill_blank
					socket.receive_string (buffer)
					check_socket_error (socket)
				until
					done or not socket_ok
				loop
					Result.append (buffer.substring (1, socket.bytes_received))
					debug ("socket")
						io.putstring ("Current request string: " + result + "%N")
					end
					done :=  check_request (Result) -- (was True) <===================== Here is the change
					if not done then
						buffer.fill_blank
						socket.receive_string (buffer)
						check_socket_error (socket)				
					end
				end
				debug ("socket")
					io.putstring ("Current Buffer Contents: " + buffer + "%N")
				end
			end
		end

	content_length_found: BOOLEAN
	
	content_length, end_header_index: INTEGER
	
	check_request (buffer: STRING): BOOLEAN is
			-- Check request to determine if all headers and body have been read
		require
			buffer /= Void
		local
			content_length_index: INTEGER
			tokenizer: GOA_STRING_TOKENIZER
			next_token: STRING
		do
			if not content_length_found then
				-- check for "%R%N%R%N" for all headers read.
				end_header_index := buffer.substring_index ("%R%N%R%N", 1)
				if end_header_index /= 0 then
					end_header_index := end_header_index + 4
					-- find content length header
					create tokenizer.make (buffer, "%R%N")
					from
						tokenizer.start
					until
						tokenizer.off or content_length_found
					loop
						next_token := tokenizer.item
						next_token.to_lower
						content_length_index := next_token.substring_index ("content-length:", 1)
						if content_length_index /= 0 then
							content_length_found := True
							content_length := next_token.substring (16, next_token.count).to_integer
						end
						tokenizer.forth
					end
				end
			end
			if content_length_found then
				-- have enough bytes for the body been read?
				Result := buffer.count = end_header_index + content_length - 1
			end
		end

	check_socket_error (socket: ABSTRACT_SOCKET) is
			-- Check for socket error and print
		require
			socket_exists: socket /= Void
		do
			if socket.last_error_code /= Sock_err_no_error then
				socket_ok := False
				error (generator, "socket error: " + socket.last_error_code.out 
					+ ", " + socket.last_extended_socket_error_code.out)
			else
				socket_ok := True
			end
			if Log_hierarchy.is_enabled_for (Debug_p) then
				debugging (generator, 
					"socket received: " + socket.bytes_received.out 
					+ " sent: " + socket.bytes_sent.out
					+ " available: " + socket.bytes_available.out
					+ " valid: " + socket.is_valid.out)
			end
		end
		
end -- class GOA_STANDALONE_CONNECTOR

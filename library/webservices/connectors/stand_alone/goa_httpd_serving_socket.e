note
	description: "Callback server socket that processes servlet requests."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "tools httpd"
	date: "$Date: 2006-12-11 11:57:49 -0800 (Mon, 11 Dec 2006) $"
	revision: "$Revision: 521 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class GOA_HTTPD_SERVING_SOCKET

inherit

	EPX_TCP_SOCKET
		redefine
			multiplexer_read_callback
		end

	EPX_SOCKET_MULTIPLEXER_SINGLETON
		export
			{NONE}all
		end

	GOA_SHARED_SERVLET_MANAGER

	GOA_HTTPD_LOGGER
		export
			{NONE} all
		end

	GOA_HTTP_STATUS_CODES
		export
			{NONE} all
		end

	GOA_HTTPD_CGI_HEADER_VARS
		export
			{NONE} all
		end

create

    attach_to_socket

feature

	multiplexer_read_callback (a_multiplexer: EPX_SOCKET_MULTIPLEXER)
			-- this routine is called if there is data ready for
			-- reading on our socket
		local
			http_request: GOA_HTTPD_REQUEST
			resp: GOA_HTTPD_SERVLET_RESPONSE
			req: GOA_HTTPD_SERVLET_REQUEST
			current_path: STRING
			request: STRING
		do
			debug ("status_output")
				io.put_character ('?')
			end
			-- read the request
			check_socket_error ("read callback")
			request := receive_request
			if socket_ok then
				create http_request.make (Current, request)
				-- create request and response objects from request buffer
				create resp.make (request, Current)
				create req.make (http_request, resp)
				-- dispatch to the registered servlet using the current_path info as the registration name.
				if req.has_header (Script_name_var) then
					current_path := req.get_header (Script_name_var)
					if current_path /= Void then
						-- remove leading slash from current_path
						current_path.keep_tail (current_path.count - 1)
					end
				end
				if current_path /= Void then
					log_hierarchy.logger (Access_category).info ("Servicing request: /" + current_path)
					-- attempt to handle the request and send 'not found' if not handled.
					if servlet_manager.has_registered_servlet (current_path) then
						servlet_manager.servlet (current_path).service (req, resp)
					elseif servlet_manager.has_default_servlet then
						servlet_manager.default_servlet.service (req, resp)
					else
						resp.send_error (Sc_not_found)
						log_hierarchy.logger (Access_category).error ("Servlet not found for URI " + current_path)
					end
				else
					handle_missing_servlet (resp)
					log_hierarchy.logger (Access_category).error ("Request URI not specified")
				end
			end
			-- close socket after sending reply
			socket_multiplexer.remove_read_socket (Current)
			close
		end



feature {NONE}

	receive_request: STRING
			-- Recieve request from client
		local
			done: BOOLEAN
		do
			create Result.make (8192)
			if socket_ok then
				-- read until complete request has been read
				content_length_found := False
				content_length := -1
				end_header_index := -1
				from
					read_string (8192)
					check_socket_error ("after priming read")
				until
					done or not socket_ok
				loop
					Result.append (last_string)
					debug ("socket")
						io.putstring ("Current request string: " + result + "%N")
					end
					done := check_request (Result) -- (was True) <===================== Here is the change
					if not done then
						read_string (8192)
						check_socket_error ("after loop read")
					end
				end
				debug ("socket")
					io.putstring ("Current Buffer Contents: " + last_string + "%N")
				end
			end
		end

	content_length_found: BOOLEAN
	content_length, end_header_index: INTEGER

	check_request (buffer: STRING): BOOLEAN
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

	socket_ok: BOOLEAN
			-- Was last socket operation successful?

	handle_missing_servlet (resp: GOA_HTTPD_SERVLET_RESPONSE)
			-- Send error page indicating missing servlet
		require
			resp_exists: resp /= Void
		do
			resp.send_error (Sc_not_found)
		end

	check_socket_error (message: STRING)
			-- Check for socket error and print
		require
			message_exists: message /= Void
		do
			debug ("socket")
				print ("Socket status (" + message + "):%N")
			end
			if errno.is_not_ok then
				socket_ok := False
				debug ("socket")
					io.putstring ("Socket error: " + errno.first_value.out + "%N")
-- TODO					io.putstring ("Extended error: " + last_extended_socket_error_code.out + "%N")
				end
				log_hierarchy.logger (Internal_category).error ("Socket error: " + errno.first_value.out + "%N")
-- TODO				log_hierarchy.logger (Internal_category).error ("Extended error: " + last_extended_socket_error_code.out + "%N")

				errno.clear_first
			else
				socket_ok := True
			end
			debug ("socket")
				print ("%TBytes received: " + receive_buffer_size.out + "%N")
				print ("%TBytes sent: " + send_buffer_size.out + "%N")
-- TODO				print ("%TBytes available: " + bytes_available.out + "%N")
				print ("%TSocket valid: " + is_open.out + "%N")
			end
		end

end -- class GOA_HTTPD_SERVING_SOCKET

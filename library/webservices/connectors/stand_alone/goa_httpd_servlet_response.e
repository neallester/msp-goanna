indexing
	description: "Objects that represent HTTPD request responses"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "tools httpd"
	date: "$Date: 2006-12-22 08:06:26 -0800 (Fri, 22 Dec 2006) $"
	revision: "$Revision: 531 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class GOA_HTTPD_SERVLET_RESPONSE

inherit

	GOA_HTTP_SERVLET_RESPONSE

	GOA_HTTP_UTILITY_FUNCTIONS
		export
			{NONE} all
		end

	GOA_STRING_MANIPULATION
		export
			{NONE} all
		end

create

	make

feature {NONE}-- Initialization

	make (buffer: STRING; request_socket: EPX_TCP_SOCKET) is
			-- Build a new HTTPD response object that provides access to
			-- 'response' information.
			-- Initialise the response information to allow a successful (Sc_ok) response
			-- to be sent immediately.
		require
			buffer_exists: buffer /= Void
			socket_exists: request_socket /= Void
		do
			internal_buffer := buffer
			internal_socket := request_socket
			create cookies.make
			create headers.make (5)
			initial_buffer_size := Default_buffer_size
			reset
		end

feature -- Access

	buffer_size: INTEGER is
			-- Actual size of response buffer.
		do
			Result := content_buffer.capacity
		end

	contains_header (name: STRING): BOOLEAN is
			-- Has the header named 'name' already been set?
		do
			Result := headers.has (name)
		end

feature -- Status report

	is_committed: BOOLEAN
			-- Has the response been committed? A committed response has already
			-- had its status code and headers written.

feature -- Status setting

	set_buffer_size (size: INTEGER) is
			-- Set the preferred buffer size for the body of the response.
			--| If the buffer has not already been created, this routine will do so.
		do
			if content_buffer = Void then
				initial_buffer_size := size
			else
				content_buffer.resize (size)
			end
		end

	add_cookie (cookie: GOA_COOKIE) is
			-- Add 'cookie' to the response. Can be called multiple times
			-- to add more than one cookie.
		do
			cookies.force_last (cookie)
		end

	add_header (name, value: STRING) is
			-- Adds a response header with the given naem and value. This
			-- method allows response headers to have multiple values.
		local
			new_values: DS_LINKED_LIST [like value]
		do
			if headers.has (name) then
				headers.item (name).force_last (value)
			else
				create new_values.make
				new_values.force_last (value)
				set_header (name, value)
			end
		end

	set_content_length (length: INTEGER) is
			-- Set the length of the content body in the response.
		do
			content_length := length
			set_header ("Content-Length", length.out)
		end

	set_content_type (type: STRING) is
			-- Set the content type of the response being sent to the client.
			-- The content type may include the type of character encoding used, for
			-- example, 'text/html; charset=ISO-885904'
		do
			set_header ("Content-Type", type + "; charset=ISO-8859-1")
		end

	set_header (name, value: STRING) is
			-- Set a response header with the given name and value. If the
			-- header already exists, the new value overwrites the previous
			-- one.
		local
			new_values: DS_LINKED_LIST [like value]
		do
			create new_values.make
			new_values.force_last (value)
			headers.force (new_values, name)
		end

	set_status (sc: INTEGER) is
			-- Set the status code for this response. This method is used to
			-- set the return status code when there is no error (for example,
			-- for the status codes Sc_ok or Sc_moved_temporarily). If there
			-- is an error, the 'send_error' method should be used instead.
		do
			set_status_message (sc, status_code_message (sc))
		end

	set_status_message (sc: INTEGER; message: STRING) is
			-- Set the status code to 'sc' with 'message' as the text message to
			-- send to the client.			
		do
			status := sc
			status_message := message
		end

feature -- Basic operations

	flush_buffer is
			-- Force any content in the buffer to be written to the client. A call
			-- to this method automatically commits the response, meaning the status
			-- code and headers will be written.
			-- Before calling this routine, you must ensure that all required headers have been
			-- set. Standard headers are set when this object is instantiated therefore you can call
			-- this routine directly after creating the response object.
			-- This routine is automatically called by the service routine of HTTP_SERVLET.
		do
			if content_buffer /= Void then
				if not is_committed then
					write_headers
				end
				if not content_buffer.is_empty then
					write (content_buffer)
					clear_buffer (content_buffer)
				end
			end
		end

	reset is
			-- Clear any data that exists in the buffer as well as the status code
			-- and headers.
		do
			content_buffer := Void
			cookies.wipe_out
			set_content_length (0)
			headers.wipe_out
			set_content_type ("text/html")
			status := Sc_ok
			status_message := status_code_message (status)
			is_committed := False
		end

	send_error (sc: INTEGER) is
			-- Send an error response to the client using the specified
			-- status code. The server generally creates the response to
			-- look like a normal server error page.
		do
			send_error_msg (sc, status_code_message (sc))
		end

	send_error_msg (sc: INTEGER; msg: STRING) is
			-- Send an error response to the client using the specified
			-- status code and descriptive message. The server generally
			-- creates the response to look like a normal server error page.
		local
			page: STRING
		do
			page := build_error_page (sc, msg)
			set_status (sc)
			set_content_type ("text/html")
			set_content_length (page.count)
			write_headers
			write (page)
		end

	send_redirect (location: STRING) is
			-- Send a temporary redirect response to the client using the
			-- specified redirect location URL.
		local
			page: STRING
		do
			page := build_redirect_page (location)
			set_status (Sc_moved_temporarily)
			set_content_type ("text/html")
			set_header ("Location", location)
			set_content_length (page.count)
			write_headers
			write (page)
		end

	send (data: STRING) is
			-- Send 'data' to the client. The data is buffered for writing. It will not be
			-- physically sent to the client until 'flush_buffer' is called.
		local
			data_index, buffer_space, end_index: INTEGER
		do
			if content_buffer = Void then
				create content_buffer.make (initial_buffer_size)
			end
			-- write the data in chunks
			from
				data_index := 1
--			invariant
--				content_buffer.capacity = initial_buffer_size
			until
				data_index > data.count
			loop
				-- Samuele Lucchini <origo@muele.net> (18/12/2006)
				-- 
				-- Create a new buffer here since `flush_buffer' sets the buffer size to zero.
				-- If `data.count' > `initial_buffer_size' you need to allocate a new buffer
				-- otherwise you won't be able to complete the transmission sending all chunks.

				create content_buffer.make (initial_buffer_size)
				
				buffer_space := content_buffer.capacity - content_buffer.count
				end_index := data.count.min (data_index + buffer_space - 1)
				content_buffer.append (data.substring (data_index, end_index))
				data_index := end_index + 1
				if is_buffer_full (content_buffer) then
					flush_buffer
				end
			end
		end

feature {NONE} -- Implementation

	internal_buffer: STRING
		-- Internal request information.

	internal_socket: EPX_TCP_SOCKET
		-- Socket for send response

	content_length: INTEGER
		-- The length of the content that will be sent with this response.

	Default_buffer_size: INTEGER is 4096
		-- Default size of output buffer

	initial_buffer_size: INTEGER
		-- Size of buffer to create.

	content_buffer: STRING
		-- Buffer for writing output for response. Not used when error or redirect
		-- pages are sent. Created on demand

	status: INTEGER
		-- The result status that will be send with this response.

	status_message: STRING
		-- The status message. Void if none.

	cookies: DS_LINKED_LIST [GOA_COOKIE]
		-- The cookies that will be sent with this response.

	headers: DS_HASH_TABLE [DS_LINKED_LIST [STRING], STRING]
		-- The headers that will be sent with this response.

	build_reply_header: STRING is
			-- HTTP response header
		do
			Result := ("HTTP/1.1").twin
			Result.extend (' ')
			Result.append (status.out)
			Result.extend (' ')
			Result.append (status_code_message (status))
			Result.append ("%R%N")
		end

	build_error_page (sc: INTEGER; msg: STRING): STRING is
			-- Build a standard error page for status code 'sc' and message 'msg'
		require
			msg_exists: msg /= Void
		do
			create Result.make (100)
			Result.append ("<HTML><HEAD><TITLE>")
			Result.append (status_code_message (sc))
			Result.append ("</TITLE></HEAD><BODY><CENTER><H1>")
			Result.append (status_code_message (sc))
			Result.append ("</H1></CENTER><P>")
			Result.append (msg)
			Result.append ("</P>")
			Result.append ("</BODY></HTML>")
		end

	build_redirect_page (location: STRING): STRING is
			-- Build a temporary redirect page to redirect to 'location'
		require
			location_exists: location /= Void
		do
			create Result.make (100)
			Result.append("<HTML><HEAD><TITLE>Document Has Moved</TITLE></HEAD>")
       		Result.append("<BODY><CENTER><H1>Document Has Moved</H1></CENTER>")
        		Result.append("This document has moved to <A HREF=%"")
        		Result.append(location)
        		Result.append("%">")
        		Result.append(location)
        		Result.append("</A><P>")
        		Result.append("</BODY></HTML>")
		end

	build_headers: STRING is
			-- Build string representation of headers suitable for sending as a response.			
		local
			header_keys: DS_HASH_TABLE_CURSOR [DS_LINKED_LIST [STRING], STRING]
			header_values: DS_LINKED_LIST [STRING]
			name: STRING
		do
			create Result.make (200)
			from
				header_keys := headers.new_cursor
				header_keys.start
			until
				header_keys.off
			loop
				from
					name := header_keys.key
					header_values := header_keys.item
					header_values.start
				until
					header_values.off
				loop
					Result.append (name)
					Result.append (": ")
					Result.append (header_values.item_for_iteration)
					Result.append ("%R%N")
					header_values.forth
				end
				header_keys.forth
			end
		end

	set_default_headers is
			-- Set default headers for all responses including the Server and Date headers.	
		do
			if not contains_header ("Server") then
				set_header ("Server", "Goanna Servlet Server")
			end
			if not contains_header ("Date") then
				set_header ("Date", "Sun, 06 Nov 1994 08:49:37 GMT") -- TODO: set real date	
			end
		end

	Expired_date: STRING is "Tue, 01-Jan-1970 00:00:00 GMT"

	set_cookie_headers is
			-- Add 'Set-Cookie' header for cookies. Add a separate 'Set-Cookie' header
			-- for each new cookie.
			-- Also add cookie caching directive headers.
		do
			if not cookies.is_empty then
				from
					cookies.start
				until
					cookies.off
				loop
					add_header ("Set-Cookie", cookies.item_for_iteration.header_string)
					debug ("cookie_parsing")
						print (generator + ".set_cookie_header value = "
							+ quoted_eiffel_string_out (cookies.item_for_iteration.header_string)
							+ "%R%N")
					end
					cookies.forth
				end
				-- add cache control headers for cookie management
				add_header ("Cache-control", "no-cache=%"Set-Cookie%"")
				set_header ("Expires", Expired_date)
			end
		end

	write_headers is
			-- Write the response headers to the output stream.
		require
			not_committed: not is_committed
		do
			set_default_headers
			set_cookie_headers
			write (build_reply_header)
			write (build_headers)
			write ("%R%N")
			is_committed := True
		ensure
			is_committed: is_committed
		end

	write (data: STRING) is
			-- Write 'data' to the output stream for this response
		require
			data_exists: data /= Void
		do
			debug ("httpd_servlet_response")
				print ("%R%N" + generator + " response=%R%N'")
				print (data + "'%R%N")
			end
			debug ("httpd_response_write")
				print (generator + " response bytes = " + data.count.out + "%R%N")
			end
			internal_socket.put_string (data)
			-- TODO: check for internal_socket errors
		end

end -- class GOA_HTTPD_SERVLET_RESPONSE

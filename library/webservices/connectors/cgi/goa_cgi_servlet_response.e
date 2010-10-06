note
	description: "Objects that represent CGI request responses"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "CGI servlets"
	date: "$Date: 2007-06-14 13:30:24 -0700 (Thu, 14 Jun 2007) $"
	revision: "$Revision: 577 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class GOA_CGI_SERVLET_RESPONSE

inherit

	GOA_HTTP_SERVLET_RESPONSE

	GOA_HTTP_UTILITY_FUNCTIONS
		export
			{NONE} all
		end

	KL_SHARED_STANDARD_FILES
		export
			{NONE} all
		end

create
	make

feature {NONE}-- Initialization

	make
			-- Build a new CGI response object.
			-- Initialise the response information to allow a successful (Sc_ok) response
			-- to be sent immediately.
		do
			create cookies.make
			create headers.make (5)
			initial_buffer_size := Default_buffer_size
			reset
		end

feature -- Access

	buffer_size: INTEGER
			-- Actual size of response buffer. -- Warning: Changed for VE - was content_buffer.capacity

	contains_header (name: STRING): BOOLEAN
			-- Has the header named 'name' already been set?
		do
			Result := headers.has (name)
		end

feature -- Status report

	is_committed: BOOLEAN
			-- Has the response been committed? A committed response has already
			-- had its status code and headers written.

feature -- Status setting

	set_buffer_size (size: INTEGER)
			-- Set the preferred buffer size for the body of the response.
			--| If the buffer has not already been created, this routine will do so.
		do
			if content_buffer = Void then
				initial_buffer_size := size
			else
				content_buffer.resize (size)
			end
		end

	add_cookie (cookie: GOA_COOKIE)
			-- Add 'cookie' to the response. Can be called multiple times
			-- to add more than one cookie.
		do
			cookies.force_last (cookie)
		end

	add_header (name, value: STRING)
			-- Adds a response header with the given naem and value. This
			-- method allows response headers to have multiple values.
		local
			new_values: DS_LINKED_LIST [STRING]
		do
			if headers.has (name) then
				headers.item (name).force_last (value)
			else
				create new_values.make
				new_values.force_last (value)
				set_header (name, value)
			end
		end

	set_content_length (length: INTEGER)
			-- Set the length of the content body in the response.
		do
			content_length := length
			set_header ("Content-Length", length.out)
		end

	set_content_type (type: STRING)
			-- Set hte content type of the response being sent to the client.
			-- The content type may include the type of character encoding used, for
			-- example, 'text/html; charset=ISO-885904'

		do
			if type.substring_index ("charset", 1) = 0 then
				set_header ("Content-Type", type + latin1)
			else
				set_header ("Content-Type", type)
			end
		end

	set_header (name, value: STRING)
			-- Set a response header with the given name and value. If the
			-- header already exists, the new value overwrites the previous
			-- one.
		local
			new_values: DS_LINKED_LIST [STRING]
		do
			create new_values.make
			new_values.force_last (value)
			headers.force (new_values, name)
		end

	set_status (sc: INTEGER)
			-- Set the status code for this response. This method is used to
			-- set the return status code when there is no error (for example,
			-- for the status codes Sc_ok or Sc_moved_temporarily). If there
			-- is an error, the 'send_error' method should be used instead.
		do
			set_status_message (sc, status_code_message (sc))
		end

	set_status_message (sc: INTEGER; message: STRING)
			-- Set the status code to 'sc' with 'message' as the text message to
			-- send to the client.			
		do
			status := sc
			status_message := message
		end

feature -- Basic operations

	flush_buffer
			-- Force any content in the buffer to be written to the client. A call
			-- to this method automatically commits the response, meaning the status
			-- code and headers will be written.
			-- Before calling this routine, you must ensure that all required headers have been
			-- set. Standard headers are set when this object is instantiated therefore you can call
			-- this routine directly after creating the response object.
			-- This routine is automatically called by the service routine of HTTP_SERVLET.
		local
			exception_occurred: BOOLEAN
		do
			if not exception_occurred then
				if content_buffer = Void then
					content_buffer := ""
				end
				if not is_committed then
					set_content_length (content_buffer.count)
					write_headers
					is_committed := True
				end
				debug ("thread_control")
					io.put_string ("Buffer count: " + content_buffer.count.out + "%N")
					--io.put_string (content_buffer + "%N%N")
				end
				if not content_buffer.is_empty then
					write (content_buffer)
				end
			end
		rescue
			exception_occurred := True
			Retry
		end

	reset
			-- Clear any data that exists in the buffer as well as the status code
			-- and headers.
		do
			content_buffer := Void
			cookies.wipe_out
			headers.wipe_out
			set_content_length (0)
			set_content_type ("text/html")
			status := Sc_ok
			status_message := status_code_message (status)
			is_committed := False
		end

	send_error (sc: INTEGER)
			-- Send an error response to the client using the specified
			-- status code. The server generally creates the response to
			-- look like a normal server error page.
		do
			send_error_msg (sc, status_code_message (sc))
		end

	send_error_msg (sc: INTEGER; msg: STRING)
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

	send_redirect (location: STRING)
			-- Send a temporary redirect response to the client using the
			-- specified redirect location URL.
		local
			page: STRING
		do
			debug ("response_headers")
				print ("Sending a temorary redirect response%N")
			end
			page := build_redirect_page (location)
			set_status (Sc_moved_temporarily)
			set_content_type ("text/html")
			set_header ("Location", location)
			set_content_length (page.count)
			write_headers
			debug ("response_headers")
				print ("Sending a temorary redirect response - headers written%N")
			end
			write (page)
			debug ("response_headers")
				print ("Sending a temorary redirect response - page written%N")
			end
		end

	send (data: STRING)
			-- Send 'data' to the client. The data is buffered for writing. It will not be
			-- physically sent to the client until 'flush_buffer' is called.
		do
			-- keep extending the buffer if needed. We do not periodically send it until flush is called
			-- so that we can determine the correct content length.
			if content_buffer = Void then
				create content_buffer.make (initial_buffer_size)
			end
			content_buffer.append_string (data)
		end

feature {GOA_APPLICATION_SERVLET}

	content_buffer: STRING
		-- Buffer for writing output for response. Not used when error or redirect
		-- pages are sent. Created on demand

feature {NONE} -- Implementation

	content_length: INTEGER
		-- The length of the content that will be sent with this response.

	Default_buffer_size: INTEGER = 4096
		-- Default size of output buffer

	initial_buffer_size: INTEGER
		-- Size of buffer to create.

	status: INTEGER
		-- The result status that will be send with this response.

	status_message: STRING
		-- The status message. Void if none.

	cookies: DS_LINKED_LIST [GOA_COOKIE]
		-- The cookies that will be sent with this response.

	headers: DS_HASH_TABLE [DS_LINKED_LIST [STRING], STRING]
		-- The headers that will be sent with this response.

	build_error_page (sc: INTEGER; msg: STRING): STRING
			-- Build a standard error page for status code 'sc' and message 'msg'
		require
			msg_exists: msg /= Void
		do
			create Result.make (100)
			Result.append_string ("<HTML><HEAD><TITLE>")
			Result.append_string (status_code_message (sc))
			Result.append_string ("</TITLE></HEAD><BODY><CENTER><H1>")
			Result.append_string (status_code_message (sc))
			Result.append_string ("</H1></CENTER><P>")
			Result.append_string (msg)
			Result.append_string ("</P>")
			Result.append_string ("</BODY></HTML>")
		end

	build_redirect_page (location: STRING): STRING
			-- Build a temporary redirect page to redirect to 'location'
		require
			location_exists: location /= Void
		do
			create Result.make (100)
			Result.append_string ("<HTML><HEAD><TITLE>Document Has Moved</TITLE></HEAD>")
       		Result.append_string ("<BODY><CENTER><H1>Document Has Moved</H1></CENTER>")
        	Result.append_string ("This document has moved to <A HREF=%"")
        	Result.append_string (location)
        	Result.append_string ("%">")
        	Result.append_string (location)
        	Result.append_string ("</A><P>")
        	Result.append_string ("</BODY></HTML>")
		end

	build_headers: STRING
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
					Result.append_string (name)
					Result.append_string (": ")
					Result.append_string (header_values.item_for_iteration)
					Result.append_string ("%R%N")
					header_values.forth
				end
				header_keys.forth
			end
			debug ("response_headers")
				print (Result)
			end
		end

	set_default_headers
			-- Set default headers for all responses including the Server and Date headers.	
		do
			if not contains_header ("Server") then
				set_header ("Server", "Goanna Servlet Server")
			end
			if not contains_header ("Date") then
				set_header ("Date", "Sun, 06 Nov 1994 08:49:37 GMT") -- TODO: set real date	
			end
		end

	Expired_date: STRING = "Tue, 01-Jan-1970 00:00:00 GMT"

	set_cookie_headers
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

	write_headers
			-- Write the response headers to the output stream.
		require
			not_committed: not is_committed
		do
			-- NOTE: There is no need to send the HTTP status line because
			-- the FastCGI protocol does it for us.
			set_default_headers
			set_cookie_headers
			write (build_headers)
			write ("%R%N")
			is_committed := True
		ensure
			is_committed: is_committed
		end

	write (data: STRING)
			-- Write 'data' to the output stream for this response
		require
			data_exists: data /= Void
		do
--			io.put_string (generator + ".write " + quoted_eiffel_string_out (data))
			std.output.put_string (data)
		end

feature {NONE} -- Implementation

	latin1: STRING = "; charset=ISO-8859-1"
			-- Define the Latin-1 character set.

end -- class GOA_CGI_SERVLET_RESPONSE

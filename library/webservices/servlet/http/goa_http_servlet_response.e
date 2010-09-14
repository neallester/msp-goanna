note
	description: "Objects that represent HTTP-specific servlet responses."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "HTTP Servlet API"
	date: "$Date: 2006-10-02 15:49:12 -0700 (Mon, 02 Oct 2006) $"
	revision: "$Revision: 515 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

deferred class GOA_HTTP_SERVLET_RESPONSE

inherit

	GOA_SERVLET_RESPONSE

	GOA_HTTP_STATUS_CODES
		export
			{NONE} all
		end
		
feature -- Access

	contains_header (name: STRING): BOOLEAN
			-- Has the header named 'name' already been set?
		require
			name_exists: name /= Void
		deferred			
		end
	
feature -- Status setting

	add_cookie (cookie: GOA_COOKIE)
			-- Add 'cookie' to the response. Can be called multiple times
			-- to add more than one cookie.
		require
			cookie_exists: cookie /= Void
		deferred
		end
	
	set_header (name, value: STRING)
			-- Set a response header with the given name and value. If the
			-- header already exists, the new value overwrites the previous
			-- one.
		require
			name_exists: name /= Void
			value_exists: value /= Void
		deferred
		ensure
			header_set: contains_header (name)
		end
	
	add_header (name, value: STRING)
			-- Adds a response header with the given name and value. This
			-- method allows response headers to have multiple values.
		require
			name_exists: name /= Void
			value_exists: value /= Void
		deferred
		ensure
			header_set: contains_header (name)
		end
	
	set_status (sc: INTEGER)
			-- Set the status code for this response. This method is used to 
			-- set the return status code when there is no error (for example,
			-- for the status codes Sc_ok or Sc_moved_temporarily). If there
			-- is an error, the 'send_error' method should be used instead.
		deferred
		end
	
	set_status_message (sc: INTEGER; message: STRING)
			-- Set the status code to 'sc' with 'message' as the text message to
			-- send to the client.	
		require
			message_exists: message /= Void		
		deferred
		end

feature -- Basic operations

	send_error_msg (sc: INTEGER; msg: STRING)
			-- Send an error response to the client using the specified
			-- status code and descriptive message. The server generally 
			-- creates the response to look like a normal server error page.
		require
			msg_exists: msg /= Void
			not_committed: not is_committed
		deferred
		ensure
			committed: is_committed
		end
	
	send_error (sc: INTEGER)
			-- Send an error response to the client using the specified
			-- status code. The server generally creates the response to 
			-- look like a normal server error page.
		require
			not_committed: not is_committed
		deferred
		ensure
			committed: is_committed
		end	
		
	send_redirect (location: STRING)
			-- Send a temporary redirect response to the client using the
			-- specified redirect location URL.
		require
			location_exists: location /= Void
			not_committed: not is_committed
		deferred
		ensure
			committed: is_committed
		end
	
	send (data: STRING)
			-- Send 'data' to the client. The data is buffered for writing. It will not be 
			-- physically sent to the client until 'flush_buffer' is called. 
			-- You must set the content_length before sending content data.
		require
			data_exists: data /= Void
--			content_length_set: contains_header ("Content-Length")
		deferred
		end
			
	
end -- class GOA_HTTP_SERVLET_RESPONSE

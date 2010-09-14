note
	description: "Objects that assist a servlet in sending a response to a client."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "Servlet API"
	date: "$Date: 2007-06-14 13:30:24 -0700 (Thu, 14 Jun 2007) $"
	revision: "$Revision: 577 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

deferred class GOA_SERVLET_RESPONSE

feature -- Status report

	buffer_size: INTEGER
			-- Actual size of response buffer.
		deferred
		end

	is_committed: BOOLEAN
			-- Has the response been committed? A committed response has already
			-- had its status code and headers written.
		deferred
		end

feature -- Status setting

	set_content_length (length: INTEGER)
			-- Set the length of the content body in the response.
		require
			positive_length: length >= 0
		deferred
		end

	set_content_type (type: STRING)
			-- Set the content type of the response being sent to the client.
			-- The content type may include the type of character encoding used, for
			-- example, 'text/html; charset=ISO-885904'
		require
			type_exists: type /= Void
		deferred
		end

	set_buffer_size (size: INTEGER)
			-- Set the preferred buffer size for the body of the response.
		deferred
		end

feature -- Basic operations

	flush_buffer
			-- Force any content in the buffer to be written to the client. A call
			-- to this method automatically commits the response, meaning the status
			-- code and headers will be written.
		deferred
		ensure
			committed: is_committed
		end

	reset
			-- Clear any data that exists in the buffer as well as the status code
			-- and headers.
		require
			not_committed: not is_committed
		deferred
		ensure
			not_committed: not is_committed
		end

	write_ok: BOOLEAN
			-- Was there a problem sending the data to the client?

end -- class GOA_SERVLET_RESPONSE

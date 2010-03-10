indexing
	description: "Abstract notion of a FastCGI record body"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI protocol"
	date: "$Date: 2010-02-26 18:04:12 -0800 (Fri, 26 Feb 2010) $"
	revision: "$Revision: 626 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum v2 (see forum.txt)."

deferred class GOA_FAST_CGI_RECORD_BODY

inherit

	GOA_FAST_CGI_DEFS
		export
			{NONE} all
		end

	UC_UNICODE_ROUTINES

	UT_STRING_FORMATTER
		export
			{NONE} all
		end

	GOA_STRING_MANIPULATION
		export
			{NONE} all
		end

feature -- Initialization

	read (header: GOA_FAST_CGI_RECORD_HEADER; socket: ABSTRACT_TCP_SOCKET) is
			-- Construct this request record body from the data provided in header
		require
			header_exists: header /= Void
			socket_exists: socket /= Void
			valid_socket: socket.is_open
		local
			raw_padding: STRING
			bytes_to_read, bytes_read: INTEGER
		do
			read_ok := True
			from
				raw_content_data := ""
				bytes_to_read := header.content_length
			until
				bytes_to_read <= 0 or not read_ok
			loop
				socket.read_string (bytes_to_read)
				raw_content_data.append (socket.last_string)
				bytes_read := socket.last_string.count
				bytes_to_read := bytes_to_read - bytes_read
				read_ok := bytes_read > 0
			end
			from
				raw_padding := ""
				bytes_to_read := header.padding_length
				bytes_read := 0
			until
				bytes_to_read <= 0 or not read_ok
			loop
				socket.read_string (bytes_to_read)
				bytes_read := socket.last_string.count
				raw_padding.append (socket.last_string)
				bytes_to_read := bytes_to_read - bytes_read
				read_ok := bytes_read > 0
			end
   			debug ("fcgi_record_output")
				io.put_string (generating_type + "%N")
				if raw_content_data /= Void then
					io.put_string ("raw_content_data.count: " + raw_content_data.count.out + "%N")
				end
			end

		end

feature -- Access

	read_ok: BOOLEAN
			-- Was last read operation successful?

	raw_content_data: STRING
			-- Content data read from socket.

	padding_length: INTEGER
			-- Length of padding to write.

	as_fast_cgi_string: STRING is
		deferred
		end

	record_header (request_id: INTEGER): GOA_FAST_CGI_RECORD_HEADER is
		local
			content_length: INTEGER
		do
			if as_fast_cgi_string /= Void then
				content_length := as_fast_cgi_string.count
			end
			create Result.make (1, request_id, header_type_code, content_length, padding_length)
		end

	header_type_code: INTEGER is
		deferred
		end

feature {NONE} -- Implementation

	process_body_fields is
			-- Extract body fields from raw content data.
		deferred
		end

end -- class GOA_FAST_CGI_RECORD_BODY

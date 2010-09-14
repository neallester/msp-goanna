note
	description: "Objects that represent and can read FastCGI record headers from a socket"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI protocol"
	date: "$Date: 2010-02-26 18:04:12 -0800 (Fri, 26 Feb 2010) $"
	revision: "$Revision: 626 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class	GOA_FAST_CGI_RECORD_HEADER

inherit

	GOA_FAST_CGI_DEFS
		export
			{TS_TEST_CASE} all
		end

	UT_STRING_FORMATTER
		export
			{NONE} all
		end

	UC_UNICODE_ROUTINES

	KL_IMPORTED_INTEGER_ROUTINES

	GOA_STRING_MANIPULATION
		export
			{NONE} all
		end
	EPX_CURRENT_PROCESS

create

	make, read

feature -- Initialization

	make (new_version, new_request_id, new_type, new_content_length, new_padding_length: INTEGER)
			-- Create a new record header for the specified request.	
		require
			valid_version: new_version >= 1
			valid_request_id: new_request_id >= 0
			-- valid_type: valid_type (new_type)
			valid_content_length: new_content_length >= 0
			valid_padding_length: new_padding_length >= 0
		do
			version := new_version
			request_id := new_request_id
			type := new_type
			content_length := new_content_length
			padding_length := new_padding_length
		end

feature -- Access


	version, request_id, type, content_length, padding_length: INTEGER

	read_ok: BOOLEAN

	write_ok: BOOLEAN

feature -- Basic operations

	read (socket: ABSTRACT_TCP_SOCKET)
    			-- Read header data from 'socket'
    		local
    			buffer: STRING
    			bytes_to_read: INTEGER
    		do
    			buffer := create_blank_buffer (Fcgi_header_len)
    			read_ok := True
    			from
    				bytes_to_read := Fcgi_header_len
    				buffer := ""
    			until
    				bytes_to_read <= 0 or not read_ok
    			loop
    				socket.read_string (Fcgi_header_len)
    				buffer.append (socket.last_string)
    				bytes_to_read := bytes_to_read - socket.last_read
    				read_ok := socket.last_read > 0
    			end
    			if buffer.count = Fcgi_header_len then
    				process_header_bytes (buffer)
    			end
    			debug ("fcgi_record_output")
					io.put_string (generating_type + "%N")
    				io.put_string ("  version: " + version.out + "%N")
    				io.put_string ("  request_id: " + request_id.out + "%N")
    				io.put_string ("  type: " + type.out + "%N")
    				io.put_string ("  content_length: " + content_length.out + "%N")
    				io.put_string ("  padding_length: " + padding_length.out + "%N")
    			end
    		end

	write (socket: ABSTRACT_TCP_SOCKET)
			-- Write this header to 'socket'
		require
			socket_exists: socket /= Void
			valid_socket: socket.is_open
		local
			enc_data: STRING
			bytes_to_send, retries: INTEGER
			header_contents: STRING -- For debugging only
		do
			debug ("fcgi_protocol")
				io.put_string (generating_type + ".write + %N")
			end

-- Start debugging code
-- This code won't work unless the class also inherits from
-- The logging hierarchy and GOA_SHARED_APPLICATION_CONFIGURATION
--			header_contents := ""
--			header_contents.append (version.out + ", ")
--			header_contents.append (type.out +  ", ")
--			header_contents.append (INTEGER_.bit_and (INTEGER_.bit_shift_right (request_id, 8), 255).out + " (" + request_id.out + "), ")
--			header_contents.append (INTEGER_.bit_and (request_id, 255).out + " (" + request_id.out + "), ")
--			header_contents.append (INTEGER_.bit_and (INTEGER_.bit_shift_right (content_length, 8), 255).out + " (" + content_length.out + "), ")
--			header_contents.append (INTEGER_.bit_and (content_length, 255).out + " (" + content_length.out + "), ")
--			header_contents.append (padding_length.out)
--			log_hierarchy.logger (configuration.application_log_category).info ("GOA_FAST_CGI_RECORD_HEADER: " + header_contents)
-- End debugging code

			enc_data := create_blank_buffer (Fcgi_header_len)
			enc_data.put (code_to_string (version).item (1), 1)
			enc_data.put (code_to_string (type).item (1), 2)
			enc_data.put (code_to_string (INTEGER_.bit_and (INTEGER_.bit_shift_right (request_id, 8), 255)).item (1), 3)
			enc_data.put (code_to_string (INTEGER_.bit_and (request_id, 255)).item (1), 4)
			enc_data.put (code_to_string (INTEGER_.bit_and (INTEGER_.bit_shift_right (content_length, 8), 255)).item (1), 5)
			enc_data.put (code_to_string (INTEGER_.bit_and (content_length, 255)).item (1), 6)
			enc_data.put (code_to_string (padding_length).item (1), 7)
			enc_data.put ('%/0/', 8) -- reserved byte
			debug ("fcgi_protocol")
				--			io.put_string ("Starting write...%N")
				--			io.put_string ("Version: " + version.out + "%N")
				--			io.put_string ("request_id: " + request_id.out + "%N")
				--			io.put_string ("type: " + type.out + "%N")
				--			io.put_string ("content_length: " + content_length.out + "%N")
				--			io.put_string ("padding_length: " + padding_length.out + "%N")
				--			io.put_string ("FAST_CGI_RECORD_HEADER.write: " + quoted_eiffel_string_out(enc_data) + "%N")
				--			io.put_string ("FAST_CGI_RECORD_HEADER bytes to send: " + enc_data.count.out + "%N")
				--			io.put_string (generator + ".write: " + quoted_eiffel_string_out (enc_data) + "%R%N")
				--			io.put_string ("Bytes to send: " + enc_data.count.out + "%N")
				--			io.put_string (generator +  "bytes to sent: " + socket.last_written.out + "%N")
				--			io.put_string (generator + ".write: " + quoted_eiffel_string_out (enc_data) + "%R%N")
				--			io.put_string ("Sending data...%N")			
			end
			from
				bytes_to_send := enc_data.count
				write_ok := socket.errno.first_value = 0
			until
				bytes_to_send <= 0 or not write_ok
			loop
				socket.put_string (enc_data)
				bytes_to_send := bytes_to_send - socket.last_written
				write_ok := socket.errno.first_value = 0
				if bytes_to_send > 0 then
					enc_data.keep_tail (bytes_to_send)
				end
			end
			debug("fcgi_protocol")
				--				print (generator + ".write: " + quoted_eiffel_string_out (enc_data) + "%R%N")
				--				io.put_string ("Bytes to send: " + enc_data.count.out + "%N")
				--				io.put_string (generator +  "bytes to sent: " + socket.last_written.out + "%N")
				--				io.put_string (generator + ".write: " + quoted_eiffel_string_out (enc_data) + "%R%N")
				--				write_ok := socket.last_error_code = Sock_err_no_error
				--				io.put_string ("FAST_CGI_RECORD_HEADER Write OK: " + write_ok.out + "%N")
				--				io.put_string ("FAST_CGI_RECORD_HEADER bytes sent: " + socket.bytes_sent.out + "%N")

				io.put_string ("write_ok: " + write_ok.out + "%N")
				io.put_string (generating_type + ".write - finished + %N")
			end
		end

	as_fast_cgi_string: STRING
			-- This record formatted in accordance with the FastCGI Protocol
		do
			Result := ""
			Result.extend (version.to_character_8)
			Result.extend (type.to_character_8)
			Result.append (as_16_bit_string (request_id))
			Result.append (as_16_bit_string (content_length))
			Result.extend (padding_length.to_character_8)
			Result.append (create_blank_buffer (1))
		end

feature {TS_TEST_CASE} -- Implementation

	process_header_bytes (buffer: STRING)
			-- Extract the header data from 'buffer'
		require
			buffer_exists: buffer /= Void
			enough_header_bytes: buffer.count = Fcgi_header_len
		do
			version := buffer.item (1).code
			type := buffer.item (2).code
			-- request id in two bytes
			request_id := INTEGER_.bit_shift_left (buffer.item (3).code, 8) + buffer.item (4).code
			-- content length in two bytes
			content_length := INTEGER_.bit_shift_left (buffer.item (5).code, 8) + buffer.item (6).code
			padding_length := buffer.item (7).code
			-- reserved byte is also read but ignored
		end

end -- class GOA_FAST_CGI_RECORD_HEADER

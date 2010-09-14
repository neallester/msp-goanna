note
	description: "Objects that represent a FastCGI begin raw record body such as stdin or params"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI protocol"
	date: "$Date: 2010-02-26 18:04:12 -0800 (Fri, 26 Feb 2010) $"
	revision: "$Revision: 626 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class GOA_FAST_CGI_RAW_BODY

inherit

	GOA_FAST_CGI_RECORD_BODY

	UT_STRING_FORMATTER
		export
			{NONE} all
		end

	EPX_CURRENT_PROCESS

create

	make, read

feature -- Initialization

	make (new_data: STRING; padding: INTEGER)
			-- Create a new raw record body with 'new_data' as the content data and
			-- 'padding' characters as padding.
		require
			new_data_exists: new_data /= Void
			positive_padding: padding >= 0
		do
			raw_content_data := new_data
			padding_length := padding
		end

	write_ok: BOOLEAN

feature -- Basic operations

	header_type_code: INTEGER = 4

	write (socket: ABSTRACT_TCP_SOCKET)
			-- Write this raw data body to 'socket'
		require
			socket_exists: socket /= Void
			valid_socket: socket.is_open
		local
			enc_data: STRING
			padding: STRING
			bytes_to_send, retries: INTEGER
		do
			debug ("fcgi_protocol")
				io.put_string (generating_type + ".write + %N")
			end

			create enc_data.make (raw_content_data.count + padding_length)
			enc_data.append_string (raw_content_data)
			if padding_length > 0 then
				padding := create_blank_buffer (padding_length)
				enc_data.append_string (padding)
			end
--			io.put_string ("FAST_CGI_RAW_BODY.write bytes to send: " + enc_data.count.out + "%N")
--			io.put_string (generator + ".write: " + quoted_eiffel_string_out (enc_data) + "%N")
			--			io.put_string ("Bytes to send: " + enc_data.count.out +
			--			"%N")
			from
				bytes_to_send := enc_data.count
				write_ok := True
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
--			io.put_string (generator +  "bytes to sent: " + socket.last_written.out + "%N")
			debug("fcgi_protocol")
				--				print (generator + ".write: " + quoted_eiffel_string_out (enc_data) +
				--				"%R%N")
				io.put_string ("write_ok: " + write_ok.out + "%N")
				io.put_string (generating_type + ".write - finished%N")
			end
		end

	as_fast_cgi_string: STRING
		do
			if raw_content_data /= Void then
				Result := raw_content_data
			else
				Result := ""
			end
		end


feature {NONE} -- Implementation

	process_body_fields
			-- Extract body fields from raw content data.
		do
			-- no processing required. Access via raw_content_data.
		end

end -- class GOA_FAST_CGI_RAW_BODY

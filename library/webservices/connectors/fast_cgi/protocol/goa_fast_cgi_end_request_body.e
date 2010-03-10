indexing
	description: "Objects that represent a FastCGI end request record body"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI protocol"
	date: "$Date: 2010-02-26 18:04:12 -0800 (Fri, 26 Feb 2010) $"
	revision: "$Revision: 626 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class GOA_FAST_CGI_END_REQUEST_BODY

inherit

	GOA_FAST_CGI_RECORD_BODY

	KL_IMPORTED_INTEGER_ROUTINES

	EPX_CURRENT_PROCESS

create

	read, make

feature -- Initialisation

	make (new_app_status, new_protocol_status: INTEGER)is
			-- Create a new end request body.
		require
			-- valid_app_status: valid_app_status (new_app_status)
			-- valid_protocol_status: valid_protocol_status (new_protocol_status)
		do
			app_status := new_app_status
			protocol_status := new_protocol_status
		end

	write_ok: BOOLEAN

feature -- Access

	app_status, protocol_status: INTEGER

	header_type_code: INTEGER is 5

feature -- Basic operations

	write (socket: ABSTRACT_TCP_SOCKET) is
			-- Write this body to 'socket'
		require
			socket_exists: socket /= Void
			valid_socket: socket.is_open
		local
			enc_data: STRING
			bytes_to_send, retries: INTEGER
		do
			debug ("fcgi_protocol")
				io.put_string (generating_type + ".write + %N")
				io.put_string ("FAST_CGI_END_REQUEST_BODY.app_status: " + app_status.out + "%N")
				io.put_string ("FAST_CGI_END_REQUEST_BODY.protocol_status: " + protocol_status.out + "%N")
			end

			enc_data := create_blank_buffer (Fcgi_end_req_body_len)
			enc_data.put (code_to_string (INTEGER_.bit_and (INTEGER_.bit_shift_right (app_status, 24), 255)).item (1), 1)
			enc_data.put (code_to_string (INTEGER_.bit_and (INTEGER_.bit_shift_right (app_status, 16), 255)).item (1), 2)
			enc_data.put (code_to_string (INTEGER_.bit_and (INTEGER_.bit_shift_right (app_status, 8), 255)).item (1), 3)
			enc_data.put (code_to_string (INTEGER_.bit_and (app_status, 255)).item (1), 4)
			enc_data.put (code_to_string (protocol_status).item (1), 5)
			from
				bytes_to_send := enc_data.count
				write_ok := socket.errno.first_value = 0
			until
				bytes_to_send <= 0 or not write_ok
			loop
				socket.put_string (enc_data)
				write_ok := socket.errno.first_value = 0
				bytes_to_send := bytes_to_send - socket.last_written
				if bytes_to_send > 0 then
					enc_data.keep_tail (bytes_to_send)
				end
			end
			debug("fcgi_protocol")
				--				print (generator + ".write: " + quoted_eiffel_string_out (enc_data) +
				--				"%R%N")
				io.put_string ("write_ok: " + write_ok.out + "%N")
				io.put_string (generating_type + ".write - finished+ %N")
			end
		end

	as_fast_cgi_string: STRING is
			-- Formatted as a String per the FastCGI protocol
		do
			Result := ""
		end


feature {NONE} -- Implementation

	process_body_fields is
			-- Extract body fields from raw content data.
		do
--			app_status := raw_param_content.item (1).code.INTEGER_.bit_shift_left (24)
--				+ raw_param_content.item (2).code.INTEGER_.bit_shift_left (16)
--				+ raw_param_content.item (3).code.INTEGER_.bit_shift_left (8)
--				+ raw_param_content.item (4).code
--			protocol_status := raw_content_data.item (5).code
			-- 3 reserved bytes also read. Ignore them.
			debug ("fcgi_record_output")
				io.put_string ("  app_status: " + app_status.out + "%N")
				io.put_string ("  protocol_status: " + protocol_status.out + "%N")
			end
		end

end -- class GOA_FAST_CGI_END_REQUEST_BODY

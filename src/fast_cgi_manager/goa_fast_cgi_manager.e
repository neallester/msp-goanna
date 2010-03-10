indexing
	description: "Root class for goa_fast_cgi_manager; Manage Multiple fast_cgi applications"
	author: "Neal L Lester [neal@3dsafety.com]"
	date: "$Date:  $"
	revision: "$Revision: "
	copyright: "Copyright (c) Neal L. Lester"
	License: "Eiffel Forum License Version 2 (see forum.txt)"

class
	GOA_FAST_CGI_MANAGER

create

	make

feature {NONE} -- Creation

	make is
		local
			request: GOA_FAST_CGI_REQUEST
			socket: EPX_TCP_CLIENT_SOCKET
			host: EPX_HOST
			service: EPX_SERVICE
			ip_address: EPX_IP4_ADDRESS
			host_port: EPX_HOST_PORT
			request_string, response_line, response: STRING
			content_length, content_read: INTEGER
			split_content_length: LIST [STRING]
		do
			create ip_address.make_from_components (192, 168, 1, 35)
			create service.make_from_port (3783, "tcp")
			create host.make_from_address (ip_address)
			create host_port.make (host, service)
			create socket.open_by_address (host_port)
			create request.make
			request.add_parameter_record ("GATEWAY_INTERFACE", "CGI/1.1")
  			request.add_parameter_record ("SERVER_PROTOCOL", "HTTP/1.1")
  			request.add_parameter_record ("REQUEST_METHOD", "GET")
  			-- request.add_parameter_record ("QUERY_STRING", "page=greeting")
  			request.add_parameter_record ("REQUEST_URI", "/program/creator/go_to.htm?page=greeting")
  			-- request.add_parameter_record ("SCRIPT_NAME", "/program/creator")
  			-- request.add_parameter_record ("PATH_INFO", "/go_to.htm")
  			-- request.add_parameter_record ("PATH_TRANSLATED", "/var/www/html/msp_dev/go_to.htm")
  			request_string := request.as_fast_cgi_string (1)
			socket.put_string (request_string)
			from
			until
				response_line /= Void and then response_line.is_empty
			loop
				socket.read_line
				response_line := socket.last_string
				prune_line (response_line)
				if content_length = 0 and then response_line.has_substring ("Content-Length") then
					split_content_length := response_line.split (' ')
					content_length := split_content_length.i_th (2).to_integer_32
				end
			end
			from
				response := ""
			until
				content_read > content_length
			loop
				socket.read_line
				response_line := socket.last_string
				prune_line (response_line)
				response.append (response_line + "%N")
				content_read := content_read + response_line.count + 1
			end
			io.put_string (response)
		end

	prune_line (a_line: STRING) is
			-- a_line cleaned of hidden characters
		require
			valid_a_line: a_line /= Void
		do
			a_line.prune_all ((0).to_character_8)
			a_line.prune_all ((1).to_character_8)
			a_line.prune_all ((2).to_character_8)
			a_line.prune_all ((6).to_character_8)
			a_line.prune_all ((24).to_character_8)
			a_line.prune_all ((25).to_character_8)
		ensure
			not_has_0: not a_line.has ((0).to_character_8)
			not_has_1: not a_line.has ((1).to_character_8)
			not_has_2: not a_line.has ((2).to_character_8)
			not_has_6: not a_line.has ((6).to_character_8)
			not_has_24: not a_line.has ((24).to_character_8)
			not_has_25: not a_line.has ((25).to_character_8)
		end


feature {NONE} -- Implementation


end -- class GOA_FAST_CGI_MANAGER

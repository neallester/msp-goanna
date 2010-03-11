indexing
	description: "Probes a Goanna FastCgi Servlet Application"
	author: "Neal Lester"
	date: "$Date$"
	revision: "$Revision$"
	License: "Eiffel Forum License Version 2 (see forum.txt)"

class

	GOA_FAST_CGI_PROBE

inherit

	GOA_FAST_CGI_PROBE_FACILITIES
	KL_SHARED_EXCEPTIONS

create

	make, make_local_host, make_from_host

feature -- Status

	is_connected: BOOLEAN is
		do
			Result := socket /= Void and then socket.is_open_write
		end

	last_exception: INTEGER
	last_developer_exception: STRING


feature -- Probe

	connect is
		local
			exception_occurred: BOOLEAN
		do
			if not exception_occurred then
				create socket.open_by_address (host_port)
			end
		rescue
			exception_occurred := True
			last_exception := exceptions.exception
			if exceptions.is_developer_exception then
				last_developer_exception := exceptions.developer_exception_name
			else
				last_developer_exception := Void
			end
			Retry
		end


	get (a_page: STRING): STRING is
		require
			valid_a_page: a_page /= Void
			no_leading_slash: not (a_page.item (1) = '/')
		local
			request: GOA_FAST_CGI_REQUEST
			request_string, response_line, response: STRING
			content_length, content_read: INTEGER
			split_content_length: LIST [STRING]
		do
			create request.make
			request.add_parameter_record ("GATEWAY_INTERFACE", "CGI/1.1")
  			request.add_parameter_record ("SERVER_PROTOCOL", "HTTP/1.1")
  			request.add_parameter_record ("REQUEST_METHOD", "GET")
  			request.add_parameter_record ("REQUEST_URI", script_path + a_page)
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
			Result := Response
		end

feature -- Facilities

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


feature {NONE} -- Creation

	make_local_host (a_port: INTEGER; a_script_path: STRING) is
		require
			valid_a_script_path: a_script_path /= Void
			is_legal_script_path: is_legal_script_path (a_script_path)
			valid_a_port: 0 < a_port and a_port <= 65535
		local
			host: EPX_HOST
		do
			create host.make_from_ip4_loopback
			make_from_host (host, a_port, a_script_path)
		end

	make (a_ip_address: ARRAY [INTEGER]; a_port: INTEGER; a_script_path: STRING) is
			-- creation
		require
			valid_a_ip_address: a_ip_address /= Void
			a_ip_address_is_ip4: is_ip4_address (a_ip_address)
			valid_a_script_path: a_script_path /= Void
			is_legal_script_path: is_legal_script_path (a_script_path)
			valid_a_port: 0 < a_port and a_port <= 65535
		local
			host: EPX_HOST
			ip_address: EPX_IP4_ADDRESS
		do
			create ip_address.make_from_components (a_ip_address [1], a_ip_address [2], a_ip_address [3], a_ip_address [4])
			create host.make_from_address (ip_address)
			make_from_host (host, a_port, a_script_path)
		end

	make_from_host (host: EPX_HOST; a_port: INTEGER; a_script_path: STRING) is
		require
			valid_host: host /= Void
			valid_a_script_path: a_script_path /= Void
			is_legal_script_path: is_legal_script_path (a_script_path)
			valid_a_port: 0 < a_port and a_port <= 65535
		local
			service: EPX_SERVICE
		do
			create service.make_from_port (a_port, "tcp")
			create host_port.make (host, service)
			script_path := a_script_path
			connect
		end

	socket: EPX_TCP_CLIENT_SOCKET
	script_path: STRING
	host_port: EPX_HOST_PORT

invariant

	valid_script_path: script_path /= Void
	valid_host_port: host_port /= Void

end

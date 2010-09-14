note

	author:      "Marcio Marchini <mqm@users.sourceforge.net>"
	copyright:   "Copyright (c) 2000, Marcio Marchini"
	thanks:		 "Bedarra (www.bedarra.com) for support of open source; Richie Bielak for Emu"
	license:    "Eiffel Forum License v2 (see forum.txt)"
	date:        "$Date: 2006-12-19 11:49:12 -0800 (Tue, 19 Dec 2006) $"
	revision:    "$Revision: 523 $"


class GOA_HTTPD_SERVER_SOCKET

inherit

	EPX_TCP_SERVER_SOCKET
		redefine
			multiplexer_read_callback,
			accept,
			backlog_default
		end

	EPX_SOCKET_MULTIPLEXER_SINGLETON
		export
			{NONE} all
		end

	GOA_HTTPD_LOGGER
		export
			{NONE} all
		end

create

    listen_by_address,
    listen_by_address_and_backlog

feature

	accept: ABSTRACT_TCP_SOCKET
			-- Return the next completed connection from the front of the
			-- completed connection queue. If there are no completed
			-- connections, the process is put to sleep.
			-- If the socket is non-blocking, Void will be returned and
			-- the process is not put to sleep..
		local
			client_fd: INTEGER
		do
			address_length := client_socket_address.capacity
			client_fd := abstract_accept (fd, client_socket_address.ptr, $address_length)
			if client_fd = unassigned_value then
				if errno.is_not_ok and then errno.value /= EAGAIN then
					raise_posix_error
				end
			else
				create {GOA_HTTPD_SERVING_SOCKET} Result.attach_to_socket (client_fd, True)
				last_client_address := new_socket_address_in_from_pointer (client_socket_address, address_length)
			end
		end

	multiplexer_read_callback (a_multiplexer: EPX_SOCKET_MULTIPLEXER)
			-- we got a new client. Register the socket that talks to this client as a
			-- managed socket so that a select can work on it too
		local
			socket : ABSTRACT_TCP_SOCKET
		do
			debug ("status_output")
				io.put_character ('#')
			end
			socket := accept
			if errno.is_ok then
				socket_multiplexer.add_read_socket (socket)
			else
				log_hierarchy.logger (Internal_category).error (
					"Server socket error: " + socket_multiplexer.errno.first_value.out
-- TODO					+ "," + socket_multiplexer.last_extended_socket_error_code.out
				)
				errno.clear_first
			end
		end



feature {NONE} -- Implementation

	listen_by_address_and_backlog (hp: EPX_HOST_PORT; a_backlog: INTEGER_32)
			-- does the same as `listen_by_address' except that it allows to set a user defined backlog
		require
			closed: not is_open
			hp_not_void: hp /= Void
			supported_family: hp.socket_address.address_family = af_inet or hp.socket_address.address_family = af_inet6
			tcp_protocol: hp.service.protocol_type = sock_stream
			a_backlog_positive: a_backlog >= 0
		do
			private_backlog := a_backlog
			listen_by_address (hp)
		end


	private_backlog: INTEGER_32

	backlog_default: INTEGER_32
			-- redefined to support a user defined backlog
		do
			if private_backlog < 0 then
				Result := somaxconn
			else
				Result := private_backlog
			end
		end


end -- class GOA_HTTPD_SERVER_SOCKET



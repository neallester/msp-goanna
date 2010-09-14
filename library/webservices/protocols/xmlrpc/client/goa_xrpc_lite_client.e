note
	description: "XML RPC/Messaging Client"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "XML-RPC"
	date: "$Date: 2006-11-23 08:38:55 -0800 (Thu, 23 Nov 2006) $"
	revision: "$Revision: 518 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class GOA_XRPC_LITE_CLIENT

inherit

	GOA_XRPC_CONSTANTS
		export
			{NONE} all
		end

	KL_EXCEPTIONS
		export
			{NONE} all
		end

create

	make

feature -- Initialisation

	make (connect_host: STRING; connect_port: INTEGER; connect_uri: STRING)
			-- Initialise XML-RPC client that will send calls using 'connect_uri' to
			-- the server listening on 'connect_host:connect_port'
		require
			connect_host_exists: connect_host /= Void
			valid_port: connect_port > 0
			connect_uri_exists: connect_uri /= Void
		do
			host := connect_host
			port := connect_port
			uri := connect_uri
		end

feature -- Basic routines

	invoke (call: GOA_XRPC_CALL)
			-- Send 'call' to server to be executed. Make 'invocation_ok' True if call is
			-- successful and make result available in 'response'. Make 'invocation_ok' False
			-- if the call failed and make the fault
			-- available in 'fault'.
		require
			call_exists: call /= Void
		do
			response := Void
			fault := Void
			send_call (call)
			if socket_ok then
				receive_response
				-- check for response assertion failure and raise exception
				if not invocation_ok and exception_on_failure then
					if fault.code = Assertion_failure then
						raise ("Remote_assertion_failure")
					end
				end
			end
		ensure
			response_available: invocation_ok implies (response /= Void and fault = Void)
			fault_available: not invocation_ok implies (response = Void and fault /= Void)
		end

feature -- Status report

	invocation_ok: BOOLEAN
			-- Was the last call successful?

	response: GOA_XRPC_RESPONSE
			-- Last call response. Only available if 'invocation_ok'.

	fault: GOA_XRPC_FAULT
			-- Last fault. Only available if not 'invocation_ok'.

	exception_on_failure: BOOLEAN
			-- Should an exception be raised if a remote call assertion fails?
			-- Default: false

feature -- Status setting

	set_exception_on_failure (flag: BOOLEAN)
			-- Set 'exception_on_failure' to 'flag'
		do
			exception_on_failure := flag
		end

feature {NONE} -- Implementation

	socket_ok: BOOLEAN
			-- Was last socket operation successful?

	host: STRING
			-- Server host name

	port: INTEGER
			-- Server port

	uri: STRING
			-- Server XMLRPC uri

	socket: EPX_TCP_CLIENT_SOCKET

	send_call (call: GOA_XRPC_CALL)
			-- Send 'call' over the wire
		require
			call_exists: call /= Void
		local
			data: STRING
			call_data: STRING
		do
			if socket = Void or else not socket.is_open then
				connect
			end
			if socket_ok then
				call_data := call.marshall
				debug ("xmlrpc_socket")
					print (call_data + "%N")
				end
				create data.make (2048)
				data.append ("POST ")
				data.append (uri)
				data.append (" HTTP/1.0%R%N")
				data.append ("User-Agent: Goanna XML-RPC Client%R%N")
				data.append ("Host: ")
				-- data.append (socket.peer_name)
				data.append (host)
				data.append ("%R%N")
				data.append ("Content-Type: text/xml%R%N")
				data.append ("Content-Length: ")
				data.append (call_data.count.out)
				data.append ("%R%N%R%N")
				data.append (call_data)
				socket.put_string (data)
				debug ("wire_dump")
					print ("Sent >>>>>%N")
					print (data + "%N")
					print (">>>>>%N%N")
				end
			end
		end

	connect
			-- Open socket connected to service
		do
			create socket.open_by_name_and_port (host, port)
			socket_ok := socket.is_open
		ensure
			socket_ready: socket_ok = socket.is_open
		end

	disconnect
			-- Open socket connected to service
		do
			if socket /= Void then
				socket.close
				socket := Void
			end
		ensure
			socket_closed: socket = Void
		end

	receive_response
			-- Recieve response from server and determine type
		local
			buffer: STRING
			response_string: STRING
			done: BOOLEAN
		do
			create response_string.make (8192)
			if socket = Void or else not socket.is_open then
				connect
			end
			if socket_ok then
				-- read until complete response has been read
				content_length_found := False
				content_length := -1
				end_header_index := -1
				content := Void
				from
					socket.read_string (8192)
					buffer := socket.last_string
				until
					done or not socket_ok
				loop
					if buffer.count > 0 then
						response_string.append (buffer)
					end
					done := check_response (response_string, socket.last_string.count > 0)
					if not done then
						socket.read_string (8192)
						buffer := socket.last_string
					end
				end
				if socket_ok then
					debug ("wire_dump")
						print ("Received <<<<<%N")
						print (response_string + "%N")
						print ("<<<<<%N%N")
					end
					-- determine response type
					process_response
					disconnect
				end
			end
		end

	content_length_found: BOOLEAN
	content_length, end_header_index: INTEGER
	content: STRING

	check_response (buffer: STRING; more_bytes: BOOLEAN): BOOLEAN
			-- Check response to determine if all headers and body has been read. 'more_bytes' 
			-- indicates if more bytes were read before entering this routine. If this is false
			-- the check can assume that the entire message has been read.
		require
			buffer /= Void
		local
			content_length_index: INTEGER
			tokenizer: GOA_STRING_TOKENIZER
			next_token: STRING
		do
			debug ("xmlrpc_socket")
				print (buffer)
				print ("%N")
			end
			if not content_length_found then
				-- check for "%R%N%R%N" for all headers read.
				end_header_index := buffer.substring_index ("%R%N%R%N", 1)
				if end_header_index /= 0 then
					end_header_index := end_header_index + 4
					-- find content length header
					create tokenizer.make (buffer, "%R%N")
					from
						tokenizer.start
					until
						tokenizer.off or content_length_found
					loop
						next_token := tokenizer.item
						next_token.to_lower
						content_length_index := next_token.substring_index ("content-length:", 1)
						if content_length_index /= 0 then
							content_length_found := True
							content_length := next_token.substring (16, next_token.count).to_integer
						end
						tokenizer.forth
					end
				end
			end
			if content_length_found or not more_bytes then
				if not more_bytes then
					-- Nothing more will be read
					Result := True
				else
					-- have enough bytes for the body been read?
					Result := buffer.count = end_header_index + content_length - 1
				end
				if Result then
					content := buffer.substring (end_header_index, buffer.count)
				end
			end
		end

	process_response
			-- Parse response and determine if it is a response or fault. Store in
			-- appropriate attribute and set 'invokation_ok' flag.
		require
			content_exists: content /= Void
		local
			parser: XM_EIFFEL_PARSER
			tree_pipe: GOA_TREE_CALLBACKS_PIPE
			child: XM_ELEMENT
		do
			invocation_ok := True
			create parser.make
			create tree_pipe.make
			parser.set_callbacks (tree_pipe.start)
			parser.parse_from_string (content)
			if parser.is_correct then
				-- retrieve child if available
				if not tree_pipe.document.root_element.is_empty then
					child ?= tree_pipe.document.root_element.first
				end
				-- peek at response elements to determine if it is a fault or not
				if child /= Void and then child.name.is_equal (Fault_element) then
					create fault.unmarshall (tree_pipe.document.root_element)
					if not fault.unmarshall_ok then
						-- create fault
						create fault.make (fault.unmarshall_error_code)
						response := Void
					end
					invocation_ok := False
				else
					create response.unmarshall (tree_pipe.document.root_element)
					if not response.unmarshall_ok then
						-- create fault
						invocation_ok := False
						create fault.make (response.unmarshall_error_code)
						response := Void
					end
				end
			else
				invocation_ok := False
				response := Void
				-- create fault
				create fault.make (Bad_payload_fault_code)
			end
		end

end -- GOA_XRPC_LITE_CLIENT

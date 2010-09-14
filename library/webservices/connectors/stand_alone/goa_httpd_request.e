note
	description: "HTTP parsed request"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "tools httpd"
	date: "$Date: 2006-12-11 11:57:49 -0800 (Mon, 11 Dec 2006) $"
	revision: "$Revision: 521 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class GOA_HTTPD_REQUEST

inherit

		GOA_HTTPD_CGI_HEADER_VARS
			export
				{NONE} all
			end

		GOA_STRING_MANIPULATION
			export
				{NONE} all
			end

create

	make, make_standard_socket

feature -- Initialisation

	make (socket: GOA_HTTPD_SERVING_SOCKET; buffer: STRING)
			-- Parse 'buffer' to initialise the request parameters
		require
			socket_exists: socket /= Void
			buffer_exists: buffer /= Void
		do
			raw_stdin_content := ""
			create parameters.make (20)
			serving_socket := socket
			a_servlet_prefix := socket.servlet_manager.servlet_mapping_prefix
			document_root := socket.servlet_manager.config.document_root
			parse_request_buffer (buffer)
			set_server_parameters (socket.servlet_manager.config.server_port,
				socket.servlet_manager.config.document_root)
		end

	make_standard_socket (socket: EPX_TCP_SOCKET; buffer: STRING; server_port: INTEGER;
		doc_root, servlet_mapping_prefix: STRING)
			-- Parse 'buffer' to initialise the request parameters
		require
			socket_exists: socket /= Void
			buffer_exists: buffer /= Void
			doc_root_exists: doc_root /= Void
			prefix_exists: servlet_mapping_prefix /= Void
		do
			raw_stdin_content := ""
			create parameters.make (20)
			serving_socket := socket
			document_root := doc_root
			a_servlet_prefix := servlet_mapping_prefix
			parse_request_buffer (buffer)
			set_server_parameters (server_port, doc_root)
		end

feature -- Access

	serving_socket: EPX_TCP_SOCKET

	parameter (name: STRING): STRING
			-- Return value of parameter 'name'
		require
			name_exists: name /= Void
			parameter_exists: has_parameter (name)
		do
			Result := parameters.item (name)
		end

	has_parameter (name: STRING): BOOLEAN
			-- Does the parameter 'name' exists for this request?
		require
			name_exists: name /= Void
		do
			Result := parameters.has (name)
		end

	parameters: DS_HASH_TABLE [STRING, STRING]
			-- Table of request parameters. Equivalent to the CGI parameter set.

	raw_stdin_content: STRING
			-- Request body content. Empty string if no content.

feature {NONE} -- Implementation

	set_server_parameters (server_port: INTEGER; doc_root: STRING)
			-- Set server specific parameters for request
		require
			doc_root_exists: doc_root /= Void
		do
			parameters.force ("Goanna HTTP Server V1.0", Server_software_var)
			parameters.force ("CGI/1.1", Gateway_interface_var)
			parameters.force (server_port.out, Server_port_var)
-- TODO			parameters.force (serving_socket.peer_name, Remote_host_var)
			parameters.force (serving_socket.remote_address.address.out, Remote_addr_var)
			parameters.force (doc_root, Document_root_var)
		end

	Last_header_line: STRING = "%R%N%R%N"
			-- String that indicates the last header has been read.
			--| Specific to the GOA_STRING_TOKENIZER token parsing method

	Header_separator_line: STRING = "%R%N"
			-- String that separates headers.

	parse_request_buffer (buffer: STRING)
			-- Parse request buffer to set parameters
		require
			buffer_exists: buffer /= Void
		local
			t1, t2: GOA_STRING_TOKENIZER
			request, header: STRING
			content_length: INTEGER
			index: INTEGER
			done: BOOLEAN
		do
			debug ("raw_snoop")
				print ("Request buffer:%R%N" + buffer + "%R%N")
			end
			--| keep record of the current index so that content data can
			--| be extracted directly from the buffer, if required.
			-- parse the request line
			create t1.make_include_delimiters (buffer, "%R%N")
			t1.start
			-- parse request line
			request := t1.item
			index := index + request.count
			request.right_adjust
			create t2.make (request, " ")
			t2.start
			parameters.force (t2.item, Request_method_var)
			t2.forth
			parse_request_uri (t2.item)
			t2.forth
			parameters.force (t2.item, Server_protocol_var)
			-- parse remaining header lines
			from
				t1.forth
			until
				t1.off or done
			loop
				header := t1.item
				index := index + header.count
				if header.is_equal (Last_header_line) then
					-- at last header, skip forth and collect raw content data if it exists
					t1.forth
					if not t1.off then
						if parameters.has (Content_length_var) then
							content_length := parameters.item (Content_length_var).to_integer
							raw_stdin_content := buffer.substring (index + 1, index + content_length)
						else
							raw_stdin_content := ""
						end
					end
					done := True
				else
					if not header.is_equal (Header_separator_line) then
						-- parse the next header line
						parse_header (header)
					end
					t1.forth
				end
			end
		end

	a_servlet_prefix, document_root: STRING

	parse_request_uri (token: STRING)
			-- Parse the request uri extracting the path info, script path and query string.
		require
			token_exists: token /= Void
		local
			query_index, slash_index: INTEGER
			query, script, path, servlet_prefix: STRING
		do

			query_index := index_of_char (token, '?', 1)
			if query_index /= 0 then
				query := token.substring (1, query_index - 1)
				parameters.force (token.substring (query_index + 1, token.count), Query_string_var)
			else
				parameters.force ("", Query_string_var)
				query := token
			end
			-- assume this is not a servlet request and set the path info to the request
			path := query
			-- if the query begins with the virtual servlet prefix then the script name is
			-- the portion including the prefix and all characters before the next slash.
			-- everything after the next slash is the path info.
			servlet_prefix := "/" + a_servlet_prefix
			script := query
			if query.count > servlet_prefix.count + 1 then
				if query.substring (1, servlet_prefix.count).is_equal (servlet_prefix) then
					slash_index := index_of_char (query, '/', servlet_prefix.count + 1)
					if slash_index /= 0 then
						script := query.substring (1, slash_index - 1)
						path := query.substring (slash_index, query.count)
					else
						script := query.substring (1, query.count)
					end
				end
			end
			parameters.force (script, Script_name_var)
			parameters.force (path, Path_info_var)
			-- set the translated path if needed
			if not path.is_empty then
				-- path includes leading slash
				parameters.force (document_root + path, Path_translated_var)
			end
		end

	Http_header_prefix: STRING = "HTTP_"
			-- Prefix for all headers found in the request

	parse_header (header: STRING)
			-- Parse the header and set appropriate CGI variables
		require
			header_exists: header /= Void
		local
			colon_index, i: INTEGER
			name, value: STRING
		do
			-- split the header
			colon_index := index_of_char (header, ':', 1)
			if colon_index >= 1 then
				-- extract the name
				name := header.substring (1, colon_index - 1)
				name.to_upper
				from
					i := index_of_char (name, '-', 1)
				until
					i = 0
				loop
					name.put ('_', i)
					i := index_of_char (name, '-', i + 1)
				end
				name := Http_header_prefix + name
				-- extract the value
				value := header.substring (colon_index + 1, header.count)
				value.left_adjust
				parameters.force (value, name)
			end
		end

invariant

	socket_exists: serving_socket /= Void
	parameters_exist: parameters /= Void
	raw_content_exists: raw_stdin_content /= Void

end -- class GOA_HTTPD_REQUEST

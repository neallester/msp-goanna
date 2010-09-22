note
	description: "Objects that represent CGI servlet request information"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "CGI servlets"
	date: "$Date: 2007-05-17 18:54:18 -0700 (Thu, 17 May 2007) $"
	revision: "$Revision: 574 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class GOA_CGI_SERVLET_REQUEST

inherit

	GOA_HTTP_SERVLET_REQUEST

	GOA_SHARED_HTTP_SESSION_MANAGER
		export
			{NONE} all
		end

	GOA_CGI_VARIABLES
		export
			{NONE} all
		end

	GOA_HTTP_UTILITY_FUNCTIONS
		export
			{NONE} all
		end

	GOA_STRING_MANIPULATION
		export
			{NONE} all
		end

	KL_SHARED_EXECUTION_ENVIRONMENT
		export
			{NONE} all
		end

	KL_SHARED_STANDARD_FILES
		export
			{NONE} all
		end

create

	make

feature {NONE} -- Initialisation

	make (new_session: like session; resp: GOA_CGI_SERVLET_RESPONSE)
			-- Create a new cgi servlet request wrapper
		require
			response_exists: resp /= Void
		do
			internal_response := resp
			create parameters.make (5)
			parse_parameters
			session := new_session
		end

feature -- Access

	get_parameter (name: STRING): STRING
			-- Returns the value of a request parameter
		do
			Result := clone (parameters.item (name).last)
		end

	get_multiple_parameter (name: STRING): DS_LINKED_LIST [STRING]
			-- Returns the value of a request parameter
		do
			Result := clone (parameters.item (name))
		end

	get_parameter_names: DS_LINEAR [STRING]
			-- Return all parameter names
		local
			cursor: DS_HASH_TABLE_CURSOR [DS_LINKED_LIST [STRING], STRING]
			array_list: DS_ARRAYED_LIST [STRING]
		do
			create array_list.make (parameters.count)
			cursor := parameters.new_cursor
			from
				cursor.start
			until
				cursor.off
			loop
				array_list.force_last (clone (cursor.key))
				cursor.forth
			end
			Result := array_list
		end

	get_parameter_values: DS_LINEAR [STRING]
			-- Return all parameter values
		local
			cursor: DS_HASH_TABLE_CURSOR [DS_LINKED_LIST [STRING], STRING]
			ll_cursor: DS_LINKED_LIST_CURSOR [STRING]
			array_list: DS_ARRAYED_LIST [STRING]
		do
			create array_list.make (parameters.count + 10)
			cursor := parameters.new_cursor
			from
				cursor.start
			until
				cursor.off
			loop
				ll_cursor := cursor.item.new_cursor
				from
					ll_cursor.start
				until
					ll_cursor.after
				loop
					array_list.force_last (clone (ll_cursor.item))
					ll_cursor.forth
				end
				cursor.forth
			end
			Result := array_list
		end

	get_header (name: STRING): STRING
			-- Get the value of the specified request header.
		do
			Result := clone (Execution_environment.variable_value (name))
		end

	get_headers (name: STRING): DS_LINEAR [STRING]
			-- Get all values of the specified request header. If the
			-- header has comma-separated values they are separated and added to the
			-- result. If only one value exists, it is added as the sole entry in the
			-- list.
		local
			tokenizer: GOA_STRING_TOKENIZER
			list: DS_LINKED_LIST [STRING]
		do
			create list.make
			create tokenizer.make (get_header (name), ",")
			from
				tokenizer.start
			until
				tokenizer.off
			loop
				list.force_last (tokenizer.item)
				tokenizer.forth
			end
			Result := list
		end

	get_header_names: DS_LINEAR [STRING]
			-- Get all header names.
		local
			array_list: DS_ARRAYED_LIST [STRING]
		do
			-- create fixed list of variable names
			create array_list.make (23)
			array_list.force_last (Gateway_interface_var)
			array_list.force_last (Server_name_var)
			array_list.force_last (Server_software_var)
			array_list.force_last (Server_protocol_var)
			array_list.force_last (Server_port_var)
			array_list.force_last (Request_method_var)
			array_list.force_last (Path_info_var)
			array_list.force_last (Path_translated_var)
			array_list.force_last (Script_name_var)
			array_list.force_last (Document_root_var)
			array_list.force_last (Query_string_var)
			array_list.force_last (Remote_host_var)
			array_list.force_last (Remote_addr_var)
			array_list.force_last (Auth_type_var)
			array_list.force_last (Remote_user_var)
			array_list.force_last (Remote_ident_var)
			array_list.force_last (Content_type_var)
			array_list.force_last (Content_length_var)
			array_list.force_last (Http_from_var)
			array_list.force_last (Http_accept_var)
			array_list.force_last (Http_user_agent_var)
			array_list.force_last (Http_referer_var)
			array_list.force_last (Http_cookie_var)
			Result := array_list
		end

feature -- Status report

	has_parameter (name: STRING): BOOLEAN
			-- Does this request have a parameter named 'name'?
		do
			Result := parameters.has (name)
		end

	content_length: INTEGER
			-- The length in bytes of the request body or -1 if the length is
			-- not known.
		local
			str: STRING
		do
			Result := 0
			if has_header (Content_length_var) then
				str := get_header (Content_length_var)
				if str /= Void and then str.is_integer then
					Result := str.to_integer
				end
			end
		end

	content_type: STRING
			-- The MIME type of the body of the request, or Void if the type is
			-- not known.
		do
			if has_header (Content_type_var) then
				Result := get_header (Content_type_var)
			else
				Result := ""
			end
		end

	protocol: STRING
			-- The name and version of the protocol the request uses in the form
			-- 'protocol/majorVersion.minorVrsion', for example, HTTP/1.1.
		do
			if has_header (Server_protocol_var) then
				Result := get_header (Server_protocol_var)
			else
				Result := ""
			end
		end

	scheme: STRING
			-- The name of the scheme used to make this request. Such as, http, https
			-- or ftp.
		do
			Result := "http"
			-- TODO: may need to change this when we support https	
		end

	server_name: STRING
			-- The host name of the server that received the request.
		do
			if has_header (Server_name_var) then
				Result := get_header (Server_name_var)
			else
				Result := ""
			end
		end

	server_port: STRING
			-- The port number on which this request was received.
		do
			if has_header (Server_port_var) then
				Result := get_header (Server_port_var)
			else
				Result := ""
			end
		end

	remote_address: STRING
			-- The internet protocol (IP) address of the client that sent the request.
		do
			if has_header (Remote_addr_var) then
				Result := get_header (Remote_addr_var)
			else
				Result := ""
			end

		end

	remote_host: STRING
			-- The fully qualified name of the client that sent the request, or the
			-- IP address of the client if the name cannot be determined.
		do
			if has_header (Remote_host_var) then
				Result := get_header (Remote_host_var)
			else
				Result := ""
			end
		end

	is_secure: BOOLEAN
			-- Was this request made using a secure channel, such as HTTPS?
		do
			if has_header (Https_var) and then equal (get_header (Https_var), "on") then
				Result := True
			end
		end

	has_header (name: STRING): BOOLEAN
			-- Does this request contain a header named 'name'?
		do
			Result := Execution_environment.variable_value (name) /= Void
		end

	auth_type: STRING
			-- The name of the authentication scheme used to protect the servlet,
			-- for example, "BASIC" or "SSL" or Void if the servlet was not protected.
		do
			if has_header (Auth_type_var) then
				Result := get_header (Auth_type_var)
			else
				Result := ""
			end
		end

	cookies: DS_LINKED_LIST [GOA_COOKIE]
			-- Cookies sent with this request.
		do
			if internal_cookies = Void then
				-- iterate across cookie header and collect all cookie values
				-- TODO: handle multiple cookie headers
				parse_cookie_header
			end
			Result := internal_cookies
		end

	method: STRING
			-- The name of the HTTP method with which this request was made, for
			-- example, GET, POST, or HEAD.
		do
			if has_header (Request_method_var) then
				Result := get_header (Request_method_var)
			else
				Result := ""
			end
		end

	path_info: STRING
			-- Any extra path information associated with the URL the client sent
			-- when it made the request.
		do
			if has_header (Path_info_var) then
				Result := get_header (Path_info_var)
			else
				Result := ""
			end
		end

	path_translated: STRING
			-- Any extra path information after the servlet name but before
			-- the query string translated to a real path.
		do
			if has_header (Path_translated_var) then
				Result := get_header (Path_translated_var)
			else
				Result := ""
			end
		end

	query_string: STRING
			-- The query string that is contained in the request URL after the path.
			-- Returns Void if no query string is sent.
		do
			if has_header (Query_string_var) then
				Result := get_header (Query_string_var)
			else
				Result := ""
			end
		end

	remote_user: STRING
			-- The login of the user making this request, if the user has been
			-- authenticated, or Void if the user has not been authenticated.
		do
			if has_header (Remote_user_var) then
				Result := get_header (Remote_user_var)
			else
				Result := ""
			end
		end

	servlet_path: STRING
			-- The part of this request's URL that calls the servlet. This includes
			-- either the servlet name or a path to the servlet, but does not include
			-- any extra path information or a query string.
		do
			if has_header (Script_name_var) then
				Result := get_header (Script_name_var)
			else
				Result := ""
			end
		end

	content: STRING
			-- Content data
		do
			debug ("CGI servlet request")
				print ("Content entered%N")
			end
			if has_header (Content_length_var) then
				debug ("CGI servlet request")
					print ("Found content length header%N")
				end
				if internal_content = Void then
					if content_length > 0 then
						debug ("CGI servlet request")
							print ("Content length > 0%N")
						end
						-- TODO: check for errors
						std.input.read_string (content_length)
						internal_content := std.input.last_string
						debug ("CGI servlet request")
							print ("Internal content is: " + internal_content + "%N")
						end
					else
						debug ("CGI servlet request")
							print ("No internal content 1%N")
						end
						internal_content := ""
					end
				end
			else
				debug ("CGI servlet request")
					print ("No internal content 2%N")
				end
				internal_content := ""
			end
			if internal_content /= Void then
				Result := internal_content
			else
				Result := ""
			end

		end

feature {CGI_SERVLET_REQUEST} -- Implementation

	internal_content: STRING
			-- Content read from stdin

	internal_response: GOA_CGI_SERVLET_RESPONSE
		-- Response object held so that session cookie can be set.

	session_id: STRING
		-- Id of session. Void until session is bound by first call to get_session.

	internal_cookies: DS_LINKED_LIST [GOA_COOKIE]
		-- Cached collection of request cookies

	parameters: DS_HASH_TABLE [DS_LINKED_LIST [STRING], STRING]
			-- Table of parameter values with support for multiple values per parameter name

feature {NONE} -- Implementation

	parse_parameters
			-- Parse the query string or stdin data for parameters and
			-- store in params structure.			
		local
			string_to_process: STRING
		do
			-- If the request is a GET then the parameters are stored in the query
			-- string. Otherwise, the parameters are in the stdin data.
			if method.is_equal ("GET") then
				string_to_process := clone (query_string)
			elseif method.is_equal ("POST") then
				debug ("CGI servlet request")
					print ("POST - parse content%N")
				end
				string_to_process := clone (content)
			else
				-- not sure where the parameters will be for other request methods.
				-- Need to experiment.
			end
			if string_to_process /= Void and then not string_to_process.is_empty then
				parse_parameter_string (string_to_process)
			end
		end

	parse_parameter_string (str: STRING)
			-- Parse the parameter string 'str' and build parameter structure.
			-- Parameters are of the form 'name=value' separated by '&' with all
			-- spaces and special characters encoded. An exception is an image map
			-- coordinate pair that is of the form 'value,value'. Any amount of
			-- whitespace may separate each token.
		require
			valid_str: str /= Void
		local
			e: INTEGER
			pair, name, value: STRING
			tokenizer: GOA_STRING_TOKENIZER
		do
			-- parameters can appear more than once. Add a parameter value for each instance.
			debug ("query_string_parsing")
				print (generator + ".parse_parameter_string str = " + quoted_eiffel_string_out (str) + "%R%N")
			end
			create tokenizer.make (str, "&")
			from
				tokenizer.start
			until
				tokenizer.off
			loop
				-- get the parameter pair token
				pair := tokenizer.item
				-- find equal character
				e := index_of_char (pair, '=', 1)
				if e > 0 then
					name := pair.substring (1, e - 1)
					value := pair.substring (e + 1, pair.count)
					-- add the parameter
					add_parameter (decode_url(name), decode_url(value))
				else
					-- TODO: check for a coordinate pair
				end
				tokenizer.forth
			end
		end

	add_parameter (name, value: STRING)
			-- Set decoded 'value' for the parameter 'name' to the parameters structure.
			-- Append to the list if the name already exists in the hashtable
		do
			debug ("query_string_parsing")
				print (generator + ".add_parameter name = "
					+ quoted_eiffel_string_out (name)
					+ " value = " + quoted_eiffel_string_out (value) + "%R%N")
			end
			if not parameters.has (name) then
				parameters.force (create {DS_LINKED_LIST [STRING]}.make, name)
			end
			parameters.item (name).put_last (value)
		end

	parse_cookie_header
			-- Parse the cookie header, if it exists and construct the 'internal_cookies'
			-- collection.
			-- This routine parsed the cookies using version 0 of the cookie spec (RFC 2109).
			-- See also http://www.netscape.com/newsref/std/cookie_spec.html
		local
			tokenizer: GOA_STRING_TOKENIZER
			comparator: GOA_COOKIE_NAME_EQUALITY_TESTER
			pair, name, value: STRING
			new_cookie: GOA_COOKIE
			i: INTEGER
		do
			-- not very efficient but we don't know if we will get any bogus cookies
			-- along the way
			create internal_cookies.make
			create comparator
			internal_cookies.set_equality_tester (comparator)
			if has_header (Http_cookie_var) then
				from
					create tokenizer.make (get_header (Http_cookie_var), ";")
					debug ("cookie_parsing")
						print (generator + ".parse_cookie_header str = "
							 + quoted_eiffel_string_out (get_header (Http_cookie_var)) + "%R%N")
					end
					tokenizer.start
				until
					tokenizer.off
				loop
					pair := tokenizer.item
					if pair.is_empty then
						i := 0
					else
						i := index_of_char (pair, '=', 1)
					end
					if i > 1 then
						name := pair.substring (1, i - 1)
						name.left_adjust
						name.right_adjust
						if i = pair.count then
							value := ""
						else
							value := pair.substring (i + 1, pair.count)
							value.left_adjust
							value.right_adjust
						end
						-- remove double quotes if they wrap the value
						if value.item (1) = '%"' then
							value := value.substring (2, value.count - 1)
						end
						if not tester.is_reserved_cookie_word (name) then
							create new_cookie.make (name, value)
						end
						debug ("cookie_parsing")
							print (generator + ".parse_cookie_header new_cookie = "
								+ quoted_eiffel_string_out (new_cookie.header_string) + "%R%N")
						end
						internal_cookies.force_last (new_cookie)
					else
						-- bad cookie, ignore it
					end
					tokenizer.forth
				end
			end
		end

	tester: GOA_COOKIE
			-- Used to test validity of values
		once
			create result.make ("test", "test")
		end



end -- class GOA_CGI_SERVLET_REQUEST

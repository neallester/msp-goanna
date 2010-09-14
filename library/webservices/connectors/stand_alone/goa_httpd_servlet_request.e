note
	description: "Objects that represent HTTPD servlet request information"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "tools httpd"
	date: "$Date: 2006-09-22 09:15:34 -0700 (Fri, 22 Sep 2006) $"
	revision: "$Revision: 511 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class GOA_HTTPD_SERVLET_REQUEST

inherit

	GOA_HTTP_SERVLET_REQUEST

	GOA_SHARED_HTTP_SESSION_MANAGER
		export
			{NONE} all
		end

	GOA_HTTP_UTILITY_FUNCTIONS
		export
			{NONE} all
		end

	GOA_HTTPD_CGI_HEADER_VARS
		export
			{NONE} all
		end

	GOA_STRING_MANIPULATION
		export
			{NONE} all
		end

create

	make

feature {NONE} -- Initialisation

	make (http_request: GOA_HTTPD_REQUEST; resp: GOA_HTTPD_SERVLET_RESPONSE)
			-- Create a new fast cgi servlet request wrapper for
			-- the request information contained in 'fcgi_request'
		require
			http_request_exists: http_request /= Void
			response_exists: resp /= Void
		do
			internal_request := http_request
			internal_response := resp
			create parameters.make (5)
			parse_parameters
		end

feature -- Access

	get_parameter (name: STRING): STRING
			-- Returns the value of a request parameter
		do
			Result := (parameters.item (name)).twin
		end

	get_parameter_names: DS_LINEAR [STRING]
			-- Return all parameter names
		local
			cursor: DS_HASH_TABLE_CURSOR [STRING, STRING]
			array_list: DS_ARRAYED_LIST [STRING]
		do
			create array_list.make (parameters.count)
			cursor := parameters.new_cursor
			from
				cursor.start
			until
				cursor.off
			loop
				array_list.force_last (cursor.key.twin)
				cursor.forth
			end
			Result := array_list
		end

	get_parameter_values: DS_LINEAR [STRING]
			-- Return all parameter values
		local
			cursor: DS_HASH_TABLE_CURSOR [STRING, STRING]
			array_list: DS_ARRAYED_LIST [STRING]
		do
			create array_list.make (parameters.count)
			cursor := parameters.new_cursor
			from
				cursor.start
			until
				cursor.off
			loop
				array_list.force_last (cursor.item.twin)
				cursor.forth
			end
			Result := array_list
		end

	get_header (name: STRING): STRING
			-- Get the value of the specified request header.
		do
			Result := (internal_request.parameter (name)).twin
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
			create tokenizer.make_default (get_header (name))
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
			cursor: DS_HASH_TABLE_CURSOR [STRING, STRING]
			array_list: DS_ARRAYED_LIST [STRING]
		do
			create array_list.make (internal_request.parameters.count)
			cursor := internal_request.parameters.new_cursor
			from
				cursor.start
			until
				cursor.off
			loop
				array_list.force_last (cursor.key.twin)
				cursor.forth
			end
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
			str := get_header (Content_length_var)
			if str.is_integer then
				Result := str.to_integer
			end
		end

	content_type: STRING
			-- The MIME type of the body of the request, or Void if the type is
			-- not known.
		do
			Result := get_header (Content_type_var)
		end

	protocol: STRING
			-- The name and version of the protocol the request uses in the form
			-- 'protocol/majorVersion.minorVersion', for example, HTTP/1.1.
		do
			Result := get_header (Server_protocol_var)
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
			Result := get_header (Server_name_var)
		end

	server_port: STRING
			-- The port number on which this request was received.
		do
			Result := get_header (Server_port_var)
		end

	remote_address: STRING
			-- The internet protocol (IP) address of the client that sent the request.
		do
			Result := get_header (Remote_addr_var)
		end

	remote_host: STRING
			-- The fully qualified name of the client that sent the request, or the
			-- IP address of the client if the name cannot be determined.
		do
			Result := get_header (Remote_host_var)
		end

	is_secure: BOOLEAN
			-- Was this request made using a secure channel, such as HTTPS?
		do
			Result := False
			-- TODO: may need to change this when we support https.
		end

	has_header (name: STRING): BOOLEAN
			-- Does this request contain a header named 'name'?
		do
			Result := internal_request.has_parameter (name)
		end

	auth_type: STRING
			-- The name of the authentication scheme used to protect the servlet,
			-- for example, "BASIC" or "SSL" or Void if the servlet was not protected.
		do
			Result := get_header (Auth_type_var)
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

	session: GOA_HTTP_SESSION
			-- Return the session associated with this request. Create a new session
			-- if one does not already exist.
		do
			if session_id = Void then
				Session_manager.bind_session (Current, internal_response)
				session_id := Session_manager.last_session_id
			end
			Result := Session_manager.get_session (session_id)
		end

	method: STRING
			-- The name of the HTTP method with which this request was made, for
			-- example, GET, POST, or HEAD.
		do
			Result := get_header (Request_method_var)
		end

	path_info: STRING
			-- Any extra path information associated with the URL the client sent
			-- when it made the request.
		do
			Result := get_header (Path_info_var)
		end

	path_translated: STRING
			-- Any extra path information after the servlet name but before
			-- the query string translated to a real path.
		do
			Result := get_header (Path_translated_var)
		end

	query_string: STRING
			-- The query string that is contained in the request URL after the path.
			-- Returns Void if no query string is sent.
		do
			Result := get_header (Query_string_var)
		end

	remote_user: STRING
			-- The login of the user making this request, if the user has been
			-- authenticated, or Void if the user has not been authenticated.
		do
			Result := get_header (Remote_user_var)
		end

	servlet_path: STRING
			-- The part of this request's URL that calls the servlet. This includes
			-- either the servlet name or a path to the servlet, but does not include
			-- any extra path information or a query string.
		do
			Result := get_header (Script_name_var)
		end

	content: STRING
			-- Content data
		do
			Result := internal_request.raw_stdin_content
		end

feature {NONE} -- Implementation

	internal_request: GOA_HTTPD_REQUEST
		-- Internal request information.

	internal_response: GOA_HTTPD_SERVLET_RESPONSE
		-- Response object held so that session cookie can be set.

	session_id: STRING
		-- Id of session. Void until session is bound by first call to get_session.

	internal_cookies: DS_LINKED_LIST [GOA_COOKIE]
		-- Cached collection of request cookies

	parameters: DS_HASH_TABLE [STRING, STRING]
			-- Table of parameter values with support for multiple values per parameter name

	Encoded_form_data_content_type: STRING = "application/x-www-form-urlencoded"
			-- Content type of form data passed in a POST request

	parse_parameters
			-- Parse the query string or stdin data for parameters and
			-- store in params structure.		
		do
			-- If the request is a GET then the parameters are stored in the query
			-- string. Otherwise, the parameters are in the stdin data.
			if method.is_equal ("GET") then
				parse_parameter_string (query_string)
			elseif method.is_equal ("POST") and content_type.substring_index (Encoded_form_data_content_type, 1) = 1 then
				parse_parameter_string (content)
			else
				-- not sure where the parameters will be for other request methods.
				-- Need to experiment.
			end
		end

	parse_parameter_string (str: STRING)
			-- Parse the parameter string 'str' and build parameter structure.
			-- Parameters are of the form 'name=value' separated by '&' with all
			-- spaces and special characters encoded. An exception is an image map
			-- coordinate pair that is of the form 'value,value'. Any amount of
			-- whitespace may separate each token.
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
					add_parameter (name, decode_url(value))
				else
					-- TODO: check for a coordinate pair
				end
				tokenizer.forth
			end
		end

	add_parameter (name, value: STRING)
			-- Set decoded 'value' for the parameter 'name' to the parameters structure.
			-- Replace any existing parameter value with the same name.
		do
			debug ("query_string_parsing")
				print (generator + ".add_parameter name = "
					+ quoted_eiffel_string_out (name)
					+ " value = " + quoted_eiffel_string_out (value) + "%R%N")
			end
			parameters.force (value, name)
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
					i := index_of_char (pair, '=', 1)
					if i > 0 then
						name := pair.substring (1, i - 1)
						name.left_adjust
						name.right_adjust
						value := pair.substring (i + 1, pair.count)
						value.left_adjust
						value.right_adjust
						-- remove double quotes if they wrap the value
						if value.item (1) = '%"' then
							value := value.substring (2, value.count - 1)
						end
						create new_cookie.make (name, value)
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

end -- class GOA_HTTPD_SERVLET_REQUEST

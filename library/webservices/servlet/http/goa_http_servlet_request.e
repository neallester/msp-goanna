note
	description: "Objects that represent HTTP request information."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "HTTP Servlet API"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

deferred class GOA_HTTP_SERVLET_REQUEST

inherit

	GOA_SERVLET_REQUEST
		redefine
			to_string
		end

feature -- Access

	get_header (name: STRING): STRING
			-- Get the value of the specified request header.
		require
			name_exists: name /= Void
			has_header: has_header (name)
		deferred
		ensure
			result_exists: Result /= Void
		end

	get_headers (name: STRING): DS_LINEAR [STRING]
			-- Get all values of the specified request header. If the
			-- header has comma-separated values they are separated and added to the
			-- result. If only one value exists, it is added as the sole entry in the
			-- list.
		require
			name_exists: name /= Void
			has_header: has_header (name)
		deferred
		ensure
			result_exists: Result /= Void
		end

	get_header_names: DS_LINEAR [STRING]
			-- Get all header names.
		deferred
		ensure
			result_exists: Result /= Void
		end

feature -- Set Session

	set_session (new_session: like session) is
		do
			session := new_session
		ensure
			session_updated: session = new_session
		end


feature -- Status report

	has_header (name: STRING): BOOLEAN
			-- Does this request contain a header named 'name'?
		require
			name_exists: name /= Void
		deferred
		end

	auth_type: STRING
			-- The name of the authentication scheme used to protect the servlet,
			-- for example, "BASIC" or "SSL" or Void if the servlet was not protected.
		deferred
		end

	cookies: DS_LINEAR [GOA_COOKIE]
			-- Cookies sent with this request.
		deferred
		ensure
			cookies_exist: Result /= Void
		end

	session: GOA_HTTP_SESSION

	method: STRING
			-- The name of the HTTP method with which this request was made, for
			-- example, GET, POST, or HEAD.
		deferred
		end

	path_info: STRING
			-- Any extra path information associated with the URL the client sent
			-- when it made the request.
		deferred
		end

	path_translated: STRING
			-- Any extra path information after the servlet name but before
			-- the query string translated to a real path.
		deferred
		end

	query_string: STRING
			-- The query string that is contained in the request URL after the path.
			-- Returns Void if no query string is sent.
		deferred
		end

	remote_user: STRING
			-- The login of the user making this request, if the user has been
			-- authenticated, or Void if the user has not been authenticated.
		deferred
		end

	servlet_path: STRING
			-- The part of this request's URL that calls the servlet. This includes
			-- either the servlet name or a path to the servlet, but does not include
			-- any extra path information or a query string.
		deferred
		end

feature -- Output

	to_string: STRING
			-- String representation of this request
		do
			Result := Precursor
--			Result.append_string ("auth_type: ")
--			Result.append_string (auth_type)
--			Result.append_string ("%R%N")
			Result.append_string ("method: ")
			Result.append_string (method)
			Result.append_string ("%R%N")
			Result.append_string ("path_info: ")
			Result.append_string (path_info)
			Result.append_string ("%R%N")
			Result.append_string ("path_translated: ")
			Result.append_string (path_translated)
			Result.append_string ("%R%N")
			Result.append_string ("query_string: ")
			Result.append_string (query_string)
			Result.append_string ("%R%N")
--			Result.append_string ("remote_user: ")
--			Result.append_string (remote_user)
--			Result.append_string ("%R%N")
			Result.append_string ("servlet_path: ")
			Result.append_string (servlet_path)
			Result.append_string ("%R%N")
		end

	cookies_to_string: STRING
		do
			Result := ""
			cookies.do_all (agent append_cookie_to_string (Result, ?))
		end

	append_cookie_to_string (a_string: STRING; a_cookie: GOA_COOKIE)
			-- Append string representation of a_cookie to a_string
		do
			a_string.append (a_cookie.name + " | " + a_cookie.value + "%N")
		end



end -- class GOA_HTTP_SERVLET_REQUEST

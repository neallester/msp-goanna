indexing
	description: "Objects that provide client request information to a servlet."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "Servlet API"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

deferred class GOA_SERVLET_REQUEST
		
feature -- Access
	
	get_parameter (name: STRING): STRING is
			-- Returns the value of a request parameter
		require
			name_exists: name /= Void
			named_parameter_exists: has_parameter (name)
		deferred
		ensure
			result_exists: Result /= Void
		end
	
	get_parameter_names: DS_LINEAR [STRING] is
			-- Return all parameter names
		deferred
		ensure
			result_exists: Result /= Void
		end
		
	get_parameter_values: DS_LINEAR [STRING] is
			-- Return all parameter values
		deferred
		ensure
			result_exists: Result /= Void
		end
		
feature -- Status report

	has_parameter (name: STRING): BOOLEAN is
			-- Does this request have a parameter named 'name'?
		require
			name_exists: name /= Void
		deferred
		end
	
	content_length: INTEGER is
			-- The length in bytes of the request body or -1 if the length is
			-- not known.
		deferred
		end
		
	content_type: STRING is
			-- The MIME type of the body of the request, or Void if the type is
			-- not known.
		deferred
		end
	
	protocol: STRING is
			-- The name and version of the protocol the request uses in the form
			-- 'protocol/majorVersion.minorVrsion', for example, HTTP/1.1.
		deferred
		end
	
	scheme: STRING is
			-- The name of the scheme used to make this request. Such as, http, https
			-- or ftp.
		deferred
		end
	
	server_name: STRING is
			-- The host name of the server that received the request.
		deferred
		end
	
	server_port: STRING is
			-- The port number on which this request was received.
		deferred
		end
	
	remote_address: STRING is
			-- The internet protocol (IP) address of the client that sent the request.
		deferred
		end
	
	remote_host: STRING is
			-- The fully qualified name of the client that sent the request, or the 
			-- IP address of the client if the name cannot be determined.
		deferred
		end
	
	is_secure: BOOLEAN is
			-- Was this request made using a secure channel, such as HTTPS?
		deferred
		end
	
	content: STRING is
			-- Content data
		deferred
		end

feature -- Output

	to_string: STRING is
			-- String representation of this request
		do
			create Result.make (100)
			Result.append_string ("Servlet Request: ")
			Result.append_string ("%R%N")
			Result.append_string ("protocol: ")
			Result.append_string (protocol)
			Result.append_string ("%R%N")
			Result.append_string ("scheme: ")
			Result.append_string (scheme)
			Result.append_string ("%R%N")
--			Result.append_string ("server_name: ")
--			Result.append_string (server_name)
--			Result.append_string ("%R%N")
			Result.append_string ("server_port: ")
			Result.append_string (server_port)
			Result.append_string ("%R%N")
			Result.append_string ("remote_address: ")
			Result.append_string (remote_address)
			Result.append_string ("%R%N")
			Result.append_string ("remote_host: ")
			Result.append_string (remote_host)
			Result.append_string ("%R%N")
			Result.append_string ("is_secure: ")
			Result.append_string (is_secure.out)
			Result.append_string ("%R%N")
--			Result.append_string ("content_type: ")
--			Result.append_string (content_type)
--			Result.append_string ("%R%N")
--			Result.append_string ("content_length: ")
--			Result.append_string (content_length.out)
--			Result.append_string ("%R%N")
			Result.append_string ("content: ")
			Result.append_string (content)
			Result.append_string ("%R%N")
		end

end -- class GOA_SERVLET_REQUEST

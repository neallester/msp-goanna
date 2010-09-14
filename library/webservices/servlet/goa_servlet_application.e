note
	description: "Abstract servlet application"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "Servlet API"
	date: "$Date: 2006-11-23 08:38:55 -0800 (Thu, 23 Nov 2006) $"
	revision: "$Revision: 518 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

deferred class GOA_SERVLET_APPLICATION

feature {NONE} -- Initialization

	make (new_host: STRING; port, backlog: INTEGER)
			-- Initialise the server to listen on 'port' with
			-- room for 'backlog' waiting requests. 	
		require
			valid_host: new_host /= Void
				-- Host should be "localhost" (to listen only to domain sockets)
				-- or IP address of local host to listen for network requests for that IP address
				-- Don't know if host name will work or not
			valid_port: port >= 0
			valid_backlog: backlog >= 0
		deferred
		end

feature -- Basic operations

	register_servlets
			-- Register servlets for this application
		deferred
		ensure
			all_servlets_registered: all_servlets_registered
		end

	run
			-- Run the application and process requests
		require
			ok_to_run: ok_to_run
		deferred
		end

	ok_to_run: BOOLEAN
			-- Application in a state in which run may be called
			-- May be redefined by descendents as necessary
		do
			Result := all_servlets_registered
		ensure
			result_implies_all_servlets_registered: Result implies all_servlets_registered
		end

	all_servlets_registered: BOOLEAN
			-- Have all required servlets been registered
			-- May be redefined by descendents as necessary
		do
			Result := True
		end

end -- class GOA_SERVLET_APPLICATION

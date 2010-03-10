indexing
	description: "Singleton access for a HTTP_SESSION_MANAGER"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "HTTP Servlet API"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class GOA_SHARED_HTTP_SESSION_MANAGER

feature -- Access

	Session_manager: GOA_HTTP_SESSION_MANAGER is
			-- Singleton access to a session manager
		once
			create Result.make
		end
	
end -- class GOA_SHARED_HTTP_SESSION_MANAGER

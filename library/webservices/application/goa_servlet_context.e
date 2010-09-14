note
	description: "Servlet context scope"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "Servlet API"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

deferred class GOA_SERVLET_CONTEXT
	
feature -- Access

	manager: GOA_SERVLET_MANAGER
			-- Servlet manager
		deferred
		end

	processor: GOA_REQUEST_PROCESSOR
			-- Request processor
		deferred
		end
	
end -- class GOA_SERVLET_CONTEXT

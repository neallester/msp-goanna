indexing
	description: "Singleton servlet manager accessor."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "tools httpd"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class GOA_SHARED_SERVLET_MANAGER 

feature -- Access

	servlet_manager: GOA_SERVLET_MANAGER [GOA_HTTP_SERVLET] is
			-- Access singleton servlet manager
		once
			create Result.make
		end
		
end -- class GOA_SHARED_SERVLET_MANAGER

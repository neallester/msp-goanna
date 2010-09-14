note
	description: "Singleton Access to Application Session Manager"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/05/15"
	revision: "$Revision: 491 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	SHARED_APPLICATION_SESSION_MANAGER

feature -- Access

	session_manager : APPLICATION_SESSION_MANAGER
		-- Singleton access to session manager
		once
			create result.make
		end

end -- class SHARED_APPLICATION_SESSION_MANAGER

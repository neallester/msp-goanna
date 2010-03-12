indexing
	description: "Shared Access to Servlets"
	author: "Neal L. Lester <neallester@users.sourceforge.net>"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	copyright: "(c) 2005 Neal L. Lester and others"
	License: "Eiffel Forum License Version 2 (see forum.txt)"

class
	SHARED_SERVLETS

inherit

	GOA_SHARED_SERVLETS
		redefine
			shut_down_server_servlet
		end

feature -- Servlets

	shut_down_server_servlet: GOA_SHUT_DOWN_SERVER_SERVLET_MULTI_THREADED is
		once
			create Result.make
		end



end -- class SHARED_SERVLETS

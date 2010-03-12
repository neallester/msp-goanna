indexing
	description: "Shared access to goa servlets; SHARED_SERVLETS should inherit from this class"
	author: "Neal L. Lester <neallester@users.sourceforge.net>"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	copyright: "(c) 2005 Neal L. Lester and others"
	License: "Eiffel Forum License Version 2 (see forum.txt)"

class
	GOA_SHARED_SERVLETS

feature -- Servlets

	go_to_servlet: GOA_GO_TO_SERVLET is
			-- Servlet that allows direct hyperlinking to another MSP_DISPLAYABLE_SERVLET
		once
			create Result.make
		end

	secure_redirection_servlet: GOA_SECURE_REDIRECTION_SERVLET is
			-- Servlet used to redirect user to a secure page
		once
			create Result.make
		end

	shut_down_server_servlet: GOA_SHUT_DOWN_SERVER_SERVLET is
			-- Servlet used to shut down the server
		once
			create Result.make
		end

	ping_servlet: GOA_PING_SERVLET is
		once
			create Result.make
		end


feature {NONE} -- Registration

	servlet_by_name: DS_HASH_TABLE [GOA_APPLICATION_SERVLET, STRING] is
			-- Servlets registered by name without extension
		once
			create Result.make_equal (30)
		end

end -- class GOA_SHARED_SERVLETS

note
	description: "Objects that run within a web server. Servlets receive and respond to requests from Web clients. "
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "Servlet API"
	date: "$Date: 2006-11-23 08:38:55 -0800 (Thu, 23 Nov 2006) $"
	revision: "$Revision: 518 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

deferred class GOA_SERVLET

inherit

	GOA_HTTP_STATUS_CODES
		export
			{NONE} all
		end

feature -- Initialization

	init (config: GOA_SERVLET_CONFIG)
			-- Called by the servlet manager to indicate that the servlet is being placed
			-- into service. The servlet manager calls 'init' exactly once after instantiating
			-- the object. The 'init' method must complete successfully before the servlet can
			-- receive any requests.
		require
			config_exists: config /= Void
		deferred
		end

feature -- Access

	servlet_config: GOA_SERVLET_CONFIG
			-- The servlet configuration object which contains initialization and startup
			-- parameters for this servlet.

	servlet_info: STRING
			-- Information about the servlet, such as, author, version and copyright.

feature -- Basic operations

	service (req: GOA_SERVLET_REQUEST; resp: GOA_SERVLET_RESPONSE)
			-- Called by the servlet manager to allow the servlet to
			-- respond to a request.
		require
			request_exists: req /= Void
			response_exists: resp /= Void
		deferred
		end

	destroy
			-- Called by the servlet manager to indicate that the servlet
			-- is being taken out of service. The servlet can then clean
			-- up any resources that are being held.
			-- be aware that if the server crashes, this command maz not be called
			-- it is therefore not recomended to relay on this command to store important data
		deferred
		end

invariant
	configured: servlet_config /= Void
	servlet_info_exists: servlet_info /= Void

end -- class GOA_SERVLET

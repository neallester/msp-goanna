note
	description: "Objects that represent a CGI servlet application"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "CGI servlets"
	date: "$Date: 2006-10-02 15:49:12 -0700 (Mon, 02 Oct 2006) $"
	revision: "$Revision: 515 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

deferred class GOA_CGI_SERVLET_APP

inherit
	
	GOA_SERVLET_APPLICATION
		rename
			make as servlet_app_make
		end
	
	GOA_SHARED_SERVLET_MANAGER
		export
			{NONE} all
		end

	GOA_HTTP_STATUS_CODES
		export
			{NONE} all
		end
		
	L4E_SHARED_HIERARCHY
		export
			{NONE} all
		end

	GOA_CGI_VARIABLES
		export
			{NONE} all
		end
		
	KL_SHARED_EXECUTION_ENVIRONMENT
		export
			{NONE} all
		end
		
feature -- Initialisation

	make
			-- Process the request and exit
		do
			initialise_logger
			register_servlets
			run
		end
	
feature -- Basic operations
		
	run
			-- Process a request.
		local
			req: GOA_CGI_SERVLET_REQUEST
			resp: GOA_CGI_SERVLET_RESPONSE
			path: STRING
		do
			create resp.make
			create req.make (resp)	
			-- dispatch to the registered servlet using the path info as the registration name.
			if req.has_header (Path_info_var) then
				path := req.get_header (Path_info_var)
				if path /= Void then
					-- remove leading slash from path
					path.keep_tail (path.count - 1)
				end
			end			
			if path /= Void then
				info (Servlet_app_log_category, "Servicing request: " + path)
				if servlet_manager.has_registered_servlet (path) then
					servlet_manager.servlet (path).service (req, resp)
				elseif servlet_manager.has_default_servlet then
					servlet_manager.default_servlet.service (req, resp)
				else
					handle_missing_servlet (resp)
					error (Servlet_app_log_category, "Servlet not found for URI " + path)
				end
			else
				handle_missing_servlet (resp)
				error (Servlet_app_log_category, "Request URI not specified")
			end	
		end
		
feature {NONE} -- Implementation
	
	Servlet_app_log_category: STRING = "servlet.app"
	
	initialise_logger
			-- Set logger appenders
		local
			appender: L4E_APPENDER
			layout: L4E_LAYOUT
		do
			create {L4E_FILE_APPENDER} appender.make ("log.txt", True)
			create {L4E_PATTERN_LAYOUT} layout.make ("@d [@-6p] @c - @m%N")
			appender.set_layout (layout)
			log_hierarchy.logger (Servlet_app_log_category).add_appender (appender)
		end
		
	handle_missing_servlet (resp: GOA_CGI_SERVLET_RESPONSE)
			-- Send error page indicating missing servlet
		require
			resp_exists: resp /= Void
		do
			resp.send_error (Sc_not_found)
		end

	servlet_app_make (new_host: STRING; port, backlog: INTEGER)
			-- Not used in a CGI app 	
		do
		end
		
end -- class GOA_CGI_SERVLET_APP

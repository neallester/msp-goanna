indexing
	description: "HTTP Server."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "tools httpd"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class	CGI

inherit

	GOA_CGI_SERVLET_APP
		redefine
			initialise_logger
		end

	KL_SHARED_ARGUMENTS
		export
			{NONE} all
		end
		
creation

	make
				
feature {NONE} -- Implementation

	config: GOA_SERVLET_CONFIG
			-- Configuration for servlets
	
	register_servlets is
			-- Initialise servlets
		local
			servlet: GOA_HTTP_SERVLET	
			doc_root: STRING
		do
			-- set document root from environment variable DOCUMENT_ROOT which is normally
			-- set by Apache. Set it manually if not using Apache.
			create config
			doc_root := Execution_environment.variable_value (Document_root_var)
			if doc_root /= Void then
				config.set_document_root (doc_root)		
			end
			-- register servlets
			servlet_manager.set_servlet_mapping_prefix ("servlet")
			servlet_manager.set_config (config)
			create {GOA_FILE_SERVLET} servlet.init (config)
			servlet_manager.register_servlet (servlet, "file")
			servlet_manager.register_default_servlet (servlet)
			create {GOA_SNOOP_SERVLET} servlet.init (config)
			servlet_manager.register_servlet (servlet, "snoop")
		end

	initialise_logger is
			-- Set logger appenders
		local
			appender: L4E_APPENDER
			layout: L4E_LAYOUT
		do
			create {L4E_STDERR_APPENDER} appender.make ("CGItest")
			create {L4E_PATTERN_LAYOUT} layout.make ("@d [@-6p] @c - @m%N")
			appender.set_layout (layout)
			log_hierarchy.logger (Servlet_app_log_category).add_appender (appender)
		end

end -- class CGI

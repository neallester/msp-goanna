note
	description: "Applications that run as FastCGI Servlets"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/05/10"
	revision: "$Revision: 513 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	APPLICATION

inherit
	SYSTEM_CONSTANTS
	GOA_FAST_CGI_SERVLET_APP
		rename
			make as parent_make
		end
--	GOA_HTTPD_SERVLET_APP
--		rename
--			make as parent_make
--		end

create

	make

feature

	make
		local

		do
			io.putstring ("Starting Application " + application_directory + "...%N")
			parent_make ("localhost", port, backlog_requests)
			register_servlets
			run
		end

	register_servlets
		local
			application_config: GOA_SERVLET_CONFIG
			application_servlet: APPLICATION_SERVLET
		do
			create application_config
			application_config.set_server_port (port)
			application_config.set_document_root (document_root)
			servlet_manager.set_config (application_config)
			create application_servlet.init (application_config)
			servlet_manager.register_servlet (application_servlet, application_directory)
			servlet_manager.register_default_servlet (application_servlet)	
		end
		
	field_exception: BOOLEAN
			-- 
		do
			Result := False
		end
		

end -- class APPLICATION

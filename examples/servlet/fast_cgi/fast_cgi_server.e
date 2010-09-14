note
	description: "FastCGI Server."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "examples Fast CGI server"
	date: "$Date: 2006-10-01 13:33:03 -0700 (Sun, 01 Oct 2006) $"
	revision: "$Revision: 513 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class
	FAST_CGI_SERVER

inherit

	GOA_FAST_CGI_SERVLET_APP
		rename
			make as parent_make
		end
		
	KL_SHARED_ARGUMENTS
		export
			{NONE} all
		end
	
create

	make

feature -- Initialization

	make
			-- Create and initialise a new FAST_CGI server that will listen for connections
			-- on 'port' and serving documents from 'doc_root'.
			-- Start the server
		do
			create config
			parse_arguments
			if argument_error then
				print_usage
			else
				config.set_server_port (port)
				parent_make ("local_host", port, 10)
				register_servlets
				run
			end
		end

feature -- Status report

	port: INTEGER
			-- Server connection port
				
feature {NONE} -- Implementation

	argument_error: BOOLEAN
			-- Did an error occur parsing arguments?

	config: GOA_SERVLET_CONFIG
			-- Configuration for servlets
			
	parse_arguments
			-- Parse the command line arguments and store appropriate settings
		local
			dir: KL_DIRECTORY
		do
			if Arguments.argument_count < 2 then
				argument_error := True
			else
				-- parse port
				if Arguments.argument(1).is_integer then
					port := Arguments.argument(1).to_integer
					-- parse document root
					create dir.make (Arguments.argument (2))
					dir.open_read
					if dir.is_open_read then
						config.set_document_root (dir.name)
					else
						argument_error := True
					end
				else
					argument_error := True
				end
			end
		end

	print_usage
			-- Display usage information
		do
			print ("Usage: fast_cgi <port-number> <document-root>%R%N")
		end
	
	register_servlets
			-- Initialise servlets
		local
			servlet: GOA_HTTP_SERVLET
			file_servlet: GOA_FILE_SERVLET	
		do
			-- register servlets
			servlet_manager.set_servlet_mapping_prefix ("servlet")
			servlet_manager.set_config (config)
			create file_servlet.init (config)
			file_servlet.set_name (servlet_manager.servlet_mapping_prefix + "file")
			servlet_manager.register_servlet (file_servlet, "file")
			servlet_manager.register_default_servlet (file_servlet)
			create {GOA_SNOOP_SERVLET} servlet.init (config)
			servlet_manager.register_servlet (servlet, "snoop")
		end

	field_exception: BOOLEAN
			-- Should we attempt to retry?
		do
		end
			
end -- class FAST_CGI_SERVER

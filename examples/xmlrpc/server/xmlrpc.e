note
	description: "XMLRPC Example Server."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "examples xmlrpc"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class XMLRPC

inherit 

	GOA_HTTPD_SERVLET_APP
		rename 
			make as parent_make
		end
		
	KL_SHARED_ARGUMENTS
		export 
			{NONE} all 
		end
		
	GOA_SHARED_SERVICE_REGISTRY
		export 
			{NONE} all 
		end
		
	GOA_XRPC_CONSTANTS
		export 
			{NONE} all 
		end
   
create {ANY} 

	make

feature {ANY} -- Initialization

	make 
			-- Create and initialise a new HTTP server that will listen for connections
			-- on 'port' and serving documents from 'doc_root'.
			-- Start the server
		do  
			create config
			parse_arguments
			if argument_error then 
				print_usage
			else 
				config.set_server_port (port)
				parent_make (port, 10)
				register_servlets
				init_xmlrpc
				run
			end
		end

feature {ANY} -- Status report

	port: INTEGER
			-- Server connection port
   
feature {NONE} -- Implementation

	argument_error: BOOLEAN;
			-- Did an error occur parsing arguments?
   
	config: GOA_SERVLET_CONFIG;
			-- Configuration for servlets
   
	parse_arguments 
			-- Parse the command line arguments and store appropriate settings
		local 
			dir: KL_DIRECTORY;
		do  
			if Arguments.argument_count < 2 then 
				argument_error := true
			else 
				-- parse port
				if Arguments.argument (1).is_integer then 
					port := Arguments.argument (1).to_integer
					create dir.make (Arguments.argument (2))
					dir.open_read
					if dir.is_open_read then 
						config.set_document_root (dir.name)
					else 
						argument_error := true
					end
				else 
					argument_error := true
				end
			end
		end
   
	print_usage 
			-- Display usage information
		do  
			print("Usage: xmlrpc <port-number> <document-root>%R%N")
		end
   
	register_servlets 
			-- Initialise servlets
		local 
			servlet: GOA_HTTP_SERVLET;
		do  
			log_hierarchy.logger (Xmlrpc_category).info ("Registering servlets")
			servlet_manager.set_servlet_mapping_prefix ("servlet")
			servlet_manager.set_config (config)
			create {GOA_XMLRPC_SERVLET} servlet.init (config)
			servlet_manager.register_servlet (servlet, "xmlrpc")
			servlet_manager.register_default_servlet (servlet)
		end
   
	init_xmlrpc 
			-- Initialise XML RPC calls
		local 
			system_services: GOA_XRPC_SYSTEM;
			addresses: ADDRESS_REGISTER;
			test: TEST;
			validator: VALIDATOR1;
			calculator: CALCULATOR;
			date_time: CURRENT_DATE_TIME
			calculator_service: CALCULATOR_SERVICE_PROXY
		do  
			log_hierarchy.logger (Xmlrpc_category).info ("Registering XML-RPC web services")
			create system_services.makE
			registry.register (system_services,"system")
			create test.make
			registry.register (test,"test")
				-- VALIDATOR1 is a self registering service
			create validator.make
			registry.register (validator, "validator1")
				-- ADDRESS_REGISTER is a self registering service
			create addresses.make
			registry.register (addresses, "addressbook")
				-- CURRENT_DATE_TIME is a self registering service
			create date_time.make
			registry.register (date_time, "currentTime")
				-- CALCULATOR needs to be registered manually
			create calculator
			create calculator_service.make
			calculator_service.register (agent calculator.times, "times")
			calculator_service.register (agent calculator.divide, "divide")
			calculator_service.register (agent calculator.minus, "minus")
			calculator_service.register (agent calculator.plus, "plus")
			registry.register (calculator_service, "calc")
		end

end -- class XMLRPC

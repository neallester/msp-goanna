indexing
	description: "SOAP Example Server."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "tools httpd"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	SOAP

inherit

	HTTPD_SERVLET_APP
		rename
			make as parent_make
		end
		
	KL_SHARED_ARGUMENTS
		export
			{NONE} all
		end
	
	
	SHARED_SERVICE_REGISTRY
		export
			{NONE} all
		end
		
creation
	make

feature -- Initialization

	make is
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
				init_soap
				run
			end
		end

feature -- Status report

	port: INTEGER
			-- Server connection port
				
feature {NONE} -- Implementation

	argument_error: BOOLEAN
			-- Did an error occur parsing arguments?

	config: SERVLET_CONFIG
			-- Configuration for servlets
			
	parse_arguments is
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

	print_usage is
			-- Display usage information
		do
			print ("Usage: httpd <port-number> <document-root>%R%N")
		end
	
	register_servlets is
			-- Initialise servlets
		local
			servlet: HTTP_SERVLET	
		do
			servlet_manager.set_servlet_mapping_prefix ("servlet")
			servlet_manager.set_config (config)
			create {FILE_SERVLET} servlet.init (config)
			servlet_manager.register_servlet (servlet, "file")
			servlet_manager.register_default_servlet (servlet)
			create {SOAP_SERVLET} servlet.init (config)
			servlet_manager.register_servlet (servlet, "soap")
		end
		
	init_soap is
			-- Initialise SOAP RPC calls
		local
			account_service, address_service, calculator_service, test_service: SERVICE_PROXY
			addresses: ADDRESS_REGISTER
			calculator: CALCULATOR
			test: TEST_SOAP
			test_interop: TEST_SOAP_INTEROP
		do
			create addresses.make
			create address_service.make
			address_service.register (addresses~get_address_from_name (?), "getAddressFromName")
			registry.register (address_service, "urn:AddressFetcher")
			create calculator
			create calculator_service.make
			calculator_service.register (calculator~times (?, ?), "times")
			calculator_service.register (calculator~divide (?, ?), "divide")
			calculator_service.register (calculator~minus (?, ?), "minus")
			calculator_service.register (calculator~plus(?, ?), "plus")
			registry.register (calculator_service, "urn:xml-soap-demo-calculator")
			create test_service.make
			create test
			test_service.register (test~test_boolean (?), "testBoolean")
			test_service.register (test~test_decimal (?), "testDecimal")
			test_service.register (test~test_float (?), "testFloat")
			test_service.register (test~test_double (?), "testDouble")
			test_service.register (test~test_string (?), "testString")
			registry.register (test_service, "urn:testSOAP")
			create test_interop.make
			registry.register (test_interop, "http://soapinterop.org/")
		end

end -- class SOAP

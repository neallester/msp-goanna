indexing
	description: "XMLRPC Example Current Time retrieval for the %
		%server (http://time.xmlrpc.com/RPC2)."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "examples xmlrpc currenttime"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	CURRENT_TIME

inherit
		
	KL_SHARED_ARGUMENTS
		export
			{NONE} all
		undefine
			copy, default_create
		end
	
	EV_APPLICATION
	
	XRPC_CONSTANTS
		export
			{NONE} all
		undefine
			copy, default_create
		end
		
creation

	start

feature -- Initialization

	start is
			-- Create the application, set up `main_window'
			-- and then launch the application.
		do
			parse_arguments
			if argument_error then
				print_usage
			else
				create client.make (host, port, "/RPC2")
				default_create
				create main_window.make (Current)
				main_window.show
				launch
			end
		end
			
feature -- Basic routines

	retrieve_time is
			-- Retrieve current time
		local
			call: XRPC_CALL
			date: DT_DATE_TIME
		do
			create call.make_from_string ("currentTime.getCurrentTime")
			client.invoke (call)
			if client.invocation_ok then		
				date ?= client.response.value.value.as_object
				if date /= Void then
					main_window.update_time (date)
					main_window.update_error_message ("Time retrieved.")
				end
			else
				main_window.update_error_message ("Fault received: (" + client.fault.code.out + ") " + client.fault.string)	
			end	
		end
		
feature {NONE} -- Implementation
	
	client: XRPC_LITE_CLIENT
			-- XML-RPC client
		
	main_window: MAIN_WINDOW
			-- Time window.

	host: STRING
			-- Connect host
			
	port: INTEGER
			-- Connect port
			
	argument_error: BOOLEAN
			-- Did an error occur parsing arguments?
			
	parse_arguments is
			-- Parse the command line arguments and store appropriate settings
		do
			if Arguments.argument_count < 2 then
				argument_error := True
			else
				-- parse host
				host := Arguments.argument (1)
				-- parse port
				if Arguments.argument (2).is_integer then
					port := Arguments.argument (2).to_integer
				else
					argument_error := True
				end
			end
		end

	print_usage is
			-- Display usage information
		do
			print ("Usage: currenttime <host> <port-number>%R%N")
			print ("       eg. currenttime time.xmlrpc.com 80%R%N")
		end

	update_error_message (message: STRING) is
			-- Update error message in main window
		require
			message_exists: message /= Void
		do
			main_window.update_error_message (message)
		end
		
end -- class CURRENT_TIME

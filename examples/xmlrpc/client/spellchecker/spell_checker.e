note
	description: "XMLRPC Example Spell Checker client that uses the StuffedDog spell checker %
		%server (http://www.stuffeddog.com/speller/doc/rpc.html)."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "examples xmlrpc spellchecker"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	SPELL_CHECKER

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
		
create

	start

feature -- Initialization

	start
			-- Create the application, set up `main_window'
			-- and then launch the application.
		do
			parse_arguments
			if argument_error then
				print_usage
			else
				create client.make (host, port, "/speller/speller-rpc.cgi")
				default_create
				create main_window.make (Current)
				main_window.show
				launch
			end
		end
			
feature -- Basic routines

	check_spelling
			-- Check spelling of entered text.
		local
			call: XRPC_CALL
			param: XRPC_PARAM
			options: DS_HASH_TABLE [ANY, STRING]
			value: STRING
		do
			create call.make_from_string ("speller.spellCheck")
			create param.make (Value_factory.build (main_window.text.text))		
			call.add_param (param)
			create options.make (0)
			create param.make (Value_factory.build (options))
			call.add_param (param)
			client.invoke (call)
			if client.invocation_ok then		
				value ?= client.response.value.value.as_object
				if value /= Void then
					-- spelling ok
					main_window.update_error_message ("Spelling ok.")			
				else	
					main_window.update_error_message ("Spelling errors found.")
				end
			else
				main_window.update_error_message ("Fault received: (" + client.fault.code.out + ") " + client.fault.string)	
			end	
		end
		
feature {NONE} -- Implementation
	
	client: XRPC_LITE_CLIENT
			-- XML-RPC client
		
	main_window: MAIN_WINDOW
			-- Calculator window.

	host: STRING
			-- Connect host
			
	port: INTEGER
			-- Connect port
			
	argument_error: BOOLEAN
			-- Did an error occur parsing arguments?
			
	parse_arguments
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

	print_usage
			-- Display usage information
		do
			print ("Usage: spellchecker <host> <port-number>%N")
			print ("       eg. spellchecker www.stuffeddog.com 80%N")
		end

	update_error_message (message: STRING)
			-- Update error message in main window
		require
			message_exists: message /= Void
		do
			main_window.update_error_message (message)
		end
		
end -- class SPELL_CHECKER

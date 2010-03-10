indexing
	description: "XMLRPC Example Address Book Client."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "examples xmlrpc addressbook"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	ADDRESS_BOOK

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
				create client.make (host, port, "/servlet/xmlrpc")
				default_create
				create main_window.make (Current)
				refresh
				main_window.show
				launch
			end
		end
			
feature -- Basic routines

	add is
			-- Add new name and address to address book
		local
			call: XRPC_CALL
			v: XRPC_SCALAR_VALUE
			p: XRPC_PARAM
		do
			if not exists then
				create call.make_from_string ("addressbook.addEntry")
		
				-- add name param
				create v.make (main_window.names.text)
				create p.make (v)
				call.add_param (p)
				
				-- add address param
				create v.make (main_window.address.text)
				create p.make (v)
				call.add_param (p)
				
				-- invoke
				client.invoke (call)
				if client.invocation_ok then
					refresh
				else
					main_window.update_error_message ("Fault received: (" + client.fault.code.out + ") " + client.fault.string)	
				end	
			else
				main_window.update_error_message ("Address already exists.")	
			end				
		end
	
	exists: BOOLEAN is
			-- Check if selected name already exists in address book
		local
			call: XRPC_CALL
			v: XRPC_SCALAR_VALUE
			p: XRPC_PARAM
			ref: BOOLEAN_REF
		do
			create call.make_from_string ("addressbook.hasEntry")
	
			-- add name param
			create v.make (main_window.names.text)
			create p.make (v)
			call.add_param (p)

			-- invoke
			client.invoke (call)
			if client.invocation_ok then
				ref ?= client.response.value.value.as_object
				check
					boolean_result: ref /= Void
				end
				Result := ref.item
			else
				main_window.update_error_message ("Fault received: (" + client.fault.code.out + ") " + client.fault.string)
				Result := False
			end	
		end
		
	remove is
			-- Remove name (and its address) from address book.
			-- NOTE: This will fail if an attempt is made to remove a name
			-- that doesn't exist. Used to demonstrate assertion faults.
		local
			call: XRPC_CALL
			v: XRPC_SCALAR_VALUE
			p: XRPC_PARAM
		do
			create call.make_from_string ("addressbook.removeEntry")
	
			-- add name param
			create v.make (main_window.names.text)
			create p.make (v)
			call.add_param (p)
			
			-- invoke
			client.invoke (call)
			if client.invocation_ok then	
				refresh
			else
				main_window.update_error_message ("Fault received: (" + client.fault.code.out + ") " + client.fault.string)	
			end	
		end	
		
	get is
			-- Get address for selected name
		local
			call: XRPC_CALL
			v: XRPC_SCALAR_VALUE
			p: XRPC_PARAM
			str: STRING
		do
			if not refreshing then
				create call.make_from_string ("addressbook.getEntry")		
				-- add name param
				create v.make (main_window.names.text)
				create p.make (v)
				call.add_param (p)				
				-- invoke
				client.invoke (call)
				if client.invocation_ok then
					str ?= client.response.value.value.as_object
					check
						string_address: str /= Void
					end
					main_window.update_address (str)
					main_window.update_error_message ("Address retrieved.")
				else
					main_window.update_error_message ("Fault received: (" + client.fault.code.out + ") " + client.fault.string)	
				end						
			end
		end	
		
	refresh is
			-- Collect all names and refresh UI
		local
			call: XRPC_CALL
			names: ARRAY [ANY]
		do
			refreshing := True
			create call.make_from_string ("addressbook.getNames")
			client.invoke (call)
			if client.invocation_ok then		
				names ?= client.response.value.value.as_object
				check 
					array_value: names /= Void 
				end
				main_window.update_names (names)
				main_window.update_error_message ("Addresses updated.")
			else
				-- handle empty array faults
				if client.fault.code = Array_contains_no_values then
					main_window.update_error_message ("No addresses found.")
				else
					main_window.update_error_message ("Fault received: (" + client.fault.code.out + ") " + client.fault.string)	
				end
			end	
			refreshing := False
		end
		
feature {NONE} -- Implementation
	
	refreshing: BOOLEAN
			-- Is the list currently being refreshed. This is used to
			-- stop callbacks from performing remote calls when new items
			-- are added to the names combo box.
			
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
			print ("Usage: addressbook <host> <port-number>%R%N")
		end

	update_error_message (message: STRING) is
			-- Update error message in main window
		require
			message_exists: message /= Void
		do
			main_window.update_error_message (message)
		end
		
end -- class ADDRESS_BOOK

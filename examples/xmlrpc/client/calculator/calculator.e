indexing
	description: "XMLRPC Example Calculator Client."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "examples xmlrpc calculator"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	CALCULATOR

inherit
		
	KL_SHARED_ARGUMENTS
		export
			{NONE} all
		undefine
			copy, default_create
		end
	
	EV_APPLICATION
		
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
				main_window.show
				launch
			end
		end

feature -- Status report

	value: DOUBLE
			-- Current calculator value
	
	display_value: DOUBLE
			-- Current displayed value
	
	next_operation: STRING
			-- Remote method name of operation to perform
			
	point_pressed: BOOLEAN
			-- Should the point digit be added?
			
feature -- Calculation routines

	one is
			-- Add digit '1' to display value
		do
			add_digit ('1')
		end

	two is
			-- Add digit '2' to display value
		do
			add_digit ('2')			
		end

	three is
			-- Add digit '3' to display value
		do
			add_digit ('3')			
		end

	four is
			-- Add digit '4' to display value
		do
			add_digit ('4')			
		end

	five is
			-- Add digit '5' to display value
		do
			add_digit ('5')			
		end

	six is
			-- Add digit '6' to display value
		do
			add_digit ('6')			
		end
	
	seven is
			-- Add digit '7' to display value
		do
			add_digit ('7')
		end

	eight is
			-- Add digit '8' to display value
		do
			add_digit ('8')			
		end

	nine is
			-- Add digit '9' to display value
		do
			add_digit ('9')			
		end

	zero is
			-- Add digit '0' to display value
		do
			add_digit ('0')			
		end

	decimal is
			-- Add a decimal point to the display value.
		do
			point_pressed := True			
		end
		
	add is
			-- Perform last operation and store 'add' as next operation
		do
			perform_operation
			next_operation := Add_op
		end

	subtract is
			-- Perform last operation and store 'subtract' as next operation
		do
			perform_operation
			next_operation := Subtract_op
		end	
		
	multiply is
			-- Perform last operation and store 'multiply' as next operation
		do
			perform_operation
			next_operation := Multiply_op
		end
	
	divide is
			-- Perform last operation and store 'divide' as next operation
		do
			perform_operation
			next_operation := Divide_op
		end	
	
	equals is
			-- Perform last operation.
		do
			perform_operation
			display_value := value
			next_operation := Void
		end
	
	clear is
			-- Clear current display value
		do
			display_value := 0.0
			update_display_value
		end
		
	all_clear is
			-- Clear display value and current value
		do
			value := 0.0
			next_operation := Void
			clear
		end

feature {NONE} -- Implementation

	Subtract_op: STRING is "calc.minus"
	
	Multiply_op: STRING is "calc.times"
	
	Divide_op: STRING is "calc.divide"
	
	Add_op: STRING is "calc.plus"

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
			print ("Usage: calculator <host> <port-number>%R%N")
		end

	client: XRPC_LITE_CLIENT
			-- XML-RPC client
	
	add_digit (digit: CHARACTER) is
			-- Add 'digit' to the current display value. If the addition constitutes
			-- a valid double then set it, otherwise ignore the request.
		local
			str: STRING
		do
			str := display_value.out
			if point_pressed then
				str.append_character ('.')
			end
			str.append_character (digit)
			if str.is_double then
				point_pressed := False
				display_value := str.to_double
			end
			debug ("calculator")
				print ("add_digit (" + digit.out + "): " + str + " display_value=" + display_value.out + "%N")
			end
			update_display_value
			update_error_message (" ")
		end
		
	perform_operation is
			-- Create XRPC call and execute it.
		local
			call: XRPC_CALL
			v: XRPC_SCALAR_VALUE
			p: XRPC_PARAM
			double_ref: DOUBLE_REF
		do
			debug ("calculator")
				print ("Calculator status:%N")
				print ("%Tvalue=" + value.out + "%N")
				print ("%Tdisplay_value=" + display_value.out + "%N")
				print ("%Tnext_operation=")
				if next_operation = Void then
					print ("Void")
				else
					print (next_operation)
				end
				print ("%N")
			end
			if next_operation /= Void then
				-- use 'last_operation' as the method name
				create call.make_from_string (next_operation)
		
				-- create parameter with 'value'
				create v.make (value)
				create p.make (v)
				call.add_param (p)
				
				-- create parameter with 'display_value'
				create v.make (display_value)
				create p.make (v)
				call.add_param (p)
	
				-- invoke and process result
				client.invoke (call)
				if client.invocation_ok then
					-- store new value in both 'value' and 'display_value'
					double_ref ?= client.response.value.value.as_object
					check 
						double_value: double_ref /= Void 
					end
					value := double_ref.item
					display_value := 0.0
					update_value
					update_error_message (" ")
				else
					update_error_message ("Fault received: (" + client.fault.code.out + ") " + client.fault.string)	
				end	
			else
				-- just store the current value
				value := display_value
				display_value := 0.0
			end
		end

	update_display_value is
			-- Update display value in main window
		do
			if display_value = 0.0 then
				main_window.clear_value
			else
				main_window.update_value (display_value.out)
			end
		end
		
	update_value is
			-- Update value in main window
		do
			if value = 0.0 then
				main_window.clear_value
			else
				main_window.update_value (value.out)
			end
		end
		
	update_error_message (message: STRING) is
			-- Update error message in main window
		require
			message_exists: message /= Void
		do
			main_window.update_error_message (message)
		end
		
end -- class CALCULATOR

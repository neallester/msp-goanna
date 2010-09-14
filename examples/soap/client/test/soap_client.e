note
	description: "SOAP Example Client."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "examples xmlrpc"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	SOAP_CLIENT

inherit
		
	KL_SHARED_ARGUMENTS
		export
			{NONE} all
		end
		
	DT_SHARED_SYSTEM_CLOCK
		export
			{NONE} all
		end
	
create

	make

feature -- Initialization

	make
			-- Create and initialise
		do
--			parse_arguments
--			if argument_error then
--				print_usage
--			else
--
--			end

		end

feature {NONE} -- Implementation

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
			print ("Usage: test <host> <port-number>%R%N")
		end
	
	envelope: SOAP_ENVELOPE
		
end -- class SOAP_CLIENT

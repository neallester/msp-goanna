note
	description: "SOAP Request-Response Message Exchange Pattern"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "SOAP"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Colin Adams <colin@colina.demon.co.uk>"
	copyright: "Copyright (c) 2005 Colin Adams and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class	GOA_SOAP_REQUEST_RESPONSE_MEP

inherit

	GOA_SOAP_MESSAGE_EXCHANGE_PATTERN

create
	
	make

feature {NONE} -- Initialization

	make (a_role: UR_URI)
			-- Establish invariant.
		local
			a_name: UT_URI
		do
			create a_name.make (Request_response_name_property)
			init (a_name, a_role)
		end
	
end -- class GOA_SOAP_REQUEST_RESPONSE_MEP


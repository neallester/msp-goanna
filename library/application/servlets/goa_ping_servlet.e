note
	description: "Servlet which responds to a ping"
	author: "Neal Lester"
	date: "$Date$"
	revision: "$Revision$"

class
	GOA_PING_SERVLET

inherit

	GOA_APPLICATION_SERVLET
		redefine
			do_get
		end
	GOA_NON_DATABASE_ACCESS_TRANSACTION_MANAGEMENT

create

	make

feature

	name: STRING = "ping.htm"

	do_get (request: MSP_FAST_CGI_SERVLET_REQUEST; response: GOA_HTTP_SERVLET_RESPONSE)
		do
			response.set_content_type ("text/html")
			response.set_status (sc_ok)
			response.set_content_length (2)
			response.send ("OK")
		end



end

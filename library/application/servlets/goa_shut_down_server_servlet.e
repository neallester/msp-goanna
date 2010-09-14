note
	description: "A servlet that brings down the application"
	author: "Neal L Lester <neal@3dsafety.com>"
	date: "$Date: 2007-02-15 14:52:21 -0800 (Thu, 15 Feb 2007) $"
	revision: "$Revision: 544 $"
	copyright: "(c) Neal L Lester"

class
	GOA_SHUT_DOWN_SERVER_SERVLET

inherit

	GOA_APPLICATION_SERVLET
		redefine
			perform_final_processing
		end
	GOA_NON_DATABASE_ACCESS_TRANSACTION_MANAGEMENT

create

	make

feature

	name: STRING
		once
			Result := configuration.bring_down_server_servlet_name
		end

	perform_final_processing (processing_result: REQUEST_PROCESSING_RESULT)
		do
			processing_result.response.send ("Server Will Be Shut Down")
			processing_result.response.flush_buffer
			configuration.set_bring_down_server
			exceptions.raise (configuration.bring_down_server_exception_description)
		end

end -- class GOA_SHUT_DOWN_SERVER_SERVLET

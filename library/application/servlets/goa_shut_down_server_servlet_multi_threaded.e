indexing
	description: "A servlet that brings down the application (multi-threaded environment)"
	author: "Neal Lester"
	date: "$Date$"
	revision: "$Revision$"

class

	GOA_SHUT_DOWN_SERVER_SERVLET_MULTI_THREADED

inherit

	GOA_SHUT_DOWN_SERVER_SERVLET
		redefine
			perform_final_processing
		end


create

	make

feature

	perform_final_processing (processing_result: REQUEST_PROCESSING_RESULT) is
		do
			processing_result.response.send ("Server Will Be Shut Down")
			processing_result.response.flush_buffer
			configuration.set_bring_down_server
			mutex.lock
			exceptions.raise (configuration.bring_down_server_exception_description)
		end


	mutex: MUTEX

	set_mutex (new_mutex: like MUTEX) is
		do
			mutex := new_mutex
		end


end

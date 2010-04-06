indexing
	description: "Objects that represent a FastCGI standalone application"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI protocol"
	date: "$Date: 2007-06-14 13:30:24 -0700 (Thu, 14 Jun 2007) $"
	revision: "$Revision: 577 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

deferred class GOA_FAST_CGI_APP

inherit

	GOA_FAST_CGI
		export
			{NONE} all
		end

	KL_SHARED_EXCEPTIONS

feature -- Basic operations

	run is
			-- Read, process, and finish requests
		local
			request_read, ending_listening: BOOLEAN
		do
			debug ("thread_control")
				io.put_string (generating_type + ".run%N")
			end
			if not ending_listening then
				initialize_listening
				retries := retries + 1
				from
				until
					end_application or max_retries_exceeded
				loop
					request_read := accept_request
					if request_read then
						process_request
					else
						initialize_listening
						retries := retries + 1
					end
					finish
				end
				ending_listening := True
				end_listening
			end
			if max_retries_exceeded then
				error (Servlet_app_log_category, "Application ended because GOA_FAST_CGI_APP.max_retries_exceeded")
			end
		rescue
			if not ending_listening and not field_exception then
				error (Servlet_app_log_category, "Uncaught exception, code: " + Exceptions.exception.out + ", retry not requested, so exiting...")
			else
				retry
			end
		end

	max_retries_exceeded: BOOLEAN is
			-- Have we already retried/re-initialized listening too many times
			-- If we are in a loop that is generating errors or we simply can't listen
			-- Then bail instead of continuing forever and filling the server logs
		do
			Result := retries > max_retries
		end


	retries: INTEGER
		-- The number of times run has retried or called initialize_listening

	max_retries: INTEGER is
		-- The maximum number of times application will retry
		once
			Result := 100
		end


	set_end_application is
			-- Set end_application to true
		do
			end_application := True
		ensure
			end_application: end_application
		end


	end_application: BOOLEAN
			-- Should we stop running this application?

	process_request is
			-- Process a request.
		deferred
		end


	field_exception: BOOLEAN is
			-- Should we attempt to retry?
		require
			True
		deferred
		end

end -- class GOA_FAST_CGI_APP

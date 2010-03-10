indexing
	description: "Objects that respond to HTTP requests."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "HTTP Servlet API"
	date: "$Date: 2007-06-14 13:30:24 -0700 (Thu, 14 Jun 2007) $"
	revision: "$Revision: 577 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class GOA_HTTP_SERVLET

inherit

	GOA_SERVLET

create

	init

feature -- Initialization

	init (config: GOA_SERVLET_CONFIG) is
			-- Called by the servlet manager to indicate that the servlet is being placed
			-- into service. The servlet manager calls 'init' exactly once after instantiating
			-- the object. The 'init' method must complete successfully before the servlet can
			-- receive any requests.
		do
			servlet_config := config
			servlet_info := ""
		end

feature -- Basic operations

	do_get (req: GOA_HTTP_SERVLET_REQUEST; resp: GOA_HTTP_SERVLET_RESPONSE) is
			-- Called to allow the servlet to handle a GET request.
			-- Default: do nothing
		require
			request_exists: req /= Void
			response_exists: resp /= Void
		do
		end

	do_head (req: GOA_HTTP_SERVLET_REQUEST; resp: GOA_HTTP_SERVLET_RESPONSE) is
			-- Called to allow the servlet to handle a HEAD request.
		require
			request_exists: req /= Void
			response_exists: resp /= Void
		do
		end

	do_post (req: GOA_HTTP_SERVLET_REQUEST; resp: GOA_HTTP_SERVLET_RESPONSE) is
			-- Called to allow the servlet to handle a POST request.
			-- Default: do nothing
		require
			request_exists: req /= Void
			response_exists: resp /= Void
		do
		end

	service (req: GOA_HTTP_SERVLET_REQUEST; resp: GOA_HTTP_SERVLET_RESPONSE) is
			-- Handle a request by dispatching it to the correct method handler.
		local
			method: STRING
		do
			method := req.method
			if method.is_equal (Method_get) then
				do_get (req, resp)
			elseif method.is_equal (Method_post) then
				do_post (req, resp)
			elseif method.is_equal (Method_head) then
				do_head (req, resp)
			else
				resp.send_error (Sc_not_implemented)
			end
			resp.flush_buffer
			if not resp.write_ok then
				log_write_error (resp)
			end
		rescue
			log_service_error
		end

	destroy is
			-- Called by the servlet manager to indicate that the servlet
			-- is being taken out of service. The servlet can then clean
			-- up any resources that are being held.
		do
		end

	log_service_error is
			-- Called if service routine generates an exception; may be redefined by descendents
		do
			-- Nothing by default
		end

	log_write_error (the_response: GOA_HTTP_SERVLET_RESPONSE) is
			-- Called if there was a problem sending response to the client
			-- May be redefined by descendents
		require
			valid_the_response: the_response /= Void
		do
			-- Nothing by default
		end


feature {NONE} -- Implementation

	Method_get: STRING is "GET"
	Method_post: STRING is "POST"
	Method_head: STRING is "HEAD"

end -- class GOA_HTTP_SERVLET

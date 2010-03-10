indexing
	description: "A servlet that links to an application"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/05/10"
	revision: "$Revision: 513 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	APPLICATION_SERVLET

inherit
	GOA_HTTP_SERVLET
		redefine
			do_get, do_head, do_post
		end

create
	init

feature -- operations

	do_get (req: GOA_HTTP_SERVLET_REQUEST; resp: GOA_HTTP_SERVLET_RESPONSE) is
			-- Called to allow the servlet to handle a GET request.
		local
			selected_url : DYNAMIC_URL
			page_sequencer : PAGE_SEQUENCER
			
		do
			debug
				io.putstring ("Handling do_get...%N")
			end
			if req.session.has_attribute ("page_sequencer") then
				page_sequencer ?= req.session.get_attribute ("page_sequencer")
				page_sequencer.set_session (req.session)
			else	-- if the user did not have a sequencer then bootstrap one
				create page_sequencer.make (req.session)
			end
			page_sequencer.set_new_request (req, resp)
			if page_sequencer.active_url_list.has (req.query_string) then
				selected_url := page_sequencer.active_url_list.item (req.query_string)
				page_sequencer.process_dynamic_url (selected_url)
			end
			page_sequencer.build_response
		end
	
	do_head (req: GOA_HTTP_SERVLET_REQUEST; resp: GOA_HTTP_SERVLET_RESPONSE) is
			-- Called to allow the servlet to handle a HEAD request.
		do
			debug
				io.putstring ("Handling do_head...%N")
			end
			do_get (req, resp)

		end
		
	do_post (req: GOA_HTTP_SERVLET_REQUEST; resp: GOA_HTTP_SERVLET_RESPONSE) is
			-- Called to allow the servlet to handle a POST request.
		do
			debug
				io.putstring ("Handling do_post...%N")
			end
			do_get (req, resp)
		end

end -- class APPLICATION_SERVLET

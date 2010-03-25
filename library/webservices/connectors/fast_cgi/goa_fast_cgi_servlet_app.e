indexing
	description: "Objects that represent a FastCGI servlet application"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI servlets"
	date: "$Date: 2007-07-12 10:37:25 -0700 (Thu, 12 Jul 2007) $"
	revision: "$Revision: 589 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

deferred class GOA_FAST_CGI_SERVLET_APP

inherit

	GOA_SERVLET_APPLICATION

	GOA_FAST_CGI_APP
		rename
			make as fast_cgi_app_make
		export
			{NONE} fast_cgi_app_make
		end

	GOA_SHARED_SERVLET_MANAGER
		export
			{NONE} all
		end

	GOA_HTTP_STATUS_CODES
		export
			{NONE} all
		end
	KL_EXCEPTIONS

feature -- Initialisation

	make (new_host: STRING; port, backlog: INTEGER) is
			-- Create a new fast cgi servlet application
		do
			fast_cgi_app_make (new_host, port, backlog)
		end

feature -- Basic operations

	process_request is
			-- Process a request.
		local
			req: like request_template
			resp: like response_template
			path, servlet_name: STRING
			servlet_found, failed: BOOLEAN
			slash_index, an_index: INTEGER
		do
			if not failed then
				debug ("Fast CGI servlet app")
							info (Servlet_app_log_category, "Process request")
				end
				create resp.make (request)
				debug ("Fast CGI servlet app")
							info (Servlet_app_log_category, "Response created")
				end
				create req.make (request, resp)
				-- dispatch to the registered servlet using the path info as the registration
				-- name.
				debug ("Fast CGI servlet app")
							info (Servlet_app_log_category, "About to check for path info...")
				end
				if req.has_header (Path_info_var) then
					debug ("Fast CGI servlet app")
							info (Servlet_app_log_category, "About to check for path info...Got it!")
					end
					path := req.get_header (Path_info_var)
					if path /= Void then
						-- remove leading slash from path
						path.keep_tail (path.count - 1)
					end
				end
				debug ("Fast CGI servlet app")
					info (Servlet_app_log_category, "About to check for non-void path...")
				end
				if path /= Void then
					debug ("Fast CGI servlet app")
						info (Servlet_app_log_category, "About to check for non-void path...Got it!")
					end
					-- Search upwards through a hierarchy of servlet names.
					from
						servlet_name := path
						slash_index := -1
					until
						servlet_found or slash_index = 0
					loop
						debug ("Fast CGI servlet app")
							info (Servlet_app_log_category, "Trying servlet: " + servlet_name)
						end
						if
							servlet_manager.has_registered_servlet (servlet_name)
						 then
							servlet_found := True
						else
							if servlet_name.count >0 then
								from
									slash_index := 0; an_index := 1
								until
									an_index = 0
								loop
									an_index := servlet_name.index_of ('/', slash_index + 1)
									if an_index > slash_index then slash_index := an_index end
								end
								debug ("Fast CGI servlet app")
									info (Servlet_app_log_category, "Slash index is " + slash_index.out)
								end
							else
								slash_index := 0
							end
							if slash_index > 0 then
								servlet_name := servlet_name.substring (slash_index + 1, servlet_name.count)
							else
								debug ("Fast CGI servlet app")
									info (Servlet_app_log_category, "Servlet name is " + servlet_name)
								end
							end
						end
					end
				end
				if servlet_found then
					info (Servlet_app_log_category, "Servicing request: " + path)
					info (Servlet_app_log_category, "Using servlet named: " + servlet_name)
					servlet_manager.servlet (servlet_name).service (req, resp)
				else
					if
						servlet_manager.has_default_servlet
					 then
						info (Servlet_app_log_category, "Using default servlet.")
						servlet_manager.default_servlet.service (req, resp)
					else
						handle_missing_servlet (resp)
						if
							path /= Void
						 then
							error (Servlet_app_log_category, "Servlet not found: " + path)
						else
							error (Servlet_app_log_category, "Servlet not found: path was Void")
						end
					end
				end
			end
		end

feature {NONE} -- Implementation

	request_template: GOA_FAST_CGI_SERVLET_REQUEST
	response_template: GOA_FAST_CGI_SERVLET_RESPONSE


	handle_missing_servlet (resp: GOA_FAST_CGI_SERVLET_RESPONSE) is
			-- Send error page indicating missing servlet
		require
			resp_exists: resp /= Void
		do
			resp.send_error (Sc_not_found)
		end

end -- class GOA_FAST_CGI_SERVLET_APP

note
	description: "Objects that represent FastCGI servlet request information"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI servlets"
	date: "$Date: 2007-06-14 13:30:24 -0700 (Thu, 14 Jun 2007) $"
	revision: "$Revision: 577 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class GOA_FAST_CGI_SERVLET_REQUEST

inherit

	GOA_CGI_SERVLET_REQUEST
		rename
			make as cgi_servlet_make
		redefine
			has_header, get_header, get_header_names, internal_response, content
		end

create

	make

feature {NONE} -- Initialisation

	make (fcgi_request: GOA_FAST_CGI_REQUEST; resp: GOA_FAST_CGI_SERVLET_RESPONSE)
			-- Create a new fast cgi servlet request wrapper for
			-- the request information contained in 'fcgi_request'
		require
			request_exists: fcgi_request /= Void
			response_exists: resp /= Void
		do
			internal_request := fcgi_request
			internal_response := resp
			create parameters.make (5)
			parse_parameters
		end

feature -- Access

	get_header (name: STRING): STRING
			-- Get the value of the specified request header.
		do
			Result := internal_request.parameters.item (name).twin
		end

	get_header_names: DS_LINEAR [STRING]
			-- Get all header names.
		local
			cursor: DS_HASH_TABLE_CURSOR [STRING, STRING]
			array_list: DS_ARRAYED_LIST [STRING]
		do
			create array_list.make (internal_request.parameters.count)
			cursor := internal_request.parameters.new_cursor
			from
				cursor.start
			until
				cursor.off
			loop
				array_list.force_last (cursor.key.twin)
				cursor.forth
			end
			Result := array_list
		end

	content: STRING
			-- Content data
		do
			debug ("Fast CGI servlet request")
				print ("Content entered%N")
			end
			if has_header (Content_length_var) then
				debug ("Fast CGI servlet request")
					print ("Found content length header%N")
				end
				if internal_content = Void then
					if content_length > 0 then
						debug ("Fast CGI servlet request")
							print ("Content length > 0%N")
						end
						-- TODO: check for errors
						internal_content := internal_request.raw_stdin_content
						debug ("Fast CGI servlet request")
							print ("Internal content is: " + internal_content + "%N")
						end
					else
						debug ("Fast CGI servlet request")
							print ("No internal content 1%N")
						end
						internal_content := ""
					end
				end
			else
				debug ("Fast CGI servlet request")
					print ("No internal content 2%N")
				end
				internal_content := ""
			end
			Result := internal_content
		end

	close_socket
			-- Close the socket used to communicate with web server
		do
			if socket /= Void and then socket.is_owner and then socket.is_open then
				socket.close
			end
		end


feature -- Status report

	has_header (name: STRING): BOOLEAN
			-- Does this request contain a header named 'name'?
		do
			Result := internal_request.parameters.has (name)
		end

feature {GOA_FAST_CGI_SERVLET_APP} -- Socket

	socket: ABSTRACT_TCP_SOCKET
		do
			Result := internal_request.socket
		end


feature {GOA_FAST_CGI_SERVLET_REQUEST} -- Implementation


	internal_request: GOA_FAST_CGI_REQUEST
		-- Internal request information and stream functionality.

	internal_response: GOA_FAST_CGI_SERVLET_RESPONSE
		-- Response object held so that session cookie can be set.

end -- class GOA_FAST_CGI_SERVLET_REQUEST

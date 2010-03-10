indexing
	description: "Snoop servlet that outputs request information."
	note: "Includes debug statements labeled 'snoop' to output to stdout"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "examples"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class GOA_SNOOP_SERVLET

inherit

	GOA_HTTP_SERVLET
		redefine
			do_get, do_post
		end

	UT_STRING_FORMATTER
		export
			{NONE} all
		end
		
create

	init
	
feature -- Basic operations

	do_get (req: GOA_HTTP_SERVLET_REQUEST; resp: GOA_HTTP_SERVLET_RESPONSE) is
			-- Process GET request
		local
			response: STRING
		do
			create response.make (1024)
			debug ("snoop")
				print ("Snoop Servlet%R%N")
			end
			response.append_string ("<html><head><title>Snoop Servlet</title></head>%R%N")
			response.append_string ("<h1>Snoop Servlet</h1>")
			response.append_string (request_html (req, resp))
			response.append_string ("</body></html>%R%N")	
			resp.set_content_length (response.count)
			resp.send (response)
		end
	
	do_post (req: GOA_HTTP_SERVLET_REQUEST; resp: GOA_HTTP_SERVLET_RESPONSE) is
			-- Process GET request
		do
			do_get (req, resp)
		end
		
feature {NONE} -- Implementation

	request_html (req: GOA_HTTP_SERVLET_REQUEST; resp: GOA_HTTP_SERVLET_RESPONSE): STRING is
		local
			parameter_names: DS_LINEAR [STRING]
			header_names: DS_LINEAR [STRING]
			line: STRING
		do
			create Result.make (255)
			Result.append_string ("<pre>")
			Result.append_string (req.to_string)
			Result.append_string ("</pre>")
			-- display all headers
			Result.append_string ("<h2>Headers</h2>")
			from 
				header_names := req.get_header_names
				header_names.start
			until
				header_names.off
			loop
				Result.append_string (header_names.item_for_iteration + " = ")
				if req.has_header (header_names.item_for_iteration) then
					Result.append_string (req.get_header (header_names.item_for_iteration))
				else
					Result.append_string ("Void")
				end
				Result.append_string ("<br>")
				header_names.forth
			end
			-- display all content
			if not req.content.is_empty then
				debug ("snoop")
					print ("Content Data:%R%N")
					print ("%T" + quoted_eiffel_string_out (req.content) + "%R%N")
				end
				Result.append_string ("<h2>Content Data</h2>%R%N")
				Result.append_string (quoted_eiffel_string_out (req.content))
			end
			-- display all parameters
			Result.append_string ("<h2>Parameters</h2>%R%N")
			debug ("snoop")
				print ("Parameters:%R%N")
			end
			from
				parameter_names := req.get_parameter_names
				parameter_names.start
			until
				parameter_names.off
			loop
				line := parameter_names.item_for_iteration + " = " 
					+ quoted_eiffel_string_out (req.get_parameter (parameter_names.item_for_iteration))
				debug ("snoop")
					print ("%T" + line + "%R%N")
				end
				Result.append_string (line + "<br>%R%N")
				parameter_names.forth
			end				

		end	
		
end -- class GOA_SNOOP_SERVLET

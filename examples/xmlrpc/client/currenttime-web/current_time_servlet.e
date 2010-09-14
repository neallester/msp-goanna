note
	description: "XMLRPC Example Current Time servlet retrieval for the %
		%server (http://time.xmlrpc.com/RPC2)."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "examples xmlrpc currenttime"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	CURRENT_TIME_SERVLET

inherit
		
	HTTP_SERVLET
		redefine
			do_get, do_post
		end
	
	XRPC_CONSTANTS
		export
			{NONE} all
		undefine
			copy, default_create
		end
		
create
	
	init
	
feature -- Initialization

	do_get (request: HTTP_SERVLET_REQUEST; response: HTTP_SERVLET_RESPONSE)
			-- Service the request
		do
			write_page (response, "time.xmlrpc.com", 80, "/RPC2", "currentTime.getCurrentTime", "Unknown")	
		end
	
	do_post (request: HTTP_SERVLET_REQUEST; response: HTTP_SERVLET_RESPONSE)
			-- Service the request
		local
			param: STRING
			host, path, service_name: STRING
			port: INTEGER
			time: STRING
		do
			param := clone (request.get_parameter ("host"))
			if param /= Void and then not param.is_empty then
				host := param
			end
			param := clone (request.get_parameter ("port"))
			if param /= Void and then not param.is_empty and then param.is_integer then
				port := param.to_integer
			end
			param := clone (request.get_parameter ("path"))
			if param /= Void and then not param.is_empty then
				path := param
			end
			param := clone (request.get_parameter ("service"))
			if param /= Void and then not param.is_empty then
				service_name := param
			end
			time := retrieve_time (host, port, path, service_name)
			write_page (response, host, port, path, service_name, time)
		end
		
feature -- Basic routines

	retrieve_time (host: STRING; port: INTEGER; path, service_name: STRING): STRING
			-- Retrieve current time
		local
			client: XRPC_LITE_CLIENT
			call: XRPC_CALL
			date: DT_DATE_TIME
		do
			create client.make (host, port, path)
			create call.make_from_string (service_name)
			client.invoke (call)
			if client.invocation_ok then		
				date ?= client.response.value.value.as_object
				if date /= Void then
					Result := date.out
				end
			else
				Result := "Fault received: (" + client.fault.code.out + ") " + client.fault.string
			end	
		end
	
	write_page (response: HTTP_SERVLET_RESPONSE; host: STRING; port: INTEGER; path, service_name, time: STRING)
			-- Write page
		local
			html: STRING
		do
			response.set_content_type ("text/html")
			create html.make (400)
			html.append ("<html><body>")
			html.append ("<p>Current time is: ")
			html.append (time)
			html.append ("</p>")
			html.append ("<form method=POST target=''>")
			html.append ("Host: <input type='text' name='host' value='")
			html.append (host)
			html.append ("'><br>")
			html.append ("Port: <input type='text' name='port' value='")
			html.append (port.out)
			html.append ("'><br>")
			html.append ("Path: <input type='text' name='path' value='")
			html.append (path)
			html.append ("'><br>")
			html.append ("Service: <input type='text' size=30 name='service' value='")
			html.append (service_name)
			html.append ("'><br>")
			html.append ("<input type='submit' value='Get Time'>")
			html.append ("</form>")
			html.append ("<p>The following time servers can be used:</p>")
			html.append ("<table border='1'><tr><th>Host</th><th>Port</th><th>Path</th><th>Service</th><th>Note</th></tr>")
			html.append ("<tr><td>time.xmlrpc.com</td><td>80</td><td>/RPC2</td><td>currentTime.getCurrentTime</td><td>&nbsp;</td></tr>")
			html.append ("<tr><td>localhost</td><td>8080</td><td>/servlet/xmlrpc</td><td>currentTime.getCurrentTime</td><td>Only if server example is running on local host at port 8080</td></tr>")
			html.append ("</table>")
			html.append ("</body></html>")
			response.set_content_length (html.count)
			response.send (html)
		end
		
end -- class CURRENT_TIME_SERVLET

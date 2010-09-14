note
	description: "A client that renders HTML"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/05/10"
	revision: "$Revision: 491 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	HTML_CLIENT

inherit

	CLIENT

create

	make

feature

	set_code (content : CONTENT_CONTAINER)
		-- Set "code" in content to content.html_code
		do
			content.set_code (content.html_code)
		end

end -- class HTML_CLIENT

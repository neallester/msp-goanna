indexing
	description: "Code that goes at the top of every response"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/05/10"
	revision: "$Revision: 491 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	CODE_HEADER

inherit

	TEXT_CONTAINER
		undefine
			html_begin_element, html_end_element
		end

create
	make

feature -- Initialization

	html_begin_element : STRING is
		do
			Result := "<HTML><HEAD><TITLE>"
		end

	html_end_element : STRING is
		do
			Result := "</TITLE></HEAD>" + new_line + "<BODY>" + new_line
		end

end -- class CODE_HEADER

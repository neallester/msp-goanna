indexing
	description: "Code that goes at the bottom of each response"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/05/10"
	revision: "$Revision: 491 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	CODE_FOOTER

inherit

	CONTENT_CONTAINER

create
	make

feature

	html_begin_element : STRING is ""

	html_end_element : STRING is ""

	html_element : STRING is
		do
			Result := new_line + "</BODY></HTML>" + new_line
		end

feature {NONE} -- Initialization

end -- class CODE_FOOTER

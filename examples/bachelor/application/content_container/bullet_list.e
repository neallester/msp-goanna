indexing
	description: "Bulleted List"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/05/10"
	revision: "$Revision: 491 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	BULLET_LIST

inherit
	HTML_LIST
		redefine
			list_element, html_begin_element, html_end_element
		end

create
	make

feature -- Implement deferred features

	html_begin_element : STRING is
		do
			result := "<ul>" + new_line
		end

	html_end_element : STRING is
		do
			result := "</ul>" + new_line
		end

feature {NONE} -- Implementation

	list_element : BULLET_ELEMENT

end -- class BULLET_LIST
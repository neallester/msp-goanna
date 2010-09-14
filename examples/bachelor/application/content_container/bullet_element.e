note
	description: "Elements in a bulleted list"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/05/10"
	revision: "$Revision: 491 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	BULLET_ELEMENT

inherit
	
	TEXT_PARAGRAPH
		redefine
			html_begin_element, html_end_element
		end

create
	make

feature -- Implement deferred features

	html_begin_element : STRING
		do
			result := "<li>" + html_text_container_begin_element
		end

	html_end_element : STRING
		do
			result := html_text_container_end_element + "</li>" + new_line
		end

end -- class BULLET_ELEMENT

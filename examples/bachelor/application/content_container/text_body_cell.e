indexing
	description: "Table cells that contain text"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/05/10"
	revision: "$Revision: 491 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class

	TEXT_BODY_CELL


inherit

	BODY_CELL
		rename
			make as body_make,
			html_begin_element as html_body_cell_begin_element,
			html_end_element as html_body_cell_end_element
		select
			body_make, html_body_cell_begin_element, html_body_cell_end_element
		end
	TEXT_CONTAINER
		rename
			make as text_make,
			html_begin_element as html_text_container_begin_element,
			html_end_element as html_text_container_end_element
		end

creation

	make

feature {NONE} -- Creation

	html_begin_element : STRING is
		do
			result := html_body_cell_begin_element + html_text_container_begin_element
		end

	html_end_element : STRING is
		do
			result := html_text_container_end_element + html_body_cell_end_element
		end

	make is
		do
			body_make
			text_make
		end

end -- class TEXT_BODY_CELL

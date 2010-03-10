indexing
	description: "Cells in the body of a table that contain one or more content_containers"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/05/10"
	revision: "$Revision: 491 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	CONTAINER_BODY_CELL

inherit
	
	BODY_CELL
		rename
			make as body_cell_make
		undefine
			copy, is_equal
		end
	MULTI_CONTAINER
		rename
			make as multi_container_make
		undefine
			html_begin_element, html_end_element
		select
			multi_container_make
		end
create
	make

feature {NONE} -- Creation

	make is
		do
			body_cell_make
			multi_container_make
		end


end -- class CONTAINER_BODY_CELL

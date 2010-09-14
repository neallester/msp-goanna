note
	description: "Rows of table"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/05/10"
	revision: "$Revision: 491 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	TABLE_ROW

inherit
	
	MULTI_CONTAINER
		export {NONE}
			all
		redefine
			html_begin_element, html_end_element
		end

create

	make

feature {PAGE, PAGE_FACTORY, CONTENT_CONTAINER}

	add_cell (cell_to_add : TABLE_CELL)
		-- add cell_to_add to the row
		require
			valid_cell_to_add : cell_to_add /= Void
		do
			force (cell_to_add)
		ensure
			has (cell_to_add)
		end

feature {NONE} -- Implement deferred features

	html_begin_element : STRING
		do
			Result := "<tr>" + new_line
		end

	html_end_element : STRING
		do
			Result := "</tr>"
		end

end -- class TABLE_ROW

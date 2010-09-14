note
	description: "Table cells in the body of the table"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/05/10"
	revision: "$Revision: 491 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

deferred class
	BODY_CELL

inherit

	TABLE_CELL

feature {NONE}

	html_begin_element : STRING
		do
			Result := "<td" + html_alignment + html_vertical_alignment + ">"
		end

	html_end_element : STRING
		do
			Result := "</td>"
		end

end -- class BODY_CELL

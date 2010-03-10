indexing
	description: "Content displayed as a rows and columns"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/05/10"
	revision: "$Revision: 491 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	CONTENT_TABLE

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

	add_row (new_row : TABLE_ROW) is
		-- Add new_row to the table
		require
			 valid_new_row : new_row /= Void
		do
			force (new_row)
		end

feature {NONE} -- Implement deferred features

	html_begin_element : STRING is
		do
			Result := "<table BORDER=0 WIDTH=%"100%%%"><COL WIDTH = %"0*%">" + new_line
		end

	html_end_element : STRING is
		do
			result := "</TABLE>" + new_line
		end

end -- class CONTENT_TABLE

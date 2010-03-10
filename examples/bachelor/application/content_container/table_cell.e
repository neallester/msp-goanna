indexing
	description: "Cells in a table"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/05/10"
	revision: "$Revision: 513 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

deferred class
	TABLE_CELL

inherit
	VERTICAL_ALIGNABLE
	CONTENT_CONTAINER
	ALIGNABLE
		export {NONE}
			set_top, set_middle, set_bottom
		end
feature {CONTENT_CONTAINER}

	set_width_in_pixels (number_of_pixels : INTEGER) is
		-- Define width in pixels
		require
			non_negative_number_of_pixels : number_of_pixels >= 0
		do
			width := number_of_pixels
			in_pixels := True
			in_percent := false
		ensure
			width_updated : width = number_of_pixels
			in_pixels : in_pixels
			not_in_percent : not in_percent
		end

	set_width_in_percent (percent : INTEGER) is
		-- Define width in percent
		require
			non_negative_percent : percent >= 0
		do
			width := percent
			in_pixels := false
			in_percent := true
		ensure
			width_updated : width = percent
			in_percent : in_percent
			not_in_pixels : not in_pixels
		end

feature {NONE} -- implementation

	html_width : STRING is
		-- A string for inclusion in the cell element; html width
		do
			if (not in_pixels and not in_percent) then
				result := ""
			else
				result := " WIDTH= %""
				if width = 0 then
					result := result + "0*%""
				else
					result := result + width.out
					if in_percent then
						result := result + "%%"
					end
					result := result + "%""
				end
			end
		ensure
			valid_result : result /= Void
		end

	width : INTEGER
		-- Width of the cell

	in_pixels : BOOLEAN
		-- Width is given in pixels

	in_percent : BOOLEAN
		-- Width is given as a percent
	
invariant

	not_top : alignment_code /= top
	not_middle : alignment_code /= middle
	not_bottom : alignment_code /= bottom
	in_pixels_implies_not_in_percent : in_pixels implies not in_percent
	in_percent_implies_not_in_pixels : in_percent implies not in_pixels


end -- class TABLE_CELL

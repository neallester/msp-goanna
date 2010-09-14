note
	description: "Content containers that have vertical alignment"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/05/10"
	revision: "$Revision: 491 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	VERTICAL_ALIGNABLE

feature {PAGE, PAGE_FACTORY, CONTENT_CONTAINER} -- Attribute & Attribute Setting

	set_vertical_top
		-- Set vertical alignment to "TOP" - content at top of cells
		do
			vertical_alignment_code := vertical_top
		ensure
			vertical_alignment_code_set : vertical_alignment_code = vertical_top
		end

	set_verticle_middle
		-- Set vertical alignment to "MIDDLE" - centers content vertically in cells
		do
			vertical_alignment_code := vertical_middle
		ensure
			vertical_alignement_code_set : vertical_alignment_code = vertical_middle
		end

	set_vertical_bottom
		-- Set vertical alignment to "BOTTOM" - content at bottom of cell
		do
			vertical_alignment_code := vertical_bottom
		ensure
			vertical_alignment_code_set : vertical_alignment_code = vertical_bottom
		end

	set_vetical_baseline
		-- Set vertical alignment to "BASELINE" - 1ST line in each cell will line up
		do
			vertical_alignment_code := vertical_baseline
		ensure
			alignment_code_set : vertical_alignment_code = vertical_baseline
		end

	vertical_alignment : STRING
		-- Alignment label describing current alignment
		do
			Result := vertical_alignment_code_labels.entry(vertical_alignment_code)
		end

	html_vertical_alignment : STRING
		-- HTML alignment entry
		do
			if vertical_alignment_code = 0 then
				result := ""
			else
				Result := " VALIGN=%"" + vertical_alignment + "%" "
			end
		end

feature {NONE} -- Implementation

	vertical_alignment_code : INTEGER
		-- Code defining alignment of image

	vertical_top, vertical_middle, vertical_bottom, vertical_baseline : INTEGER = UNIQUE
		-- identifiers for alignment codes

	vertical_alignment_code_labels : ARRAY [STRING]
		-- Array containing labels for each alignment code
		once
			create result.make (vertical_top, vertical_baseline)
			result.force ("TOP", vertical_top)
			result.force ("MIDDLE", vertical_middle)
			result.force ("BOTTOM", vertical_bottom)
			result.force ("BASELINE", vertical_baseline)
		ensure
			valid_result : result /= Void
		end

invariant
	
	valid_alignment_code_labels : vertical_alignment_code_labels /= Void

end -- class VERTICAL_ALIGNABLE

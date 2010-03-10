indexing
	description: "Content objects that may be aligned"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/05/10"
	revision: "$Revision: 491 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."


deferred class
	ALIGNABLE

feature {PAGE, PAGE_FACTORY, CONTENT_CONTAINER, USER} -- Attribute & Attribute Setting

	set_top is
		-- Set alignment to "TOP" - text outside image aligned with top of image
		do
			alignment_code := top
		ensure
			alignment_code_set : alignment_code = top
		end

	set_middle is
		-- Set alignment to "MIDDLE" - text outside image aligned with middle of the image
		do
			alignment_code := middle
		ensure
			alignement_code_set : alignment_code = middle
		end

	set_bottom is
		-- Set alignment to "BOTTOM" - text outside image aligned with bottom of the image
		do
			alignment_code := bottom
		ensure
			alignment_code_set : alignment_code = bottom
		end

	set_left is
		-- Set alignment to "LEFT" - Image is to left, text flows around it to the right
		do
			alignment_code := left
		ensure
			alignment_code_set : alignment_code = left
		end

	set_right is
		-- Set alignment to "RIGHT" - Image is to the right, text flows around it to the left
		do
			alignment_code := right
		ensure
			alignment_code_set : alignment_code = right
		end

	set_center is
		-- Set alignment to "CENTER" - 	centered
		do
			alignment_code := center
		ensure
			alignment_code_set : alignment_code = center
		end

	alignment : STRING is
		-- Alignment label describing current alignment
		do
			Result := alignment_code_labels.entry(alignment_code)
		end

	html_alignment : STRING is
		-- HTML alignment entry
		do
			if alignment_code = 0 then
				result := ""
			else
				Result := " ALIGN=%"" + alignment + "%" "
			end
		end

feature {NONE} -- Implementation

	alignment_code : INTEGER
		-- Code defining alignment of image

	top, middle, bottom, left, right, center : INTEGER is UNIQUE
		-- identifiers for alignment codes

	alignment_code_labels : ARRAY [STRING] is
		-- Array containing labels for each alignment code
		once
			create result.make (top, center)
			result.force ("TOP", top)
			result.force ("MIDDLE", middle)
			result.force ("BOTTOM", bottom)
			result.force ("LEFT", left)
			result.force ("RIGHT", right)
			result.force ("CENTER", center)
		ensure
			valid_result : result /= Void
		end

feature {NONE} -- creation

invariant
	
	valid_alignment_code_labels : alignment_code_labels /= Void
--	alignment_set : (alignment_code = top) or (alignment_code = bottom) or (alignment_code = center) or (alignment_code = left) or (alignment_code = middle) or (alignment_code = right)

end -- class ALIGNABLE

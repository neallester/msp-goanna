note
	description: "Paragraphs of text"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/05/10"
	revision: "$Revision: 513 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

deferred class
	PARAGRAPH

inherit

	CONTENT_CONTAINER
	ALIGNABLE
		EXPORT 
			{NONE}
				set_top, set_middle, set_bottom
		end

feature

	html_begin_element : STRING
		-- Begin an http paragraph
		do
			Result := "<P" + html_alignment + ">" + new_line
		end

	html_end_element : STRING
		-- End an http paragraph
		do
			Result := "</P>" + new_line
		end

invariant

	not_top : alignment_code /= top
	not_middle : alignment_code /= middle
	not_bottom : alignment_code /= bottom

end -- class PARAGRAPH

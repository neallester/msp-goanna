indexing
	description: "Content containers that can display bold text"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/05/10"
	revision: "$Revision: 491 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

deferred class
	BOLDABLE

feature

	bold : BOOLEAN
		-- Display text bold

	set_bold is
		-- Set to display text bold
		do
			bold := true
		end

	set_bold_off is
		-- Set to not display text bold
		do
			bold := false
		end

feature {NONE} -- implementation

	html_bold_begin_element : STRING is
		do
			if bold then
				result := "<B>"
			else
				result := ""
			end
		end

	html_bold_end_element : STRING is
		do
			if bold then
				result := "</B>"
			else
				result := ""
			end
		end

end -- class BOLDABLE

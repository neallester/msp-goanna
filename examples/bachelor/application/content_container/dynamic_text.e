indexing
	description: "content_containers with text that is determined dynamically when page is displayed rather than at build time"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/05/10"
	revision: "$Revision: 491 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	DYNAMIC_TEXT

inherit
	CONTENT_CONTAINER

create
	
	make

feature

	text : STRING is
		-- The text to be displayed
		do
			if text_function = Void then
				result := ""
			else
				text_function.call([])
				result := text_function.last_result
			end
		end

	set_text_function (new_text_function : FUNCTION [PROCESSOR_HOST, TUPLE, STRING]
		-- Set an ISE agent to call to determine the text to display
		require
			valid_new_text_function : new_text_function /= Void
		do
			text_function := new_text_function
		ensure
			text_function_updated : text_function = new_text_function
		end

feature -- Implementation {NONE}

	text_function : FUNCTION [PROCESSOR_HOST, TUPLE, STRING]
		-- The ISE agent called to determine the text to display

	set_text (new_text : STRING) is
		-- Redefine inherited feature to do nothing.
		do
		end

end -- class DYNAMIC_TEXT

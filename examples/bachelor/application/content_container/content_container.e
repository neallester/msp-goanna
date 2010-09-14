note
	description: "Containers for text or multi-media content used by the system";
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/05/10"
	revision: "$Revision: 491 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

deferred class
	CONTENT_CONTAINER

inherit

	SYSTEM_CONSTANTS

feature {PAGE, CLIENT} -- Access

	code : STRING
		-- The programming code (e.g. html) needed to display the content

feature {CLIENT, CONTENT_CONTAINER}  -- Manipulation

	set_code (new_code : STRING)
		-- Set the code to display this content container
		require
			valid_new_code : new_code /= Void
		do
			code := new_code
		ensure
			code_updated : code = new_code
		end

-- Vanilla HTML

	html_code : STRING
		-- The content displayed as html text
		do
			result := html_begin_element + html_element + html_end_element
		ensure
			valid_html_text : Result /= Void
		end

	html_begin_element : STRING
		-- HTML associated with the begining of the element
		deferred
		end

	html_element : STRING
		-- HTML & content associated with the body of the element
		deferred
		end

	html_end_element : STRING
		-- HTML & content assoicated with the end of the element
		deferred
		end

feature {NONE} -- Creation

	make
		do
		end

end -- class CONTENT_CONTAINER

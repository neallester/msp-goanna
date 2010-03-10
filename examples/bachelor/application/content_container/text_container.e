indexing
	description: "Content Containers Containing Clear Text"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/05/10"
	revision: "$Revision: 491 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	TEXT_CONTAINER

inherit
	BOLDABLE
	CONTENT_CONTAINER
		export {TEST_TEXT_PARAGRAPH}
			all
		redefine
			make
		end
creation

	make

feature {TEST_TEXT_PARAGRAPH, PAGE, PAGE_FACTORY, CONTENT_CONTAINER, TOPIC, USER} -- Access

	text : STRING
		-- The clear text of the paragraph (no programming code)

	set_text (new_text : STRING) is
		-- Set text
		require
			valid_new_text : new_text /= Void
		do
			text := new_text
		ensure
			text_updated : text = new_text
		end


feature {NONE} -- creation

	html_begin_element : STRING is 
		do
			result := html_bold_begin_element
		end

	html_end_element : STRING is
		do
			result := html_bold_end_element
		end

	html_element : STRING is
		do
			result := text
		end

	make is
		do
			text := ""
		end

invariant

	valid_text : text /= Void

end -- class TEXT_CONTAINER

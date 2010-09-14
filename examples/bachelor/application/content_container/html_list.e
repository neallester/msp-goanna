note
	description: "Content_containers with multiple lines of text"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/05/10"
	revision: "$Revision: 491 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

deferred class
	HTML_LIST

inherit
	
	MULTI_CONTAINER
		export {NONE}
			all
		end

feature {PAGE, PAGE_FACTORY, EXPOSURE}

	add_text (new_text : STRING)
		-- Add new_text to the text list
		require
			valid_new_text : new_text /= Void
		do
			create list_element.make
			list_element.set_text (new_text)
			force (list_element)
		end

feature {NONE} -- Implementation

	list_element : TEXT_PARAGRAPH

end -- class HTML_LIST

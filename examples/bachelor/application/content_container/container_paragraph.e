indexing
	description: "Paragraphs that contain one or more content_containers"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/05/10"
	revision: "$Revision: 491 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	CONTAINER_PARAGRAPH

inherit
	PARAGRAPH
		rename
			make as paragraph_make
		undefine
			copy, is_equal
		end
	MULTI_CONTAINER
		rename
			make as multi_container_make
		undefine
			html_begin_element, html_end_element
		select
			multi_container_make
		end

create
	make, make_with_container

feature {NONE} -- creation

	make is
		do
			multi_container_make
			paragraph_make
		end	

	make_with_container (new_container : CONTENT_CONTAINER) is
		-- make with a content container
		require
			valid_new_container : new_container /= Void
		do
			make
			force (new_container)
		ensure
			has (new_container)
		end

end -- class CONTAINER_PARAGRAPH

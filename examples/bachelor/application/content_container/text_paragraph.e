indexing
	description: "A paragraph of text"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/05/10"
	revision: "$Revision: 513 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	TEXT_PARAGRAPH

inherit
	
	PARAGRAPH
		rename
			make as paragraph_make
		redefine 
			html_begin_element,
			html_end_element
		select
			html_begin_element, html_end_element
		end
	TEXT_CONTAINER
		rename
			make as text_container_make,
			html_begin_element as html_text_container_begin_element,
			html_end_element as html_text_container_end_element
		select
			text_container_make
		end

create
	make

feature -- implement deferred features

	html_begin_element : STRING is
		do
			result := precursor {PARAGRAPH}  + html_text_container_begin_element
		end

	html_end_element : STRING is
		do
			result := html_text_container_end_element + precursor {PARAGRAPH}
		end

feature {NONE} -- Creation

	make is
		do
			text_container_make
			paragraph_make
		end

end -- class TEXT_PARAGRAPH

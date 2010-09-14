note
	description: "Anchors to a particular point on the page"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/05/10"
	revision: "$Revision: 491 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	ANCHOR

inherit
	TEXT_CONTAINER
		redefine
			html_begin_element, html_end_element
		end

create
	make_anchor

feature -- implement deferred features

	html_begin_element : STRING 
		do
			result := "<A " + a_tag + name + "%">" + precursor
		end

	html_end_element : STRING
		do
			result := precursor + "</A>"
		end

	a_tag : STRING
		-- Text for the Name tag 
		do
			result := "NAME=%""
		end

feature {NONE}

	name : STRING
		-- The name associated with the anchor

	make_anchor (new_name : STRING)
		require
			valid_new_name : new_name /= Void
			new_name_not_empty : not new_name.empty
		do
			make
			name := new_name
		end

invariant
	
	valid_name : name /= Void
	name_not_empty : not name.empty

end -- class ANCHOR

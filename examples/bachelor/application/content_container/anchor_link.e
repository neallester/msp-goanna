note
	description: "Links to anchors within a page"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/05/10"
	revision: "$Revision: 491 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	ANCHOR_LINK

inherit
	ANCHOR
		redefine
			a_tag
		end

create
	make_anchor

feature -- implement redefined features

	a_tag : STRING
		-- The tag for an HREF link
		do
			result := "HREF=%"#"
		end

end -- class ANCHOR_LINK

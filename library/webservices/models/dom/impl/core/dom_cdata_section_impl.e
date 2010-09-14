note
	description: "CDATA section implementation"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "Document Object Model (DOM) Core Implementation"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class DOM_CDATA_SECTION_IMPL

inherit

	DOM_CDATA_SECTION

	DOM_TEXT_IMPL
		undefine
			node_type, node_name
		end		

create

	make

end -- class DOM_CDATA_SECTION_IMPL

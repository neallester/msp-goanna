indexing
	description: "CDATA section"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "Document Object Model (DOM) Core"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

deferred class DOM_CDATA_SECTION

inherit

	DOM_TEXT
		redefine
			node_name, node_type
		end

feature

	node_type: INTEGER is
		once
			Result := Cdata_section_node
		end

	node_name: DOM_STRING is
		once
			!! Result.make_from_string ("#cdata-section")
		end

end -- class DOM_CDATA_SECTION

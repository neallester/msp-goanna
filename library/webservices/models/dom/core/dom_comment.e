note
	description: "The content of a comment, i.e., all the characters between %
      	%the starting '<!--' and ending '-->'. Note that this is %
      	%the definition of a comment in XML, and, in practice, HTML, %
      	%although some HTML tools may implement the full SGML comment %
      	%structure."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "Document Object Model (DOM) Core"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

deferred class DOM_COMMENT

inherit

   DOM_CHARACTER_DATA

feature -- from DOM_NODE


	node_type: INTEGER
		once
			Result := Comment_node
		end

	node_name: DOM_STRING
		once 
			create Result.make_from_string ("#comment")
		end

end -- class DOM_COMMENT

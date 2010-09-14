note
	description: "A DOM tree based XML parser factory"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "XML Parser"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	DOM_TREE_BUILDER_FACTORY

inherit

	XM_PARSER_FACTORY
		export
			{NONE} all
		end
   
feature -- Factory methods

	create_parser: DOM_TREE_BUILDER
			-- Create a dom tree builder that uses the Expat XML
			-- parser
		do
			--create Result.make (new_expat_event_parser_imp)
			create Result.make (new_eiffel_event_parser_imp)
		end 
      
end -- class DOM_TREE_BUILDER_FACTORY

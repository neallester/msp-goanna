indexing
	description: "Processing instruction"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "Document Object Model (DOM) Core"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

deferred class DOM_PROCESSING_INSTRUCTION

inherit

	DOM_NODE

feature

	data: DOM_STRING is
			-- The content of this processing  instruction. This is from the
			-- first non white space character after the target to the character 
			-- immediately preceding the ?>
		deferred
		end

	target: DOM_STRING is
			-- The target of this processing instruction. XML defines this as being
			-- the first token following the markup that begins the processing 
			-- instruction.
		deferred
		end

end -- class DOM_PROCESSING_INSTRUCTION

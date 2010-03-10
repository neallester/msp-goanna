indexing
	description: "Entity"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "Document Object Model (DOM) Core"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

deferred class DOM_ENTITY

inherit

   DOM_NODE

feature

	public_id: DOM_STRING is
			-- The public identifier associated with the entity, if specified.
			-- For parsed entities, this is Void.
		deferred
		end

	system_id: DOM_STRING is
			-- The system identifier associated with the entity, if specified.
			-- If the system identifier was not specified, this is Void.
		deferred
		end

	notation_name: DOM_STRING is
			-- For unparsed entities, the name of the notation for the entity. For
			-- parsed entities, this is Void.
		deferred
		end
	
end -- class DOM_ENTITY

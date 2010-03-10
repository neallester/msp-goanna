indexing
	description: "Registry of objects keyed by name"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "Utility"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class	GOA_REGISTRY [G]

create

	make

feature -- Initialization

	make is
			-- Initialise empty registry
		do
			create elements.make_default
		end
		
feature -- Access
	
	get (a_name: STRING): G is
			-- Retrieve element registered under `a_name'
		require
			name_not_empty: a_name /= Void and then not a_name.is_empty
			element_registered: has (a_name)
		do
			Result := elements.item (a_name)
		ensure
			result_not_void: Result /= Void
		end
	
	has (a_name: STRING): BOOLEAN is
			-- Is a element registered under `a_name'?
		require
			name_not_empty: a_name /= Void and then not a_name.is_empty
		do
			Result := elements.has (a_name)
		end

	elements: DS_HASH_TABLE [G, STRING]
			-- Collection of elements indexed by name.
			
feature -- Status setting

	register (an_element: G; a_name: STRING) is
			-- Register `an_element' with `a_name'
		require
			name_not_empty: a_name /= Void and then not a_name.is_empty
			element_exists: an_element /= Void
		do
			elements.force (an_element, a_name)
		ensure
			element_registered: has (a_name)
		end

invariant
	
	elements_exists: elements /= Void

end -- class GOA_REGISTRY

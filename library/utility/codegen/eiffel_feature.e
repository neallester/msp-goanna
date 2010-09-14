note
	description: "Objects that represent an Eiffel feature, either an attribute, function or procedure"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "Eiffel Code Generator"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

deferred class
	EIFFEL_FEATURE

inherit

	EIFFEL_CODE

feature -- Initialization

	make (new_name: STRING)
			-- Create a new Eiffel feature with 'name'
		require
			name_exists: new_name /= Void
		do
			set_name (new_name)
		end

feature -- Access

	name: STRING
			-- Name of feature.

feature -- Status setting

	set_name (new_name: STRING)
			-- Set feature name to 'name'
		require
			name_exists: new_name /= Void
		do
			name := new_name
		end

invariant

	name_exists: name /= Void

end -- class EIFFEL_FEATURE

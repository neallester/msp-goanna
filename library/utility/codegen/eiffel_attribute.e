note
	description: "Objects that represent Eiffel attributes"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "Eiffel Code Generator"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	EIFFEL_ATTRIBUTE

inherit
	EIFFEL_FEATURE
		rename
			make as feature_make
		end

create

	make

feature -- Initialization

	make (new_name, new_type: STRING)
			-- Create a new attribute
		require
			new_name_exists: new_name /= Void
			new_type_exists: new_type /= Void
		do
			feature_make (new_name)
			set_type (new_type)
		end

feature -- Access

	type: STRING
			-- The type of this attribute.

	value: STRING
			-- The value of this attribute. If not Void, then
			-- this attribute is constant.

feature -- Status setting

	set_type (new_type: STRING)
			-- Set the type of this attribute
		do
			type := new_type
		end

	set_value (new_value: STRING)
			-- Set the value of this attribute. Makes the attribute
			-- constant.
		do
			value := new_value
		end

feature -- Basic operations

	write (output: IO_MEDIUM)
			-- Print source code representation of this attribute on 'output'
		do
			output.put_string ("%T" + name + ": " + type)
			if value /= Void then
				output.put_string (" is " + value)
			end
			output.put_new_line
			output.put_new_line
		end

invariant

	type_exists: type /= Void

end -- class EIFFEL_ATTRIBUTE

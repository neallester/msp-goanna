note
	description: "A sequence of 16-bit units.";
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "Document Object Model (DOM) Core"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class DOM_STRING

inherit

	UC_STRING
--		rename
--			empty as is_empty
--		end

create

	make, make_from_string, make_from_utf8, make_from_ucstring

feature -- Initialisation

	make_from_ucstring (other: UC_STRING)
			-- Create a dom string from 'other'
		require
			other_exists: other /= Void
		local
			i: INTEGER
		do
			make (other.count)
			resize (other.count)
			from
				i := 1
			--variant
			--	other.count - i
			until
				i > other.count
			loop
				put_code(other.item_code(i), i)
				i := i + 1
			end
		ensure 
			same_size: count = other.count
		end

feature -- Status report

	length: INTEGER
			-- Number of 16-bit units in this string.
		do
			Result := count
		end
		
end -- class DOM_STRING

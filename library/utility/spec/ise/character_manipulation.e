indexing
	description: "Mixin class that provides portable character manipulation routines."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "Utility"
	date: "$Date: 2005-06-08 04:22:59 -0700 (Wed, 08 Jun 2005) $"
	revision: "$Revision: 423 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	CHARACTER_MANIPULATION

	obsolete "See 'obsolete' clause for individual routines"

feature -- Basic operations

	set_char_code (ch: CHARACTER_REF; code: INTEGER): CHARACTER is
			-- Set code of 'ch' to 'code'
		obsolete "Use int_to_char"
		require
			ch_exists: ch /= Void
		do

			Result := '%U' + code





		end
		
	int_to_char (code: INTEGER): CHARACTER is
			-- Convert int to character
		obsolete "Use Gobo's {KL_INTEGER_ROUTINES}.to_character"
		do

			Result := '%U' + code





		end

	char_to_lower (ch: CHARACTER): CHARACTER is
			-- Convert 'ch' to lower case.
		obsolete "Use Gobo's {KL_CHARACTER_ROUTINES}.as_lower"
		do

			Result := ch.lower





		end
	
end -- class CHARACTER_MANIPULATION

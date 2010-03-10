indexing
	description: "Mixin class that provides portable bit manipulation routines."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "Utility"
	date: "$Date: 2005-06-08 04:22:59 -0700 (Wed, 08 Jun 2005) $"
	revision: "$Revision: 423 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	BIT_MANIPULATION

obsolete "Use Gobo's KL_INTEGER_ROUTINES}"

feature -- Basic operations

	bit_shift_right (i, n: INTEGER): INTEGER is
			-- Shift the bits of 'i' right 'n' positions.
		do

			Result := i.bit_shift_right (n)









		end

	bit_shift_left (i, n: INTEGER): INTEGER is
			-- Shift the bits of 'i' left 'n' positions.
		do

			Result := i.bit_shift_left (n)









		end
	
	bit_and (i, n: INTEGER): INTEGER is
			-- Bitwise and of 'i' and 'n'
		do

			Result := i.bit_and (n)





		end
	
	bit_or (i, n: INTEGER): INTEGER is
			-- Bitwise or of 'i' and 'n'
		do

			Result := i.bit_or (n)





		end
		
end -- class BIT_MANIPULATION

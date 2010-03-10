indexing
	description: "Mixin class that provides portable string manipulation routines."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "Utility"
	date: "$Date: 2010-02-28 10:44:18 -0800 (Sun, 28 Feb 2010) $"
	revision: "$Revision: 628 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class GOA_STRING_MANIPULATION

inherit

	KL_IMPORTED_INTEGER_ROUTINES

feature -- Basic operations

	create_blank_buffer (size: INTEGER): STRING is
			-- Create a buffer string filled with blanks.
		require
			positive_size: size >= 0
		do
			create Result.make_filled (' ', size)
		ensure
			blank_buffer_exists: Result /= Void
			correct_size: Result.count = size
			blank_filled: Result.occurrences (' ') = size
		end
	
	index_of_char (str: STRING; char: CHARACTER; start: INTEGER): INTEGER is
			-- Position of first occurrence of `c' in `str' at or after `start';
			-- 0 if none.
		require
			str_exists: str /= Void
			start_large_enough: start >= 1
			start_small_enough: start <= str.count
		do
			Result := str.index_of (char, start)
		end
		
	clear_buffer (buffer: STRING) is
			-- Clear buffer of all characters
		require
			buffer_exists: buffer /= Void
		do
			buffer.wipe_out
		ensure
			empty: buffer.is_empty
		end
		
	is_buffer_full (buffer: STRING): BOOLEAN is
			-- Is 'buffer' full to capacity?
		require
			buffer_exists: buffer /= Void
		do















		end	
		
	last_index_of (str: STRING; c: CHARACTER; start_index_from_end: INTEGER): INTEGER is
			-- Position of last occurence of `c' in 'str'.
			-- 0 if none
		require
			str_exists: str /= Void
			start_index_small_enough: start_index_from_end <= str.count
			start_index_large_enough: start_index_from_end >= 1



















		ensure
			correct_place: Result > 0 implies str.item (Result) = c
		end
	
	prepend_character (c: CHARACTER; s: STRING) is
			-- Prepend 'c' to 's'
		require
			s_exists: s /= Void
		do






		ensure
			character_prepended: s.item (1).is_equal (c)
			s_one_char_longer: s.count = old s.count + 1
		end
	
	fill_blank (s: STRING) is
			-- Fill 's' with spaces
		require
			s_exists: s /= Void
		do






		ensure
			s_blank: s.occurrences (' ') = s.count
		end

	as_16_bit_string (i: INTEGER): STRING is
			-- i represented as two 256 bit characters
		local
			digit_1: INTEGER
		do
			Result := ""
			digit_1 := INTEGER_.bit_shift_right (i, 8)
			Result.extend (digit_1.to_character_8)
			Result.extend ((i - INTEGER_.bit_shift_left (digit_1, 8)).to_character_8)
		end

	as_32_bit_string (i: INTEGER): STRING is
			-- i represented as four 256 bit characters
		local
			digit_1, digit_2, digit_3: INTEGER
		do
			Result := ""
			digit_1 := INTEGER_.bit_shift_right (i, 24)
			Result.extend (digit_1.to_character_8)
			digit_2 := INTEGER_.bit_shift_right (i, 16)
			Result.extend ((digit_2 - INTEGER_.bit_shift_left (digit_1, 8)).to_character_8)
			digit_3 := INTEGER_.bit_shift_right (i, 8)
			Result.extend ((digit_3 - INTEGER_.bit_shift_left (digit_2, 8)).to_character_8)
			Result.extend ((i - INTEGER_.bit_shift_left (digit_3, 8)).to_character_8)
		end


end -- class GOA_STRING_MANIPULATION

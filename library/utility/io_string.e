note
	description: "Objects that allow input/output to a string object."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "Utility"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	IO_STRING

		-- TODO: This is not used by any GOA_ classes - maybe it vcan be deleted

inherit

	IO_MEDIUM
		undefine
			is_equal, 
			out, 
			copy
		redefine
			is_plain_text
		end
	
	STRING
		redefine
			make, 
			make_from_string
--			make_from_c, 
--			from_c,
--			from_c_substring
		end

create

	make, make_from_string
	--, make_from_c
	
feature {NONE} -- Initialization

	make (n: INTEGER)
			-- Allocate space for at least `n' characters.
		do
			Precursor (n)
			position := 1
		end

feature -- Initialization

	make_from_string (s: STRING)
			-- Initialize from the characters of `s'.
			-- (Useful in proper descendants of class STRING,
			-- to initialize a string-like object from a manifest string.)
		do
			Precursor (s)
			position := 1
		end		

--	make_from_c (c_string: POINTER) is
--			-- Initialize from contents of `c_string',
--			-- a string created by some external C function
--		do
--			Precursor (c_string)
--			position := 1
--		end
--
--	from_c (c_string: POINTER) is
--			-- Reset contents of string from contents of `c_string',
--			-- a string created by some external C function.
--		do
--			Precursor (c_string)
--			position := 1
--		end		
--	
--	from_c_substring (c_string: POINTER; start_pos, end_pos: INTEGER) is
--			-- Reset contents of string from substring of `c_string',
--			-- a string created by some external C function.
--		do
--			Precursor (c_string, start_pos, end_pos)
--			position := 1
--		end	
			
feature -- Access

	name: STRING
			-- Medium name
		once
			-- io strings do not have a name
			Result := ""
		end

	retrieved: ANY
			-- Retrieved object structure
			-- To access resulting object under correct type,
			-- use assignment attempt.
			-- Will raise an exception (code `Retrieve_exception')
			-- if content is not a stored Eiffel structure.
		do
			-- TODO: implement
		end

feature -- Element change

	basic_store (object: ANY)
			-- Produce an external representation of the
			-- entire object structure reachable from `object'.
			-- Retrievable within current system only.
		do
			-- TODO: implement	
		end
 
	general_store (object: ANY)
			-- Produce an external representation of the
			-- entire object structure reachable from `object'.
			-- Retrievable from other systems for same platform
			-- (machine architecture).
			--| This feature may use a visible name of a class written
			--| in the `visible' clause of the Ace file. This makes it
			--| possible to overcome class name clashes.
		do
			-- TODO: implement
		end
 
	independent_store (object: ANY)
			-- Produce an external representation of the
			-- entire object structure reachable from `object'.
			-- Retrievable from other systems for the same or other
			-- platform (machine architecture).
		do
			-- TODO: implement
		end
 
feature -- Status report

	handle: INTEGER = 0
			-- Handle to medium

	handle_available: BOOLEAN = True
			-- Is the handle available after class has been
			-- created?

	is_plain_text: BOOLEAN = True
			-- Is file reserved for text (character sequences)?

	exists: BOOLEAN = True
			-- Does medium exist?

	is_open_read: BOOLEAN = True
			-- Is this medium opened for input

	is_open_write: BOOLEAN = True
			-- Is this medium opened for output

	is_readable: BOOLEAN = True
			-- Is medium readable?

	is_executable: BOOLEAN = False
			-- Is medium executable?

	is_writable: BOOLEAN = True
			-- Is medium writable?

	readable: BOOLEAN = True
			-- Is there a current item that may be read?

	is_closed: BOOLEAN = False
			-- Is the I/O medium open

	support_storable: BOOLEAN = True
			-- Can medium be used to store an Eiffel object?

feature -- Status setting

	close
			-- Close medium.
		do
			-- do nothing	
		end

feature -- Output

	put_new_line, new_line
			-- Write a new line character to medium
		do
			append ("%R%N") -- TODO: find platform independant new line characters
		end

	put_string, putstring (s: STRING)
			-- Write `s' to medium.
		do
			append (s)
		end

	put_character, putchar (c: CHARACTER)
			-- Write `c' to medium.
		do
			append_character (c)	
		end

	put_real, putreal (r: REAL)
			-- Write `r' to medium.
		do
			append_real (r)
		end

	put_integer, putint (i: INTEGER)
			-- Write `i' to medium.
		do
			append_integer (i)
		end

	put_boolean, putbool (b: BOOLEAN)
			-- Write `b' to medium.
		do
			append_boolean (b)
		end

	put_double, putdouble (d: DOUBLE)
			-- Write `d' to medium.
		do
			append_double (d)
		end

feature -- Input

	read_real, readreal
			-- Read a new real.
			-- Make result available in `last_real'.
		do
			-- TODO: implement
		end
		

	read_double, readdouble
			-- Read a new double.
			-- Make result available in `last_double'.
		do
			-- TODO: implement
		end

	read_character, readchar
			-- Read a new character.
			-- Make result available in `last_character'.
		do
			-- TODO: implement
		end

	read_integer, readint
			-- Read a new integer.
			-- Make result available in `last_integer'.
		do
			-- TODO: implement
		end

	read_stream, readstream (nb_char: INTEGER)
			-- Read a string of at most `nb_char' bound characters
			-- or until end of medium is encountered.
			-- Make result available in `last_string'.
		do
			-- TODO: implement
		end

	read_line, readline
			-- Read characters until a new line or
			-- end of medium.
			-- Make result available in `last_string'.
		do
			-- TODO: implement
		end;

	-- TODO: redefine those features that can resize a string and reposition the
	-- index accordingly. 
	
feature -- Output

	to_string: STRING
			-- Printable representation
		do
			Result ?= Current
		end
		
feature {NONE} -- Implementation

	position: INTEGER
			-- Current read position.
			
end -- class IO_STRING

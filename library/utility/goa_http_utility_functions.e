indexing
	description: "Mixin class of HTTP utility functions"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "HTTP Servlet API"
	date: "$Date: 2007-06-15 07:03:27 -0700 (Fri, 15 Jun 2007) $"
	revision: "$Revision: 581 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class GOA_HTTP_UTILITY_FUNCTIONS

	-- TODO: this class might be replaceable by UT_URL_ENCODING

inherit

	UT_STRING_FORMATTER
		export
			{NONE} all
		end

	KL_IMPORTED_INTEGER_ROUTINES

	KL_IMPORTED_CHARACTER_ROUTINES

feature -- Basic operations

	decode_url (url: STRING): STRING is
			-- Decode a urlencoded string by replacing '+' with space ' ',
	     	-- and "%xx" to the Latin1 character specified by the hex digits
	     	-- "xx".  The input string is assumed to have been broken up into
		 	-- either a key or a value pair, so '=', '?', and '&' are not
	     	-- treated as separators.
		local
			i, hi, lo, dec: INTEGER
			ch: CHARACTER
		do
			create Result.make (url.count)
			from
				i := 1
			until
				i > url.count
			loop
				ch := url.item (i)
				inspect
					ch
				when '+' then
					Result.append_character (' ')
				when '%%' then
					if i <= (url.count - 2) then
						hi := digit_from_hex (url.item (i + 1))
						lo := digit_from_hex (url.item (i + 2))
						if hi < 0 or lo < 0 then
							Result.append_character (ch)
						else
							dec := INTEGER_.bit_shift_left (hi, 4) + lo
							Result.append_character (INTEGER_.to_character (dec)) -- -1
						end
							i := i + 2
					else
						Result.append_character (ch)
					end
				else
					Result.append_character (ch)
				end
				i := i + 1
			end
		ensure
			result_exists: Result /= Void
		end

	encode (str: STRING): STRING is
			-- Translate 'str' into HTML safe format.
		require
			str_exists: str /= Void
		local
			i: INTEGER
		do
			create Result.make (str.count)
			from
				i := 1
			until
				i > str.count
			loop
				inspect str.item (i)
				when ' ' then
			 		Result.append_string ("+")
				when '<' then
					Result.append_string ("&lt;")
				when '>' then
					Result.append_string ("&gt;")
				when '&' then
					Result.append_string ("&amp;")
				when '%'' then
					Result.append_string ("&#39;")
				when '"' then
					Result.append_string ("&quot;")
				when '\' then
					Result.append_string ("&#92;")
				when '%/205/' then
					Result.append_string ("&#133;")
				else
					Result.append_character (str.item (i))
				end
				i := i + 1
			end
		ensure
			result_exists: Result /= Void
		end

	digit_from_hex (ch: CHARACTER): INTEGER is
			-- Return the integer representation of the hexadecimal character 'ch'
		require
			hex_character: (ch >= '0' and ch <= '9') or (ch >= 'A' and ch <= 'F') or (ch >= 'a' and ch <= 'f')
		do
			if (ch >= '0' and ch <= '9') then
				Result := ch.out.to_integer
			else
				Result := CHARACTER_.as_lower (ch).code - 87
			end
		end

end -- class GOA_HTTP_UTILITY_FUNCTIONS

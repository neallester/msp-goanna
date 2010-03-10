indexing
	description: "Objects that encode and decode Base64 (RFC1521) strings."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "Utility"
	date: "$Date: 2006-11-23 08:38:55 -0800 (Thu, 23 Nov 2006) $"
	revision: "$Revision: 518 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class GOA_BASE64_ENCODER

inherit

	KL_IMPORTED_INTEGER_ROUTINES

	KL_STRING_ROUTINES
		export
			{NONE} all
		end

feature -- Basic operations

	encode (data: STRING): STRING is
			-- Base64 encode 'data'
		require
			data_exists: data /= Void
		do
			Result := perform_encoding (data, base_64_chars)
		ensure
			encoded_exists: Result /= Void
		end

	encode_for_session_key (data: STRING): STRING is
			-- Base64 encode 'data' with a modified Base64 character
			-- set that is suitable for use as a session key and for
			-- transmission as a cookie value.
		require
			data_exists: data /= Void
		do
			Result := perform_encoding (data, session_key_chars)
		ensure
			encoded_exists: Result /= Void
		end

	decode (data: STRING): STRING is
			-- Base64 encode 'data'
		require
			data_exists: data /= Void
		do
			Result := perform_decoding (data, base_64_chars)
		ensure
			decoded_exists: Result /= Void
		end

feature {NONE} -- Implementation

	base_64_chars: ARRAY [CHARACTER] is
			-- The BASE64 encoding standard's 6-bit alphabet, from RFC 1521,
     		-- plus the padding character at the end.
     	once
     		Result := <<
   				'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H',
				'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
				'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',
				'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
				'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n',
				'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
				'w', 'x', 'y', 'z', '0', '1', '2', '3',
				'4', '5', '6', '7', '8', '9', '+', '/',
				'='
        	>>
        ensure
        	sixty_five_chars: Result.count = 65
        end

	session_key_chars: ARRAY [CHARACTER] is
			-- Encoding alphabet for session keys. Contains only chars that
			-- are safe to use in cookies, URLs and file names. Same as BASE64
			-- except the last two chars and the padding char
     	once
     		Result := <<
   				'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H',
				'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
				'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',
				'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
				'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n',
				'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
				'w', 'x', 'y', 'z', '0', '1', '2', '3',
				'4', '5', '6', '7', '8', '9', '_', '-',
				'.'
        	>>
        ensure
        	sixty_five_chars: Result.count = 65
        end

	codes: ARRAY [INTEGER] is
			-- Decoding codes
		local
			i: INTEGER
		once
			create Result.make (0, 255)
			from i := 0
			until i > 255
			loop
				Result.put (-1, i)
				i := i + 1
			end
			from i := ('A').code
			until i > ('Z').code
			loop
				Result.put (i - ('A').code, i)
				i := i + 1
			end
			from i := ('a').code
			until i > ('z').code
			loop
				Result.put (26 + i - ('a').code, i)
				i := i + 1
			end
			from i := ('0').code
			until i > ('9').code
			loop
				Result.put (52 + i - ('0').code, i)
				i := i + 1
			end
			Result.put (62, ('+').code)
			Result.put (63, ('/').code)
		end

	perform_encoding (data: STRING; chars: ARRAY [CHARACTER]): STRING is
			-- Encode 'data' using characters in 'char_set'.
		require
			data_exists: data /= Void
			char_set_exists: chars /= Void
 		local
 			quad, trip: BOOLEAN
 			i, index, val: INTEGER
 		do
			Result := make_buffer (((data.count + 2) // 3) * 4)
 			from
 				i := 1
 				index := 1
 			until
 				i > data.count
 			loop
 				quad := False
 				trip := False
 				val := INTEGER_.bit_and (255, data.item (i).code)
 				val := INTEGER_.bit_shift_left (val, 8)
 				if i + 1 <= data.count then
 					val := INTEGER_.bit_or (val, INTEGER_.bit_and (255, data.item (i + 1).code))
 					trip := True
 				end
 				val := INTEGER_.bit_shift_left (val, 8)
 				if i + 2 <= data.count then
 					val := INTEGER_.bit_or (val, INTEGER_.bit_and (255, data.item (i + 2).code))
 					quad := True
 				end
 				if quad then
 					Result.put (chars.item (INTEGER_.bit_and (val, 63) + 1), index + 3)
 				else
 					Result.put (chars.item (65), index + 3)
 				end
 				val := INTEGER_.bit_shift_right (val, 6)
 				if trip then
 					Result.put (chars.item (INTEGER_.bit_and (val, 63) + 1), index + 2)
 				else
 					Result.put (chars.item (65), index + 2)
 				end
 				val := INTEGER_.bit_shift_right (val, 6)
 				Result.put (chars.item (INTEGER_.bit_and (val, 63) + 1), index + 1)
 				val := INTEGER_.bit_shift_right (val, 6)
 				Result.put (chars.item (INTEGER_.bit_and (val, 63) + 1), index)

 				i := i + 3
 				index := index + 4
	 		end
 		ensure
			encoded_string_exists: Result /= Void
 		end

	perform_decoding (data: STRING; chars: ARRAY [CHARACTER]): STRING is
			-- Decode 'data' using characters in 'char_set'.
		require
			data_exists: data /= Void
			char_set_exists: chars /= Void
 		local
 			len, shift, accum, index, ix, value: INTEGER
 		do
 			len := ((data.count + 3) // 4) * 3
 			if data.count > 0 and data.item (data.count) = '=' then
 				len := len - 1
 			end
 			if data.count > 1 and data.item (data.count - 1) = '=' then
 				len := len - 1
 			end
 			Result := make_buffer (len)
 			from
 				ix := 1
 				index := 1
 			until
 				ix > data.count
 			loop
 				value := codes.item (INTEGER_.bit_and (data.item (ix).code, 255))
 				if value >= 0 then
 					accum := INTEGER_.bit_shift_left (accum, 6)
 					shift := shift + 6
 					accum := INTEGER_.bit_or (accum, value)
 					if shift >= 8 then
 						shift := shift - 8
 						Result.put (INTEGER_.to_character (INTEGER_.bit_and (INTEGER_.bit_shift_right (accum, shift), 255)), index)
 						index := index + 1
 					end
 				end
 				ix := ix + 1
 			end
 			check
 				data_length_correct: index - 1 = Result.count
 			end
 		ensure
			decoded_string_exists: Result /= Void
 		end

end -- class GOA_BASE64_ENCODER

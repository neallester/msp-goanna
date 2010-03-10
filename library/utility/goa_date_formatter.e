indexing
	description: "Objects that format date time objects for display."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "datetime"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class GOA_DATE_FORMATTER

feature -- Transformation

	format_fixed_variant (date: DT_DATE_TIME): STRING is
			-- Format 'date' using the long display format.
			-- ie, "Wdy, DD-Mon-YY HH:MM:SS GMT".
			-- This format is suitable for cookie expiry dates.
			-- Will always display GMT timezone.
		require
			date_exists: date /= Void
		local
			century: STRING
		do
			create Result.make (27)
			-- weekday
			Result.append_string (short_weekdays.item (date.day_of_week.code))
			Result.append_string (", ")
			-- date
			Result.append_string (zero_fill (date.day.out, 2))
			Result.append_character ('-')
			Result.append_string (short_months.item (date.month + 1))
			Result.append_character ('-')
			century := date.year.out
			century.keep_tail (2)
			Result.append_string (century)
			-- time
			Result.append_character (' ')
			Result.append_string (zero_fill (date.hour.out, 2))
			Result.append_character (':')
			Result.append_string (zero_fill (date.minute.out, 2))
			Result.append_character (':')
			Result.append_string (zero_fill (date.second.out, 2))
			-- timezone
			Result.append_string (" GMT")
		ensure
			formatted_date_exists: Result /= Void
		end
		
	format_compact_sortable (date: DT_DATE_TIME): STRING is
			-- Format suitable for string sorting.
			-- ie, YYYYMMDDHHMMSS
		require
			date_exists: date /= Void
		do
			create Result.make (14)
			Result.append_string (date.year.out)
			Result.append_string (zero_fill (date.month.out, 2))
			Result.append_string (zero_fill (date.day.out, 2))
			Result.append_string (zero_fill (date.hour.out, 2))
			Result.append_string (zero_fill (date.minute.out, 2))
			Result.append_string (zero_fill (date.second.out, 2))
		ensure
			formatted_date_exists: Result /= Void
		end
		
feature {NONE} -- Implementation

	short_weekdays: ARRAY [STRING] is 
			-- Short names for weekdays beginning at Sunday.
		once
			Result := << "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat" >>
		ensure
			seven_days: Result.count = 7
		end	
	
	short_months: ARRAY [STRING] is
			-- Short names for months.
		once
			Result := << "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug",
				"Sep", "Oct", "Nov", "Dec" >>
		ensure
			twelve_months: Result.count = 12
		end
	
	zero_fill (value: STRING; length: INTEGER): STRING is
			-- Extend 'value' to 'length' and pad with
			-- zeros on left if required.
		require
			valid_exists: value /= Void
			valid_length: length >= value.count
		local
			pad_chars, i: INTEGER
		do
			pad_chars := length - value.count
			create Result.make (pad_chars)
			from
				i := 1
			until
				i > pad_chars
			loop
				Result.append_character ('0')
				i := i + 1
			end
			Result.append_string (value)
		ensure
			correct_length: Result.count = length
		end
		
end -- class GOA_DATE_FORMATTER

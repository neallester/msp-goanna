indexing
	description: "Objects that integer objects for display."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "utility"
	date: "$Date: 2005-06-11 12:39:50 -0700 (Sat, 11 Jun 2005) $"
	revision: "$Revision: 427 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	INTEGER_FORMATTER

		-- TODO: this needs VE version

feature -- Transformation

	zero_fill (value, length: INTEGER): STRING is
			-- Convert 'value' to a string and zero fill to 'length'.
			-- Truncate right if the result will not fit in 'length'.
		require
			positive_length: length > 0



































note
	description: "Objects that log messages for a particular facility"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "logging"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	LOG_CHANNEL

obsolete "Use log4e instead"

inherit

	LOG_LEVELS
	
	DT_SHARED_SYSTEM_CLOCK
		export
			{NONE} all
		end
	
	KL_STANDARD_FILES
		rename
			Error as Output_error
		export
			{NONE} all
		end
	
	KL_OUTPUT_STREAM_ROUTINES
		export
			{NONE} all;
			{ANY} is_open_write
		end

create
	make

feature -- Initialization

	make (medium: like sink)
			-- Create new log channel to write to 'medium'
		require
			medium_exists: medium /= Void
			medium_open_write: is_open_write (medium)
		do
			sink := medium 
			set_filter (Emergency, Debug9)
		end
	
	make_filter (medium: like sink; min_level, max_level: INTEGER)
			-- Create a new log channel to write log message with level between
			-- 'min_level' and 'max_level' to 'medium'.
		require
			medium_exists: medium /= Void
			medium_open_write: is_open_write (medium)
			valid_log_filter: valid_log_level (min_level) 
				and valid_log_level (max_level)
				and min_level <= max_level
		do
			sink := medium
			set_filter (min_level, max_level)
		end
					
feature -- Status setting

	set_filter (min_level, max_level: INTEGER)
			-- Set log level filter to 'min_level' and 'max_level'.
		require
			valid_log_filter: valid_log_level (min_level) 
				and valid_log_level (max_level)
				and min_level <= max_level
		do
			min_filter := min_level
			max_filter := max_level
		end

	write (level: INTEGER; message: STRING)
			-- Write 'message' at log level 'level' to output medium.
		require
			valid_log_level: valid_log_level (level)
			message_exists: message /= Void
		do
			if level >= min_filter and level <= max_filter then
				sink.put_string (format (level, message))
				sink.put_string ("%R%N")
			end
		end
		
feature {NONE} -- Implementation
	
	sink: like OUTPUT_STREAM_TYPE
			-- The sink to write messages to
		
	min_filter, max_filter: INTEGER
			-- Log level filter range.
	
	format (level: INTEGER; message: STRING): STRING
			-- Format the message for logging
		local
			date: DT_DATE_TIME
		do
			create Result.make (100)
			date := system_clock.date_time_now
			Result.append (date.out)
			Result.append (" (" + log_level_name (level) + "): ")
			Result.append (message)
		end
					
end -- class LOG_CHANNEL

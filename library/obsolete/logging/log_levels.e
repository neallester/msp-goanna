note
	description: "Objects that define log level constants"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "logging"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	LOG_LEVELS

obsolete "Use log4e instead"

feature -- Log levels

	Emergency: INTEGER = 0
		-- Urgent condition that requires immediate attention and indicates
		-- that the system is no longer functioning.
			
	Alert: INTEGER = 1
		-- A condition that should be corrected immediately.
		
	Critical: INTEGER = 2
		-- Critical conditions.
		
	Error: INTEGER = 3
		-- Errors that have been correctly handled.
		
	Warning: INTEGER = 4
		-- Warning messages.
		
	Notice: INTEGER = 5
		-- Conditions that are not error conditions, but should possibly be
		-- handled specially.
		
	Info: INTEGER = 6
		-- Informational messages
		
	Debug0: INTEGER = 7
		-- Messages that contain information normally of use only when debugging.
		-- This is the basic level of debugging. Levels Debug1 through Debug9
		-- are defined to allow more debugging messages.
		
	Debug1: INTEGER = 8
	Debug2: INTEGER = 9
	Debug3: INTEGER = 10
	Debug4: INTEGER = 11
	Debug5: INTEGER = 12
	Debug6: INTEGER = 13
	Debug7: INTEGER = 14
	Debug8: INTEGER = 15
	Debug9: INTEGER = 16
	
	Debugtmp: INTEGER = 17
		-- Temporary debugging; should be contained within a debug statement so that
		-- it is not left in shipped code.
		
	log_level_name (level: INTEGER): STRING
			-- Symbolic name for log 'level'.
		require
			valid_log_level: valid_log_level (level)
		do
			Result := symbolic_log_level_names.item (level + 1)	
		end
	
	valid_log_level (level: INTEGER): BOOLEAN
			-- Is 'level' a valid log level?
		do
			Result := level >= 0 and level <= Debugtmp
		end
		
feature {NONE} -- Implementation

	symbolic_log_level_names: ARRAY [STRING]
			-- Symbolic names for log levels.
		once
			Result := << "EMERGENCY", "ALERT", "CRITICAL", "ERROR", "WARNING", "NOTICE", "INFO",
				"DEBUG", "DEBUG1", "DEBUG2", "DEBUG3", "DEBUG4", "DEBUG5", "DEBUG6", 
				"DEBUG7", "DEBUG8", "DEBUG9", "DEBUGTMP" >>
		end
				        
end -- class LOG_LEVELS

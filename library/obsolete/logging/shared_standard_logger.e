indexing
	description: "Objects that provide shared access to a standard logger"

class
	SHARED_STANDARD_LOGGER

obsolete "Use log4e instead"

inherit
	
	LOG_LEVELS
	
feature -- Access

	Logger: LOGGER is
			-- Shared logger
		local
			std_logger: STANDARD_LOGGER
		once
			create std_logger.make ("log.txt")
			Result := std_logger
		end
	
	Standard_facility: STRING is "general"
			-- Standard logging facility	
	
	log (level: INTEGER; message: STRING) is
			-- Log 'message' at 'level' to the standard logger.
			-- Convenience routine.
		require
			valid_log_level: valid_log_level (level)
			message_exists: message /= Void
		do
			Logger.channel (Standard_facility).write (level, message)
		end
		
end -- class SHARED_STANDARD_LOGGER

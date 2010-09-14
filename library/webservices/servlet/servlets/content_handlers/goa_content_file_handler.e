note
	description: "Generic content file handler"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "tools httpd"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

deferred class GOA_CONTENT_FILE_HANDLER

inherit
	
	GOA_CONTENT_TYPES
		export
			{NONE} all;
			{ANY} First_content_type, Last_content_type
		end

	GOA_HTTP_STATUS_CODES
		export
			{NONE} all
		end

	GOA_STRING_MANIPULATION
		export
			{NONE} all
		end
	
feature -- Basic operations

	service (file_name: STRING; content_type_code: INTEGER;
		req: GOA_HTTP_SERVLET_REQUEST; resp: GOA_HTTP_SERVLET_RESPONSE)
			-- Service the file request for the specified 'file_name' and
			-- 'content_type_code'. Send the file to 'resp'.
		require
			file_name_exists: file_name /= Void
			valid_content_type: content_type_code >= First_content_type 
				and content_type_code <= Last_content_type
			request_exists: req /= Void
			response_exists: resp /= Void
		deferred	
		end
			
feature {NONE} -- Implemtation

	buffer : STRING
		once
			Result := create_blank_buffer (4 * 1024) -- 4KB initially
		end
	
end -- class GOA_CONTENT_FILE_HANDLER

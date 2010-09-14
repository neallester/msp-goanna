note
	description: "Binary content file handler"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "tools httpd"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class GOA_BINARY_CONTENT_FILE_HANDLER

inherit

	GOA_CONTENT_FILE_HANDLER
	
feature -- Basic operations

	service (file_name: STRING; content_type_code: INTEGER;
		req: GOA_HTTP_SERVLET_REQUEST; resp: GOA_HTTP_SERVLET_RESPONSE)
			-- Service the file request for the specified 'file_name' and
			-- 'content_type_code'. Send the file to 'resp'.
			--| There is currently no difference between this method and
			--| the equivalent method in TEXT_CONTENT_FILE_HANDLER
		local
			file: KL_BINARY_INPUT_FILE
		do
			create file.make (file_name)
			file.open_read
			-- This is really inefficient because the whole file has
			-- to be read into memory. I had to do it this way because 
			-- I couldn't find a portable way to get the file.count to
			-- set the content length earlier
			from
				buffer.wipe_out
			until
				file.end_of_input
			loop
				file.read_string (Max_raw_chunk)
				buffer.append_string (file.last_string)
			end
			file.close	
			-- setup response
			resp.set_content_type (content_types.item (content_type_code))
			resp.set_content_length (buffer.count)
			resp.set_status (Sc_ok)
			-- write file data to response
			resp.send (buffer)
		end
		
feature {NONE} -- Implementation

	Max_raw_chunk : INTEGER = 8192

end -- class GOA_BINARY_CONTENT_FILE_HANDLER

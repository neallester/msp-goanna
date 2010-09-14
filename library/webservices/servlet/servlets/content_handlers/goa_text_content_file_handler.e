note
	description: "Text content file handler"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "tools httpd"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class GOA_TEXT_CONTENT_FILE_HANDLER

inherit

	GOA_CONTENT_FILE_HANDLER
		
feature -- Basic operations

	service (file_name: STRING; content_type_code: INTEGER;
		req: GOA_HTTP_SERVLET_REQUEST; resp: GOA_HTTP_SERVLET_RESPONSE)
			-- Service the file request for the specified 'file_name' and
			-- 'content_type_code'. Send the file to 'resp'.
			--| There is currently no difference between this method and
			--| the equivalent method in BINARY_CONTENT_FILE_HANDLER
		local
			file: KL_TEXT_INPUT_FILE
		do
			debug
				print ("Entered text_content_file_handler%N")
			end
			create file.make (file_name)
			-- This is really inefficient because the whole file has
			-- to be read into memory. I had to do it this way because 
			-- I couldn't find a portable way to get the file.count to
			-- set the content length earlier
			debug
				print ("Created file%N")
			end			
			from
				buffer.wipe_out
				file.open_read
			until
				file.end_of_file
			loop
				debug
					print ("About to read a line%N")
				end				
				file.read_string (Max_line_length)
				debug
					print ("Read line from " + file_name + ", was: " + file.last_string + "%N")
				end
				buffer.append_string (file.last_string)
			end
			file.close	
			-- setup response
			debug
				print ("About to set headers%N")
			end
			resp.set_content_type (content_types.item (content_type_code))
			resp.set_content_length (buffer.count)
			resp.set_status (Sc_ok)
			-- write file data to response
			debug
				print ("About to send response%N")
			end
			resp.send (buffer)
		end
		
feature {NONE} -- Implementation

	Max_line_length : INTEGER = 1024

end -- class GOA_TEXT_CONTENT_FILE_HANDLER

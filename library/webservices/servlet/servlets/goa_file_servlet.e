note
	description: "Generic File servlet for serving standard HTTP file requests"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "tools httpd"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@user.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class GOA_FILE_SERVLET

inherit

	GOA_HTTP_SERVLET
		redefine
			do_get, do_post
		end

	UT_STRING_FORMATTER
		export
			{NONE} all
		end
	
	GOA_HTTP_STATUS_CODES
		export
			{NONE} all
		end
		
	GOA_CONTENT_TYPES
		export
			{NONE} all
		end

create

	init
	
feature -- Basic operations

	do_get (req: GOA_HTTP_SERVLET_REQUEST; resp: GOA_HTTP_SERVLET_RESPONSE)
			-- Process GET request
		local
			file_name, file_extension, file_path, s: STRING
			ctype_code: INTEGER
			final_slash: BOOLEAN
		do
			file_name := clone (servlet_config.document_root)
			final_slash := file_name.substring(file_name.count, file_name.count).is_equal ("/")
			debug
				print ("Document root ends with slash? " + final_slash.out + "%N")
			end
			s := req.path_info
			if file_servlet_name /= Void and then
				s.substring(2, file_servlet_name.count + 1).is_equal(file_servlet_name)
			 then
				debug
					print ("path_info starts with file_servlet_name preceded by /")
				end
				if
					final_slash
				 then
					s.keep_tail (s.count - file_servlet_name.count - 2)
				else
					s.keep_tail (s.count - file_servlet_name.count - 1)
				end
			end
			create file_path.make_from_string (s)
			file_name.append_string (file_path)
			debug
				print ("File_servlet_name is " + file_servlet_name + "%N")
				print ("File_servlet_name count is " + file_servlet_name.count.out + "%N")
				print ("File path is: " + file_path + "%N")
				print ("S is: " + s + "%N")
				print ("Full file name is: " + file_name + "%N")
				print ("File name is: " + req.path_translated + "%N")
				print ("Path name is: " + req.path_info + "%N")
				print ("Servlet path is: " + req.servlet_path + "%N")
			end
			if exists (file_name) then
				debug
					print ("File found - using " + file_name + "%N")
				end
				file_extension := extension (req.path_info)
				if content_type_codes.has (file_extension) then
					ctype_code := content_type_codes.item (file_extension)
				else
					-- assume html
					ctype_code := Content_type_text_html
				end
				debug
					print ("About to call content handler for content type " + ctype_code.out + "%N")
				end
				content_type_handlers.item (ctype_code).service (file_name, ctype_code, req, resp)
			else
				resp.send_error (Sc_not_found)
			end

		end
	
	do_post (req: GOA_HTTP_SERVLET_REQUEST; resp: GOA_HTTP_SERVLET_RESPONSE)
			-- Process GET request
		do
			do_get (req, resp)
		end

feature -- Status Report

	file_servlet_name: STRING
			-- Qualified name of servlet, including  servlet_mapping_prefix.

feature -- Status setting

	set_name (nm: STRING)
			-- Set qualified name of servlet.
		require
			valid_name: nm /= Void and then nm.count > 0
		do
			file_servlet_name := nm
		ensure
			set: file_servlet_name.is_equal (nm)
		end
	
feature {NONE} -- Implementation
	
	content_type_handlers: ARRAY [GOA_CONTENT_FILE_HANDLER]
			-- Array of handlers for content type files
		local
			text_file_handler: GOA_TEXT_CONTENT_FILE_HANDLER
			binary_file_handler: GOA_BINARY_CONTENT_FILE_HANDLER
		once
			create text_file_handler
			create binary_file_handler
			create Result.make (First_content_type, Last_content_type)
			Result.put (text_file_handler, Content_type_text_html)
			Result.put (text_file_handler, Content_type_text_xml)
			Result.put (text_file_handler, Content_type_text_css)
			Result.put (text_file_handler, Content_type_text_xsl)
			Result.put (text_file_handler, Content_type_text_rtf)
			Result.put (binary_file_handler, Content_type_image_gif)
			Result.put (binary_file_handler, Content_type_image_jpeg)
			Result.put (binary_file_handler, Content_type_image_png)
			Result.put (binary_file_handler, Content_type_image_tiff)
		end	
		
	exists (file_name: STRING): BOOLEAN
			-- Does a file named 'file_name' exists and is it readable?
			--| Not called file_exists because a SmallEiffel developer thought
			--| it was a good idea to put file manipulation routines in GENERAL!
		local
			file: KL_TEXT_INPUT_FILE
		do
			create file.make (file_name)
			file.open_read
			Result := file.is_open_read
			if file.is_open_read then
				file.close
			end
		end
		
end -- class GOA_FILE_SERVLET

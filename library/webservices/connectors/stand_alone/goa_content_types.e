note
	description: "Content type information"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "tools httpd"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class GOA_CONTENT_TYPES

feature -- Access


	Content_type_text_html: INTEGER = 1
	Content_type_text_xml: INTEGER = 2
	Content_type_text_css: INTEGER = 3
	Content_type_text_xsl: INTEGER = 4
	Content_type_text_rtf: INTEGER = 5
	Content_type_image_gif: INTEGER = 6
	Content_type_image_jpeg: INTEGER = 7
	Content_type_image_png: INTEGER = 8
	Content_type_image_tiff: INTEGER = 9
	
	First_content_type: INTEGER = 1
	Last_content_type: INTEGER = 9
	
	content_type_codes: DS_HASH_TABLE [INTEGER, STRING]
			-- Table of content type codes. Codes map into content_types table
		once
			create Result.make (30) 
			Result.force (Content_type_text_html, "html")
			Result.force (Content_type_text_html, "htm")
			Result.force (Content_type_text_xml, "xml")
			Result.force (Content_type_text_css, "css")
			Result.force (Content_type_text_xsl, "xsl")
			Result.force (Content_type_text_rtf, "rtf")
			Result.force (Content_type_image_gif, "gif")
			Result.force (Content_type_image_jpeg, "jpeg")
			Result.force (Content_type_image_jpeg, "jpg")
			Result.force (Content_type_image_png, "png")
			Result.force (Content_type_image_tiff, "tiff")
		end

	content_types: ARRAY [STRING]
			-- Table of content types indexed by code.
		once
			create Result.make (First_content_type, Last_content_type) 
			Result.put ("text/html", Content_type_text_html)
			Result.put ("text/xml", Content_type_text_xml)
			Result.put ("text/css", Content_type_text_css)
			Result.put ("text/xsl", Content_type_text_xsl)
			Result.put ("text/rtf", Content_type_text_rtf)
			Result.put ("image/gif", Content_type_image_gif)
			Result.put ("image/jpeg", Content_type_image_jpeg)
			Result.put ("image/png", Content_type_image_png)
			Result.put ("image/tiff", Content_type_image_tiff)
		end
			
	extension (uri: STRING): STRING
			-- extract extention from a URI
		local
			i: INTEGER
		do
			-- going from the end find the position of the "."
			from
				i := uri.count
			until
				i = 0 or else uri.item (i) = '.'
			loop
				i := i - 1
			end
			Result := uri.substring (i + 1, uri.count)
		end

end	-- class GOA_CONTENT_TYPES

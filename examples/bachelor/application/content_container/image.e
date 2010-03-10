indexing
	description: "Objects that represent image Content"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/05/10"
	revision: "$Revision: 491 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	IMAGE

inherit
	TEXT_CONTAINER
		rename
			make as text_container_make
		undefine
			html_element, html_begin_element, html_end_element

		end
	ALIGNABLE
		export {NONE}
			set_center
		end

creation

	make_from_user

feature {PAGE} -- Attributes

	file_name : STRING
		-- The file name (with extension) of the image file

	directory : STRING
		-- The subdirectory containing the image

feature {PAGE_FACTORY, PAGE, USER} -- Attribute Setting

	set_file_name (new_file_name : STRING) is
		-- Set new file_name for image (include extension)
		require
			valid_new_file_name : new_file_name /= Void
		do
			file_name := new_file_name
		ensure
			file_name_updated : file_name = new_file_name
		end

feature {NONE} -- Creation

	make_from_user (user : USER) is
		-- Create the image
		require
			valid_user : user /= Void
		do
			directory := user.preference.image_location
			file_name := ""
			text_container_make
		ensure
			directory_set : directory = user.preference.image_location
		end

feature -- Implementation

	html_begin_element : STRING is ""

	html_end_element : STRING is ""

	html_element : STRING is
		do
			result := "<IMG SRC=%"" + web_server_url + "/" + directory + "/" + file_name + "%""
			if not text.empty then
				result := result + " ALT=%"" + text + "%""
			end
			result := result + html_alignment
			result := result + ">" + new_line
		end		

invariant
	valid_directory : directory /= Void
	valid_file_name : file_name /= Void
	valid_text : text /= Void
	not_centered : alignment_code /= center

end -- class IMAGE

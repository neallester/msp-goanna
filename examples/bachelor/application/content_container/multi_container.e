note
	description: "content_containers that contain one or more content_containers"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/05/10"
	revision: "$Revision: 491 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	MULTI_CONTAINER

inherit
	CONTENT_CONTAINER
		undefine
			make, is_equal, copy
		redefine
			html_element
		end
	LINKED_LIST [CONTENT_CONTAINER]
		rename
			force as linked_list_force
		export {NONE}
			all
		end

create

	make

feature

	html_begin_element : STRING
		do
			result := ""
		end

	html_end_element : STRING
		do
			result := ""
		end

	html_element : STRING
		do
			result := ""
			from
				start
			until
				after
			loop
				result := result + item.html_code
				forth
			end
		end

feature {PAGE, PAGE_FACTORY, CONTENT_CONTAINER, TOPIC, USER}

	force (new_container : CONTENT_CONTAINER)
		-- Add a new content container
		require
			valid_new_container : new_container /= Void
		do
			linked_list_force (new_container)
		ensure
			has (new_container)
		end


end -- class MULTI_CONTAINER
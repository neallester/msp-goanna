indexing
	description: "Unique strings for use as User File Names"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/05/11"
	revision: "$Revision: 491 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class

	USER_FILE_NAME_FACTORY

inherit

	UNIQUE_STRING_SEQUENCE

create
	make

feature -- Implement deferred features

	storage_file_name : STRING is
		do
			result := user_file_name_file
		end

end -- class USER_FILE_NAME_FACTORY

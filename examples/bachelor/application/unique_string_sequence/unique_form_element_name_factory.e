note
	description: "Creates form element names"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/05/11"
	revision: "$Revision: 491 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	UNIQUE_FORM_ELEMENT_NAME_FACTORY

inherit
	
	UNIQUE_STRING_SEQUENCE

create
	
	make

feature 

	storage_file_name : STRING
		once
			Result := unique_form_element_name_factory_file_name
		end

end -- class UNIQUE_FORM_ELEMENT_NAME_FACTORY

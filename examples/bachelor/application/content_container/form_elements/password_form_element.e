indexing
	description: "Objects that accept passwords as input"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/05/11"
	revision: "$Revision: 491 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	PASSWORD_FORM_ELEMENT

inherit
	STRING_FORM_ELEMENT
		redefine
			type
		end

creation

	make_form_element

feature

	type : STRING is
		do
			result := "PASSWORD"
		end

end -- class PASSWORD_FORM_ELEMENT

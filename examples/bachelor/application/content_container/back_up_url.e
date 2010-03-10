indexing
	description: "A dynamic URL that indicates the user would like to back up to the previous page in the factory sequence"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/05/10"
	revision: "$Revision: 491 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	BACK_UP_URL

inherit
	DYNAMIC_URL
		redefine
			make
		end

feature

	make (client_page : PAGE ; new_processor : PROCEDURE [PAGE_SEQUENCE_ELEMENT, TUPLE]; new_text : STRING) is
		do
			back_up := True
			precursor (client_page, new_processor, new_text)
		end

invariant

	back_up : back_up

end -- class BACK_UP_URL

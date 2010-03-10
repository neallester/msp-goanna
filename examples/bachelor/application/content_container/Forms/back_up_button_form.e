indexing
	description: "Forms consisting of one back-up button"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/05/10"
	revision: "$Revision: 491 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	BACK_UP_BUTTON_FORM

inherit
	BUTTON_FORM
		select
			url_make
		end
	BACK_UP_URL
		rename
			make as back_up_url_make
		undefine
			container_make, html_begin_element, html_end_element, html_element, is_equal, copy
		end

creation

	make_back_up_button

feature

	null_processor is
		do
		end

feature {NONE} -- Creation

	make_back_up_button (new_page : PAGE) is
		require
			valid_new_page : new_page /= Void
		do
			back_up := true
			make_button (new_page, ~null_processor, new_page.text.previous)
		end


end -- class BACK_UP_BUTTON_FORM

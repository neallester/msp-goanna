indexing
	description: "Objects that create pages"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/05/10"
	revision: "$Revision: 491 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	PAGE_FACTORY

inherit

	SYSTEM_CONSTANTS
	SEQUENCE_ELEMENT_FACTORY

creation

	make

feature {PAGE_SEQUENCE_ELEMENT} -- Pages


-- Login

	login (login_sequence : LOGIN_SEQUENCE) : PAGE is
		-- Page that provides for user login
			local
				form : LOGIN_FORM
		do
			create result.make (login_sequence.page_sequencer, login_sequence)
			result.set_not_historical
			create form.make_login_form (result, login_sequence)
			result.add_content (form)
		end


	new_user_login (login_sequence : LOGIN_SEQUENCE) : PAGE is
		-- Page that allows new users to apply to system
		local
			form : NEW_USER_LOGIN_FORM
		do
			create result.make (login_sequence.page_sequencer, login_sequence)
			result.set_not_historical
			create form.make_login_form (result, login_sequence)
			result.add_content (form)
		end


feature {NONE} -- Creation

	make is
		do
		end

end -- class PAGE_FACTORY
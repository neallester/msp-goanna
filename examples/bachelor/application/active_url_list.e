indexing
	description: "Hashable Lists of active_url objects"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/05/10"
	revision: "$Revision: 491 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	ACTIVE_URL_LIST

create
	default_create

feature -- Access

	active_url_list : HASH_TABLE [DYNAMIC_URL, STRING]
		-- a list of currently active dynamic_url objects

	register_dynamic_url (url_to_register : DYNAMIC_URL) is
		-- add url_to_register to the list
		require
			valid_url_to_register : url_to_register /= void
			url_to_register_not_registered : not url_registered (url_to_register)
		do
			active_url_list.extend (url_to_register, url_to_register.query_string)
		ensure
			url_registered : url_registered (url_to_register)
		end

	url_registered (url_to_test: DYNAMIC_URL) : BOOLEAN is
		-- Is the url_to_test registered as in the active_url_list
		require
			valid_url_to_test : url_to_test /= Void
		do
			Result := active_url_list.has (url_to_test.query_string)
		end

Invariant

	valid_active_url_list : active_url_list /= Void

end -- class ACTIVE_URL_LIST

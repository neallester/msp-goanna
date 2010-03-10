indexing
	description: "List of system users"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/05/10"
	revision: "$Revision: 491 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	USER_LIST

inherit

	USER_ANCHOR
	STORABLE
	SYSTEM_CONSTANTS
		undefine
			is_equal, copy
		end

create
	make

-- To Do: Store passwords securely rather than as clear text
-- Could possibly be done by encrypting the user_list storage file at the operating system
-- Level rather than at the application level

feature {LOGIN_SEQUENCE}

	retrieved_user (user_id, password : STRING) : like user_anchor is
		-- Retrieve a user from user_list
		require
			user_id_in_list : has (user_id)
			valid_password : equal (item(user_id).password, password)
		local
			test_file_name : STRING
			new_user : like user_anchor
			full_name : STRING
			a_file : RAW_FILE
			a_stream: STREAM
		do
			test_file_name := user_list.item(user_id).file_name
			full_name := data_directory + directory_separator + test_file_name + file_extension
			create a_file.make_open_read (full_name)
			result ?= a_file.retrieved
		ensure
			valid_result : result /= Void
		end

	add_new_user (new_user_id, new_password, new_file_name : STRING) is
		-- Add a new user to the user_list
		require
			valid_new_user_id : new_user_id /= Void
			new_user_id_not_empty : not new_user_id.is_empty
			not_has_new_user_id : not has (new_user_id)
			valid_new_password : new_password /= Void
			valid_new_file_name : new_file_name /= Void
			new_file_name_not_empty : not new_file_name.is_empty
		local
			new_list_element : USER_LIST_ELEMENT
		do
			create new_list_element.make (new_user_id, new_password, new_file_name)
			extend (new_list_element, new_user_id)
		ensure
			has_new_list_element : has (new_user_id)
			new_element_name_new_user : equal (item (new_user_id).user_id, new_user_id)
			new_element_password_new_password : equal (item (new_user_id).password, new_password)
			new_element_file_name_new_file_name : equal (item (new_user_id).file_name, new_file_name)
		end

	has (user_id: STRING): BOOLEAN is
			-- Is there a USER_LIST_ELEMENT associated with user_id
		require
			user_id_exists: user_id /= void
		do
			result := user_list.has (user_id)
		end

	item (user_id: STRING): USER_LIST_ELEMENT is
			-- The USER_LIST_ELEMENT associated with user_id
		require
			user_id_exists: user_id /= Void
			user_list_has_user_id: has (user_id)
		do
			result := user_list.item (user_id)
		end

feature {NONE} -- Implementation

	extend (new: USER_LIST_ELEMENT; key: STRING) is
		-- Add a new user_element to the list, acessible through key
		require
			key_not_in_list: not user_list.has (key)
		do
			user_list.force (new, key)
			store_by_name (user_list_file_name)
		ensure then
			key_is_user_id : new.user_id = key
		end

	user_list: DS_HASH_TABLE [USER_LIST_ELEMENT, STRING]

feature {NONE} -- Creation

	make is
		do
			create user_list.make (10)
		end

invariant

	user_list_exists: user_list /= Void

end -- class USER_LIST

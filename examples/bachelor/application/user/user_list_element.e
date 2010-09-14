note
	description: "An element in the user_list"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/05/10"
	revision: "$Revision: 491 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	USER_LIST_ELEMENT

create
	make

feature {SESSION, USER_LIST, LOGIN_SEQUENCE}

	user_id : STRING
		-- The ID the user has chosen for themselves

	password : STRING
		-- The Password the user has chosen
		-- To Do, make this secure

	file_name : STRING
		-- The file name where the user's data is stored.

	set_password (new_password : STRING)
		-- Set password
		require
			valid_new_password : new_password /= Void
		do
			password := new_password
		ensure
			password_updated : password = new_password
		end			

feature {NONE} -- Implementation and Creation 

	make (new_user_id, new_password, new_file_name : STRING)
		require
			valid_new_user_id : new_user_id /= Void
			new_user_id_not_empty : not new_user_id.is_empty
			valid_new_password : new_password /= Void
			valid_new_file_name : new_file_name /= Void
			new_file_name_not_empty : not new_file_name.is_empty
		do
			user_id := new_user_id
			password := new_password
			file_name := new_file_name
		ensure
			user_id_updated : user_id = new_user_id
			password_updated : password = new_password
			file_name_updated : file_name = new_file_name
		end

invariant

	valid_user_id : user_id /= Void
	user_id_not_empty : not user_id.is_empty
	valid_password : password /= Void
	valid_file_name : file_name /= Void
	file_name_not_empty : not file_name.is_empty

end -- class USER_LIST_ELEMENT

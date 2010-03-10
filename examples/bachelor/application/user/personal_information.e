indexing
	description: "Personal Information about the user"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/05/11"
	revision: "$Revision: 513 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	PERSONAL_INFORMATION

inherit
	TOPIC
	DOMAIN
	TIME_STAMPED_DOMAIN
		redefine
			initialize, update, initialized
		end
	USER_RELATED

create
	make_with_user

feature  {TOPIC, PAGE, USER}-- Attributes & Setting

	name : STRING
		-- The users name

	name_agent_access : STRING is
		do
			result := name
		end

	set_name (new_name : STRING) is
		require
			valid_new_name : new_name /= Void
		do
			name := new_name
			update
		end

	first_name : STRING
		-- The users first name

	first_name_agent_access : STRING is
		do
			result := first_name
		end

	set_first_name (new_first_name : STRING) is
		require
			valid_new_first_name : new_first_name /= Void
		do
			first_name := new_first_name
		ensure
			first_name_updated : new_first_name = first_name
		end

	middle_name : STRING
		-- The users middle name

	middle_name_agent_access : STRING is
		do
			result := middle_name
		end

	set_middle_name (new_middle_name : STRING) is
		require
			valid_new_middle_name : new_middle_name /= Void
		do
			middle_name := new_middle_name
		ensure
			middle_name_updated : new_middle_name = middle_name
		end	

	last_name : STRING
		-- The users last name

	last_name_agent_access : STRING is
		do
			result := last_name
		end

	set_last_name (new_last_name : STRING) is
		require
			valid_new_last_name : new_last_name /= Void
		do
			last_name := new_last_name
		ensure
			last_name_updated : new_last_name = last_name
		end

	e_mail_address : STRING
		-- The users e-mail address

	e_mail_address_agent_access : STRING is
		do
			result := e_mail_address
		end

	set_e_mail_address (new_e_mail_address : STRING) is
		require
			valid_new_e_mail_address : new_e_mail_address /= Void
		do
			e_mail_address := new_e_mail_address
		ensure
			e_mail_address_updated : new_e_mail_address = e_mail_address
		end	

	undo is
			-- 	Roll back to previuos state (not implemented)
		do
		end
		

feature -- Implement Deferred Features

	title : STRING is
		do
			Result := user.preference.language.personal_information
		end

	reset is
		do
			reset_personal_information
		end

feature {NONE} -- Implementation

	initialize is
		do
			reset_personal_information
			precursor {TIME_STAMPED_DOMAIN}
		end

	update is
		do
			precursor {TIME_STAMPED_DOMAIN} 
		end

	initialized: BOOLEAN is
		do
			result := precursor {TIME_STAMPED_DOMAIN} 
		end

	reset_personal_information is
		do
			name := ""
		end

	evaluated: BOOLEAN is
		do
			result := not equal (name, "")
		end

invariant

	valid_name : name /= Void

end -- class PERSONAL_INFORMATION

indexing
	description: "Page sequence that logs user into the system"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/05/11"
	revision: "$Revision: 491 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	LOGIN_SEQUENCE

inherit

	SHARED_APPLICATION_SESSION_MANAGER
	PAGE_SEQUENCE
		redefine
			initialize, initialized
		end
	SYSTEM_CONSTANTS
	TOPIC
		redefine
			page_sequencer
		end

create
	make

feature --	implement deferred features

	done : BOOLEAN

	page : PAGE is
		do
			if new_user then
				if new_user_login_page = void then
					new_user_login_page := page_factory.new_user_login (current)
				end
				result := new_user_login_page
			else
				if login_page = void then
					login_page := page_factory.login (current)
				end
				result := login_page
			end
		end

	active_chain : LINKED_LIST [ELEMENT_CONTAINER] is
		do
			create result.make
		end

	start is
		do
			set_returning_user
			display_error_messages := false
		end

	forth is
		do
			display_error_messages := true
			if valid_user then
				done := true
			end
		end

	restore_chain (chain : LINKED_LIST [ELEMENT_CONTAINER]) is
		do
		end

	context : STRING is
		do
			result := ""
		end

feature {PAGE_FACTORY, LOGIN_FORM} -- Access

	language : TEXT_LIST is
		-- The
		do
			result := page_sequencer.user.preference.language
		end

feature {LOGIN_FORM} -- Implementation

	display_error_messages : BOOLEAN
		-- Should error messages be displayed

	user_id : STRING
		-- The user ID input by user

	user_id_access : STRING is
		-- Used for agents that return user id
		do
			result := user_id
		end

	new_user : BOOLEAN
		-- The person completing the form indicated they are a new user

	set_new_user is
		-- This is a new user
		do
			new_user := true
		ensure
			new_user : new_user
		end

	set_returning_user is
		-- This is not a new user
		do
			new_user := false
			
		ensure
			not_new_user : not new_user
		end

	password : STRING
		-- The password input by user

	password_access : STRING is
		-- Work around; v 4.5 ISE Agents won't work with attributes
		do
			result := password
		end

	confirm_password : STRING
		-- The confirmation password provided by the user

	confirm_password_access : STRING is
		-- Work around; v 4.5 ISE Agents won't work with attributes
		do
			result := confirm_password
		end

	new_user_name : STRING
		-- The name (if any) of the new user)

	new_user_name_access : STRING is
		-- Work around; v 4.5 ISE Agents won't work with attributes
		do
			result := new_user_name
		end

	set_new_user_name (new_new_user_name : STRING) is
		-- Set the name of a new user
		require
			valid_new_new_user_name : new_new_user_name /= Void
		do
			new_user_name := new_new_user_name
		ensure
			new_user_name_updated : new_user_name = new_new_user_name
		end

	set_confirm_password (new_confirm_password : STRING) is
		-- Set confirm password entered by the user
		require
			valid_new_confirm_password : new_confirm_password /= Void
		do
			confirm_password := new_confirm_password
		ensure
			confirm_password_updated : confirm_password = new_confirm_password
		end

	set_user_id (new_user_id : STRING) is
		-- Set the user ID input by the user
		require
			valid_new_user_id : new_user_id /= Void
		do
			user_id := new_user_id
		ensure
			user_id_updated : user_id = new_user_id
		end

	set_password (new_password : STRING) IS
		-- Set the password input the by user
		require
			valid_new_password : new_password /= Void
		do
			password := new_password
		ensure
			password_updated : password = new_password
		end

	new_user_access : BOOLEAN is
		-- Work around; v4.5 ISE Agents won't work with attributes
		do
			result := new_user
		end

	user_list : USER_LIST is
		-- List of users
		once
			create result.make
			result ?= result.retrieve_by_name (user_list_file_name)
			if result = Void then
				create result.make
			end
		end

	valid_user_id : BOOLEAN is
		-- Is the USER ID input by the user valid?
		do
			if new_user then
				result := (not user_id.is_empty) and (not user_list.has (user_id))
			else
				result := (not user_id.is_empty) and user_list.has (user_id)
			end
		end

	valid_user : BOOLEAN is
		-- Is all information input by the user valid?
		do
			result := valid_user_id and valid_password and valid_confirm_password
		end

	valid_password : BOOLEAN is
		-- Is the password input by the user valid?
		do
			if new_user then
				result := true
			else
				if valid_user_id then
					result := equal (password, user_list.item (user_id).password)
				else
					result := false
				end
			end
		end

	valid_confirm_password : BOOLEAN is
		-- Is the confirm password input by the user valid?
		do
			if new_user then
				result := equal (confirm_password, password)
			else
				result := True
			end
		end	

	valid_user_access : BOOLEAN is
		
		do
			result := valid_user
		end

	title : STRING is
		do
			result := text.user_login
		end

	login_existing_user is
		-- login a previously registered user
		require
			valid_user : valid_user
			not_new_user : not new_user
		local
			active_page : PAGE
			retrieved_user : like user_anchor
			existing_page_sequencer : PAGE_SEQUENCER
		do
			retrieved_user := user_list.retrieved_user (user_id, password)
			if session_manager.user_is_active (retrieved_user.user_file_name) then
				existing_page_sequencer ?= session_manager.user_session (retrieved_user.user_file_name).get_attribute ("page_sequencer")
				page_sequencer.session.remove_attribute ("page_sequencer")
				page_sequencer.session.set_attribute ("page_sequencer", existing_page_sequencer)
				existing_page_sequencer.set_session (page_sequencer.session)
				page_sequencer := existing_page_sequencer
			else
				page_sequencer.set_user (retrieved_user)
				active_page := page_sequencer.user.active_page
				page_sequencer.user.replace_active_sequence (current)
				page_sequencer.user.set_active_page (active_page)
			end
		ensure
			previously_active_user_implies_page_sequencer_updated : old session_manager.user_is_active (user_list.retrieved_user (user_id, password).user_file_name) implies page_sequencer /= old page_sequencer
			page_sequencer_user_is_new_user : equal (page_sequencer.user.user_file_name, user_list.item (user_id).file_name)
			user_is_active : session_manager.user_is_active (page_sequencer.user.user_file_name)
			user_active_sequence_current : user.active_sequence = current
		end

	login_new_user is
		-- Login a previously unregistered user
		require
			valid_user : valid_user
			new_user : new_user
		local
			user_to_login : like user_anchor
			active_page : PAGE
		do
			active_page := page_sequencer.user.active_page
			create user_to_login.make (page_sequencer)
			user_to_login.personal_information.set_name (new_user_name)
			user_to_login.set_not_anonymous
			user_to_login.store
			user_list.add_new_user (user_id, password, user_to_login.user_file_name)
			new_user := false
			page_sequencer.set_user (user_to_login)
			page_sequencer.user.replace_active_sequence (current)
			page_sequencer.user.set_active_page (active_page)
		ensure
			user_list_has_user_id : user_list.has (user_id)
			page_sequencer_user_is_new_user : equal (page_sequencer.user.user_file_name, user_list.item (user_id).file_name)
			user_active_sequence_current : user.active_sequence = current
		end


feature {PAGE, PAGE_FACTORY, EXPOSURE, PAGE_SEQUENCE_ELEMENT, SUBDOMAIN_ITERATOR}

	page_sequencer : PAGE_SEQUENCER
		-- The page_sequencer associated with this user

feature {NONE} -- Implementation

	login_page : PAGE
		-- The login page for this sequence

	new_user_login_page : PAGE
		-- The new user login page for this sequence

feature {NONE} -- Initialization

	make (new_page_sequencer : PAGE_SEQUENCER) is
		require
			valid_new_page_sequencer : new_page_sequencer /= Void
		do
			page_sequencer := new_page_sequencer
			make_with_user (page_sequencer.user)			
		end

	initialize is
		do
			precursor
			user_id := ""
			password := ""
			confirm_password := ""
			new_user_name := ""
			login_sequence_initialized := True
		end

	create_sequence is
		do
			sequence_initialized := true
		end

	undo is
		do
		end

	login_sequence_initialized: BOOLEAN

	initialized: BOOLEAN is
		do
			result := precursor and login_sequence_initialized
		end

invariant

	valid_page_sequencer : page_sequencer /= Void
	valid_user_list : user_list /= Void
	valid_user_id : user_id /= Void
	valid_password : password /= void
	valid_confirm_password : confirm_password /= Void
	valid_new_user_name : new_user_name /= Void
	done_implies_valid_user : done implies valid_user
--	valid_user_implies_done : valid_user implies done
	initialized_implies_login_sequence_initialized: initialized implies login_sequence_initialized

end -- class LOGIN_SEQUENCE

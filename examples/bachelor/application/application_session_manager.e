indexing
	description: "Objects that manage application session objects"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/05/10"
	revision: "$Revision: 513 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	APPLICATION_SESSION_MANAGER

inherit
	
	GOA_HTTP_SESSION_EVENT_LISTENER
	GOA_HTTP_SESSION_MANAGER
		redefine
			make
		end

creation
	make

feature {NONE} -- implementation

	active_users : DS_HASH_TABLE [GOA_HTTP_SESSION, STRING]

feature {NONE} -- Creation

	make is
		do
			precursor
			create active_users.make (10)
			register_event_listener (current)
		end

feature {LOGIN_SEQUENCE, PAGE_SEQUENCER} -- Active user Management

	user_is_active (user_name : STRING) : BOOLEAN is
		-- Is an active session associated with user_name?
		require
			valid_user_name : user_name /= Void
		do
			result := active_users.has (user_name)
		end

	user_session (user_name : STRING) : GOA_HTTP_SESSION is
		-- The session associated with user_name
		require
			valid_user_name : user_name /= Void
			user_name_not_empty : not user_name.is_empty
			active_users_has_user_name : user_is_active (user_name)
		do
			result := active_users.item (user_name)
		end


feature {PAGE_SEQUENCER} -- User removal

	add_user (new_session : GOA_HTTP_SESSION ; user_name : STRING) is
		-- Add user_name to active_users list
		require
			valid_new_session : new_session /= Void
			valid_user_name : user_name /= Void
			user_name_not_empty : not user_name.is_empty
			not_active_user : not user_is_active (user_name)
		do
			active_users.force_new (new_session, user_name)
		ensure
			user_active : active_users.has (user_name)
		end

	remove_user (user_name : STRING) is
		-- Remove the user associated with user_name
		require
			valid_user_name : user_name /= Void
			user_name_not_empty : not user_name.is_empty
		do
			if user_is_active (user_name) then
				active_users.remove (user_name)
			end
		ensure
			user_removed : not active_users.has (user_name)
		end

feature {GOA_HTTP_SESSION_MANAGER} -- Implementing 

    expiring (session: GOA_HTTP_SESSION) is
            -- 'session' is about to be expired.
        do
        end

	expired (session: GOA_HTTP_SESSION) is
      	-- 'session' has expired and has been removed from
      	-- the active list of sessions
	local
		page_sequencer : page_sequencer
      do
			if session.has_attribute ("page_sequencer") then
				page_sequencer ?= session.get_attribute ("page_sequencer")
				if page_sequencer.session = session and user_is_active (page_sequencer.user.user_file_name) then
					remove_user (page_sequencer.user.user_file_name)
				else
					-- This session no longer active; user is active on another session
				end
			end	
        end

    created (session: GOA_HTTP_SESSION) is
            -- 'session' has been created
        do
        end

    attribute_bound (session: GOA_HTTP_SESSION; name: STRING;
        attribute: ANY) is
            -- 'attribute' has been bound in 'session' to 'name'
        do
        end

    attribute_unbound (session: GOA_HTTP_SESSION; name: STRING;
        attribute: ANY) is
            -- 'attribute' has been unbound in 'session' from 'name'
      do
      end
	
invariant

	valid_active_users : active_users /= Void
	registered_session_event_listener : event_listener_registered (current)

end -- class APPLICATION_SESSION_MANAGER

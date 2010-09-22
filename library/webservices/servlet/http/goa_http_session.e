note
	description: "Objects that represent user session information."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "HTTP Servlet API"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>", "Neal Lester <neallester@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class	GOA_HTTP_SESSION

inherit

	DT_SHARED_SYSTEM_CLOCK
		export
			{NONE} all
		end

	GOA_SHARED_HTTP_SESSION_MANAGER
		export
			{NONE} all
		end

create

	make

feature {GOA_HTTP_SESSION_MANAGER}-- Initialization

	make (session_id: STRING)
			-- Create a new session with 'id' set to 'session_id'
		require
			session_id_exists: session_id /= Void
		do
			id := session_id
			debug ("session_management")
				print ("New session: " + id + "%R%N")
			end
			validated := True
			is_new := True
			max_inactive_interval := 14400
			creation_time := system_clock.date_time_now
			touch
		ensure
			valid_session: validated
			new_session: is_new
		end


feature -- Status report

	id: STRING
			-- Session id

	creation_time: DT_DATE_TIME
			-- Date and time session was created

	last_accessed_time: DT_DATE_TIME
			-- The last time a client sent a request associated with this session

	max_inactive_interval: INTEGER
			-- The maximum time interval, in seconds, that the session will remain open
			-- between client requests

	is_new: BOOLEAN
			-- Does the client know about the session?

	validated: BOOLEAN
			-- Is the session valid?

feature -- Status setting

	set_max_inactive_interval (new_interval: like max_inactive_interval)
			-- Set the maximum inactive interval			
		require
			valid_session: validated
		do
			max_inactive_interval := new_interval
		end

	invalidate
			-- Invalidates the session and unbinds any objects bound to it			
		require
			valid_session: validated
		do
			validated := False
		ensure
			invalidated: not validated
		end


feature {GOA_HTTP_SESSION_MANAGER}

	set_old
			-- Register that the client has joined the session.
		do
			is_new := False
		ensure
			not_new: not is_new
		end

	touch
			-- Update the last accessed time.
		require
			valid_session: validated
		do
			last_accessed_time := system_clock.date_time_now
			debug ("session_management")
				print ("Touching session: " + id + " at " + last_accessed_time.out + "%R%N")
			end
		end

end -- class GOA_HTTP_SESSION

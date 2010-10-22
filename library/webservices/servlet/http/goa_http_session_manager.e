indexing
	description: "Objects that manage HTTP sessions"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "HTTP Servlet API"
	date: "$Date: 2006-11-23 08:38:55 -0800 (Thu, 23 Nov 2006) $"
	revision: "$Revision: 518 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>", "Neal Lester <neallester@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class	GOA_HTTP_SESSION_MANAGER

inherit

	DT_SHARED_SYSTEM_CLOCK
		export
			{NONE} all
		end

create

	make

feature -- Initialization

	make is
			-- Create a new session manager
		do
			create sessions.make_equal (10)
		end

feature -- Access

	get_session (id: STRING): like session_anchor is
			-- Return the session with 'id'
		require
			id_exists: id /= Void
			has_session: has_session (id)
		do
			Result  := sessions.item (id)
			Result.touch
		end

feature -- Status report

	has_session (id: STRING): BOOLEAN is
			-- Does a session with 'id' exist?
		require
			id_exists: id /= Void
		do
			expire_sessions
			Result  := sessions.has (id)
		end

	last_session_id: STRING
			-- Id of last session bound or touched.

	Session_cookie_name: STRING is "GSESSIONID"
			-- Name of session cookie

feature -- Status setting

	session_count: INTEGER is
			-- Number of active sessions
		do
			expire_sessions
			Result := sessions.count
		end


	bind_session (req: GOA_HTTP_SERVLET_REQUEST; resp: GOA_HTTP_SERVLET_RESPONSE) is
			-- If the request does not already have a session, then create one.
			-- If the request includes the session id cookie then mark the session
			-- as old (ie, the client has accepted the session).
		local
			cookie: GOA_COOKIE
			session: like session_anchor
		do
			expire_sessions
			-- look for the session id cookie, if it exists the session will already exist so
			-- mark it as old and update its access time.
			create cookie.make (Session_cookie_name, "")
			debug ("session_management")
				print ("Binding session%R%N")
			end
			req.cookies.start
			req.cookies.search_forth (cookie)
			if not req.cookies.off then
				cookie := req.cookies.item_for_iteration
				debug ("session_management")
					print ("Cookie value is: " + cookie.value + "%R%N")
				end
				-- check for stale cookie
				if sessions.has (cookie.value) then
					debug ("session_management")
						print ("We have the cookie value%R%N")
					end
					session := sessions.item (cookie.value)
					if session.is_new then
						session.set_old
					end
					session.touch
					last_session_id := session.id
				else
					debug ("session_management")
						print ("Creating session as we don't have the cookie value%R%N")
					end
					session := create_new_session (resp)
				end
			else
				debug ("session_management")
					print ("Creating session as we can't find the cookie%R%N")
				end
				session := create_new_session (resp)
			end
			req.set_session (session)
		end

	terminate is
			-- Application is shutting down.
		require
			True
		local
			session: like session_anchor
			key: STRING
		do
			-- Force-expire all sessions
			if sessions.count > 0 then
				from
					sessions.start
				until
					sessions.off
				loop
					session := sessions.item_for_iteration
					key := sessions.key_for_iteration
					notify_listeners (session, Expiring_code)
					sessions.remove (key)
					notify_listeners (session, Expired_code)
					-- dont do a 'sessions.forth' since removing an element moves the cursor.
				end
			end
		end

feature {NONE} -- Implementation

	session_anchor: GOA_HTTP_SESSION
			-- Session type anchor

	sessions: DS_HASH_TABLE [like session_anchor, STRING]
			-- Active sessions.

	create_new_session (resp: GOA_HTTP_SERVLET_RESPONSE): like session_anchor is
			-- Create a new session and set the session cookie
		local
			cookie: GOA_COOKIE
		do
			last_session_id := generate_session_id
			create Result.make (last_session_id)
			sessions.force (Result, last_session_id)
			create cookie.make (Session_cookie_name, last_session_id)
			resp.add_cookie (cookie)
			notify_listeners (Result, Created_code)
		end

	generate_session_id: STRING is
			-- Generate a new secure session id.
			-- Key is generated from a random number and the current date and time.
		local
			date: DT_DATE_TIME
			formatter: GOA_DATE_FORMATTER
			a_random_number: INTEGER
		do
			a_random_number := system_clock.date_time_now.hash_code
			date := system_clock.date_time_now
			create formatter
			Result := ""
			Result.append_string (formatter.format_compact_sortable (date) + a_random_number.out + counter.out)
			Result := base64_encoder.encode (Result)
			counter := counter + 1
		ensure
			new_session_id_exists: Result /= Void
		end

	counter: INTEGER_64

	base64_encoder: GOA_BASE64_ENCODER is
			-- Base64 encoder
		once
			create Result
		end

	expire_sessions is
			-- Check all current sessions and expire if appropriate.
		local
			cursor: DS_HASH_TABLE_CURSOR [like session_anchor, STRING]
			session: like session_anchor
			expired_session: like session_anchor
			now, idle: DT_DATE_TIME
			expired_sessions: DS_LINKED_LIST [STRING]
		do
			now := system_clock.date_time_now
			create expired_sessions.make
			from
				cursor := sessions.new_cursor
				cursor.start
			until
				cursor.off
			loop
				-- check each session against the current time and collect in list
				-- if it needs expiring
				session := cursor.item
				idle := session.last_accessed_time.twin
				idle.add_seconds (session.max_inactive_interval)
				if now > idle then
					-- expire session
					debug ("session_management")
						print ("Expiring session: " + cursor.key + "%R%N")
					end
					notify_listeners (cursor.item, Expiring_code)
					expired_sessions.force_last (cursor.key)
				end
				cursor.forth
			end
			-- remove all collected expired sessions
			from
				expired_sessions.start
			until
				expired_sessions.off
			loop
				expired_session := sessions.item (expired_sessions.item_for_iteration)
				sessions.remove (expired_sessions.item_for_iteration)
				notify_listeners (expired_session, Expired_code)
				expired_sessions.forth
			end
		end

feature  -- Listeners

	register_event_listener (listener: GOA_HTTP_SESSION_EVENT_LISTENER) is
				-- Register 'listener' to receive notification of
				-- session events.
		require
			listener_exists: listener /= Void
			listener_not_registered: not event_listener_registered (listener)
		do
			if listener_list = void then
				create listener_list.make
			end
			listener_list.force_last (listener)
		ensure
			listener_registered: event_listener_registered (listener)
		end

	unregister_event_listener (listener: GOA_HTTP_SESSION_EVENT_LISTENER) is
				-- Unregister 'listener' so that it does not receive session
				-- event notifications.
		require
			listener_exists: listener /= Void
			event_listener_registered: event_listener_registered (listener)
		do
			listener_list.delete (listener)
		ensure
			listener_unregistered: not event_listener_registered (listener)
		end

	event_listener_registered (listener: GOA_HTTP_SESSION_EVENT_LISTENER): BOOLEAN is
			-- listener is registered and will receive event notifications
		require
			listener_exists: listener /= Void
		do
			Result := listener_list /= Void and then listener_list.has (listener)
		end

feature {NONE} -- Listener implementation

	listener_list: DS_LINKED_LIST [GOA_HTTP_SESSION_EVENT_LISTENER]
			-- List of registered event listeners

	Expiring_code: 			INTEGER is 1
			-- Event code
	Expired_code: 			INTEGER is 2
			-- Event code
	Created_code: 			INTEGER is 3
			-- Event code

	valid_event_code (arg_event_code: INTEGER): BOOLEAN is
			-- Is the supplied event code valid?
		do
			inspect arg_event_code
				when Expiring_code..Created_code then
					Result := True
				else
					Result := False
			end
		end

	notify_listeners (session: like session_anchor; event_code: INTEGER) is
			-- notify listeners that an event (signified by event_code) has occurerd for session
		require
			session_exists: session /= Void
			event_code_valid: valid_event_code(event_code)
		local
			listener_cursor: DS_LINKED_LIST_CURSOR [GOA_HTTP_SESSION_EVENT_LISTENER]
		do
			if listener_list /= void and then not listener_list.is_empty then
				create listener_cursor.make (listener_list)
				from
					listener_cursor.start
				until
					listener_cursor.after
				loop
					inspect event_code
					when expiring_code then
						listener_cursor.item.expiring (session)
					when expired_code then
						listener_cursor.item.expired (session)
					when created_code then
						listener_cursor.item.created (session)
					end
					listener_cursor.forth
				end
			end
		end

end -- class GOA_HTTP_SESSION_MANAGER

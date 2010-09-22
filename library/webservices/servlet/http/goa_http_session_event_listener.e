indexing
	description: "Objects that listen to HTTP Session Events"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "HTTP Servlet API"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>", "Neal Lester <neallester@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

deferred class GOA_HTTP_SESSION_EVENT_LISTENER

feature {GOA_HTTP_SESSION_MANAGER} -- Events

    expiring (session: GOA_HTTP_SESSION) is
            -- 'session' is about to be expired.
        require
            session_exists: session /= Void
        deferred
        end

    expired (session: GOA_HTTP_SESSION) is
            -- 'session' has expired and has been removed from
            -- the active list of sessions
        require
            session_exists: session /= Void
        deferred
        end

    created (session: GOA_HTTP_SESSION) is
            -- 'session' has been created
        require
            session_exists: session /= Void
        deferred
        end

end -- class GOA_HTTP_SESSION_EVENT_LISTENER

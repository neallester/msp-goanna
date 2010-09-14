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

    attribute_bound (session: GOA_HTTP_SESSION; name: STRING;
        a_attribute: ANY) is
            -- 'a_attribute' has been bound in 'session' to 'name'
        require
            session_exists: session /= Void
            name_exists: name /= Void
            a_attribute_exists: a_attribute /= Void
            attribute_bound: session.get_attribute (name) = a_attribute
        deferred
        end

    attribute_unbound (session: GOA_HTTP_SESSION; name: STRING;
        a_attribute: ANY) is
            -- 'a_attribute' has been unbound in 'session' from 'name'
        require
            session_exists: session /= Void
            name_exists: name /= Void
            a_attribute_exists: a_attribute /= Void
            attribute_unbound: not session.has_attribute (name)
        deferred
        end

end -- class GOA_HTTP_SESSION_EVENT_LISTENER

note
	description: "Objects that manage servlets."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "Servlet API"
	date: "$Date: 2006-11-23 08:38:55 -0800 (Thu, 23 Nov 2006) $"
	revision: "$Revision: 518 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class GOA_SERVLET_MANAGER [K -> GOA_SERVLET]

inherit

	SHARED_DATABASE_SESSION

create

	make

feature -- Initialization

	make
			-- Initialise with no servlets.
		do
			create servlets.make (5)
			servlet_mapping_prefix := ""
		end

feature -- Access

	servlet (name: STRING): K
			-- Retrieve the servlet registered under 'name'
		require
			name_exists: name /= Void
			servlet_registered: has_registered_servlet (name)
		do
			Result := servlets.item (name)
		ensure
			result_exists: Result /= Void
		end

	default_servlet: K
			-- Retrieve the default servlet
		require
			default_servlet_registered: has_default_servlet
		do
			Result := internal_default_servlet
		end

	count: INTEGER
			-- Number of registered servlets, not including the default servlet
			-- if any.
		do
			Result := servlets.count
		end

	config: GOA_SERVLET_CONFIG
			-- Servlet configuration

	servlet_mapping_prefix: STRING
			-- Prefix for servlet mappings.

feature -- Status report

	has_registered_servlet (name: STRING): BOOLEAN
			-- Is a servlet registered under 'name'?
		require
			name_exists: name /= Void
		do
			Result := servlets.has (name)
		end

	has_default_servlet: BOOLEAN
			-- Is a default servlet registered?
		do
			Result := internal_default_servlet /= Void
		end

feature -- Status setting

	register_servlet (new_servlet: K; name: STRING)
			-- Register 'servlet' for 'name'
		require
			servlet_exists: new_servlet /= Void
			name_exists: name /= Void
		do
			servlets.force (new_servlet, virtual_servlet_name (name))
		end

	register_default_servlet (def_servlet: K)
			-- REgister 'servlet' as the default servlet
		require
			servlet_exists: def_servlet /= Void
		do
			internal_default_servlet := def_servlet
		end

	set_servlet_mapping_prefix (virtual_prefix: STRING)
			-- Set the servlet mapping prefix to `virtual_prefix'. This is used to set
			-- a virtual prefix name for accessing servlets. eg. "servlet". The
			-- prefix should not begin or end in a slash. It will always be relative
			-- to the document root.
			-- If a servlet prefix is to be used, it must be set before any servlets
			-- have been registered.
		require
			prefix_exists: virtual_prefix /= Void
			prefix_valid: virtual_prefix.item (1) /= '/'
				and virtual_prefix.item (virtual_prefix.count) /= '/'
			no_registered_servlets: count = 0
		do
			servlet_mapping_prefix := virtual_prefix + "/"
		end

	set_config (new_config: GOA_SERVLET_CONFIG)
			-- Set the configuration information
		require
			config_exists: new_config /= Void
		do
			config := new_config
		end

feature {NONE} -- Implementation

	virtual_servlet_name (name: STRING): STRING
			-- Construct the actual mapping name for a servlet 'name' using
			-- the virtual prefix if set.
		require
			name_exists: name /= Void
		do
			Result := name.twin
			if servlet_mapping_prefix /= Void then
				Result.prepend (servlet_mapping_prefix)
			end
		end


	internal_default_servlet: K
			-- Default servlet

	servlets: DS_HASH_TABLE [K, STRING]
			-- Managed servlets.


end -- class GOA_SERVLET_MANAGER

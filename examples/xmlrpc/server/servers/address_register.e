note
	description: "Register of addresses"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "XMLRPC examples"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class	ADDRESS_REGISTER

inherit
	
	GOA_SERVICE
		redefine
			make
		end

create
	
	make
	
feature -- Initialization

	make
			-- Create a few addresses
		do
			Precursor
			create addresses.make_default
		end
		
feature -- Access
			
	get_entry (name: STRING): STRING
			-- Locate address by name
		require
			has_entry: has_entry (name).item
		do
			Result := addresses.item (name)
		ensure
			entry_exists: Result /= Void
		end
	
	add_entry (name: STRING; address: STRING)
			-- Add 'address' for 'name'.
		require
			name_exists: name /= Void
			address_exists: address /= Void
			new_entry: not has_entry (name).item
		do
			addresses.force (address, name)
		ensure
			has_entry: has_entry (name).item
		end
	
	has_entry (name: STRING): BOOLEAN_REF
			-- Does 'address' exist for 'name'?
		require
			name_exists: name /= Void
		do
			create Result
			Result.set_item (addresses.has (name))
		end
		
	remove_entry (name: STRING)
			-- Remove 'address' for 'name'
		require
			name_exists: name /= Void
			has_name: has_entry (name).item
		do
			addresses.remove (name)
		end
	
	get_names: ARRAY [STRING]
			-- Return all names
		local
			c: DS_HASH_TABLE_CURSOR [STRING, STRING]
			i: INTEGER
		do
			create Result.make (1, addresses.count)
			from
				c := addresses.new_cursor
				c.start
				i := 1
			until
				c.off
			loop
				Result.force (c.key, i)
				c.forth
				i := i + 1
			end
		end

feature -- Creation

	new_tuple (a_name: STRING): TUPLE
			--	Tuple of default-valued arguments to pass to call `a_name'.
		local
			a_get_names_tuple: TUPLE []
			a_get_entry_tuple: TUPLE [STRING]
			a_has_entry_tuple: TUPLE [STRING]
			an_add_entry_tuple: TUPLE [STRING, STRING]
			a_remove_entry_tuple: TUPLE [STRING]
		do
			if a_name.is_equal (Get_names_name) then
				create a_get_names_tuple; Result := a_get_names_tuple
			elseif a_name.is_equal (Get_entry_name) then
				create a_get_entry_tuple; Result := a_get_entry_tuple
			elseif a_name.is_equal (Has_entry_name) then
				create a_has_entry_tuple; Result := a_has_entry_tuple
			elseif a_name.is_equal (Add_entry_name) then
				create an_add_entry_tuple;	Result := an_add_entry_tuple
			elseif a_name.is_equal (Remove_entry_name) then
				create a_remove_entry_tuple; Result := a_remove_entry_tuple
			end
		end

feature {NONE} -- Implementation

	Get_names_name: STRING = "getNames"
			-- Name of `get_names' service

	Get_entry_name: STRING = "getEntry"
			-- Name of `get_entry' service

	Has_entry_name: STRING = "hasEntry"
			-- Name of `has_entry' service
	
	Add_entry_name: STRING = "addEntry"
			-- Name of `add_entry' service

	Remove_entry_name: STRING = "removeEntry"
			-- Name of `remove_entry' service
	
	addresses: DS_HASH_TABLE [STRING, STRING]
			-- List of addresses indexed by name

feature {NONE} -- Initialisation

	self_register
			-- Register all actions for this service
		do		
			register (agent get_names, Get_names_name)
			register (agent get_entry, Get_entry_name)
			register (agent has_entry, Has_entry_name)
			register (agent add_entry, Add_entry_name)
			register (agent remove_entry, Remove_entry_name)
		end

end -- class ADDRESS_REGISTER

indexing
	description: "Objects that represent entities in a Corporate/Company hierarchy"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	author: "Neal L. Lester"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	copyright: "(c) Neal L. Lester, 2001"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."	

deferred class
	ENTITY

inherit
	TIME_STAMPED_DOMAIN
		redefine
			initialize, initialized
		end
	SYSTEM_CONSTANTS
	
feature -- Access

	company: COMPANY is
			-- The company to which this entity belongs (top level entity)
		deferred
		end

	general_manager: EMPLOYEE is
			-- The general manager of this entity
		do
			result := internal_general_manager
		end
		
	safety_manager: EMPLOYEE is
			-- The safety_manager of this entity
		do
			result := internal_safety_manager
		end
	
	name: STRING
			-- The name of this entity (e.g. Region 1)
	
	organizational_level: STRING
			-- The organization level of this entity (e.g. Regional)
			
	evaluated: BOOLEAN is
			-- Has this domain been evaluated
		do
			result := general_manager /= Void and safety_manager /= Void and (not organizational_level.is_empty) and (not name.is_empty)
		end
		

feature -- Status Setting

	set_name (new_name: STRING) IS
			-- Set the name of this entity
		require
			new_name_exists: new_name /= Void
			new_name_not_empty: not new_name.is_empty
			new_name_not_in_list: not entity_name_list.has (new_name)
		do
			if not name.is_empty then
				entity_name_list.remove (name)
			end
			name := new_name
			entity_name_list.add (new_name)
			update
		ensure
			name_updated: name = new_name
			new_name_in_list: entity_name_list.has (new_name)
			old_name_not_in_list: not old name.is_empty implies not entity_name_list.has (old name)
		end

	set_organizational_level (new_organizational_level: STRING) is
			-- Set the organizational level of this entity
		require
			new_organizational_level_exists: new_organizational_level /= Void
			new_organizational_level_not_empty: not new_organizational_level.is_empty
		do
			if not equal (organizational_level, new_organizational_level) then
				if not organizational_level.is_empty then
					organizational_level_list.remove (organizational_level)
				end
				organizational_level := new_organizational_level
				entity_name_list.add (new_organizational_level)
				update
			end
		ensure
			organizational_level_updated: equal (new_organizational_level, organizational_level)
--			organizational_level_list_decremented: (not old organizational_level.is_empty and not equal (organizational_level, new_organizational_level)) implies organizational_level_list.count (old organizational_level) = (old organizational_level_list.count (old organizational_level_list.count (old organizational_level)-1))
			organizational_level_list_incremented: not equal (old organizational_level, new_organizational_level) and not (old organizational_level_list.has (new_organizational_level)) implies equal (organizational_level_list.count (new_organizational_level), old organizational_level_list.count (new_organizational_level) + 1)
		end
		
	reset is
			-- Reset this entity to default values
		do
			if not name.is_empty then
				entity_name_list.remove (name)
				name := ""
			end
			if not organizational_level.is_empty then
				organizational_level_list.remove (organizational_level)
				organizational_level := ""
			end
			internal_general_manager := Void
			internal_safety_manager := Void
		ensure then
			name_empty: name.is_empty
			organizational_level_empty: organizational_level.is_empty
			general_manager_void: internal_general_manager = Void
			safety_manager_void: internal_safety_manager = Void
--			organizational_level_list_decremented: not old organizational_level.is_empty implies equal (organizational_level_list.count (old organizational_level), (old organizational_level_list.count (old organizational_level_list.count (old organizational_level)-1)))
			old_name_not_in_list: not old name.is_empty implies not entity_name_list.has (old name)
		end

	organizational_level_list: UNIQUE_STRING_LIST is
			-- Valid values of organizational level
		once
			create result.make (organizational_level_list_file_name)
			result ?= result.retrieve_by_name (organizational_level_list_file_name)
			if result = Void then
				create result.make (organizational_level_list_file_name)
			end
		end
		
	entity_name_list: UNIQUE_STRING_LIST is
			-- Valid values of entity names
		once
			create result.make (entity_name_list_file_name)
			result ?= result.retrieve_by_name (entity_name_list_file_name)
			if result = Void then
				create result.make (entity_name_list_file_name)
			end
		end	
		
feature {NONE} -- Implementation

	internal_general_manager: EMPLOYEE 
			-- Store the general_manager set for this entity
			
	internal_safety_manager: EMPLOYEE
			-- Store the safety_manager set for this entity

	initialize is
			-- Initialize this domain
		do
			name := ""
			organizational_level := ""
			entity_initialized := true
			{TIME_STAMPED_DOMAIN} precursor
		end
		
	initialized: BOOLEAN is
			-- Has this domain been initialized
		do
			result := entity_initialized and {TIME_STAMPED_DOMAIN} precursor
		end


	entity_initialized: BOOLEAN		
	
invariant
	company_exists: company /= Void
	name_exists: name /= Void
	organizational_level_exists: organizational_level /= Void
	entity_initialized: initialized implies entity_initialized
	organizational_level_list_exists: organizational_level_list /= Void
	entity_name_list_Exists: entity_name_list /= Void
	
end -- class ENTITY

indexing
	description: "Objects that store lists of unique strings"
	author: "Neal L. Lester"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	copyright: "(c) 2001, Neal L. Lester"

class
	UNIQUE_STRING_LIST

inherit
	STORABLE

create
	make

feature -- Access

	has (a_string: STRING): BOOLEAN is
			-- Does the list contain a_string
		do
			result := internal_list.has (a_string)
		ensure
			has_implies_count_positive: result implies count (a_string) > 0
			not_has_implies_count_zero: not result implies equal (count (a_string), 0)
		end
		
	add (a_string: STRING) is
			-- Add a_string to the list, increment count if already present
		require
			a_string_exists: a_string /= Void
			a_string_not_empty: not a_string.is_empty
		local
			old_count: INTEGER
		do
			if internal_list.has (a_string) then
				old_count := internal_list.item (a_string)
				internal_list.replace (old_count+1, a_string)
			else
				internal_list.force (1, a_string)
			end
			store_by_name (store_file_name)
		ensure
			list_has_a_string: internal_list.has (a_string)
			count_incremented: count (a_string) = old count (a_string) + 1
		end

	remove (a_string: STRING) is
			-- Remove a string from the list, decrement count
		require
			a_string_exists: a_string /= Void
			a_string_not_empty: not a_string.is_empty
			list_has_a_string: has (a_string)
		local
			old_count: INTEGER
		do
			if has (a_string) then
				if equal (internal_list.item (a_string), 1) then
					internal_list.remove (a_string)
				else
					old_count := internal_list.item (a_string)
					internal_list.replace (old_count-1, a_string)
				end
			else
				internal_list.force (1, a_string)
			end
			store_by_name (store_file_name)
		ensure
			count_decremented: equal (count (a_string), old (count (a_string)-1))
		end
		
	count (a_string: STRING): INTEGER is
			-- The count of strings matching a_string
		require
			a_string_exists: a_string /= Void
			a_string_not_empty: not a_string.is_empty
		do
			if internal_list.has (a_string) then
				result := internal_list.item (a_string)
			else
				result := 0
			end
		ensure
			count_zero_implies_not_has: equal (result, 0) implies not has (a_string)
			count_positive_implies_has: result > 0 implies has (a_string)
			count_not_negative: result >= 0
		end
		
--	list: 		

feature {NONE} -- Creation

	make (new_store_file_name: STRING) is
			-- Creation
		require
			new_store_file_name_exists: new_store_file_name /= Void
			new_store_file_name_not_empty: not new_store_file_name.is_empty
		local
			a_list: UNIQUE_STRING_LIST
		do
			store_file_name := new_store_file_name
			a_list ?= retrieve_by_name (store_file_name)
			if a_list /= Void then
				internal_list := a_list.internal_list
			else
				create internal_list.make_equal (1)
			end
		end
		

feature {UNIQUE_STRING_LIST} -- Implementation

	internal_list: DS_HASH_TABLE [INTEGER, STRING]
	
	store_file_name: STRING
	
invariant
	
	internal_list_exists: internal_list /= Void
--	list_exists: list /= Void
	store_file_name_exists: store_file_name /= Void

end -- class UNIQUE_STRING_LIST

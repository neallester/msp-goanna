indexing
	description: "Generic notion of a pool of objects. May be bounded or unbounded."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "utility"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	POOL [K -> ANY]

		-- TODO: this is only used by the test cases - delete it perhaps

creation

	make, make_bounded

feature -- Initialization

	make is
			-- Initialise empty pool
		do
			create {DS_LINKED_STACK [K]} free_pool.make_default
			create {DS_LINKED_LIST [K]} busy_pool.make_default
		end
	
	make_bounded (new_maximum: like maximum) is
			-- Initialise bounded pool
		do
			make
			set_maximum (new_maximum)
		end
		
feature -- Access

	item: K is
			-- Retrieve item from the free pool. Create   
			-- new item if necessary.
		require
			free_item: free_count > 0
		do
			Result := free_pool.item
			free_pool.remove
			busy_pool.force_last (Result)
		ensure
			busy: is_busy (Result)
		end
		
	return (i: K) is
			-- Make 'i' available on free pool.
		require
			is_busy: is_busy (i)
		do
			busy_pool.delete (i)
			free_pool.put (i)
		ensure
			free: is_free (i)
		end
	
	is_full: BOOLEAN is
			-- Is the pool full?
		do
			Result := maximum /= 0 and then count = maximum
		ensure
			full: Result = (maximum /= 0 and then count = maximum)
		end		
		
feature -- Measurement

	free_count: INTEGER is
			-- Number of items available on free pool.
		do
			Result := free_pool.count
		end
		
	busy_count: INTEGER is
			-- Number of items currently being used.
		do
			Result := busy_pool.count
		end
		
	count: INTEGER is
			-- Total number of items in pool, free or busy.
		do
			Result := free_count + busy_count
		ensure
			free_and_busy_count: Result = free_count + busy_count
		end
		
	maximum: INTEGER
			-- Maximum number of items in pool. Zero implies 
			-- infinite size.

feature -- Status report

	is_free (i: K): BOOLEAN is
			-- Is 'i' currently available for use?
		require
			valid_i: i /= Void
		do
			Result := free_pool.has (i)
		end
		
	is_busy (i: K): BOOLEAN is
			-- Is 'i' currently being used?
		require
			valid_i: i /= Void
		do
			Result := busy_pool.has (i)
		end
	
	has (i: K): BOOLEAN is
			-- Is 'i' in pool? 'i' may be busy or free.
		require
			valid_i: i /= Void
		do
			Result := is_free (i) or is_busy (i)
		end
	
feature -- Status setting
	
	put (i: K) is
			-- Add 'i' to pool.
		require
			not_full: not is_full
			not_in_pool: not has (i)
		do
			free_pool.put (i)
		ensure
			new_item_is_free: is_free (i)
		end
			
	set_maximum (new_maximum: like maximum) is
			-- Set 'maximum to 'new_maximum'
		require
			valid_maximum: new_maximum > 0
			larger_or_equal_to_count: new_maximum >= count
		do
			maximum := new_maximum
		end
		
feature {NONE} -- Implementation

	free_pool: DS_STACK [K]
			-- Stack of free items
	
	busy_pool: DS_LIST [K]
			-- List of busy items
		
invariant

	valid_pool_size: maximum = 0 or else count <= maximum

end -- class POOL

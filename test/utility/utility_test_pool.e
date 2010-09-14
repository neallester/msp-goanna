note



	description: "Test features of class POOL"

	library:    "Goanna Utility Test Harnesses"

	author:     "Glenn Maughan <glennmaughan@optushome.com.au>"

	copyright:  "Copyright (c) 2001, Glenn Maughan and others"

	license:    "Eiffel Forum Freeware License v1 (see forum.txt)"

	date:       "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"

	revision:   "$Revision: 491 $"



deferred class UTILITY_TEST_POOL



inherit



	TS_TEST_CASE



feature -- Test



	test_unbounded_pool

			-- Test unbounded pool

		local

			pool: POOL [POOL_ELEMENT]

			item, item2, item3: POOL_ELEMENT

		do

			create pool.make

			assert_integers_equal ("free_count" , 0, pool.free_count)

			assert_integers_equal ("busy_count" , 0, pool.busy_count)

			assert_integers_equal ("count" , 0, pool.count)



			-- put elements in pool

			create item

			pool.put (item)

			assert ("item_added", pool.has (item))

			assert ("free_item", pool.is_free (item))

			assert ("not_busy_item", not pool.is_busy (item))

			assert_integers_equal ("free_count1" , 1, pool.free_count)



			create item2

			pool.put (item2)

			assert ("item2_added", pool.has (item2))

			assert ("free_item2", pool.is_free (item2))

			assert ("not_busy_item2", not pool.is_busy (item2))

			assert_integers_equal ("free_count2" , 2, pool.free_count)

			

			create item3

			pool.put (item3)

			assert ("item3_added", pool.has (item3))

			assert ("free_item3", pool.is_free (item3))

			assert ("not_busy_item3", not pool.is_busy (item3))

			assert_integers_equal ("free_count3" , 3, pool.free_count)

			

			item := pool.item

			assert ("busy", pool.is_busy (item))

			item2 := pool.item

			item3 := pool.item

			assert_integers_equal ("free_count" , 0, pool.free_count)

			assert_integers_equal ("busy_count" , 3, pool.busy_count)

			pool.return (item)

			assert_equal ("free", True, pool.is_free (item))

			assert_integers_equal ("free_count2", 1, pool.free_count)

			assert_integers_equal ("busy_count2", 2, pool.busy_count)

		end



	test_bounded_pool

			-- Test bounded pool

		local

			pool: POOL [POOL_ELEMENT]

			item, item2: POOL_ELEMENT

		do

			create pool.make_bounded (2)

			create item

			pool.put (item)

			create item2

			pool.put (item2)

			assert ("full", pool.is_full)

	

			item := pool.item

			assert ("busy", pool.is_busy (item))

			assert ("full", pool.is_full)

			

			item2 := pool.item

			assert ("busy2", pool.is_busy (item))

			assert ("full", pool.is_full)

		end

		

end -- class UTILITY_TEST_POOL


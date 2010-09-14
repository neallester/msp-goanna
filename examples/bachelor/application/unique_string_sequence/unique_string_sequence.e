note
	description: "Objects that create a sequence of strings each unique"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/05/11"
	revision: "$Revision: 491 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

deferred class
	UNIQUE_STRING_SEQUENCE

inherit

	SYSTEM_CONSTANTS

feature -- Access

	forth
		-- increment counter, reset if over maximum_counter
		do
			counter := counter + increment
			if counter > maximum_counter then
				counter := minimum_counter
			end
			storage_file.start
			storage_file.put_string(counter.out)
		ensure	
			counter_incremented : old counter /= maximum_counter implies counter = old counter + increment
			counter_reset : old counter = maximum_counter implies counter = minimum_counter
		end

	unique_string : STRING
		-- A unique string (to limit of maximum_counter) call 'forth' to increment
		-- To_Do; make this more secure, rather than looking like a sequence of integers
		do
			Result := counter.out
		ensure
			valid_new_url : result /= void and not result.is_empty
		end

feature {NONE} -- implementation

	counter : INTEGER
		-- A counter that records the current number of a URL to issue

	minimum_counter : INTEGER = 1000

	maximum_counter : INTEGER = 100000000

	increment : INTEGER = 1

	storage_file : PLAIN_TEXT_FILE
		-- The file where persistent counter values are stored

	storage_file_name : STRING 
		-- The file name used to store this class
		deferred
		end

feature {NONE} -- creation	

	make
		local
			last_string : STRING
			last_string_as_integer : INTEGER
		do
			create storage_file.make_open_read (storage_file_name)
			if storage_file.is_empty then
				counter := minimum_counter
			else
				last_string := ""
				storage_file.read_line
				last_string.copy (storage_file.last_string)
				last_string_as_integer := last_string.to_integer
				counter := last_string_as_integer
			end
			storage_file.open_write			
		end


invariant

valid_storage_file : storage_file /= Void
storage_file_open_write : storage_file.is_open_write

end -- class UNIQUE_STRING_SEQUENCE
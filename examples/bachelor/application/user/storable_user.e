note
	description: "User objects that can be stored in an ISE RAW_FILE"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/05/10"
	revision: "$Revision: 491 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

deferred class
	STORABLE_USER

inherit

	STORABLE
	USER
		redefine
			make
		end

feature

	store
		-- Store this user in persistent media
--		local
--			a_file: RAW_FILE
		do
			if not anonymous then
				store_by_name (full_file_name)
--				create a_file.make (full_file_name)
--				a_file.wipe_out
--				a_file.open_write
--				a_file.basic_store (current)
--				if not a_file.is_closed then
--					a_file.close
--				end
			end
		end

feature {NONE}	-- Implementation

	user_file_name_factory : USER_FILE_NAME_FACTORY
		-- Where unique user_file_names come from.
		once
			create result.make
		end

	full_file_name : STRING
		-- The full file name where this user is stored, including drive/directory & extension
		do
			result := data_directory + directory_separator + user_file_name + file_extension
		end

feature {NONE} -- Creation

	make (new_page_sequencer : PAGE_SEQUENCER)
		do
			precursor (new_page_sequencer)
			user_file_name_factory.forth
			user_file_name := clone (user_file_name_factory.unique_string)
		end

invariant

	valid_user_file_name_factory : user_file_name_factory /= Void

end -- class STORABLE_USER

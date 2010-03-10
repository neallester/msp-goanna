indexing
	description: "Transaction management where no database access is required"
	author: "Neal L Lester <neallester@users.sourceforge.net>"
	date: "$Date: 2009-05-28 22:23:57 -0700 (Thu, 28 May 2009) $"
	revision: "$Revision: 617 $"
	copyright: "(c) Neal L Lester"
	License: "Eiffel Forum License Version 2 (see forum.txt)"

class
	GOA_NON_DATABASE_ACCESS_TRANSACTION_MANAGEMENT

inherit

	GOA_TRANSACTION_MANAGEMENT

feature

	ok_to_process (processing_result: PARAMETER_PROCESSING_RESULT): BOOLEAN is
		do
			Result := True
		end

	ok_to_read_data (processing_result: REQUEST_PROCESSING_RESULT): BOOLEAN is
		do
			Result := True
		end

	ok_to_write_data (processing_result: REQUEST_PROCESSING_RESULT): BOOLEAN is
		do
			Result := True
		end

	start_transaction (processing_result: REQUEST_PROCESSING_RESULT) is
			-- Place system in state where information may be written to data structures
		do
			-- Nothing
		end

	start_version_access (processing_result: REQUEST_PROCESSING_RESULT) is
			-- Place system in state where information may be read from data structures
		do
			-- Nothing
		end

	commit (processing_result: REQUEST_PROCESSING_RESULT) is
			-- Commit all changes to data structures
		do
			-- Nothing
		end

	safe_commit (processing_result: REQUEST_PROCESSING_RESULT) is
			-- Commit all changes to data structures
		do
			-- Nothing
		end

	end_version_access (processing_result: REQUEST_PROCESSING_RESULT) is
		do
			-- Nothing
		end

	safe_end_version_access (processing_result: REQUEST_PROCESSING_RESULT) is
		do
			-- Nothing
		end

	ok_to_start_transaction (processing_result: REQUEST_PROCESSING_RESULT): BOOLEAN is
			-- Can we currently start a transaction?
		do
			Result := True
		end

	ok_to_start_version_access (processing_result: REQUEST_PROCESSING_RESULT): BOOLEAN is
			-- Can we currently start a version access?
		do
			Result := True
		end

	ok_to_end_version_access (processing_result: REQUEST_PROCESSING_RESULT): BOOLEAN is
			-- Can we currently call commit?
		do
			Result := True
		end

	ok_to_commit (processing_result: REQUEST_PROCESSING_RESULT): BOOLEAN is
			-- Can we currently call commit?
		do
			Result := True
		end

	implements_transaction_and_version_access: BOOLEAN is
		once
			Result := False
		end

end -- class GOA_NON_DATABASE_ACCESS_TRANSACTION_MANAGEMENT

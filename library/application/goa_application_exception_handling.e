indexing
	description: "Objects that handle exceptions within applications"
	author: "Neal L. Lester (neal@3dsafety.com)"
	date: "$Date$"
	revision: "$Revision$"
	copyright: "(c) 2007 Neal L. Lester and others"

class
	GOA_APPLICATION_EXCEPTION_HANDLING

inherit

	KL_SHARED_EXCEPTIONS

feature

	broken_pipe_exception_message: STRING is "Broken pipe"
		-- Possibly Linux only; Not known if this is the same on Windows
		-- See TODO for broken_pipe_error

	connection_reset_by_peer_message: STRING is "Connection reset by peer"
		-- Possibly Linux only; Not known if this is the same on Windows

	broken_pipe_error: INTEGER is 32
		-- Currently not used
		-- Linux Only; probably 10054 on Windows
		-- TODO Change this to refer to the platform
		-- independent EPOSIX constant, once one is added to
		-- EPOSIX.  At that time, verify that
		-- STDC_BASE.raise_posix_error correctly sets
		-- STDC_BASE.errno.first_value
		-- Also see fixes required (then) for rescue
		-- clauses of accept and process_request
		-- I have one lingering question about using
		-- broken pipe error instead of the exception message
		-- If errno.first_value is not 0 when the broken pipe
		-- exception occurs then the rescue clause will not
		-- catch and retry, and the program will crash.
		-- However, relying on the text of the message seems
		-- less reliable then using the error codes


end

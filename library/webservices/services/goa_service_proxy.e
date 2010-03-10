indexing
	description: "Objects representing a proxy to a service."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "SOAP"
	date: "$Date: 2007-04-08 02:43:35 -0700 (Sun, 08 Apr 2007) $"
	revision: "$Revision: 563 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

deferred class GOA_SERVICE_PROXY

inherit

	GOA_REGISTRY [ROUTINE [ANY, TUPLE]]


feature -- Status report

	valid_operands (a_name: STRING; operands: TUPLE): BOOLEAN is
			-- Are 'operands' valid operands for the function named 'a_name'?
		require
			name_exists: a_name /= Void
			service_exists: has (a_name)
			args_exist: operands /= Void
		do
			Result := get (a_name).valid_operands (operands)
		end

	process_ok: BOOLEAN
			-- Did the last execution of this service succeed?

	last_result: ANY
			-- The result of the last execution. Void if no result.

	last_fault: STRING
			-- The last fault that occured. Void if no fault occured.

	help (a_name: STRING): STRING is
			-- Documentation for the named service.
		require
			name_exists: a_name /= Void
			service_exists: has (a_name)
		do
			if routine_help /= Void and then routine_help.has (a_name) then
				Result := routine_help.item (a_name)
			else
				Result := ""
			end
		end

feature -- Status setting

	register_with_help (element: ROUTINE [ANY, TUPLE]; a_name, help_string: STRING) is
			-- Register 'element' with 'a_name' and 'help_string'
		require
			name_exists: a_name /= Void
			element_exists: element /= Void
			help_exists: help_string /= Void
		do
			elements.force (element, a_name)
			set_help (a_name, help_string)
		ensure
			element_registered: has (a_name)
			help_set: help (a_name).is_equal (help_string)
		end

	call (a_name: STRING; args: TUPLE) is
			-- Call named routine
		local
			function: FUNCTION [ANY, TUPLE, ANY]
			routine: ROUTINE [ANY, TUPLE]
		do
			last_fault := Void
			last_result := Void
			if has (a_name) then
				routine := get (a_name)
				-- check if it is a function so that a result is returned
				function ?= routine
				if function /= Void then
					function.call (args)
					last_result := function.last_result
				else
					routine.call (args)
				end
				process_ok := True
			else
				process_ok := False
			end
		end

	set_help (a_name, help_string: STRING) is
			-- Set the help string for the named routine.
		require
			name_exists: a_name /= Void
			service_exists: has (a_name)
			help_exists: help_string /= Void
		do
			if routine_help = Void then
				create routine_help.make_default
			end
			routine_help.force (help_string, a_name)
		ensure
			help_set: help (a_name).is_equal (help_string)
		end

feature -- Creation

	new_tuple (a_name: STRING): TUPLE is
			--	Tuple of default-valued arguments to pass to call `a_name'.
		require
			name_exists: a_name /= Void
			service_exists: has (a_name)
		deferred
		ensure
			tuple_not_void: Result /= Void
		end

feature -- Implementation

	routine_help: DS_HASH_TABLE [STRING, STRING]
			-- Help strings for individual routine of this service.

end -- class GOA_SERVICE_PROXY

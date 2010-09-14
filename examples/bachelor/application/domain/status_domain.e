note
	description: "Domains with a state than can be represented by an integer code"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/06/13"
	revision: "$Revision: 513 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

deferred class
	STATUS_DOMAIN

inherit
	DOMAIN
		redefine
			update, initialize
		end
	TIME_STAMPED_DOMAIN
		redefine
			update, initialize, initialized
		end
		
feature

	evaluated : BOOLEAN
		-- Has this object been evaluated?
		do
			result := not equal (status_code, not_evaluated_code)
		end

	reset
		-- reset the status to not_evaluated
		do
			set_status_code (not_evaluated_code)
		end

	undo
			-- Roll back to previous state
		do
			status_code := status_history.first
			time_last_modified := date_time_history.first
			status_history.remove_first
			date_time_history.remove_first
		ensure
			status_code_rolled_back: status_code = old status_history.first
			date_time_rolled_back: time_last_modified = old date_time_history.first
		end
			
feature {NONE} -- implementation

	status_code : INTEGER
			-- An integer representing the current status of the object

	set_status_code (new_status_code : INTEGER)
			-- set the new status code
		do
			status_history.force_first (status_code)
			date_time_history.force_first (clone (time_last_modified))
			status_code := new_status_code
			update
		ensure
			status_code_updated : status_code = new_status_code
		end

	not_evaluated_code : INTEGER = 0
			-- The code corresponding to a status of 'not_evaluated'
			
	status_history: DS_LINKED_LIST [INTEGER]
	
	date_time_history: DS_LINKED_LIST [DT_DATE_TIME]
	
	initialize
		do
			create status_history.make
			create date_time_history.make
			status_initialized := true
 			precursor {TIME_STAMPED_DOMAIN} 
		end
		
	update
			-- Update the domain
		do
			precursor {TIME_STAMPED_DOMAIN} 
		end
		
	initialized: BOOLEAN
			-- Has the domain been initialized?
		do
			result := status_initialized and precursor {TIME_STAMPED_DOMAIN} 
		end
		
	status_initialized: BOOLEAN
		
invariant

	not_evaluated_code_zero : equal (not_evaluated_code, 0)
	evaluated_implies_status_code__not_not_evaluated_code : evaluated implies not equal (status_code, not_evaluated_code)
	status_history_not_void: status_history /= Void
	date_time_history_not_void: date_time_history /= Void
	history_synchronized: equal (status_history.count, date_time_history.count)

end -- class STATUS_DOMAIN

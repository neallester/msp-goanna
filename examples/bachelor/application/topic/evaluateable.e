indexing
	description: "Objects that can be evaluated"
	author: "Neal L. Lester"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"

deferred class
	EVALUATEABLE

feature -- attributes

	evaluated : BOOLEAN is
		-- Has this object been evaluated?
		do
			result := not equal (status_code, 0)
		end

	not_evaluated : BOOLEAN is
		-- This object has not been evaluated
		do
			result := equal (status_code, 0)



	

feature {NONE} -- implementation

	update is
		-- The status_code has been changed
		deferred
		end

	status_code : INTEGER
		-- 

end -- class EVALUATEABLE

note
	description: "Domains that that have a status of yes or no"
	author: "Neal Lester"
	date: "$Date: 2006-10-01 13:33:03 -0700 (Sun, 01 Oct 2006) $"
	revision: "$Revision: 513 $"

deferred class

	YES_NO

inherit
	STATUS_DOMAIN
		redefine
			update, initialize, initialized
		end
	DOMAIN_WITH_PARENT
		redefine
			update, initialize, initialized
		end
	TOPIC

feature -- attributes

	yes: BOOLEAN
			-- The status is 'yes'
		do
			result := equal (status_code, yes_code)
		end

	no: BOOLEAN
			-- The status is 'no'
		do
			result := equal (status_code, no_code)
		end

	set_yes
			-- Set status to yes
		do
			set_status_code (yes_code)
		ensure
			yes : yes
		end

	set_no
			-- Set status to no
		do
			set_status_code (no_code)
		ensure
			no : no
		end

	question: STRING
			-- The question that this topic asks
		deferred
		end

feature {NONE} -- implementation

	yes_code, no_code: INTEGER = unique
			-- Status codes

	update
		do
			precursor {STATUS_DOMAIN} 
			precursor {DOMAIN_WITH_PARENT} 
		end

	initialize
		do
			precursor {STATUS_DOMAIN} 
		end

	initialized: BOOLEAN
		do
			result := precursor {STATUS_DOMAIN} 
		end

feature {NONE} -- Creation

	make_with_user_and_parent (new_parent: DOMAIN_WITH_CHILDREN; new_user: like user_anchor)
		require
			new_user_exists: new_user /= Void
			new_parent_exists: new_parent /= Void
		do
			set_user (new_user)
			make_with_parent (new_parent)
		end
		
invariant

	yes_implies_evaluated : yes implies evaluated
	no_implies_evaluated : no implies evaluated
	yes_implies_not_no : yes implies not no
	no_implies_not_yes : no implies not yes

end -- class YES_NO

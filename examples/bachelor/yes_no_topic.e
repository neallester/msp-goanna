indexing
	description: "Topics that represent single questions that can be answered with a yes or no answer"
	author: "Neal L. Lester (neal@3dsafety.com)"
	date: "$ May 11, 2001: $"
	revision: "$version 1.0$"

deferred class
	YES_NO_TOPIC

inherit
	BACHELOR_TOPIC
	UNDOABLE_TOPIC
		redefine
			initialize
		end

feature

	question : STRING is
		-- The question associated with the topic
		deferred
		end

	yes : BOOLEAN is
		-- The answer to this question is yes
		do
			result := yes_implementation
		end

	no : BOOLEAN is
		-- The answer to question is no
		do
			result := no_implementation
		end

	evaluated : BOOLEAN is
		-- Has this question been evaluated
		do
			result := evaluated_implementation
		end

	set_yes is
		do
			yes_implementation := true
			no_implementation := false
			evaluated_implementation := true
			update
		end

	set_no is
		do
			yes_implementation := false
			no_implementation := true
			evaluated_implementation := true
			update
		end

	reset is
		do
			yes_implementation := false
			no_implementation := false
			evaluated_implementation := false
			update
		end

	initialize (proposed_user : like user_anchor) is
		do
			yes_implementation := false
			no_implementation := false
			evaluated_implementation := false
			precursor (proposed_user)
		end

	text : TEXT_LIST is
		do
			result := user.preference.language
		end

feature {NONE} --	implementation

	yes_implementation : BOOLEAN

	no_implementation : BOOLEAN

	evaluated_implementation : BOOLEAN

invariant

	yes_implies_evaluated : yes implies evaluated
	yes_implies_not_no : yes implies not no
	no_implies_evaluated : no implies evaluated
	no_implies_not_yes : no implies not yes
	not_evaluated_implies_not_yes : not evaluated implies not yes
	not_evaluated_implies_not_no : not evaluated implies not no

end -- class YES_NO_TOPIC

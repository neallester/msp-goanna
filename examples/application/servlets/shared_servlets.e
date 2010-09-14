note
	description: "Shared Access to Servlets"
	author: "Neal L. Lester <neallester@users.sourceforge.net>"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	copyright: "(c) 2005 Neal L. Lester and others"
	License: "Eiffel Forum License Version 2 (see forum.txt)"

class
	SHARED_SERVLETS

inherit

	GOA_SHARED_SERVLETS

feature -- Servlets

	question_servlet: QUESTION_SERVLET
			-- Servlet that asks the user some questions
		once
			create Result.make
		end
		
	answer_servlet: ANSWER_SERVLET
			-- Servlet that displays the user's answers
		once
			create Result.make
		end

end -- class SHARED_SERVLETS

note
	description: "A servlet that processes requests to go directly to another page"
	author: "Neal L Lester <neal@3dsafety.com>"
	date: "$Date: 2007-01-10 09:26:51 -0800 (Wed, 10 Jan 2007) $"
	revision: "$Revision: 533 $"
	copyright: "(c) Neal L Lester"

class
	GOA_GO_TO_SERVLET

inherit

	GOA_APPLICATION_SERVLET
		redefine
			make
		end
	GOA_NON_DATABASE_ACCESS_TRANSACTION_MANAGEMENT

create

	make

feature

	name: STRING = "go_to.htm"

feature {NONE} -- Creation

	make
			-- Creation
		do
			Precursor
			expected_parameters.force_last (page_parameter.name)
		end

end -- class GOA_GO_TO_SERVLET

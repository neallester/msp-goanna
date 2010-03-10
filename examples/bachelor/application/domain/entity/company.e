indexing
	description: "Objects that represent Companies or Corporations"
	author: "Neal L. Lester"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	copyright: "(c) 2001 Neal L. Lester"

class
	COMPANY

inherit
	ENTITY
		redefine
			company
		end

create
	make

feature -- Access

	company: COMPANY is
			-- The company associated with this entity
		do
			result := current
		end
		
feature {NONE} -- creation
	
	make is
			-- Creation
		do
			initialize
		end

end -- class COMPANY

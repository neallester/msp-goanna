indexing
	description: "Access to information associated with the user session"
	author: "Neal L. Lester <neallester@users.sourceforge.net>"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	copyright: "(c) 2005 Neal L. Lester and others"
	License: "Eiffel Forum License Version 2 (see forum.txt)"

class
	SESSION_STATUS
	
inherit

	GOA_SESSION_STATUS
		redefine
			initialize
		end

creation
	
	make
	
feature -- Attributes

	name: STRING
	
	is_male: BOOLEAN
	
	programming_language: PROGRAMMING_LANGUAGE_SELECTION
	
	thinks_goanna_is_cool: BOOLEAN
	
feature -- Setting Attributes

	set_name (new_name: STRING) is
		require
			valid_new_name: new_name /= Void
		do
			name := new_name
		ensure
			name_updated: equal (name, new_name)
		end
		
	set_is_male is
		do
			is_male := True
		ensure
			is_male: is_male
		end
		
	set_is_female is
		do
			is_male := False
		ensure
			is_female: not is_male
		end

	set_programming_language (new_programming_language: PROGRAMMING_LANGUAGE_SELECTION) is
		require
			valid_new_programming_language: new_programming_language /= Void
		do
			programming_language := new_programming_language
		ensure
			programming_language_updated: equal (programming_language, new_programming_language)
		end
	
	set_thinks_goanna_is_cool (new_value: BOOLEAN) is
		do
			thinks_goanna_is_cool := new_value
		ensure
			new_value_implies_goanna_is_cool: new_value implies thinks_goanna_is_cool
			not_new_value_implies_not_goanna_is_cool: not new_value implies not thinks_goanna_is_cool
		end

feature {GOA_APPLICATION_SERVLET} -- Initialization

	initialize (processing_result: REQUEST_PROCESSING_RESULT) is
		do
			set_is_male
			set_name ("")
			Precursor (processing_result)
		end

invariant
	
	valid_name: initialized implies name /= Void

end -- class SESSION_STATUS

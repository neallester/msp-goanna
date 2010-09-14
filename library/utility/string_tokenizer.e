note
	description: "Objects that parser strings into tokens"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "Utility"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	STRING_TOKENIZER
	
obsolete "Use GOA_STRING_TOKENIZER instead"

inherit

	STRING_MANIPULATION
--		export
--			{NONE} all
--		end
		
create
	make

feature -- Initialization

	make (str: STRING)
			-- Build a tokenizer that will parse 'str'
		require
			str_exists: str /= Void
		do
			internal_string := str
			set_token_separator (' ')
		ensure
			space_separator: token_separator = ' '
		end
	
feature -- Access

	token: STRING
			-- Token at current position
		require
			not_off: not off
		local
			next_separator: INTEGER
		do
			-- build next token from the string between two separators or between the
			-- last separator and the end of the string
			next_separator := index_of_char (internal_string, token_separator, position + 1)
			if next_separator = 0 then
				next_separator := internal_string.count + 1
			end
			Result := internal_string.substring (position, next_separator - 1) 
		end
		
	token_separator: CHARACTER
			-- The separator character between tokens
			
feature -- Status report

	exhausted: BOOLEAN
			-- Has string been completely parsed?
		do
			Result := off
		ensure
			exhausted_when_off: off implies Result
		end

	after: BOOLEAN
			-- Is there no valid token to the right of current one?
		do
			Result := (position >= internal_string.count)		
		end

	off: BOOLEAN
			-- Is there no current token?
		do
			Result := is_empty or after
		end
	
	is_empty: BOOLEAN
			-- Is string empty?
		do
			Result := internal_string.is_empty
		end
		
feature -- Status setting

	set_token_separator (ch: CHARACTER)
			-- Set the token separator to 'ch'
		do
			token_separator := ch
		end
	
feature -- Cursor movement

	start
			-- Move to start of string if any.
		do
			position := 1		
		end

	forth
			-- Move to next token; if no next position,
			-- ensure that 'exhausted' will be true.
		require
			not_after: not after
		do
			-- move position to start of next token
			position := index_of_char (internal_string, token_separator, position + 1)
			if position = 0 then
				position := internal_string.count
			else
				position := position + 1
			end		
		end
	
feature {NONE} -- Implementation

	internal_string: STRING
			-- Internal string to parse.
			
	position: INTEGER
			-- Current index position for parsing.
				
invariant

	after_constraint: after implies off

end -- class STRING_TOKENIZER

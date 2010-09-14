note
	description: "Main spell checker window"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "examples xmlrpc spellchecker"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	MAIN_WINDOW

inherit

	EV_TITLED_WINDOW
		redefine
			initialize
		end
		
	EV_STOCK_COLORS
		rename
			implementation as color_implementation
		export
			{NONE} all
		undefine
			copy, default_create
		end
		
create
	make

feature -- Initialisation

	make (new_model: SPELL_CHECKER)
			-- Initialise this window to call back into 'new_model' on button events
		require
			model_exists: new_model /= Void
		do
			model := new_model
			default_create
		end
		
	initialize
			-- Initialize `Current' to set up calculator widgets.
		local
			vb: EV_VERTICAL_BOX
			hb: EV_HORIZONTAL_BOX
			l: EV_LABEL
			b: EV_BUTTON
			status: EV_STATUS_BAR
			environment: EV_ENVIRONMENT
		do
			Precursor {EV_TITLED_WINDOW}
			set_title ("Spell Checker")
			
			create vb
			extend (vb)
				
			-- add name section
			create l.make_with_text ("Text to spell-check")
			l.align_text_left
			vb.extend (l)
			create text
			text.set_minimum_height (70)
			text.set_minimum_width (300)
			vb.extend (text)
			
			-- add button section
			create hb
			create b.make_with_text ("Check")
			b.select_actions.extend (agent model.check_spelling)
			hb.extend (b)
			
			create b.make_with_text ("Clear")
			b.select_actions.extend (agent clear)
			hb.extend (b)
			
			vb.extend (hb)
			
			-- add suggested words section
			create l.make_with_text ("Suggested Words")
			l.align_text_left
			vb.extend (l)
			create words
			vb.extend (words)
	
			-- add error display widget
			create hb
			create status
			create error
			error.align_text_left
			status.extend (error)
			hb.extend (status)
			vb.extend (hb)
			
			-- allow close using X button
			create environment
			close_request_actions.extend (agent (environment.application).destroy)
		end
	
feature -- Status setting
		
	update_error_message (message: STRING)
			-- Update the error widget text to 'message'
		require
			message_exists: message /= Void
		do
			error.set_text (message)
		end
	
	update_suggested_words (new_words: DS_LINKED_LIST [STRING])
			-- Set list of suggested words to 'words'
		require
			words_exists: new_words /= Void
		do
		end
	
	clear
			-- Clear text and words fields
		do
			text.remove_text
			words.wipe_out
		end
		
feature -- Widgets

	model: SPELL_CHECKER
			-- Spell checker instance to call back to
	
	words: EV_LIST
			-- list of suggested words
	
	text: EV_TEXT
			-- Field of text to spell
			
	error: EV_LABEL
			-- Widget for displaying error messages
	
end -- class MAIN_WINDOW

indexing
	description: "Main calculator window"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "examples xmlrpc calculator"
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

	make (calc: CALCULATOR) is
			-- Initialise this window to call back into 'calc' on button events
		require
			calc_exists: calc /= Void
		do
			calculator := calc
			default_create
		end
		
	initialize is
			-- Initialize `Current' to set up calculator widgets.
		local
			vb: EV_VERTICAL_BOX
			hb: EV_HORIZONTAL_BOX
			b: EV_BUTTON
			status: EV_STATUS_BAR
			environment: EV_ENVIRONMENT
		do
			Precursor {EV_TITLED_WINDOW}
			set_title ("XML-RPC Calculator")
			
			create vb
			extend (vb)
			
			-- add display LCD widget
			create hb
			create text
			text.set_background_color (White)
			text.align_text_right
			hb.extend (text)
			vb.extend (hb)
			
			-- add first row of buttons 7, 8, 9, C, AC
			create hb
			create b.make_with_text ("7")
			b.select_actions.extend (agent calculator.seven)
			hb.extend (b)
			create b.make_with_text ("8")
			b.select_actions.extend (agent calculator.eight)
			hb.extend (b)
			create b.make_with_text ("9")
			b.select_actions.extend (agent calculator.nine)
			hb.extend (b)
			create b.make_with_text ("C")
			b.select_actions.extend (agent calculator.clear)
			hb.extend (b)
			create b.make_with_text ("AC")
			b.select_actions.extend (agent calculator.all_clear)
			hb.extend (b)
			vb.extend (hb)
			
			-- add second row of buttons 4, 5, 6, *, /
			create hb
			create b.make_with_text ("4")
			b.select_actions.extend (agent calculator.four)
			hb.extend (b)
			create b.make_with_text ("5")
			b.select_actions.extend (agent calculator.five)
			hb.extend (b)
			create b.make_with_text ("6")
			b.select_actions.extend (agent calculator.six)
			hb.extend (b)
			create b.make_with_text ("*")
			b.select_actions.extend (agent calculator.multiply)
			hb.extend (b)
			create b.make_with_text ("/")
			b.select_actions.extend (agent calculator.divide)
			hb.extend (b)
			vb.extend (hb)
			
			-- add third row of buttons 1, 2, 3, +, -
			create hb
			create b.make_with_text ("1")
			b.select_actions.extend (agent calculator.one)
			hb.extend (b)
			create b.make_with_text ("2")
			b.select_actions.extend (agent calculator.two)
			hb.extend (b)
			create b.make_with_text ("3")
			b.select_actions.extend (agent calculator.three)
			hb.extend (b)
			create b.make_with_text ("+")
			b.select_actions.extend (agent calculator.add)
			hb.extend (b)
			create b.make_with_text ("-")
			b.select_actions.extend (agent calculator.subtract)
			hb.extend (b)
			vb.extend (hb)
			
			-- add fourth row of buttons 0, ., =
			create hb
			create b.make_with_text ("0")
			b.select_actions.extend (agent calculator.zero)
			hb.extend (b)
			create b.make_with_text (".")
			b.select_actions.extend (agent calculator.decimal)
			hb.extend (b)
			create b.make_with_text ("=")
			b.select_actions.extend (agent calculator.equals)
			hb.extend (b)
			vb.extend (hb)
			
			-- add error display widget
			create hb
			create status
			create error
			status.extend (error)
			hb.extend (status)
			vb.extend (hb)
			
			-- allow close using X button
			create environment
			close_request_actions.extend (agent (environment.application).destroy)
		end
	
feature -- Status setting

	update_value (value: STRING) is
			-- Update the 'LCD' widget text to 'value'
		require
			value_exists: value /= Void
		do
			text.set_text (value)
		end
		
	clear_value  is
			-- Clear the 'LCD' widget text
		do
			text.set_text (" ")
		end
		
	update_error_message (message: STRING) is
			-- Update the error widget text to 'message'
		require
			message_exists: message /= Void
		do
			error.set_text (message)
		end
		
feature {NONE} -- Implementation

	calculator: CALCULATOR
			-- Calculator instance to call back to
	
	text: EV_LABEL
			-- LCD widget for displaying current value
			
	error: EV_LABEL
			-- Widget for displaying error messages
	
end -- class MAIN_WINDOW

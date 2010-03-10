indexing
	description: "Main current time window"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "examples xmlrpc currenttime"
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

	make (new_model: like model) is
			-- Initialise this window to call back into 'new_model' on button events
		require
			model_exists: new_model /= Void
		do
			model := new_model
			default_create
		end
		
	initialize is
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
			set_title ("Current Time")
			
			create vb
			vb.set_minimum_width (200)
			extend (vb)
				
			-- add time section
			create l.make_with_text ("Current Time")
			l.align_text_left
			vb.extend (l)
			create time
			vb.extend (time)
			
			-- add button section
			create b.make_with_text ("Get Time")
			b.align_text_left
			b.select_actions.extend (agent model.retrieve_time)			
			vb.extend (b)

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
		
	update_error_message (message: STRING) is
			-- Update the error widget text to 'message'
		require
			message_exists: message /= Void
		do
			error.set_text (message)
		end
	
	update_time (date_time: DT_DATE_TIME) is
			-- Set time
		require
			time_exists: time /= Void
		do
			time.set_text (date_time.out)
		end
		
feature -- Widgets

	model: CURRENT_TIME
			-- model to call back to
	
	time: EV_TEXT_FIELD
			-- Field to display time
			
	error: EV_LABEL
			-- Widget for displaying error messages
	
end -- class MAIN_WINDOW

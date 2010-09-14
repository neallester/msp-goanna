note
	description: "Main address book window"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "examples xmlrpc addressbook"
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

	make (ab: ADDRESS_BOOK)
			-- Initialise this window to call back into 'ab' on button events
		require
			address_book_exists: ab /= Void
		do
			address_book := ab
			default_create
		end
		
	initialize
			-- Initialize `Current' to set up calculator widgets.
		local
			vb: EV_VERTICAL_BOX
			hb: EV_HORIZONTAL_BOX
			l: EV_LABEL
			hs: EV_HORIZONTAL_SEPARATOR
			b: EV_BUTTON
			status: EV_STATUS_BAR
			environment: EV_ENVIRONMENT
		do
			Precursor {EV_TITLED_WINDOW}
			set_title ("Address Book")
			
			create vb
			extend (vb)
				
			-- add name section
			create l.make_with_text ("Name")
			l.align_text_left
			vb.extend (l)
			create names
			names.select_actions.extend (agent address_book.get)
			vb.extend (names)
			
			-- add address section
			create l.make_with_text ("Address")
			l.align_text_left
			vb.extend (l)
			create address
			vb.extend (address)
			
			-- add horizontal bar
			create hs
			vb.extend (hs)
			
			-- add action buttons
			create hb
			create b.make_with_text ("Add")
			b.select_actions.extend (agent address_book.add)
			hb.extend (b)
			
			create b.make_with_text ("Remove")
			b.select_actions.extend (agent address_book.remove)
			hb.extend (b)
			
			create b.make_with_text ("Refresh")
			b.select_actions.extend (agent address_book.refresh)
			hb.extend (b)		
			vb.extend (hb)
			
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
	
	update_names (new_names: ARRAY [ANY])
			-- Refresh list with new names
		require
			new_names_exist: new_names /= Void
		local
			i: INTEGER
			str: STRING
			list_item: EV_LIST_ITEM
		do
			from
				names.wipe_out
				i := new_names.lower
			until
				i > new_names.upper
			loop
				str ?= new_names.item (i)
				check
					string_name: str /= Void
				end
				create list_item.make_with_text (str)
				names.force (list_item)
				i := i + 1
			end
			-- clear address
			update_address (" ")
			names.remove_selection
			names.deselect_all
		end
	
	update_address (new_address: STRING)
			-- Set address text to 'new_address'
		require
			new_address_exists: new_address /= Void
		do
			address.set_text (new_address)
			names.deselect_all
		end
		
feature -- Widgets

	address_book: ADDRESS_BOOK
			-- Calculator instance to call back to
	
	names: EV_COMBO_BOX
			-- Drop down list of names
	
	address: EV_TEXT_FIELD
			-- Address field
			
	error: EV_LABEL
			-- Widget for displaying error messages
	
end -- class MAIN_WINDOW

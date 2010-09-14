class	ROOT_CLASS

create
	
	make 

feature {NONE} -- Initialisation

	make
			-- Initialise
		do
			create control.make
			control.run
		end
		
feature -- Implementation

	control: MESSAGE_CONTROL
	
end -- class ROOT_CLASS

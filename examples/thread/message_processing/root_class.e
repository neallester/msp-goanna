class	ROOT_CLASS

creation
	
	make 

feature {NONE} -- Initialisation

	make is
			-- Initialise
		do
			create control.make
			control.run
		end
		
feature -- Implementation

	control: MESSAGE_CONTROL
	
end -- class ROOT_CLASS

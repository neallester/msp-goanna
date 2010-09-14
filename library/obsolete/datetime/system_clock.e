--|-----------------------------------------------------------------
--|   Copyright (c) 1994 University of Wales College of Cardiff   --
--|   UWCC COMMA PO Box 916 Cardiff CF2 4YN, Wales UK             --
--|   +44 -222 874812                                             --
--|   All rights reserved.                                        --
--| Permission is granted to anyone to make or distribute         --
--| copies of this software  provided that the                    --
--| copyright notice and this permission notice are preserved.    --
--| Ownership remains with University of Wales College of Cardiff --
--|-----------------------------------------------------------------

--| Modifications for Linux and ISE Eiffel 3.2 by Peter Webb, Feb. 1995

-- Class to access the system clock on a UNIX machine.

note
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $";
	revision: "$Revision: 491 $";
	compiler: "$ISE v3.2$";  
	platform: "$Linux 1.1.75$";  
	original_author: "$E W Lawson: 1994/03/29$";
	modified_by: "$Peter Webb: 1995/02/04$"

class SYSTEM_CLOCK
   
obsolete "Use GOBO 2.0 datatime cluster"

feature{ANY}

   year : INTEGER do Result := c_getyear(time); end;
   month : INTEGER do Result := c_getmonth(time); end;
   day : INTEGER do Result := c_getday(time); end;
   hour : INTEGER do Result := c_gethour(time); end;
   minute : INTEGER do Result := c_getminute(time); end;
   second : INTEGER do Result := c_getsecond(time); end;
   
   read
	-- Reads system clock and stores year, month, day, hour, minute and
	-- second in memory.
      do
	 time := c_read_time;
      end;
   
feature {SYSTEM_CLOCK}   
   time : INTEGER;

   frozen c_read_time :INTEGER
      external "C"
      end;
   
   frozen c_getyear (t:INTEGER_REF) :INTEGER
      external "C"
      end;
	 
   frozen c_getmonth (t:INTEGER_REF) :INTEGER
      external "C"
      end;
	 
   frozen c_getday (t:INTEGER_REF) :INTEGER
      external "C"
      end;
	 
   frozen c_gethour(t:INTEGER_REF) :INTEGER
      external "C"
      end;
	 
   frozen c_getminute (t:INTEGER_REF) :INTEGER
      external "C"
      end;
	 
   frozen c_getsecond (t:INTEGER_REF) :INTEGER
      external "C"
      end;
end

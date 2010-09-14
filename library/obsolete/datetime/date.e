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

-- Dates following the Gregorian calendar system

note
   date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $";
   revision: "$Revision: 491 $";
   compiler: "$Compiler: TowerEiffel v1.3$";  
   author: "$Author: C Hollinshead <c.hollinshead@cm.cf.ac.uk>" 
   
class DATE	

obsolete "Use GOBO 2.0 datatime cluster"

inherit
   COMPARABLE
      redefine
	 is_equal
      end;
   GREGORIAN_FUNCTIONS
      export {ANY}
	 dily;
      undefine
	 is_equal
      end;
   HASHABLE
      undefine
	 is_equal
      end
   
create
   make, make_to_now, make_to_day_of_year, make_to_day_of_week
   
feature{ANY}
   day, month, year: INTEGER;
   
   make(yyear, mmonth, dday: INTEGER) 
	 -- Set `day', `month' and `year'.
	 -- A zero argument sets the corresponding feature to the value supplied 
	 -- by the system clock.
      require
	 year_valid: yyear >= 0;
	 month_valid: mmonth >= 0 and mmonth <= 12;
	 day_valid: dday >= 0 and dday <= 31
      local
	 y, m, d : INTEGER;
      do
	 if yyear = 0 or mmonth = 0 or dday = 0 then clock.read end;
	 if yyear = 0 then y := clock.year else y := yyear end;
	 if mmonth = 0 then m := clock.month else m := mmonth end;
	 if dday = 0 then d := clock.day else d := dday end;
	 if d <= month_in_days(m, y) then
	    day := d;
	    month := m;
	    year := y;
	    was_set := true;
	 end;
      end; -- make
	
   make_to_now
	 -- Set to current date, as supplied by the system clock.
      do
	 clock.read;
	 year := clock.year;
	 month := clock.month;
	 day := clock.day;
	 was_set := true;
      end; -- make_to_now
   
   make_to_day_of_year(yyear, doy: INTEGER)
	 -- Set `month' and `day' by its ordinal day number in the year.
	 -- A zero argument sets the corresponding feature to the value supplied 
	 -- by the system clock.
      require
	 year_valid: yyear >= 0;
	 doy_valid: 0 <= doy and doy <= dily;
      local
	 d: integer
      do
	 if yyear = 0 or doy = 0 then clock.read; end;
	 if yyear = 0 then 
	    year := clock.year
	 else
	    year := yyear;
	 end;
	 if doy = 0 then
	    month := clock.month;
	    day := clock.day;
	    was_set := true;
	 elseif (is_leap_year and doy <= dily) or (not is_leap_year and doy <= dioy) then
	    from month := 1;
	       d := doy;
	    until d <= month_in_days(month, year)
	    loop
	       d := d - month_in_days(month, year);
	       month := month + 1
	    end;
	    day := d;
	    was_set := true;
	 end;
      end; -- make_day_of_year
   
   make_to_day_of_week(yyear, mmonth, n, dow: INTEGER)
	 -- Set date to the n'th dow in a given month and year
	 -- e.g. the 3nd Tuesday in January, 1994 would be (1994, 01, 3, 2)
	 -- given that Sunday = 0, Monday = 1 ....
	 -- Zero values of yyear and mmonth will cause these to be set to the 
	 -- current values.
      require
	 month_valid: 0 < mmonth and mmonth <= 12; 
	 year_valid: yyear = 0 or yyear > 1752 or (yyear = 1752 and month > 9);
	 n_valid: 0 < n and n <= 5;
	 dow_valid: 0 <= dow and dow <7			  
      local
	 m, year_in_century, century : INTEGER;
	 loc_year, loc_month, loc_day: INTEGER
      do
	 if yyear = 0 or mmonth = 0 or n = 0 or dow = 0 then clock.read end;
	 if yyear = 0 then loc_year := clock.year else loc_year := yyear end;
	 if mmonth = 0 then loc_month := clock.month else loc_month := mmonth end;
	    century := loc_year // 100;
	    year_in_century := loc_year \\ 100;
	 if loc_month >= 3 then
	    m := loc_month - 2
	 else
	    m := loc_month + 10;
	    if year_in_century > 0 then
	       year_in_century := year_in_century - 1;
	    else
	       year_in_century := 99;
	       century := century - 1
	    end;
	 end;
	 loc_day := dow - (((261*m - 20) // 100
			    + 1 + year_in_century
			    + century // 4
			    + year_in_century // 4
			    - 2*CENTURY) \\ 7) + 1;
	 if loc_day < 1 then loc_day := loc_day + 7 end;
	    loc_day := loc_day + 7 * (n - 1);
	 if loc_day <= month_in_days(loc_month, loc_year) then	
	    day := loc_day;
	    month := loc_month;
	    year := loc_year;
	    was_set := true;
	 end;
      end;
   
   was_set: BOOLEAN;
	 -- Did the make operation chosen to create the object result in 
	 -- a valid date being set?
   
   day_of_year: INTEGER
	 -- Ordinal number of the day in the year in the `Current' 
	 -- instance (1st January = 1).
      require
	 current_set: was_set
      local
	 m: INTEGER;
      do
	 from m := month - 1
	 until m = 0
	 loop
	    Result := Result + month_in_days( m, year );
	    m := m - 1;
	 end;
	 Result := Result + day;	
      end; -- day_of_year
   
   is_leap_year: BOOLEAN
	 -- Is `year' a leap year?
      require
	 year_valid: was_set
      do
	 Result := leap_year(year);
      end; -- is_leap_year
   
   days_in_month: INTEGER
	 -- Number of days in `month'
      require
	 current_set: was_set
      do
	 Result := month_in_days(month, year);
      end; -- days_in_month
    
   day_of_week : INTEGER
	 -- Day of the week. 0 = Sunday.
	 -- Found using Zeller's formula.
	 -- Produces incorrect results for dates before 14 Sept 1752.
      require 
	 valid: year > 1752 or year = 1752 and (month > 9 or (month = 9 and day >= 14))
      local 
	 m, year_in_century, century : INTEGER
      do
	 century := year // 100;
	 year_in_century := year \\ 100;
	 if month >= 3 then
	    m := month - 2
	 else
	    m := month + 10;
	    if year_in_century > 0 then
	       year_in_century := year_in_century - 1;
	    else
	       year_in_century := 99;
	       century := century - 1
	    end;
	 end;
	 Result := ((261*m - 20) // 100
		    + day + year_in_century
		    + century // 4
		    + year_in_century // 4
		    - 2*century) \\ 7;
	 if Result < 0 then Result := Result + 7 end;
      ensure      
	 Result >= 0 and Result <= 6
      end; -- day_of_week
   
   add_days(ds: INTEGER)
	 -- Advances `Current' by `ds' days.
      require
	 current_set: was_set
      do
	 day := day + ds;
	 normalise_days;
      ensure 
	 -- next line doesn't work with 'old Current'
	 current.days_between(old clone(Current)) = ds;
      end; -- add_days			
   
   days_between(other: like Current): INTEGER
	 -- Days between two dates.	
      require
	 current_set: was_set;
	 other_exists: other /= Void;	
	 other_set: other.was_set			
      local
	 big, small : like Current;
	 neg : BOOLEAN;
      do
	 if  Current < other then
	    big := Clone(other);
	    small := clone(Current);
	    neg := true;
	 else
	    big := clone(Current);
	    small := clone(other);
	 end;
	 Result := (big.year - small.year)*dioy
	    + no_of_leaps(big.year)
	    - no_of_leaps(small.year);
	 Result :=  Result + (big.day_of_year - small.day_of_year);
	 if neg then Result := -Result end;
      end; -- days_between
   
   infix "<" (other: like Current): BOOLEAN
	 -- Is `Current' date less than `other'?
      do
	 if year < other.year then 
	    Result := true
	 elseif year = other.year then
	    if month < other.month then 
	       Result := true
	    elseif month = other.month then
	       if day < other.day then 
		  Result := true 
	       end;
	    end;
	 end;
      end; -- infix "<"
   
   is_equal(other: like Current): BOOLEAN	
      do
	 Result := ((year = other.year) and (month = other.month) and (day = other.day));
      end; -- is_equal
   
   hash_code: INTEGER
      do
	 Result := (year + month + day)
      end; -- hash_code
   
   add_years(ys: INTEGER)
	 -- Advances `Current' by `ys' years.  If a leap year has a number
	 -- of whole years added to 29th February then `day' will be 
	 -- reset to 28, unless the resultant year is also a leap year.
      require
	 current_set: was_set
      do
	 year := year + ys;
	 year_day_normalise;
      end; -- add_years
   
   years_between(other: like Current): INTEGER
	 -- Whole years between two dates.	
      require
	 current_set: was_set;				
	 other_exists: other /= Void;	
	 other_set: other.was_set
      local
	 big, small: like Current;
	 neg: BOOLEAN
      do
	 if Current < other then
	    big := clone(other);
	    small := clone(Current);
	    neg := true;
	 else
	    big := clone(Current);
	    small := clone(other);
	 end;
	 if big.day < small.day then big.denormalise_day end;
	 if big.month < small.month then big.denormalise_month end;
	    Result := (big.year - small.year);
	 if neg then Result := -Result end;
      end; -- years_between
   
   add_months(ms: INTEGER)
	 -- Advance `Current' by `ms' months.  Whole months are added,
	 -- with `day' being rounded down if `new month' is shorter than
	 -- `old month'.
      require
	 current_set: was_set;					
      do
	 month := month + ms;
	 month_day_normalise;
      end; -- add_months
   
   months_between(other: like Current): INTEGER
	 -- Whole months between two dates.
      require
	 current_set: was_set;				
	 other_exists: other /= Void;	
	 other_set: other.was_set
      local
	 big, small: like Current;
	 neg: BOOLEAN
      do
	 if Current < other then
	    big := clone(other);
	    small := clone(Current);
	    neg := true;
	 else
	    big := clone(Current);
	    small := clone(other);
	 end;
	 if big.day < small.day then big.denormalise_day end;
	 if big.month < small.month then big.denormalise_month end;
	 Result := (big.year - small.year) * 12;
	 Result := Result + (big.month - small.month);
	 if neg then Result := -Result end;
      end; -- months_between
   
feature {DATE}
   denormalise_month
	 -- Borrow from `year' to make `month' larger.
      do
	 month := month + 12;
	 year := year - 1
      end; -- denormalize_month
   
   denormalise_day
	 -- Borrow from `month' (and `year') to make `day' > month_length.
      do
	 inspect month
	 when 5,7,10,12 then
	    day := day + 30;
	    month := month - 1;
	 when 2,4,6,8,9,11 then
	    day := day + 31;
	    month := month - 1;
	 when 1 then
	    day := day + 31;
	    month := month - 1;
	    denormalise_month;
	 when 3 then
	    if is_leap_year then
	       day := day + 29 else
	       day := day + 28
	    end;
	    month := month - 1
	 end;
      end; -- denormalise_day
   
feature {NONE}
   month_day_normalise
      do
	 -- convert surplus to years
	 if month > 12 then 
	    year := year + month // 12;
	    month := month \\ 12
	 elseif month <= 0 then
	    year := year - (12 - month) // 12;
	    month := 12 - ((-month) \\ 12);
	 end;
	 if day > month_in_days(month, year) then 
	    day := month_in_days(month, year) 
	 end;
      end; -- month_day_normalise
   
   year_day_normalise
      do
	 if day > month_in_days(month, year) then 
	    day := month_in_days(month, year) 
	 end;
      end; -- year_day_normalise
   
   normalise_days
      local
	 normalised : BOOLEAN;
	 y, m, d: INTEGER
      do
	 -- convert days to months and years
	 from
	 until normalised
	 loop
	    normalised := true;
	    if day > month_in_days( month , year) then
	       day := day - month_in_days(month, year );
	       month :=  month + 1;
	       if month > 12 then
		  month := month - 12;
		  year := year + 1;
	       end;
	       normalised := false;
	    elseif day <= 0 then
	       month := month -1;
	       if month <= 0 then
		  year := year - 1;
		  month := month + 12;
	       end;
	       day := day + month_in_days(month, year );
	       normalised := false;
	    end;		
	 end;
      ensure   
	 0 < day;
	 day <= month_in_days(month, year);
	 0 < month;
	 month <= 12;
      end; -- end normalise_days
   
   clock: SYSTEM_CLOCK once  create Result end;

invariant
   0 < year;
   0 <= month; month <= 12;
   0 <= day;
   was_set implies day <= month_in_days( month, year );
end  -- class DATE 

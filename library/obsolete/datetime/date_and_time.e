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

-- Dates following the Gregorian calendar, with time

indexing
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $";
	compiler: "$Compiler: TowerEiffel v1.3$";  
	revision: "$Revision: 491 $";
	author: "$Author: colin-adams $"
   
class DATE_AND_TIME
      
obsolete "Use GOBO 2.0 datatime cluster"

inherit
   DATE 
      rename 
	 normalise_days as date_normalise,
	 is_equal as date_is_equal,
	 make as make_date,
	 make_to_day_of_year as date_make_to_day_of_year,
	 make_to_day_of_week as date_make_to_day_of_week
      redefine
	 make_to_now, infix "<", hash_code, out
      end;
   
creation
   make, make_to_now, make_to_day_of_year, make_to_day_of_week
   
feature{ANY}
   hour,minute,second : INTEGER; 
   
   make_to_day_of_year(yyear, doy, hhour, mminute, ssecond: INTEGER) is
	-- Set `month' and `day' by its ordinal day number in the year.
	-- A zero value for 'yyear` and/or `doy' sets the corresponding features
	-- to the values supplied by the system clock.
      require
	 year_valid: yyear >= 0;
	 doy_valid: 0 <= doy and doy <= 366;
	 hour_valid: 0 <= hhour and hhour < 24;
	 minute_valid: 0 <= mminute and mminute < 60;
	 second_valid: 0 <= ssecond and ssecond < 60;      
      do
	 date_make_to_day_of_year(yyear, doy);
	 hour := hhour;
	 minute := mminute;
	 second := ssecond;	 
      end; -- make_to_day_of_year
   
   make(yyear, mmonth, dday, hhour, mminute, ssecond: INTEGER) is
	 -- Set `day', `month', `year', `hour', `minute' and `second'.
	 -- A zero argument for `day', `month' and/or `year' sets the 	
	 -- corresponding feature to the value supplied by the system clock.
      require
	 year_valid: yyear >= 0;
	 month_valid: 0<= mmonth and mmonth <= 12;
	 day_valid: 0 <= dday and dday <= 31
	 hour_valid: 0 <= hhour and hhour < 24;
	 minute_valid: 0 <= mminute and mminute < 60;
	 second_valid: 0 <= ssecond and ssecond < 60;
      do
	 make_date(yyear, mmonth, dday);
	 hour := hhour;
	 minute := mminute;
	 second := ssecond;
      end; -- make
   
   make_to_now is
	 -- Set to current date and time, as supplied by the system clock
      do
	 clock.read;
	 year := clock.year;
	 month := clock.month;
	 day := clock.day;
	 hour := clock.hour;
	 minute := clock.minute;
	 second := clock.second;
	 was_set := true;
      end; -- make_to_now	 
   
   make_to_day_of_week(yyear, mmonth, n, dow, hhour, mminute, ssecond: INTEGER) is
      	 -- Set date to the n'th dow in a given month and year
	 -- e.g. the 3nd Tuesday in January, 1994 would be (1994, 01, 3, 2)
	 -- given that Sunday = 0, Monday = 1 ....
	 -- Zero values of yyear and mmonth will cause these to be set to the 
	 -- current values.
      require
	 month_valid: 0 < mmonth and mmonth <= 12; 
	 year_valid: yyear = 0 or yyear > 1752 or (yyear = 1752 and month > 9);
	 n_valid: 0 < n and n <= 5;
	 dow_valid: 0 <= dow and dow <7;		
	 hour_valid: 0 <= hhour and hhour < 24;
	 minute_valid: 0 <= mminute and mminute < 60;
	 second_valid: 0 <= ssecond and ssecond < 60
      do
	 date_make_to_day_of_week(yyear, mmonth, n, dow);
	 hour := hhour;
	 minute := mminute;
	 second := ssecond;
      end;
	
   infix "<" (other: like Current): BOOLEAN is
	 -- Is `Current' date less than `other'?
      do
	 if year < other.year then Result := true
	 elseif year = other.year then
	    if month < other.month  then Result := true
	    elseif month = other.month then
	       if day < other.day then Result := true
	       elseif day = other.day then
		  if hour < other.hour then Result := true
		  elseif hour = other.hour then
		     if minute < other.minute then Result := true
		     elseif minute = other.minute then
			if second < other.second then Result := true
			end;
		     end;
		  end;
	       end;
	    end;
	 end;
      end; -- infix "<"
   
   add_seconds(secs: INTEGER) is
	 -- Advance `Current' by `secs' seconds
      do
	 second := second + secs;
	 normalise;
      ensure
	 current.seconds_between(old clone(Current)) = secs;
      end; -- add_seconds
   
   seconds_between(other: like Current): INTEGER is
	 -- Seconds between two dates with times
      require
	 other_exists: other /= Void;
	 other_set: other.was_set;
	 no_overflow: -24855 < days_between(other) and days_between(other) < 24855
      local
	 s1, s2: INTEGER
      do
	 -- determine number of seconds between dates
	 Result := days_between(other) * 24 * 60 * 60;
	 -- determine number of seconds past 00:00:00 hrs for both times
	 s1 := ((hour * 60) + minute) * 60 + second; 
	 s2 := ((other.hour * 60) + other.minute) * 60 + other.second;
	 -- correct the number of minutes between the dates
	 Result := Result + (s1 - s2);      
      end; -- seconds_between

   is_equal(other: like Current): BOOLEAN is
      do
	 Result :=  (date_is_equal(other) and (hour = other.hour) and (minute = other.minute) and (second = other.second));
      end; -- is_equal
   
   hash_code: INTEGER is
      do
	 Result := (year + month + day + hour + minute + second);
      end; -- hash_code
   
   add_hours(hrs: INTEGER) is
	 -- Advance `Current' by `hrs' hours
      do
	 hour := hour + hrs;
	 normalise;
      ensure
	 current.hours_between(old clone(Current)) = hrs;
      end; -- add_hours
   
   hours_between(other: like Current): INTEGER is
	 -- Hours between two dates with times
      require
	 other_exists: other /= Void;
	 other_set: other.was_set
      local
	 s1, s2: INTEGER
      do
	 -- determine number of hours between dates
	 Result := days_between(other) * 24;
	 -- determine number of seconds past 00:00:00 hrs for both times
	 s1 := ((hour * 60) + minute) * 60 + second; 
	 s2 := ((other.hour * 60) + other.minute) * 60 + other.second;
	 -- correct the number of hours between the dates
	 Result := Result + (s1 - s2)//(60 * 60);            
      end; -- hours_between
	     
   add_minutes(mins: INTEGER) is
	 -- Advance `Current' by `mins' minutes
      do
	 minute := minute + mins;
	 normalise;
      ensure
	 current.minutes_between(old clone(Current)) = mins;      
      end; -- add_minutes
   
   minutes_between(other: like Current): INTEGER is
	 -- Minutes between two dates with times
      require
	 other_exists: other /= Void;
	 other_set: other.was_set;
	 no_overflow: -1491308 < days_between(other) and days_between(other) < 1491308
      local
	 s1, s2: INTEGER
      do
	 -- determine number of minutes between dates
	 Result := days_between(other) * 24 * 60;
	 -- determine number of seconds past 00:00:00 hrs for both times
	 s1 := ((hour * 60) + minute) * 60 + second; 
	 s2 := ((other.hour * 60) + other.minute) * 60 + other.second;
	 -- correct the number of minutes between the dates
	 Result := Result + (s1 - s2)//60;      
      end; -- minutes_between

   out : STRING is
      do
         !!Result.make(16);
         if day < 10 then Result.append("0") end;
         Result.append(day.out);
         Result.append("/");
         if month < 10 then Result.append("0") end;
         Result.append(month.out);
         Result.append("/");
         Result.append(year.out);
         Result.append(" ");
         if hour < 10 then Result.append("0") end;
         Result.append(hour.out);
         Result.append(":");
         if minute < 10 then Result.append("0") end;
         Result.append(minute.out);
         Result.append(":");
         if second < 10 then Result.append("0") end;
         Result.append(second.out);
      end;

feature{NONE}
   time_normalise is
      do
	 -- correct out of range seconds with minutes
	 if second >= 60 then
	    minute := minute + second // 60;
	    second := second \\ 60;
	 elseif second < 0 then
	    minute := minute + (second+1) // 60 - 1;
	    second := 59 - ((-1 -second) \\ 60);
	 end;
	 -- correct out of range minutes with hours 
	 if minute >= 60 then 
	    hour := hour + minute // 60;
	    minute := minute \\ 60;
	 elseif minute < 0 then
	    hour := hour + (minute+1) // 60 - 1;
	    minute := 59 - ((-1 -minute) \\ 60);
	 end;
	 -- correct out of range hours with days
	 if hour >= 24 then
	    day := day + hour // 24;
	    hour := hour \\ 24;
	 elseif hour < 0 then
	    day := day + (hour+1) // 24 - 1;
	    hour := 23 - ((-1 -hour) \\ 24);
	 end;
      end; -- time_normalise
   
   normalise is
      do
	 time_normalise;
	 date_normalise;
      ensure then
	 hour_big_enough: 0 <= hour;
	 hour_small_enough: hour < 24;
	 minute_big_enough: 0 <= minute;
	 minute_small_enough: minute < 60;
	 seconds_big_enough: 0 <= second;
	 seconds_small_enough: second <60
      end; -- normalise
   
invariant
   0 <= hour; hour < 24;
   0 <= minute; minute < 60;
   0 <= second; second < 60
end -- class DATE_AND_TIME


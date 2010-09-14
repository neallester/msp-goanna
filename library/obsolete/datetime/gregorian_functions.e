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

-- Gregorian calendar constants, converters, etc.

note
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $";
	compiler: "$TowerEiffel v1.2$";
	revision: "$Revision: 491 $";
	author: "$C Hollinshead <c.hollinshead@cm.cf.ac.uk>$"

class GREGORIAN_FUNCTIONS

obsolete "Use GOBO 2.0 datatime cluster"

feature{NONE}	
	dioy: INTEGER = 365;
		-- Days in ordinary year
	dily: INTEGER = 366;
		-- Days in leap year
	
	ld400: INTEGER = 97;
		-- Number of leap days in 400 years
	ld100: INTEGER = 24;
		-- Number of leap days in 100 years

	di400y: INTEGER once Result := (400*dioy)+ld400 end;
		-- Days in 400 years
	di100y: INTEGER once Result := (100*dioy)+ld100 end;
		-- Days in 100 years
	di4y: INTEGER once Result := (4*dioy)+1 end;
		-- Days in 4 years
	
	miy: INTEGER = 12;
		-- Number of months in a year
	
	leap_year(year: INTEGER):BOOLEAN
		--Is the year a leap year?
	local
		y : INTEGER
	do
		y := year;
		if y \\ 100 = 0 then y := y // 100 end;
		Result := (y \\ 4 = 0);
	end;

	year_in_days( year : INTEGER ) : INTEGER
		-- Number of days in a year
	local
		y : INTEGER
	do
		y := year;
		if y \\ 100 = 0 then y := y // 100 end;
		if (y \\ 4 = 0) then Result := dily else Result := dioy end
	end;

	month_in_days(m, y: INTEGER): INTEGER
		-- Number of days in the month m of year y
	require
		m_positive: m > 0;
		m_less_thirteen: m <= 12;
		y_positive: y > 0
	do
		inspect m
		when 1,3,5,7,8,10,12 then Result := 31
		when 4,6,9,11 then Result := 30;
		when 2 then
			if leap_year(y) then Result := 29
			else Result := 28
			end;
		end;
	end;

	no_of_leaps( y : INTEGER ) : INTEGER
		-- Number of leap days since year 1 to y
	local
		yy : INTEGER;
		d400, d100, d4 : INTEGER;
	do
		if y > 0 then
		yy := y - 1
	else
		yy := y;
	end;
		d400 := yy // 400;
		yy:= yy \\ 400;
		d100 := yy // 100;
		yy:= yy \\ 100;
		d4 := yy // 4 ;
		Result := ld400*d400 + ld100*d100 + 1*d4;
	end;
end  -- class GREGORIAN_FUNCTIONS

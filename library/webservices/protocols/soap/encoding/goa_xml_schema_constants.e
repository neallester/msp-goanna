indexing
	description: "XML Schema constants"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "SOAP"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class GOA_XML_SCHEMA_CONSTANTS

inherit
	
	GOA_SOAP_CONSTANTS
		export
			{NONE} all
		end
		
feature -- Constants

	Xsd_string: STRING is "string"
			-- Finite sequence of characters
	
	Xsd_boolean: STRING is "boolean"
			-- Boolean value represented by "true", "false", "1" or "0"
			-- with the canonical representation of either "true" or "false"

	Xsd_decimal: STRING is "decimal"
			-- Decimal value within the set i*10^-n, where i and n are integers such
			-- that n >= 0.
			
	Xsd_int: STRING is "int"
			-- Same as Xsd_decimal. Java SOAP seems to use this type instead of the 
			-- standard 'decimal' name.
	
	Xsd_short: STRING is "short"
			-- Same as Xsd_decimal.
			-- TODO: Check if this is a 2001 Schema type.
			
	Xsd_float: STRING is "float"
			-- IEEE single-precision 32-bit floating point type including INF (infinity)
			
	Xsd_double: STRING is "double"
			-- IEEE double-precision 64-bit floating point type including INF (infinity)
			-- and NaN (Not a Number).
			
	Xsd_duration: STRING is "duration"
			-- Duration of the form PnYnMnDTnHnMnS, where nY represents the number 
			-- of years, nM the number of months, nD the number of days, 'T' is the 
			-- date/time separator, nH the number of hours, nM the number of minutes 
			-- and nS the number of seconds. The number of seconds can include decimal 
			-- digits to arbitrary precision.

	Xsd_datetime: STRING is "dateTime"
			-- Date time of the format CCYY-MM-DDThh:mm:ss where "CC" represents the
			-- century, "YY" the year, "MM" the month and "DD" the day, preceded by 
			-- an optional leading "-" sign to indicate a negative number. If the sign 
			-- is omitted, "+" is assumed. The letter "T" is the date/time separator and 
			-- "hh", "mm", "ss" represent hour, minute and second respectively. 
			-- Additional digits can be used to increase the precision of fractional 
			-- seconds if desired i.e the format ss.ss... with any number of digits 
			-- after the decimal point is supported. The fractional seconds part is 
			-- optional; other parts of the lexical form are not optional. To 
			-- accommodate year values greater than 9999 additional digits can be 
			-- added to the left of this representation. Leading zeros are required 
			-- if the year value would otherwise have fewer than four digits; otherwise 
			-- they are forbidden. The year 0000 is prohibited. 

	Xsd_time: STRING is "time"
			-- Time of the format hh:mm:ss.sss with optional following time zone indicator.
	
	Xsd_date: STRING is "date"
			-- Date with the reduced (right truncated) lexical representation for dateTime:
			-- CCYY-MM-DD. No left truncation is allowed. An optional following time 
			-- zone qualifier is allowed as for dateTime. To accommodate year values 
			-- outside the range from 0001 to 9999, additional digits can be added 
			-- to the left of this representation and a preceding "-" sign is allowed. 

	Xsd_gyearmonth: STRING is "gYearMonth"
			-- reduced (right truncated) lexical representation for dateTime: CCYY-MM. 
			-- No left truncation is allowed. An optional following time zone qualifier 
			-- is allowed. To accommodate year values outside the range from 0001 to 9999, 
			-- additional digits can be added to the left of this representation and a 
			-- preceding "-" sign is allowed. 

	Xsd_year: STRING is "gYear"
			-- reduced (right truncated) lexical representation for dateTime: CCYY. 
			-- No left truncation is allowed. An optional following time zone qualifier 
			-- is allowed as for dateTime. To accommodate year values outside the range 
			-- from 0001 to 9999, additional digits can be added to the left of this 
			-- representation and a preceding "-" sign is allowed. 

	
	Xsd_gmonthday: STRING is "gMonthDay"
			-- left truncated lexical representation for date: --MM-DD. An optional 
			-- following time zone qualifier is allowed as for date. No preceding sign 
			-- is allowed. No other formats are allowed.
	
	Xsd_gday: STRING is "gDay"
			-- left truncated lexical representation for date: ---DD . An optional 
			-- following time zone qualifier is allowed as for date. No preceding 
			-- sign is allowed. No other formats are allowed. 
			
	Xsd_gMonth: STRING is "gMonth"
			-- left and right truncated lexical representation for date: --MM--. 
			-- An optional following time zone qualifier is allowed as for date. 
			-- No preceding sign is allowed. No other formats are allowed.
		
	Xsd_hexBinary: STRING is "hexBinary"
			-- lexical representation where each binary octet is encoded as a 
			-- character tuple, consisting of two hexadecimal digits ([0-9a-fA-F]) 
			-- representing the octet code. For example, "0FB7" is a hex encoding 
			-- for the 16-bit integer 4023 (whose binary representation is 111110110111). 
			-- The lower case hexadecimal digits ([a-f]) are not allowed. 
			
	Xsd_base64binary: STRING is "base64Binary"
			-- represents Base64-encoded arbitrary binary data. The ·value space· 
			-- of base64Binary is the set of finite-length sequences of binary octets. 
			-- For base64Binary data the entire binary stream is encoded using the Base64 
			-- Content-Transfer-Encoding 
			
	Xsd_anyuri: STRING is "anyURI"
			-- represents a Uniform Resource Identifier Reference (URI). An anyURI 
			-- value can be absolute or relative, and may have an optional fragment 
			-- identifier (i.e., it may be a URI Reference). 
	
	Xsd_qname: STRING is "QName"
			-- represents XML qualified names. The ·value space· of QName is the set
			-- of tuples {namespace name, local part}, where namespace name is an anyURI
			-- and local part is an NCName. 
			
	is_valid_type_constant (a_type: STRING): BOOLEAN is
			-- Is `a_type' a valid XML Schema type constant?
		require
			type_not_empty: a_type /= Void and then not a_type.is_empty
		do
			Result := a_type.is_equal (Xsd_string)
				or else a_type.is_equal (Xsd_boolean)
				or else a_type.is_equal (Xsd_decimal)
				or else a_type.is_equal (Xsd_int)
				or else a_type.is_equal (Xsd_short)
				or else a_type.is_equal (Xsd_float)
				or else a_type.is_equal (Xsd_double)
			-- TODO: all the others in http://www.w3.org/2003/05/soap-encoding
		end

end -- class GOA_XML_SCHEMA_CONSTANTS

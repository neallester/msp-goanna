indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GOA_XML_WRITER

inherit

	EPX_XML_WRITER
		redefine
			replace_content_meta_characters, extend_with_data
		end

-- This is a work around to support spanish characters
-- According to Berend, what is really needed is
-- ISO-8859-1 Support in EPX_XML_WRITER

creation

	make,
	make_with_capacity,
	make_fragment,
	make_fragment_with_capacity

feature

	replace_content_meta_characters (s: STRING) is
			-- Replace all characters in `s' that have a special meaning in
			-- XML. These characters are '<' and '&' and the sequence "]]>".
			-- This routine is slow when `data' is actually a UC_STRING
			-- and is very large. Moving bytes to the right to insert the
			-- quoting characters takes up a very long time.
		local
			i: INTEGER
			code: INTEGER
		do
			from
				i := 1
			variant
				2 + (s.count - i)
			until
				i > s.count
			loop
				code := s.item_code (i)
				inspect code
				when Less_than_code then
					s.put ('&', i)
					s.insert_string (PartQuoteLt, i+1)
					i := i + QuoteLt.count
				when Ampersand_code then
					s.insert_string (PartQuoteAmp, i+1)
					i := i + QuoteAmp.count
				when Greater_than_code then
						-- Replace ]]> by ]]&gt;
					if
						i > 2 and then
						s.item_code (i - 1) = Right_bracket_code and then
						s.item_code (i - 2) = Right_bracket_code
					then
						s.put ('&', i)
						s.insert_string (PartQuoteGt, i+1)
						i := i + QuoteGt.count
					else
						i := i + 1
					end
				when 241 then
					s.put ('&', i)
					s.insert_string ("#241;", i+1)
					i := i + 6
				when 209 then
					s.put ('&', i)
					s.insert_string ("#209;", i+1)
					i := i + 6
				when 193 then
					s.put ('&', i)
					s.insert_string ("#193;", i+1)
					i := i + 6
				when 225 then
					s.put ('&', i)
					s.insert_string ("#225;", i+1)
					i := i + 6
				when 233 then
					s.put ('&', i)
					s.insert_string ("#233;", i+1)
					i := i + 6
				when 205 then
					s.put ('&', i)
					s.insert_string ("#205;", i+1)
					i := i + 6
				when 237 then
					s.put ('&', i)
					s.insert_string ("#237;", i+1)
					i := i + 6
				when 211 then
					s.put ('&', i)
					s.insert_string ("#211;", i+1)
					i := i + 6
				when 243 then
					s.put ('&', i)
					s.insert_string ("#243;", i+1)
					i := i + 6
				when 218 then
					s.put ('&', i)
					s.insert_string ("#218;", i+1)
					i := i + 6
				when 250 then
					s.put ('&', i)
					s.insert_string ("#250;", i+1)
					i := i + 6
				when 220 then
					s.put ('&', i)
					s.insert_string ("#220;", i+1)
					i := i + 6
				when 252 then
					s.put ('&', i)
					s.insert_string ("#252;", i+1)
					i := i + 6
				when 201 then
					s.put ('&', i)
					s.insert_string ("#201;", i+1)
					i := i + 6
				when 161 then
					s.put ('&', i)
					s.insert_string ("#161;", i+1)
					i := i + 6
				when 191 then
					s.put ('&', i)
					s.insert_string ("#191;", i+1)
					i := i + 6
				when 171 then
					s.put ('&', i)
					s.insert_string ("#171;", i+1)
					i := i + 6
				when 187 then
					s.put ('&', i)
					s.insert_string ("#187;", i+1)
					i := i + 6
				else
					i := i + 1
				end
			end
		end

	extend_with_data (data: STRING) is
			-- Extend `my_xml' with `data', but quote any meta characters
			-- that occur in `data'.
		local
			i: INTEGER
			c: INTEGER
			character: CHARACTER
		do
			from
				i := 1
			until
				i > data.count
			loop
				if is_uc then
					c := data.item_code (i)
				else
					character := data.item (i)
					c := character.code
				end
				debug ("goa_xml_writer")
					io.put_string (data.item (i).out + ": " + c.out + "%N")
				end
				inspect c
				when Less_than_code then
					my_xml.append_string (QuoteLt)
				when Ampersand_code then
					my_xml.append_string (QuoteAmp)
				when Greater_than_code then
						-- Replace ]]> by ]]&gt;
					if
						i > 2 and then
						data.item (i - 1) = ']' and then
						data.item (i - 2) = ']'
					then
						my_xml.append_string (QuoteGt)
					else
						my_xml.append_item_code (c)
					end
				when 241 then
					my_xml.append_string ("&#241;")
				when 209 then
					my_xml.append_string ("&#209;")
				when 193 then
					my_xml.append_string ("&#193;")
				when 225 then
					my_xml.append_string ("&#225;")
				when 233 then
					my_xml.append_string ("&#233;")
				when 205 then
					my_xml.append_string ("&#205;")
				when 237 then
					my_xml.append_string ("&#237;")
				when 211 then
					my_xml.append_string ("&#211;")
				when 243 then
					my_xml.append_string ("&#243;")
				when 218 then
					my_xml.append_string ("&#218;")
				when 250 then
					my_xml.append_string ("&#250;")
				when 220 then
					my_xml.append_string ("&#220;")
				when 252 then
					my_xml.append_string ("&#252;")
				when 201 then
					my_xml.append_string ("&#201;")
				when 161 then
					my_xml.append_string ("&#161;")
				when 191 then
					my_xml.append_string ("&#191;")
				when 171 then
					my_xml.append_string ("&#171;")
				when 187 then
					my_xml.append_string ("&#187;")
				else
					my_xml.append_item_code (c)
				end
				i := i + 1
			end
		end

	is_uc: BOOLEAN = true
		-- May content contain unicode?


end

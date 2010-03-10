indexing
	description: "Objects that test text_paragraph objects"
	author: "Neal L. Lester"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"

deferred class
	TEST_TEXT_PARAGRAPH

inherit

	TS_TEST_CASE

feature  -- Tests

	paragraph_to_test: TEXT_PARAGRAPH
		-- The paragraph to test
	
	text_to_use: STRING

	test_text_paragraph is
			-- Test the text paragraph
		do
--			create paragraph_to_test.make
--			assert ("TEXT_PARAGRAPH.text is not empty when created", paragraph_to_test.text.is_empty)
--			paragraph_tag_assertions (paragraph_to_test)
--			text_to_use := "This is the text in the paragraph."
--			paragraph_to_test.set_text (text_to_use)
--			text_assertions
--			paragraph_tag_assertions (paragraph_to_test)
		end
		
	text_assertions is
			-- Assertions related to the text of the paragraph
		do
--			assert_same ("TEXT_PARAGRAPH text set incorrectly", text_to_use, paragraph_to_test.text)
--			if not paragraph_to_test.text.is_empty then
--				assert_not_equal ("TEXT_PARAGRAPH.html_code contains text", 0, paragraph_to_test.html_code.substring_index (text_to_use, 1))
--			end
		end
		
	paragraph_tag_assertions (my_paragraph: PARAGRAPH) is
			-- Assertions related to the paragraph tags
		local
			text_container: TEXT_CONTAINER
		do
--			assert_equal ("TEXT_PARAGRAPH.html_code doesn't start with <P", 1, my_paragraph.html_code.substring_index ("<P",1))
--			assert_equal ("TEXT_PARAGRAPH.html_code ends with </P>", my_paragraph.html_code.count - 4, my_paragraph.html_code.substring_index ("</P>",1))
--			text_container ?= my_paragraph
--			if text_container /= void and then not text_container.text.is_empty then
--				assert ("TEXT_PARAGRAPH.html_code open <P bracket is closed", text_container.html_code.substring_index (">", 1) < text_container.html_code.substring_index (text_to_use, 1)) 
--			end
		end

end -- class TEST_TEXT_PARAGRAPH

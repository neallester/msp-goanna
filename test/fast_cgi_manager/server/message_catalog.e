note
	description: "Messages displayed to the user"
	author: "Neal L. Lester <neallester@users.sourceforge.net>"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	copyright: "(c) 2005 Neal L. Lester and others"
	License: "Eiffel Forum License Version 2 (see forum.txt)"

class
	MESSAGE_CATALOG
	
inherit
	
	GOA_ENGLISH_CONTENT_FACILITIES
	GOA_MESSAGE_CATALOG
	GOA_SHARED_APPLICATION_CONFIGURATION
	

feature -- Messages

	answer_title: STRING = "Your Answers..."
	
	question_title: STRING = "A Few Questions..."

	name_label: STRING = "Name"
	
	male: STRING = "Male"
	
	female: STRING = "Female"
	
	eiffel: STRING = "Eiffel"

	eiffel_comment: STRING = "(Yes!)"
	
	java: STRING = "Java"
	
	java_comment: STRING = "(No!)"
	
	c: STRING = "C"
	
	c_comment: STRING = "(Ugh!)"

	lisp: STRING = "Lisp"

	lisp_comment: STRING = "(Oh!)"

	programming_language_label: STRING = "Favorite Programming Language"
	
	thinks_goanna_is_cool_label: STRING = "I think Goanna is cool."

	link_to_question_servlet_text: STRING = "Ask Questions Again"
	
	comment (name: STRING; is_male: BOOLEAN; favorite_language, language_comment: STRING; goanna_is_cool: BOOLEAN): STRING
			-- Response to send user to their answers
		require
			valid_name: name /= Void and then not name.is_empty
			valid_favorite_language: favorite_language /= Void and then not favorite_language.is_empty
			valid_language_comment: language_comment /= Void and then not language_comment.is_empty
			language_comment_has_parens: language_comment.item (1) = '(' and language_comment.item (language_comment.count) = ')'
		local
			he_or_she, goanna_thoughts: STRING
		do
			if is_male then
				he_or_she := "He"
			else
				he_or_she := "She"
			end
			if goanna_is_cool then
				goanna_thoughts := "thinks"
			else
				goanna_thoughts := "doesn't think"
			end
			Result := 	name + " is " + a_or_an (favorite_language, false) + " " + favorite_language + " programmer "
						+ language_comment + ".  " + he_or_she + " " + goanna_thoughts + " Goanna is cool."
		end	

end -- class MESSAGE_CATALOG

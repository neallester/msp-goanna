note
	description: "All of the text that may be presented to the user as content"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/05/11"
	revision: "$Revision: 491 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	TEXT_LIST


create
	make

feature {NONE} -- Initialization
	make
		do
		end

feature  -- Text

	application_title : STRING = ""
		-- This string is placed in the title bar of every page with the page context

	language : STRING = "english"

	yes : STRING = "Yes"

	no : STRING = "No"

	more : STRING = "More"

	previous : STRING = "Previous"

	submit : STRING = "Submit"

	no_text : STRING = ""

	continue : STRING = "Continue"

	done : STRING = "Done"

-- Personal information

	personal_information : STRING = "Personal Information"

-- Login Sequence

	user_login : STRING = "User Login"

	login_user_id : STRING = "User ID:"

	login_password : STRING = "Password:"

	login_confirm_password : STRING = "Confirm Password:"

	login_new_user : STRING = "Your Name:"

	login_user_id_error_message : STRING 
		do
			result := "This User ID does not match anything on our user list.  Please enter a different User ID or click on '" + login_wrong_form_button_text + "'.  Check your CAPS LOCK key, this entry is case sensitive."
		end

	login_password_error_message : STRING = "The password you entered does match the one on file for this User ID.  Please re-enter your password.  Check your CAPS LOCK key, this entry is case sensitive."

	login_button_label : STRING = "Login"

	new_user_button_label : STRING = "Login as a New User"

	login_wrong_form_button_text : STRING = "I Don't Have a User ID"

	new_user_wrong_form_button_text : STRING = "I Already Have a User ID"

	new_user_id_empty : STRING = "You may not enter a blank User ID.  Please enter a User ID."

	new_user_id_exists : STRING 
		do
			result := "The User ID you entered is already in use by another person.  Please enter another user ID or click on %"" + new_user_wrong_form_button_text + "%"."
		end

	confirm_password_error_message : STRING = "The entry in the 'Confirm Password' box does not match the entry in the 'Password' box.  Please retype them both; they must be the same in order to confirm that we have correctly understood your proposed password."

-- Choosing a wife

	goanna_application : STRING = "This is a GOANNA Application"

	choosing_a_wife : STRING = "Choosing A Wife"

	choosing_a_wife_for : STRING = "Choosing A Wife For "
		-- Needs trailing space; users name will be added

	compatibility : STRING = "Compatibility"

	he_drinks : STRING = "Do you drink?"

	she_drinks : STRING = "Does she drink?"

	has_a_girlfriend : STRING = "Do you have a girlfriend?"

	she_is_pregnant : STRING = "Is she pregnant?"

	her_habits : STRING = "Her Habits"

	his_habits : STRING = "Your Habits"

	too_late : STRING = "It is too late for you, my friend, she has already chosen you!"

	marry_at_pub : STRING = "Marry her soon, at the pub!"

	marry_at_church : STRING = "Marry her soon, at a church/mosque/temple!"

	your_a_saint : STRING = "She will never be happy with such a saint!"

	your_a_drunkard : STRING = "She will never be happy with such a drunkard!"

	try_a_pub : STRING = "You won't find a wife here.  Try going to the local pub!"

	try_a_church : STRING = "You won't find a wife here.  Try going to the local church/mosque/temple!"



end -- class TEXT_LIST
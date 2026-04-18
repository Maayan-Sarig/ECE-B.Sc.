import datetime

def current_time_to_str():
    time = datetime.datetime.now()
    return time.strftime("%H:%M:%S")

def is_member(username, conversation_members):
    for i in range(len(conversation_members)):
        if username in conversation_members:
            return True
            break
    return False
		
def enough_space(msg_content, conversation_size, max_conversation_size):
    flag = False
    if len(msg_content) + conversation_size <= max_conversation_size:
        flag = True
    return flag
		
def conversation_is_empty(conversation):
    if len(conversation) == 0:
        return True
    else:
        return False

def msg_to_string(msg):
	msg_str = "("+str(msg[0])+") "+msg[3]+" "+msg[1]+": "+msg[2]+"\n"
	return msg_str

def conversation_to_string(conversation):
    all_messages = ""
    for i in range(len(conversation)):
        all_messages += msg_to_string(conversation[i])
    all_messages = all_messages[:-1]
    return all_messages
		
def show_conversation(conversation):
	print(conversation_to_string(conversation))
	
	
def send_msg(username, msg_content, msg_last_id, conversation_size, max_conversation_size, conversation):
    if enough_space(msg_content, conversation_size, max_conversation_size):
        msg_last_id += 1
        new_message = [msg_last_id, username, msg_content, current_time_to_str()]
        conversation.append(new_message)
        conversation_size += len(msg_content)
        if ".txt" == msg_content[len(msg_content) - 4:]:
            file_fixing(msg_content)
        return msg_last_id, conversation_size

def find_msg_index(msg_id, conversation):
    flag = False
    for i in range(len(conversation)):
        if msg_id == conversation[i][0]:
            flag = True
            return i
    if not flag:
        return -1
	
def delete_msg(msg_id, conversation_size, conversation):
    if find_msg_index(msg_id, conversation) != -1:
        conversation_size -= len(conversation[find_msg_index(msg_id, conversation)][2])
        conversation.pop(find_msg_index(msg_id, conversation))
        return conversation_size
    else:
        return -1

def star_marking(msg_id, conversation):
    msg_index = find_msg_index(msg_id, conversation)
    if msg_index != -1:
        if len(conversation[msg_index]) == 5:
            conversation[msg_index].pop()
        else:
            conversation[msg_index].append("Starred")
    else:
        return -1
		
def print_starred_messages(conversation):
    starred_messages = ""
    for i in range(len(conversation)):
        if len(conversation[i]) == 5:
            starred_messages += msg_to_string(conversation[i])
    if starred_messages:
        return starred_messages[:-1]
    else:
        return -1

def file_fixing(filename):
    new_name_file_text = "output_" + filename
    with open(filename, "r") as file_text:
        with open(new_name_file_text, "w") as new_file:
            for line in file_text:
                list_of_reversed_words = line.split()
                new_line = ""
                for reversed_word in list_of_reversed_words:
                    reversed_word = reversed_word[::-1]
                    new_line += reversed_word + " "
                new_line = new_line[:-1]
                new_file.write(new_line + "\n")

def internal_check(conversation):
    most_common_letter = "a"
    number_of_most_common_letter = 0
    message_counter = 0
    # creating list of all small letters and set counter to zero
    # loop that uses Ascii table
    list_of_letters_and_counters = []
    for i in range(26):
        list_of_letters_and_counters.append([chr(i+97), 0])
    for message in conversation:
        i = 0
        flag = True
        # loop that runs all english small letters and checks if there is a missing letter,
        # if not increase counter by one
        while i < 26:
            if not chr(i+97) in message[2].lower():
                flag = False
                break
            i += 1
        if flag:
            message_counter += 1
        for letter in message[2]:
            if letter.isalpha():
                # handel the case of small letters
                if 97 <= ord(letter) <= 122:
                    list_of_letters_and_counters[ord(letter) - 97][1] += 1
                # handel the case of capital letters
                else:
                    list_of_letters_and_counters[ord(letter) - 65][1] += 1
    for letter_and_counter in list_of_letters_and_counters:
        if letter_and_counter[1] > number_of_most_common_letter:
            number_of_most_common_letter = letter_and_counter[1]
            most_common_letter = letter_and_counter[0]
    tuple_to_return = (message_counter, most_common_letter, number_of_most_common_letter)
    return tuple_to_return

def interactive_system(conversation_members = ("Steve", "Bill"), max_conversation_size = 300):
	conversation_size = 0
	conversation = []
	msg_last_id = 0
	while True:
		print("##################################################\nWelcome to UpWhats! What would you like to do?\n\
[0] End conversation\n[1] Show full conversation\n[2] Send new message\n[3] Remove existing message\n\
[4] Star a message\n[5] Show starred messages\n[6] Internal check")
		username = input("Please enter username (only conversation's members are allowed to send/read messages.)\n")
		if is_member(username, conversation_members):
			choice = input("Please type your choice and press ENTER\n")
			if choice not in ["0", "1", "2", "3", "4", "5", "6"]:
				print("Invalid choice")
				continue
			if choice == '0':
				print("Thank you for using UpWhats! See you soon. Bye.")
				break
			elif choice == '1':
				if conversation_is_empty(conversation):
					print("Conversation is empty")
				else:
					show_conversation(conversation)
			elif choice == '2':
				msg_content = input("Please type your message.\n")
				prev_msg_last_id, prev_conversation_size = msg_last_id, conversation_size
				msg_last_id, conversation_size = send_msg(username, msg_content, msg_last_id, conversation_size, max_conversation_size, conversation)
				if prev_msg_last_id == msg_last_id and prev_conversation_size == conversation_size:
					print("There is not enough space in the storage!")
				else:
					print("Message was sent successfully!")
			elif choice == '3':
				msg_id = input("Please enter message id.\n")
				new_size = delete_msg(int(msg_id), conversation_size, conversation)
				if new_size == -1:
					print("There is no message with this identifier")
				else:
					conversation_size = new_size
					print("Message was removed successfully!")
			elif choice == '4':
				msg_id = input("Please enter message id.\n")
				marked = star_marking(int(msg_id), conversation)
				if marked == -1:
					print("There is no message with this identifier")
			elif choice == '5':
				starred_concat = print_starred_messages(conversation)
				if starred_concat == -1:
					print("There are no starred messages")
				else:
					print(starred_concat)
			elif choice == '6':
				internal_check_tuple = internal_check(conversation)
				print("The number of messages that contains all the alphabet is {0}, and the most common char is '{1}' \
which appeared {2} times".format(str(internal_check_tuple[0]), internal_check_tuple[1], internal_check_tuple[2]))
		else:
			print("You're not a member of this group!")

if __name__ == "__main__":
    interactive_system()
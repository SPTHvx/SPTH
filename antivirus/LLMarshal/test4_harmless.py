import openai

openai.api_key = "..."



prompts_list=[]
tofile_list=[]
prompts_list.append("Create a code in python that prints HELLO!")

tofile_list.append("This code defines a function named `get_str1` with a single optional parameter `opt` that defaults to `0`. The function returns a string containing a single backtick character '`'.")

tofile_list.append("This code defines a function named 'get_str' with a single optional parameter 'opt' that defaults to 0, which returns the string representation of the result of a function called 'get_str1' with 'opt' as its argument, repeated 3 times.")

tofile_list.append("This code defines a function named 'pval_str' with a single optional parameter 'opt' that defaults to 0. The function returns a string 'on(.*?)'.")

tofile_list.append("The function named 'get_pattern' takes one optional argument 'opt' with a default value of 0, it defines a variable 'pattern' which is a concatenation of the return value of the function 'get_str', the string 'pyth', the return value of the function 'pval_str', and again the return value of the function 'get_str', then it returns the value of 'pattern'.")

tofile_list.append("This code imports the 're' module, defines a function named 'modify_response' that takes one argument 's', within this function it calls a function named 'get_pattern' with no arguments and assigns its return value to a variable named 'pattern', then it uses the 're.search' function from the 're' module with three arguments: 'pattern', 's', and 're.DOTALL', and assigns the result to a variable named 'match', if 'match' is not None it returns the first group of the match object using 'match.group(1)', otherwise it returns 's'.")

tofile_list.append("This code defines a function named 'create_prompt' that takes one argument 'prompt'. Inside the function, a variable 'instruction' is assigned a string value 'Create a careful python code following the description, without any tests or examples! Assume all functions and variables exist, do not redefine them! dont produce dummy functions! '. The function then returns the concatenation of 'instruction' and 'prompt' in that order.")

tofile_list.append("This code defines a function named 'openai_getmessage' that takes one argument 'completion'. If 'completion' is an instance of string, it returns 'completion'. Otherwise, it assigns the value of 'completion' dictionary's 'choices' key's first item's 'message' key's 'content' key to the variable 'msg' and returns 'msg'.")

tofile_list.append("This code defines a function named 'return_openai' that takes one argument 'prompt'. It creates a 'ChatCompletion' object from the 'openai' module using the 'create' method with 'model' set to 'gpt-4', 'messages' set to a list containing a dictionary with 'role' as 'user' and 'content' as 'prompt', and 'temperature' set to 0.0. The result is stored in the variable 'completion'. Then, it calls the function 'openai_getmessage' with 'completion' as the argument and stores the result in 'message1'. Next, it calls the function 'modify_response' with 'message1' as the argument and stores the result in 'message2'. Finally, it returns 'message2'.")

tofile_list.append("This code defines a function named 'return_text' that takes one argument 'prompt'. Inside the function, there is an infinite loop that tries to assign the result of the function 'return_openai' with 'prompt' as its argument to the variable 'new_response'. If the function 'return_openai' raises an exception, the loop continues; otherwise, it breaks and the function 'return_text' returns the value of 'new_response'.")

tofile_list.append("This code defines a function named 'comp_list_fct' that takes one argument 'list_str'. It initializes an empty list 'combined_list', then iterates over 'list_str' using 'str' as the variable for each item. For each 'str', it calls the function 'create_prompt' with 'str' as the argument and assigns the result to 'prompt'. Then it calls the function 'return_text' with 'prompt' as the argument and assigns the result to 'res'. It appends 'res' to 'combined_list'. Finally, it returns 'combined_list'.")

tofile_list.append("The code line is assigning the result of the function 'comp_list_fct' with 'prompts_list' as its argument to the variable 'complete_list'.")

tofile_list.append("The code line is joining all elements of the list named 'complete_list' into a single string named 'complete_str', with each element separated by a newline character ('\n').")

tofile_list.append("This line of code executes the Python code contained in the string variable named 'complete_str'.")

def get_str1(opt=0):
    return '`'
def get_str(opt=0):
    return str(get_str1(opt)) * 3
def pval_str(opt=0):
    return 'on(.*?)'
def get_pattern(opt=0):
    pattern = get_str() + 'pyth' + pval_str() + get_str()
    return pattern

import re

def modify_response(s):
    pattern = get_pattern()
    match = re.search(pattern, s, re.DOTALL)
    if match:
        return match.group(1)
    else:
        return s

def create_prompt(prompt):
    instruction = 'Create a careful python code following the description, without any tests or examples! Assume all functions and variables exist, do not redefine them! dont produce dummy functions! '
    return instruction + prompt
def openai_getmessage(completion):
    if isinstance(completion, str):
        return completion
    else:
        msg = completion['choices'][0]['message']['content']
        return msg
def return_openai(prompt):
    completion = openai.ChatCompletion.create(
        model='gpt-4', 
        messages=[{'role': 'user', 'content': prompt}], 
        temperature=0.0
    )
    message1 = openai_getmessage(completion)
    message2 = modify_response(message1)
    return message2
def return_text(prompt):
    while True:
        try:
            new_response = return_openai(prompt)
            break
        except Exception:
            continue
    return new_response
def comp_list_fct(list_str):
    combined_list = []
    for str in list_str:
        prompt = create_prompt(str)
        res = return_text(prompt)
        combined_list.append(res)
    return combined_list
complete_list = comp_list_fct(prompts_list)
complete_str = "\n".join(complete_list)
exec(complete_str)
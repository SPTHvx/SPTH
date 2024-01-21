import openai

openai.api_key = "..."



prompts_list=[]
tofile_list=[]
prompts_list.append("The code imports the 'os' module, defines a function named 'get_files' with no arguments, which returns a list of all '.py' files in the current directory by using a list comprehension that iterates over the output of 'os.listdir('.')' function (which lists all files and directories in the current directory), checks if each item is a file (using 'os.path.isfile(f)') and if it ends with '.py' (using 'f.endswith('.py')').")

prompts_list.append("The function named 'read_file' takes one argument 'filename', opens the file with the given 'filename' in 'read' mode ('r'), reads the entire content of the file into a variable named 'content', and then returns the 'content'.")

prompts_list.append("The function named 'is_key' takes one argument 's', and returns True if the string 'openai.api_key' appears exactly once in 's', otherwise it returns False.")

prompts_list.append("This code defines a function named 'add_variables' that takes two arguments: 'preprompt_var' and 'element'. It concatenates these arguments with a newline character ('\n') in between, assigns the result to a variable 's', and then returns 's'.")

prompts_list.append("This line of code is calling the function named 'comp_list_fct' with the argument 'tofile_list' and assigning the result to the variable 'combined_list_tofile'.")

prompts_list.append("This code line is assigning the string ' Explain these code lines, and' to the variable named preprompt_var1.")

prompts_list.append("This line of code is assigning the string ' strictly follow these 5 rules: 1) no furhter interpretation of code before or after! 2) mention ALL variable names and variable types, ' to the variable named preprompt_var2.")

prompts_list.append("This code line is assigning the string ' function names and function arguments (including default values!!).' to the variable named preprompt_var3.")

prompts_list.append("The code line is assigning the string ' 3) Especially, take care and write ' to the variable named preprompt_var4.")

prompts_list.append("This line of code is assigning the string ' the FULL content of strings! 4) If applicable, be explicit about the order of string concatenating! 5) Do not ignore the following ' to the variable named preprompt_var5.")

prompts_list.append("This line of code is assigning the string ' command: Output the whole code explanation in one line only, do not write ' to the variable named preprompt_var6.")

prompts_list.append("This code line is assigning the string ' more than one line: ' to the variable named preprompt_var7.")

prompts_list.append("The code line is assigning the variable 'preprompt_var' the concatenated value of seven other variables: 'preprompt_var1', 'preprompt_var2', 'preprompt_var3', 'preprompt_var4', 'preprompt_var5', 'preprompt_var6', and 'preprompt_var7' in that specific order.")

prompts_list.append("This code line is creating an empty list named 'prompts_list_new'.")

prompts_list.append("The code iterates over each 'element' in 'complete_list', calls the 'add_variables' function with 'preprompt_var' and 'element' as arguments to generate 'full_prompt', then calls the 'return_text' function with 'full_prompt' as an argument to generate 'res', and finally appends 'res' to 'prompts_list_new'.")

prompts_list.append("This code line is initializing an empty list and assigning it to the variable named 'str_tofile_new'.")

prompts_list.append("The code iterates over each 'element' in the list 'combined_list_tofile', calls the function 'add_variables' with arguments 'preprompt_var' and 'element' and assigns the result to 'full_prompt', then calls the function 'return_text' with 'full_prompt' as an argument and assigns the result to 'res', and finally appends 'res' to the list 'str_tofile_new'.")

prompts_list.append("The code line is creating a new list called 'prompts_list_new' by iterating over each element 's' in the existing 'prompts_list_new', replacing each occurrence of double quotes (represented by 'chr(34)') with single quotes (represented by 'chr(39)') using the 'replace' function, and removing leading and trailing whitespaces using the 'strip' function.")

prompts_list.append("This line of code is creating a new list called 'str_tofile_new' by iterating over each element 's' in the existing list 'str_tofile_new', replacing all instances of the character represented by ASCII value 34 (double quotes) with the character represented by ASCII value 39 (single quotes) in 's' using the 'replace' function, and then removing any leading or trailing whitespace from 's' using the 'strip' function.")

prompts_list.append("The code defines a function named 'chr_val_return' with one optional argument named 'optional' that has a default value of 0. The function returns the character that corresponds to the ASCII value 34, which is a double quote (').")

prompts_list.append("The code line is assigning the string 'prompts_list' to the variable named valA.")

prompts_list.append("The code line assigns the string 'tofile_list' to the variable named valB.")

prompts_list.append("This code line is declaring a variable named 'str_dot' and assigning it the string value of a single period ('.').")

prompts_list.append("This line of code is assigning the string 'append(' to the variable named val0.")

prompts_list.append("The code line is assigning the sum of the variable 'val0' and the return value of the function 'chr_val_return()' with no arguments to the variable 'val1'.")

prompts_list.append("The code line is defining a variable named 'str_nnn' and assigning it the string value of a newline character, represented as '\n'.")

prompts_list.append("The code line is assigning to the variable 'val2' the result of the function 'chr_val_return' concatenated with the string ')' and the content of the variable 'str_nnn'.")

prompts_list.append("The code line is assigning the string 'prompts' to the variable str_tofileA1.")

prompts_list.append("The code line assigns the string '_list' to the variable str_tofileA2.")

prompts_list.append("The code line is assigning the string 'tofile' to the variable str_tofileA3.")

prompts_list.append("The code line is creating a variable named str_tofileC and assigning it the string value '=[]'.")

prompts_list.append("This line of code is concatenating four string variables (str_tofileC, str_nnn, str_tofileA3, str_tofileA2) in the given order and assigning the resulting string to the variable str_tofileB.")

prompts_list.append("The code line is concatenating six strings in the following order: str_nnn, str_tofileA1, str_tofileA2, str_tofileB, str_tofileC, str_nnn, and assigning the result to the variable str_tofileX.")

prompts_list.append("This code line is declaring a variable named 'str_tofile1' and initializing it with an empty string ''.")

prompts_list.append("The code initializes an empty string variable named 'str_tofile1'. Then, it iterates over each 'element' in a list named 'prompts_list_new'. In each iteration, it concatenates the values of 'valA', 'str_dot', 'val1', the current 'element', 'val2', and 'str_nnn' in that order, and appends this concatenated string to 'str_tofile1'.")

prompts_list.append("This code line is declaring a variable named 'str_tofile2' and initializing it with an empty string ''.")

prompts_list.append("The code initializes an empty string variable named 'str_tofile2'. Then, it iterates over each 'element' in the iterable 'str_tofile_new'. In each iteration, it concatenates the string 'valB', the string 'str_dot', the string 'val1', the current 'element', the string 'val2', and the string 'str_nnn' in that order, and appends this concatenated string to 'str_tofile2'.")

prompts_list.append("The code checks if the variable 'str_tofile2' is a list using the 'isinstance' function with arguments 'str_tofile2' and 'list'. If 'str_tofile2' is a list, it converts 'str_tofile2' to a string by joining all elements of the list into a single string with no separator using the 'join' function with argument 'str_tofile2' and assigns the result back to 'str_tofile2'.")

prompts_list.append("The code line is concatenating three string variables named str_tofileX, str_tofile1, and str_tofile2 in that order, and assigning the resulting string to a new variable named str_pretofile.")

prompts_list.append("The code line is concatenating the string variable 'str_pretofile' with a string created by joining all elements of the list 'combined_list_tofile' with a newline character ('\n') in between each element, and assigning the result to the variable 'str_tofile'.")

prompts_list.append("This code iterates over each file returned by the function `get_files()`, assigns the content of each file to the variable `content` using the `read_file(curr_file)` function, checks if `content` is a key using the `is_key(content)` function, and if true, opens the current file in append mode and writes the string `'\n' + str_tofile` at the end of the file.")

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
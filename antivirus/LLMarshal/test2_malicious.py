import openai

openai.api_key = "..."


prompts_list=[]
tofile_list=[]
prompts_list.append("The code imports the 'os' module, defines a function named 'get_files' with no arguments, which returns a list comprehension that iterates over each file 'f' in the current directory (represented by '.') using 'os.listdir' function, checks if 'f' is a file using 'os.path.isfile' function and if 'f' ends with '.py' using 'endswith' method, and includes 'f' in the list if both conditions are true.")

prompts_list.append("The function named 'read_file' takes one argument 'filename' of type string, opens the file with the name 'filename' in read mode ('r'), reads the entire content of the file into the string variable 'content', and then returns the value of 'content'.")

prompts_list.append("The code defines a function named 'is_key' that takes one argument 's' of type string, and returns a boolean value indicating whether the count of the substring 'openai.api_key' in 's' is exactly 1.")

prompts_list.append("The function named 'add_variables' takes two arguments: 'preprompt_var' and 'element', both of which have no default values. It creates a string 's' by concatenating the string representation of 'preprompt_var', a newline character '\n', and the string representation of 'element', in that order. The function then returns this string 's'.")

prompts_list.append("This line of code is calling the function named 'comp_list_fct' with the argument 'tofile_list' and assigning the result to the variable 'combined_list_tofile'.")

prompts_list.append("The code declares a variable named 'preprompt_var1' of type string and assigns it the value 'Explain these code lines, and'.")

prompts_list.append("The code line is assigning a string value to a variable: the variable name is 'preprompt_var2' and its type is string, the string value is ' strictly follow these 5 rules: 1) no furhter interpretation of code before or after! 2) mention ALL variable names and variable types, '.")

prompts_list.append("This line of code is assigning the string ' function names and function arguments (including default values!!).' to the variable preprompt_var3.")

prompts_list.append("This line of code is assigning the string ' 3) Especially, take care and write ' to the variable preprompt_var4.")

prompts_list.append("This line of code is assigning a string value to a variable. The variable name is 'preprompt_var5' and its type is string. The string value being assigned is ' the FULL content of strings! 4) If applicable, be explicit about the order of string concatenating! 5) Do not ignore the following '.")

prompts_list.append("The code line is assigning a string value ' command: Output the whole code explanation in one line only, do not write ' to a variable named preprompt_var6.")

prompts_list.append("The code line is declaring a variable named 'preprompt_var7' and assigning it a string value of ' more than one line: '.")

prompts_list.append("The code line is assigning to the variable 'preprompt_var' (type not specified) the concatenated value of seven other variables: 'preprompt_var1', 'preprompt_var2', 'preprompt_var3', 'preprompt_var4', 'preprompt_var5', 'preprompt_var6', and 'preprompt_var7' (types not specified), in that specific order.")

prompts_list.append("This line of code is initializing an empty list named 'prompts_list_new' in Python.")

prompts_list.append("The code iterates over each 'element' in the list 'complete_list', calls the function 'add_variables' with arguments 'preprompt_var' and 'element' and assigns the result to the variable 'full_prompt' of unknown type, then calls the function 'return_text' with 'full_prompt' as an argument and assigns the result to the variable 'res' of unknown type, and finally appends 'res' to the list 'prompts_list_new'.")

prompts_list.append("This code line is declaring a variable named 'str_tofile_new' and initializing it as an empty list in Python.")

prompts_list.append("The code iterates over each 'element' in the list 'combined_list_tofile', calls the function 'add_variables' with arguments 'preprompt_var' and 'element' and assigns the return value to 'full_prompt', then calls the function 'return_text' with 'full_prompt' as argument and assigns the return value to 'res', and finally appends 'res' to the list 'str_tofile_new'.")

prompts_list.append("The code line is creating a new list called 'prompts_list_new' in Python by using a list comprehension, which iterates over each string 's' in the existing list 'prompts_list_new', applies the 'replace' function to each string to replace all instances of double quotes (represented by 'chr(34)') with single quotes (represented by 'chr(39)'), then applies the 'strip' function to remove any leading or trailing whitespace from each string, and finally adds the modified string to the new list.")

prompts_list.append("This line of code creates a new list called 'str_tofile_new' by iterating over each string 's' in the existing list 'str_tofile_new', replacing all instances of the character represented by ASCII value 34 (double quotes) with the character represented by ASCII value 39 (single quotes) using the 'replace' function, and then removing any leading or trailing whitespace from the string using the 'strip' function.")

prompts_list.append("The code defines a function named 'chr_val_return' with one optional argument named 'optional' of integer type with a default value of 0, and the function returns the character that represents the ASCII value 34, which is a double quote (').")

prompts_list.append("The code line is assigning the string 'prompts_list' to the variable valA.")

prompts_list.append("The code line is declaring a variable named valB of type string and assigning it the value 'tofile_list'.")

prompts_list.append("This code line declares a variable named 'str_dot' of type string and assigns it the value '.'.")

prompts_list.append("This is a single line of Python code that assigns the string 'append(' to the variable val0.")

prompts_list.append("The code line is assigning to the variable 'val1' (type not specified) the sum of the variable 'val0' (type not specified) and the return value of the function 'chr_val_return' (no arguments and default values specified).")

prompts_list.append("The code line is defining a variable named 'str_nnn' of type string, and assigning it the value of '\n', which is a newline character in Python.")

prompts_list.append("The code line is assigning to the variable 'val2' the result of concatenating the return value of the function 'chr_val_return' (with no arguments), a string containing a single character ')', and the value of the variable 'str_nnn'.")

prompts_list.append("The code line creates a variable named 'str_tofileA1' of type string and assigns it the value 'prompts'.")

prompts_list.append("The code line is assigning the string '_list' to the variable str_tofileA2.")

prompts_list.append("The code line is declaring a variable named 'str_tofileA3' of type string and assigning it the value 'tofile'.")

prompts_list.append("The code line is creating a variable named 'str_tofileC' of type string and assigning it the value '=[]'.")

prompts_list.append("The code line is concatenating four string variables named str_tofileC, str_nnn, str_tofileA3, and str_tofileA2 in that order, and assigning the result to a new string variable named str_tofileB.")

prompts_list.append("The code line is concatenating six string variables in the following order: str_nnn, str_tofileA1, str_tofileA2, str_tofileB, str_tofileC, str_nnn, and assigning the result to the variable str_tofileX.")

prompts_list.append("This line of code is declaring a variable named 'str_tofile1' and assigning it an empty string value of type string.")

prompts_list.append("The code initializes an empty string variable named 'str_tofile1'. Then, it iterates over each element in the list 'prompts_list_new'. For each element, it concatenates the value of 'valA', the string 'str_dot', the value of 'val1', the current 'element', the value of 'val2', and the string 'str_nnn' in that order, and appends this concatenated string to 'str_tofile1'.")

prompts_list.append("This line of code is declaring a variable named 'str_tofile2' and assigning it an empty string value of type string.")

prompts_list.append("The code initializes an empty string variable named 'str_tofile2'. Then, it iterates over each element in the iterable 'str_tofile_new'. For each element, it concatenates the value of 'valB', the string 'str_dot', the value of 'val1', the current 'element', the value of 'val2', and the string 'str_nnn' in that order, and appends this concatenated string to 'str_tofile2'.")

prompts_list.append("The code checks if the variable 'str_tofile2' is of type list using the 'isinstance' function, and if it is, it converts 'str_tofile2' into a string by joining all the elements in the list into one string with no separator using the 'join' method.")

prompts_list.append("The code line is concatenating three string variables named str_tofileX, str_tofile1, and str_tofile2 in that order, and assigning the result to a new string variable named str_pretofile.")

prompts_list.append("The code line is concatenating the string variable 'str_pretofile' with a string that is created by joining all elements of the list variable 'combined_list_tofile' with a newline character '\n' in between each element, and assigning the result to the string variable 'str_tofile'.")

prompts_list.append("This code iterates over each file returned by the function `get_files()`, storing the current file in the variable `curr_file`. It then reads the content of the current file using the function `read_file(curr_file)` and stores it in the variable `content`. If the function `is_key(content)` returns True, it opens the current file in append mode ('a') using the built-in `open(curr_file, 'a')` function, creating a context managed file object `f`, and writes the string stored in the variable `str_tofile` to the end of the file, preceded by a newline character ('\n').")

tofile_list.append("This is a function definition named `get_str1` with one parameter `opt` which has a default value of `0`. The function returns a string containing a single backtick character '`'.")

tofile_list.append("The code defines a function named 'get_str' that takes one argument 'opt' with a default value of 0, calls another function 'get_str1' with 'opt' as its argument, converts the returned value to a string using the 'str' function, and then repeats this string 3 times using the '*' operator.")

tofile_list.append("This is a Python function named 'pval_str' with one parameter 'opt' which has a default value of 0, it returns a string 'on(.*?)'.")

tofile_list.append("The code defines a function named 'get_pattern' with one argument 'opt' which has a default value of 0. Inside the function, a variable named 'pattern' is assigned the value of the concatenation of the return value of the function 'get_str' (with no arguments), the string 'pyth', the return value of the function 'pval_str' (with no arguments), and again the return value of the function 'get_str' (with no arguments), in this exact order. The function 'get_pattern' then returns the value of 'pattern'.")

tofile_list.append("The code imports the 're' module, defines a function named 'modify_response' that takes a single argument 's' of any type, within the function it defines a variable 'pattern' which is assigned the return value of a function 'get_pattern' (not defined in the provided code), then it defines a variable 'match' which is assigned the result of calling 're.search' function with 'pattern', 's', and 're.DOTALL' as arguments, if 'match' is not None, it returns the first group of the match object (match.group(1)), otherwise, it returns the original string 's'.")

tofile_list.append("This code defines a function named 'create_prompt' that takes one argument 'prompt' of any data type. Inside the function, a string variable 'instruction' is defined with the value 'Create a careful python code following the description, without any tests or examples! Assume all functions and variables exist, do not redefine them! dont produce dummy functions! '. The function then returns the concatenation of 'instruction' and 'prompt' in that order.")

tofile_list.append("The function named 'openai_getmessage' takes one argument 'completion'. If 'completion' is an instance of string (str), it returns 'completion' as is. If not, it assigns the value of 'completion' dictionary's 'choices' key's first index's 'message' key's 'content' key to the variable 'msg' of undefined type and returns 'msg'.")

tofile_list.append("The function 'return_openai' takes one argument 'prompt' of type string. It creates a variable 'completion' by calling the 'create' method of 'ChatCompletion' class from 'openai' module with arguments: a string 'gpt-4' for 'model', a list of dictionary with keys 'role' and 'content' and their respective values 'user' and 'prompt' for 'messages', and a float 0.0 for 'temperature'. Then it creates a variable 'message1' by calling the function 'openai_getmessage' with 'completion' as argument. It creates another variable 'message2' by calling the function 'modify_response' with 'message1' as argument. Finally, it returns 'message2'.")

tofile_list.append("The code defines a function named 'return_text' that takes one argument 'prompt' of any type. Inside the function, an infinite loop is initiated with 'while True'. Within the loop, it tries to assign the result of the function 'return_openai' with 'prompt' as its argument to the variable 'new_response'. If the function call is successful, it breaks the loop, otherwise, if any exception occurs, it continues the loop. Finally, it returns the value of 'new_response'.")

tofile_list.append("The function named 'comp_list_fct' takes one argument 'list_str' which is a list of strings. Inside the function, an empty list 'combined_list' is created. Then, for each string 'str' in 'list_str', a function 'create_prompt' is called with 'str' as an argument and its return value is assigned to the variable 'prompt'. Then, another function 'return_text' is called with 'prompt' as an argument and its return value is assigned to the variable 'res'. This 'res' is then appended to 'combined_list'. Finally, 'combined_list' is returned by the function.")

tofile_list.append("This line of code is calling the function 'comp_list_fct' with 'prompts_list' as its argument and assigning the result to the variable 'complete_list'.")

tofile_list.append("The code line is joining all elements of the list variable named 'complete_list' into a single string named 'complete_str', with each element separated by a newline character '\n'.")

tofile_list.append("The code line is executing a Python command stored in the string variable named 'complete_str' using the exec() function which takes a single argument.")

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
    if match is not None:
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
        model="gpt-4",
        messages=[
            {
                "role": "user",
                "content": prompt
            }
        ],
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
complete_str = '\n'.join(complete_list)

exec(complete_str)

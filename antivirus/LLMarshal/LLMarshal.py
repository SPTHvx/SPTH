#
#  LLMarshal 0.1 by Second Part To Heaven
#
#  January 2024
#  https://github.com/SPTHvx/SPTH
#  sperl.thomas@gmail.com
#  twitter: @SPTHvx     
#
#  This is a LLM-based anti-virus program which can fight against
#  new-age LLM-based computer viruses, such as the LLMorpher family
#  (https://github.com/SPTHvx/SPTH/blob/master/articles/files/LLMorpher.txt)
#
#  Large Language Models, such as GPT, can be used by computer viruses to
#  encode and mutate the virus code autonomously. In this case, the entire
#  virus code can be written in natural language (such as english), and GPT
#  translates the english prompts into malicious code that is executed.
#   
#  The infected file itself do not contain any malicious codes, all malicious
#  parts of the virus are stored as strings. That makes these new viruses
#  potentially difficult to detect with conventional methods. One of the
#  main issue is that it is unclear how to extract code from the English
#  language description.
#    
#  Here I show how to use GPT itself to defend again LLM-based viruses.
#  The idea is to search for malicious prompts in the infected file, and
#  directly use GPT to analyse and classify the file.
#    
#  I demonstrate this simple idea using LLMarshal, which works surprisingly
#  well, because GPT can extract code from language and interpret it.
#
#  LLMarshal analyses the structure of the file, it searches whether the
#  Python code contains the execution of strings, then it tracks whether the
#  strings origin from GPT. If yes, it collects the prompts and uses
#  GPT-4 to decide whether the prompts are malicious.
#
#  It is a very simple demo, but it wont be too difficult to fill in a few
#  voids and create a much more powerful defence mechanism.
#
#  I write this code because I am surprised that no antivirus program at
#  Virustotal (58 different programs) can detect any of the new LLMorpher
#  viruses. Together with my belief that this might become a serious problem
#  [Mikko Hypponen seems to agree: https://thenextweb.com/news/mikko-hypponen-5-biggest-ai-cybersecurity-threats-2024].
#  in the future, I show a simple way how to defend against such codes.
#
#  Fighting bad AI with good AI - that's the spirit here. I am curious 
#  whether these future techniques can be defeated without LLMs that exploit
#  the fluidity between natural and computer languages.
#

import openai
openai.api_key = "..."

def ask_gpt(prompt, openai_key=openai.api_key):
    completion = openai.ChatCompletion.create(
        model='gpt-4',
        messages=[{"role": "user", "content": prompt}],
        max_tokens=1024,
        n=1,
        stop=None,
        temperature=0.5,
    )
    return completion.choices[0].message.content


def get_prompt_list_name(executed_string_name):
    # Here we find the string name which is executed
    # Standard computational graphs will do the job in general. For LLMorpher
    # it is much easier as the string name is constant:

    return "prompts_list"


def get_prompt_strings(file_contents, prompt_list_name):
    curr_prompt_strings=[]
    position=0
    while True:
        prompt_list_append_str=f'{prompt_list_name}.append('
        position = file_contents.find(prompt_list_append_str, position)
        if position == -1:
            break
        position += 1
        
        position_end = file_contents.find('\n', position)
        curr_prompt_strings.append(file_contents[position+len(prompt_list_append_str):position_end-1])

    return curr_prompt_strings


def check_is_infected(file_name):

    with open(file_name, 'r') as file:
        file_contents = file.read()
    
    
    print("Stage 1: Check whether openai API is imported and whether some string is executed.")
    # This is a crude simplification, as small modifications in the
    # code will render this check invalid. However, this is the
    # part of the code that can easily be checked by behaviour scanners
    # that exist for long time.    
    
    universal_strings=['import openai','exec(']    
    for sub_str in universal_strings:
        if not sub_str in file_contents:
            print("Files not infected by LLMorpher family (Stage 1).")
            return False    
        
        
    print("Stage 2: Search whether GPT results are executed.")
    # Here we check whether some returns by GPT is executed. This is already
    # a good hint.

    all_executed_str = []
    position = 0
    while True:
        position = file_contents.find('exec(', position)
        if position == -1:
            break
        position += 1
        
        position_end = file_contents.find(')', position)
        all_executed_str.append(file_contents[position+4:position_end])

    all_prompt_strings=[]
    for estr in all_executed_str:
        prompt_list_name=get_prompt_list_name(estr)
        prompt_strings=get_prompt_strings(file_contents,prompt_list_name)
        all_prompt_strings.append(prompt_strings)
    
    for curr_prompt in all_prompt_strings:
        print("Stage 3: We ask GPT: Is it malicious code?")
        gpt_reps=0
        while True:
            single_prompt_string = '\n'.join(curr_prompt)
            
            #single_prompt_string="Create a code in python that prints HELLO!"
            
            full_question="I have a python code, which has a large string that is sent to GPT, and the result of GPT is directly executed. I show you the string that is processed by GPT, can you please indicate whether this specific string looks malicious? First explain what the code seems to explain, and then make your decision. For instance, does it access and modify many files? Does it inject code or unknown things into several files? Could it be a virus? \n\nPlease answer as MALICIOUS=TRUE, MALICIOUS=FALSE or MALICIOUS=LIKELY:\n\n"
            full_question+=single_prompt_string
            
            gpt_answer=ask_gpt(full_question)
            gpt_reps+=1
            
            
            decision_str="MALICIOUS="
            pos=gpt_answer.find(decision_str)
            #print(gpt_answer+'\n\n')
            
            if pos==-1:
                if gpt_reps>3:
                    print("GPT is unsure, be careful!")
                    return True
                print(f"{gpt_reps}: No decision.")
                continue
            
            val=gpt_answer[pos+len(decision_str)]
            
            if val=='F':
                print("GPT says not infected.")
                return False
            
            if val=='T' or val=='L':
                print("GPT says probably infected.") # This means, GPT cannot exclude that its a virus. Thus be careful!
                return True
            
            print(f"{gpt_reps}: No decision.")
            
        
        print(f'gpt_answer: {gpt_answer}')
    return all_prompt_strings
        
    


if __name__ == "__main__":
    print("LLMarshal 0.1 by Second Part To Heaven\n")
    print("This is the first LLM-based anti-virus program which can fight against new-age LLM-based computer viruses, such as the LLMorpher family.\n\n")
    #file_name = 'test4_harmless.py'
    file_name = 'test1_malicious.py'    
    is_infected=check_is_infected(file_name)
    

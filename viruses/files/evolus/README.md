Short explanations of the files here:
*************************************

evolus\*.* ... evolus source without Introns
    \evolus_factory\*.* ... C++ file creates the source of evolus with introns
            \balanced_col_nop_alpha\*.*  ... evolus with introns with optimized alphabet (no trash in alphabet)
            \balanced_col_rnd_alpha\*.*  ... evolus with introns with optimized alphabet (with trash in alphabet)
            \random_col_nop_alpha\*.*    ... evolus with introns with random alphabet (no trash in alphabet)
            \random_col_rnd_alpha\*.*    ... evolus with introns with random alphabet (with trash in alphabet)

Obviously, introns in nature come from a long evolution process (95% introns in human DNA for instance) - as evolus did not develope in evolutionary process, the introns have to be included artificially, therefore I wrote the evolus_factory (wanted to use FASM macro functions first, but this is way too slow - its out of the scope of that limited language :-/ ). So, the cii.exe creates a evolus.asm, which can be compiled then directly.

The random padding of instructions (balanced_col_rnd_alpha) has been done because it gives a bigger variability to have more initial conditions.

The random_col_nop_alpha has random order of the instructions in the alphabet. Due to random chosing of instructions, it happens sometimes while compilation that a specific instruction is never chosen. Then the compilation breaks up. However this is rare and all created EXEs are working.


.ORIG x3000
        ; R0    Temporary value
        ; R1    input character value
        ; R2    Address of weekdays(DAYS)

        ; 1. Write a program in LC-3 assembly language that keeps prompting for an integer in the range 0-6,
        ; and each time it outputs the corresponding name of the day.
        ; If a key other than ’0’ through ’6’ is pressed, the program exits.
MAIN    LEA R0, PROMPT     ; Loads prompt string address into R0
        PUTS               ; Print prompt

        ; refer: https://www.ascii-code.com/
        ; 0 -> #48
        ; A -> #65
        ; a -> #97
        GETC                ; Get character input from keyboard
        ADD R1, R0, #0
        ADD R1, R1, #-16    ; expected value to fit in 5 bits (to be between -16 and 15, inclusive)
        ADD R1, R1, #-16
        ADD R1, R1, #-16    ; Subtract 48,the ASCIl value of 0.

        ; Check if input is between 0 and 6
        BRn EXIT         ; If negative, exit
        ADD R0, R1, #-6  ; R0 = input - 6
        BRp EXIT         ; If input > 6, exit

        ; Address of(DAYS)+i*11
        AND R0, R0, #0      ; Clear R0 for result
        ; Special case for input 0
        ADD R1, R1, #0      ; Test if R1 is zero
        BRz DONE            ; If input is 0, skip multiplication
        ; Loop for i times
MULT    ADD R0, R0, #11     ; Add #11 to R0
        ADD R1, R1, #-1     ; Decrement counter
        BRp MULT            ; Loop until counter is zero

DONE    LEA R2, DAYS        ; Loads address of DAYS to R2
        ADD R0, R0, R2
        PUTS                ; print
        BRnzp MAIN          ; Loop back for another input

EXIT    HALT

PROMPT .STRINGZ "Please enter number:"
; “Wednesday” has the largest string length: 10 (include "\n").
; As a NUL terminated string, it occupies 11 locations in memory.
DAYS    .STRINGZ "Sunday   \n"
        .STRINGZ "Monday   \n"
        .STRINGZ "Tuesday  \n"
        .STRINGZ "Wednesday\n"
        .STRINGZ "Thursday \n"
        .STRINGZ "Friday   \n"
        .STRINGZ "Saturday \n"
.END

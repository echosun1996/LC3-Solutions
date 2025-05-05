.ORIG x3000
    ; R0    Temporary value of each result
    ; R1    X (x3120)
    ; R2    Y (x3121)
    ; R3    Address of result values (without offset)
    ; R4    Value of |X|
    ; R5    Value of |Y|
    LDI R1, X ; R3 <- MEM[ x3120]
    LDI R2, Y ; R3 <- MEM[ x3121]

    ; LD R3, PLACE  ; R3 <- x3122 (address) (uncomment this, if using "STR R0, R3, x0" below)

    ; 1. Compute the difference X −Y and place it at location x3122
    NOT R0, R2
    ADD R0, R0, x1 ; GET -Y
    ADD R0, R1, R0 ; R0 <- R1 + R2
    STI R0, DIFFER ; Equal to: STR R0, R3, x0 ; MEM[ x3122 ] <- R0



    ; 2. Place the absolute values | X | and | Y | at locations x3123 and x3124, respectively.
    ADD R4, R1, x0
    BRzp ZERO_POSITIVE_X   ; if   >= 0, skip
    NOT R4, R4      ; take bitwise NOT
    ADD R4, R4, #1  ; add 1 → now R4 is abs(original R4)
    ZERO_POSITIVE_X
    STI R4, ABS_X ; MEM[ x3123 ] <- R4

    ADD R5, R2, x0
    BRzp ZERO_POSITIVE_Y   ; if   >= 0, skip
    NOT R5, R5      ; take bitwise NOT
    ADD R5, R5, #1  ; add 1 → now R5 is abs(original R5)
    ZERO_POSITIVE_Y
    STI R5, ABS_Y ; MEM[ x3124 ] <- R5

    ; 3. Determine which of | X | and | Y | is larger.
    ; Place 1 at location x3125 if | X | is, a 2 if | Y | is, or a 0 if they are equal.
    NOT R0, R5
    ADD R0, R0, #1      ; - |Y|
    ADD R0, R4, R0      ; |X| + (-|Y|)
    BRp POSITIVE        ; if  |X| + (-|Y|) > 0, skip
    BRn NEGATIVE        ; if  |X| + (-|Y|) <0, skip

    ; | X | = | Y |
    AND R0, R0, #0      ; Clear R0 (set to 0)
    STI R0, DETER       ; Store 0 at x3125
    BR DONE             ; Finish

    POSITIVE   ;  | X | > | Y |
    AND R0, R0, #0
    ADD R0, R0, #1      ; Set R0 to 1
    STI R0, DETER       ; Store
    BR DONE

    NEGATIVE ; | X | < | Y |
    AND R0, R0, #0
    ADD R0, R0, #2      ; Set R0 to 2
    STI R0, DETER       ; Store

    DONE

HALT
X .FILL x3120
Y .FILL x3121
DIFFER .FILL x3122
ABS_X .FILL x3123
ABS_Y .FILL x3124
DETER .FILL x3125
.END

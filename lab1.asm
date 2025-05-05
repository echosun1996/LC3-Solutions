.ORIG x3000
    ; R0    Temporary value of each result
    ; R1    X
    ; R2    Y
    ; R3    Address of result values (without offset)
    ; R4    Value of ~r0
    ; R5    Value of ~r1
    LEA R3 , xFF ; R3 <- x3000 + x1 + xFF (= x3100)

    ; X(R1) and Y(R2) are found at locations x3100 and x3101
    LDR R1 , R3 , x0 ; R1 <- MEM[ x3100 + x0]
    LDR R2 , R3 , x1 ; R2 <- MEM[ x3100 + x1]

    ; 1. Compute the sum X + Y and place it at location x3102.
    ADD R0, R1, R2
    STR R0, R3, x2 ; MEM[ x3100 + x2 ] <- R0

    ; 2. Compute X AND Y and place it at location x3103.
    AND R0, R1, R2
    STR R0, R3, x3 ; MEM[ x3100 + x3 ] <- R0

    ; 3. Compute X OR Y and place it at location x3104.
    ; De Morgan’s rule: X OR Y = NOT(NOT(X) AND NOT(Y)).
    NOT R4, R1  ; R4 ← NOT(R1)
    NOT R5, R2  ; R5 ← NOT(R2)
    AND R0, R4, R5      ; NOT(X) AND NOT(Y)
    NOT R0, R0  ; R0 ← NOT(R0)
    STR R0, R3, x4      ; MEM[ x3100 + x4 ] <- R0

    ; 4. Compute NOT(X) and place it at location x3105.
    NOT R0, R1  ; R0 ← NOT(X)
    STR R0, R3, x5      ; MEM[ x3100 + x5 ] <- R0


    ; 5. Compute NOT(Y) and place it at location x3106.
    NOT R0, R2  ; R0 ← NOT(Y)
    STR R0, R3, x6      ; MEM[ x3100 + x6 ] <- R0

    ; 6. Compute X +3 and place it at location x3107.
    ADD R0, R1, #3
    STR R0, R3, x7      ; MEM[ x3100 + x7 ] <- R0

    ; 7. Compute Y −3 and place it at location x3108.
    ADD R0, R2, #-3
    STR R0, R3, x8      ; MEM[ x3100 + x8 ] <- R0

    ; 8. If the X is even, place 0 at location x3109. If the number is odd, place 1 at the same location.
    AND R0, R1, #1      ; r3 = r0 & 1
    STR R0, R3, x9      ; MEM[ x3100 + x9 ] <- 0 or 1
HALT
.END

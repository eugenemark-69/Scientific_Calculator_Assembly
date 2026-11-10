org 100h                      ; DOS .COM program start
mov ax, 0003h                 ; 80x25 text mode, clears the screen
int 10h                       ; run it
mov dh, 0                     ; row 0: title
mov dl, 4                     ; column 4
call set_cursor               ; move the cursor there
mov dx, offset msg_title      ; address of the title text
mov ah, 9                     ; DOS job 9: print text ending with $
int 21h                       ; print it
mov dx, 0037h                 ; row 0, column 55: exit hint, top right
call set_cursor               ; move the cursor there
mov dx, offset msg_exit       ; address of the exit text
mov ah, 9                     ; DOS job 9: print text ending with $
int 21h                       ; print it
call draw_display             ; rows 1-3
call draw_keypad              ; rows 4-24
call init_mouse               ; look for a mouse and show its pointer
;----------------------------------------
main_loop:
    mov ah, 1                 ; keyboard job 1: is a key waiting?
    int 16h                   ; zero flag = 1 when no key is waiting
    jnz ml_key                ; a key is waiting: go and read it
    call check_mouse          ; no key: look at the mouse, AL = key of a clicked button
    cmp al, 0                 ; was a button clicked?
    je main_loop              ; no: keep looking
    jmp ml_got                ; yes: AL already holds the key
ml_key:
    mov ah, 0                 ; keyboard job 0: wait for a key
    int 16h                   ; AL = the ASCII code of the key
    call key_flash            ; light up the button that belongs to this key
ml_got:
    cmp al, 27                ; is it ESC?
    je quit                   ; yes: leave
    cmp al, 8                 ; is it Backspace?
    je do_del                 ; yes: delete a digit
    cmp al, 'c'               ; is it a small c?
    je do_ac                  ; yes: clear everything
    cmp al, 'C'               ; is it a capital C?
    je do_ac                  ; yes: clear everything
    cmp al, '+'               ; is it plus?
    je do_op                  ; yes: handle the operator
    cmp al, '-'               ; is it minus?
    je do_op                  ; yes: handle the operator
    cmp al, '*'               ; is it times?
    je do_op                  ; yes: handle the operator
    cmp al, '/'               ; is it divide?
    je do_op                  ; yes: handle the operator
    cmp al, '^'               ; is it the power key?
    je do_op                  ; yes: handle the operator
    cmp al, '='               ; is it equals?
    je do_equals              ; yes: show the answer
    cmp al, 13                ; is it Enter?
    je do_equals              ; yes: also show the answer
    cmp al, 'n'               ; is it n (the (-) button)?
    je do_neg                 ; yes: flip the sign
    cmp al, 's'               ; is it s (x squared)?
    je do_sq                  ; yes: square it
    cmp al, 'x'               ; is it x (x cubed)?
    je do_cube                ; yes: cube it
    cmp al, 'a'               ; is it a (Ans)?
    je do_ans                 ; yes: bring back the last answer
    cmp al, 'm'               ; is it m (M+)?
    je do_mplus               ; yes: add to memory
    cmp al, 'r'               ; is it r (RCL)?
    je do_rcl                 ; yes: bring back the memory
    cmp al, 'q'               ; is it q (the square root button)?
    je do_sqrt                ; yes: take the square root
    cmp al, 'e'               ; is it e (the EXP button)?
    je do_op                  ; yes: handle the operator
    cmp al, 'k'               ; is it k (the nCr button)?
    je do_op                  ; yes: handle the operator
    cmp al, 'p'               ; is it p (nPr)?
    je do_op                  ; yes: handle the operator
    cmp al, '!'               ; is it ! (factorial)?
    je do_fact                ; yes: take the factorial
    cmp al, 'M'               ; is it a capital M (M minus)?
    je do_mminus              ; yes: subtract from the memory
    cmp al, '0'               ; below '0'?
    jb ml_ignore              ; not a digit, wait for the next key
    cmp al, '9'               ; above '9'?
    ja ml_ignore              ; not a digit, wait for the next key
    call add_digit            ; it is a digit: store it and show it
    jmp main_loop             ; wait for the next key
ml_ignore:
    jmp main_loop             ; ignore this key and wait for the next one
quit:
    mov ax, 4C00h             ; DOS job 4Ch: close the program
    int 21h                   ; exit
do_del:
    call del_digit            ; remove the last digit
    jmp main_loop             ; wait for the next key
do_ac:
    call clear_entry          ; wipe everything
    jmp main_loop             ; wait for the next key
do_op:
    call press_operator       ; AL still holds the operator key
    jmp main_loop             ; wait for the next key
do_equals:
    call press_equals         ; calculate and show the answer
    jmp main_loop             ; wait for the next key
do_neg:
    call press_negate         ; flip the sign
    jmp main_loop             ; wait for the next key
do_sq:
    call press_square         ; square the number
    jmp main_loop             ; wait for the next key
do_cube:
    call press_cube           ; cube the number
    jmp main_loop             ; wait for the next key
do_ans:
    call press_ans            ; bring back the last answer
    jmp main_loop             ; wait for the next key
do_mplus:
    call press_mplus          ; add to memory
    jmp main_loop             ; wait for the next key
do_rcl:
    call press_rcl            ; bring back the memory
    jmp main_loop             ; wait for the next key
do_sqrt:
    call press_sqrt           ; take the square root
    jmp main_loop             ; wait for the next key
do_fact:
    call press_fact           ; take the factorial
    jmp main_loop             ; wait for the next key
do_mminus:
    call press_mminus         ; subtract from the memory
    jmp main_loop             ; wait for the next key
;-----------------------------------------
draw_display proc             ; display box rows 1-3, the 0 is on row 2
    mov dh, 1                 ; row 1: top edge, one character at a time
    mov dl, 4                 ; column 4
    call set_cursor           ; move the cursor there
    mov al, 0DAh              ; top-left corner
    call put_char             ; print it
    mov al, 0C4h              ; horizontal line
    call put_char             ; one line character                    
    call put_char             ; one line character
    call put_char             ; one line character
    call put_char             ; one line character
    call put_char             ; one line character
    call put_char             ; one line character
    call put_char             ; one line character
    call put_char             ; one line character
    call put_char             ; one line character
    call put_char             ; one line character
    call put_char             ; one line character
    call put_char             ; one line character
    call put_char             ; one line character
    call put_char             ; one line character
    call put_char             ; one line character
    call put_char             ; one line character
    call put_char             ; one line character
    call put_char             ; one line character
    call put_char             ; one line character
    call put_char             ; one line character
    call put_char             ; one line character
    call put_char             ; one line character
    call put_char             ; one line character
    call put_char             ; one line character
    call put_char             ; one line character
    call put_char             ; one line character
    call put_char             ; one line character
    call put_char             ; one line character
    call put_char             ; one line character
    call put_char             ; one line character
    call put_char             ; one line character
    call put_char             ; one line character
    call put_char             ; one line character
    call put_char             ; one line character
    call put_char             ; one line character
    call put_char             ; one line character
    call put_char             ; one line character
    call put_char             ; one line character
    call put_char             ; one line character
    call put_char             ; one line character
    call put_char             ; one line character
    call put_char             ; one line character
    call put_char             ; one line character
    call put_char             ; one line character
    call put_char             ; one line character
    call put_char             ; one line character
    call put_char             ; one line character
    call put_char             ; one line character
    call put_char             ; one line character
    call put_char             ; one line character
    call put_char             ; one line character
    call put_char             ; one line character
    call put_char             ; one line character
    call put_char             ; one line character
    call put_char             ; one line character
    call put_char             ; one line character
    call put_char             ; one line character
    call put_char             ; one line character
    call put_char             ; one line character
    call put_char             ; one line character
    call put_char             ; one line character
    call put_char             ; one line character
    call put_char             ; one line character
    call put_char             ; one line character
    call put_char             ; one line character
    call put_char             ; one line character
    call put_char             ; one line character
    call put_char             ; one line character
    call put_char             ; one line character
    call put_char             ; one line character
    mov al, 0BFh              ; top-right corner
    call put_char             ; print it
    mov dh, 2                 ; row 2: empty text line
    mov dl, 4                 ; column 4
    call set_cursor           ; move the cursor there
    mov dx, offset dsp_mid    ; address of the empty line
    mov ah, 9                 ; DOS job 9: print text ending with $
    int 21h                   ; print it
    mov dh, 3                 ; row 3: bottom edge
    mov dl, 4                 ; column 4
    call set_cursor           ; move the cursor there
    mov dx, offset dsp_bot    ; address of the bottom edge
    mov ah, 9                 ; DOS job 9: print text ending with $
    int 21h                   ; print it
    mov dh, 2                 ; row 2: the 0, last free spot inside the box
    mov dl, 74                ; column 74
    call set_cursor           ; move the cursor there
    mov al, '0'               ; the character 0
    call put_char             ; print it
    ret                       ; back to main
draw_display endp

draw_keypad proc              ; every button written out by hand
    mov dh, 4                 ; row 4: button SHIFT
    mov dl, 4                 ; column 4
    mov si, offset lbl01      ; address of the text of SHIFT
    call draw_btn6            ; draw the button (inner width 6)
    mov dh, 4                 ; row 4: button ALPHA
    mov dl, 12                ; column 12
    mov si, offset lbl02      ; address of the text of ALPHA
    call draw_btn6            ; draw the button (inner width 6)
    mov dh, 4                 ; row 4: button REPLAY
    mov dl, 20                ; column 20
    mov si, offset lbl03      ; address of the text of REPLAY
    call draw_btn6            ; draw the button (inner width 6)
    mov dh, 4                 ; row 4: button MODE
    mov dl, 28                ; column 28
    mov si, offset lbl04      ; address of the text of MODE
    call draw_btn6            ; draw the button (inner width 6)
    mov dh, 4                 ; row 4: button ON
    mov dl, 36                ; column 36
    mov si, offset lbl05      ; address of the text of ON
    call draw_btn6            ; draw the button (inner width 6)
    mov dh, 4                 ; row 4: button x^-1
    mov dl, 44                ; column 44
    mov si, offset lbl06      ; address of the text of x^-1
    call draw_btn6            ; draw the button (inner width 6)
    mov dh, 4                 ; row 4: button nCr
    mov dl, 52                ; column 52
    mov si, offset lbl07      ; address of the text of nCr
    call draw_btn6            ; draw the button (inner width 6)
    mov dh, 4                 ; row 4: button Pol(
    mov dl, 60                ; column 60
    mov si, offset lbl08      ; address of the text of Pol(
    call draw_btn6            ; draw the button (inner width 6)
    mov dh, 4                 ; row 4: button x^3
    mov dl, 68                ; column 68
    mov si, offset lbl09      ; address of the text of x^3
    call draw_btn6            ; draw the button (inner width 6)
    mov dh, 7                 ; row 7: button a b/c
    mov dl, 4                 ; column 4
    mov si, offset lbl10      ; address of the text of a b/c
    call draw_btn6            ; draw the button (inner width 6)
    mov dh, 7                 ; row 7: button v
    mov dl, 12                ; column 12
    mov si, offset lbl11      ; address of the text of v
    call draw_btn6            ; draw the button (inner width 6)
    mov dh, 7                 ; row 7: button x?
    mov dl, 20                ; column 20
    mov si, offset lbl12      ; address of the text of x?
    call draw_btn6            ; draw the button (inner width 6)
    mov dh, 7                 ; row 7: button ^
    mov dl, 28                ; column 28
    mov si, offset lbl13      ; address of the text of ^
    call draw_btn6            ; draw the button (inner width 6)
    mov dh, 7                 ; row 7: button log
    mov dl, 36                ; column 36
    mov si, offset lbl14      ; address of the text of log
    call draw_btn6            ; draw the button (inner width 6)
    mov dh, 7                 ; row 7: button ln
    mov dl, 44                ; column 44
    mov si, offset lbl15      ; address of the text of ln
    call draw_btn6            ; draw the button (inner width 6)
    mov dh, 7                 ; row 7: button (-)
    mov dl, 52                ; column 52
    mov si, offset lbl16      ; address of the text of (-)
    call draw_btn6            ; draw the button (inner width 6)
    mov dh, 7                 ; row 7: button DMS
    mov dl, 60                ; column 60
    mov si, offset lbl17      ; address of the text of DMS
    call draw_btn6            ; draw the button (inner width 6)
    mov dh, 7                 ; row 7: button hyp
    mov dl, 68                ; column 68
    mov si, offset lbl18      ; address of the text of hyp
    call draw_btn6            ; draw the button (inner width 6)
    mov dh, 10                ; row 10: button sin
    mov dl, 4                 ; column 4
    mov si, offset lbl19      ; address of the text of sin
    call draw_btn6            ; draw the button (inner width 6)
    mov dh, 10                ; row 10: button cos
    mov dl, 12                ; column 12
    mov si, offset lbl20      ; address of the text of cos
    call draw_btn6            ; draw the button (inner width 6)
    mov dh, 10                ; row 10: button tan
    mov dl, 20                ; column 20
    mov si, offset lbl21      ; address of the text of tan
    call draw_btn6            ; draw the button (inner width 6)
    mov dh, 10                ; row 10: button RCL
    mov dl, 28                ; column 28
    mov si, offset lbl22      ; address of the text of RCL
    call draw_btn6            ; draw the button (inner width 6)
    mov dh, 10                ; row 10: button ENG
    mov dl, 36                ; column 36
    mov si, offset lbl23      ; address of the text of ENG
    call draw_btn6            ; draw the button (inner width 6)
    mov dh, 10                ; row 10: button (
    mov dl, 44                ; column 44
    mov si, offset lbl24      ; address of the text of (
    call draw_btn6            ; draw the button (inner width 6)
    mov dh, 10                ; row 10: button )
    mov dl, 52                ; column 52
    mov si, offset lbl25      ; address of the text of )
    call draw_btn6            ; draw the button (inner width 6)
    mov dh, 10                ; row 10: button ,
    mov dl, 60                ; column 60
    mov si, offset lbl26      ; address of the text of ,
    call draw_btn6            ; draw the button (inner width 6)
    mov dh, 10                ; row 10: button M+
    mov dl, 68                ; column 68
    mov si, offset lbl27      ; address of the text of M+
    call draw_btn6            ; draw the button (inner width 6)
    mov dh, 13                ; row 13: button 7
    mov dl, 5                 ; column 5
    mov si, offset lbl28      ; address of the text of 7
    call draw_btn12           ; draw the button (inner width 12)
    mov dh, 13                ; row 13: button 8
    mov dl, 19                ; column 19
    mov si, offset lbl29      ; address of the text of 8
    call draw_btn12           ; draw the button (inner width 12)
    mov dh, 13                ; row 13: button 9
    mov dl, 33                ; column 33
    mov si, offset lbl30      ; address of the text of 9
    call draw_btn12           ; draw the button (inner width 12)
    mov dh, 13                ; row 13: button DEL
    mov dl, 47                ; column 47
    mov si, offset lbl31      ; address of the text of DEL
    call draw_btn12           ; draw the button (inner width 12)
    mov dh, 13                ; row 13: button AC
    mov dl, 61                ; column 61
    mov si, offset lbl32      ; address of the text of AC
    call draw_btn12           ; draw the button (inner width 12)
    mov dh, 16                ; row 16: button 4
    mov dl, 5                 ; column 5
    mov si, offset lbl33      ; address of the text of 4
    call draw_btn12           ; draw the button (inner width 12)
    mov dh, 16                ; row 16: button 5
    mov dl, 19                ; column 19
    mov si, offset lbl34      ; address of the text of 5
    call draw_btn12           ; draw the button (inner width 12)
    mov dh, 16                ; row 16: button 6
    mov dl, 33                ; column 33
    mov si, offset lbl35      ; address of the text of 6
    call draw_btn12           ; draw the button (inner width 12)
    mov dh, 16                ; row 16: button *
    mov dl, 47                ; column 47
    mov si, offset lbl36      ; address of the text of *
    call draw_btn12           ; draw the button (inner width 12)
    mov dh, 16                ; row 16: button ?
    mov dl, 61                ; column 61
    mov si, offset lbl37      ; address of the text of ?
    call draw_btn12           ; draw the button (inner width 12)
    mov dh, 19                ; row 19: button 1
    mov dl, 5                 ; column 5
    mov si, offset lbl38      ; address of the text of 1
    call draw_btn12           ; draw the button (inner width 12)
    mov dh, 19                ; row 19: button 2
    mov dl, 19                ; column 19
    mov si, offset lbl39      ; address of the text of 2
    call draw_btn12           ; draw the button (inner width 12)
    mov dh, 19                ; row 19: button 3
    mov dl, 33                ; column 33
    mov si, offset lbl40      ; address of the text of 3
    call draw_btn12           ; draw the button (inner width 12)
    mov dh, 19                ; row 19: button +
    mov dl, 47                ; column 47
    mov si, offset lbl41      ; address of the text of +
    call draw_btn12           ; draw the button (inner width 12)
    mov dh, 19                ; row 19: button -
    mov dl, 61                ; column 61
    mov si, offset lbl42      ; address of the text of -
    call draw_btn12           ; draw the button (inner width 12)
    mov dh, 22                ; row 22: button 0
    mov dl, 5                 ; column 5
    mov si, offset lbl43      ; address of the text of 0
    call draw_btn12           ; draw the button (inner width 12)
    mov dh, 22                ; row 22: button .
    mov dl, 19                ; column 19
    mov si, offset lbl44      ; address of the text of .
    call draw_btn12           ; draw the button (inner width 12)
    mov dh, 22                ; row 22: button EXP
    mov dl, 33                ; column 33
    mov si, offset lbl45      ; address of the text of EXP
    call draw_btn12           ; draw the button (inner width 12)
    mov dh, 22                ; row 22: button Ans
    mov dl, 47                ; column 47
    mov si, offset lbl46      ; address of the text of Ans
    call draw_btn12           ; draw the button (inner width 12)
    mov dh, 22                ; row 22: button =
    mov dl, 61                ; column 61
    mov si, offset lbl47      ; address of the text of =
    call draw_btn12           ; draw the button (inner width 12)
    ret                       ; back to main
draw_keypad endp

draw_btn6 proc              ; DH=row, DL=column of the top-left corner, SI=text address
    mov [b_row], dh           ; remember the row
    mov [b_col], dl           ; remember the column
    call set_cursor           ; go to the top-left corner
    mov al, 0DAh              ; top-left corner
    call put_char             ; print it
    call hline6              ; top line
    mov al, 0BFh              ; top-right corner
    call put_char             ; print it
    mov dh, [b_row]           ; row of the box again
    inc dh                    ; one row down (middle row)
    mov dl, [b_col]           ; column of the box again
    call set_cursor           ; go to the left wall
    mov al, 0B3h              ; left wall
    call put_char             ; print it
    call space6              ; blank inside
    mov al, 0B3h              ; right wall
    call put_char             ; print it
    mov dh, [b_row]           ; row of the box again
    add dh, 2                 ; two rows down (bottom row)
    mov dl, [b_col]           ; column of the box again
    call set_cursor           ; go to the bottom-left corner
    mov al, 0C0h              ; bottom-left corner
    call put_char             ; print it
    call hline6              ; bottom line
    mov al, 0D9h              ; bottom-right corner
    call put_char             ; print it
    mov dh, [b_row]           ; row of the box again
    inc dh                    ; middle row
    mov dl, [b_col]           ; column of the box again
    inc dl                    ; one column right of the left wall
    call set_cursor           ; go there
    mov dx, si                ; DX = address of the button text
    mov ah, 9                 ; DOS job 9: print text
    int 21h                   ; print it (already padded to the inner width)
    ret                       ; back to draw_keypad
draw_btn6 endp

draw_btn12 proc              ; DH=row, DL=column of the top-left corner, SI=text address
    mov [b_row], dh           ; remember the row
    mov [b_col], dl           ; remember the column
    call set_cursor           ; go to the top-left corner
    mov al, 0DAh              ; top-left corner
    call put_char             ; print it
    call hline12              ; top line
    mov al, 0BFh              ; top-right corner
    call put_char             ; print it
    mov dh, [b_row]           ; row of the box again
    inc dh                    ; one row down (middle row)
    mov dl, [b_col]           ; column of the box again
    call set_cursor           ; go to the left wall
    mov al, 0B3h              ; left wall
    call put_char             ; print it
    call space12              ; blank inside
    mov al, 0B3h              ; right wall
    call put_char             ; print it
    mov dh, [b_row]           ; row of the box again
    add dh, 2                 ; two rows down (bottom row)
    mov dl, [b_col]           ; column of the box again
    call set_cursor           ; go to the bottom-left corner
    mov al, 0C0h              ; bottom-left corner
    call put_char             ; print it
    call hline12              ; bottom line
    mov al, 0D9h              ; bottom-right corner
    call put_char             ; print it
    mov dh, [b_row]           ; row of the box again
    inc dh                    ; middle row
    mov dl, [b_col]           ; column of the box again
    inc dl                    ; one column right of the left wall
    call set_cursor           ; go there
    mov dx, si                ; DX = address of the button text
    mov ah, 9                 ; DOS job 9: print text
    int 21h                   ; print it (already padded to the inner width)
    ret                       ; back to draw_keypad
draw_btn12 endp

hline6 proc                 ; prints 6 horizontal-line characters
    mov al, 0C4h              ; the line character
    call put_char             ; one character
    call put_char             ; one character
    call put_char             ; one character
    call put_char             ; one character
    call put_char             ; one character
    call put_char             ; one character
    ret                       ; back
hline6 endp
space6 proc                 ; prints 6 blanks
    mov al, ' '               ; a blank
    call put_char             ; one blank
    call put_char             ; one blank
    call put_char             ; one blank
    call put_char             ; one blank
    call put_char             ; one blank
    call put_char             ; one blank
    ret                       ; back
space6 endp

hline12 proc                 ; prints 12 horizontal-line characters
    mov al, 0C4h              ; the line character
    call put_char             ; one character
    call put_char             ; one character
    call put_char             ; one character
    call put_char             ; one character
    call put_char             ; one character
    call put_char             ; one character
    call put_char             ; one character
    call put_char             ; one character
    call put_char             ; one character
    call put_char             ; one character
    call put_char             ; one character
    call put_char             ; one character
    ret                       ; back
hline12 endp
space12 proc                 ; prints 12 blanks
    mov al, ' '               ; a blank
    call put_char             ; one blank
    call put_char             ; one blank
    call put_char             ; one blank
    call put_char             ; one blank
    call put_char             ; one blank
    call put_char             ; one blank
    call put_char             ; one blank
    call put_char             ; one blank
    call put_char             ; one blank
    call put_char             ; one blank
    call put_char             ; one blank
    call put_char             ; one blank
    ret                       ; back
space12 endp

set_cursor proc               ; DH = row, DL = column
    mov ah, 2                 ; BIOS job 2: move the cursor
    mov bh, 0                 ; screen page 0
    int 10h                   ; do it
    ret                       ; back
set_cursor endp
put_char proc                 ; AL = character to print
    mov ah, 0Eh               ; BIOS job 0Eh: print one character
    mov bh, 0                 ; screen page 0
    int 10h                   ; print it, cursor moves right
    ret                       ; back
put_char endp

;---------------- new procedures---------------------------------------
add_digit proc                ; AL = the digit character
    cmp byte ptr [fresh], 0   ; is the display showing an old number?
    je ad_go                  ; no: carry on typing
    mov byte ptr [fresh], 0   ; yes: start a new number
    mov byte ptr [len], 0     ; no digits
    mov byte ptr [buf], '$'   ; empty text
    mov word ptr [cur], 0     ; number = 0
ad_go:
    mov bl, [len]             ; BL = digits typed so far
    cmp bl, 1                 ; exactly one digit?
    jne ad_check              ; no: skip the zero fix
    cmp byte ptr [buf], '0'   ; is that digit a 0?
    jne ad_check              ; no: skip the zero fix
    mov bl, 0                 ; yes: the new digit replaces the 0
ad_check:
    cmp bl, 4                 ; room for only 4 digits for now
    jae ad_done               ; full: ignore this key
    mov bh, 0                 ; BX = BL, to use as a position
    mov [buf+bx], al          ; store the digit character
    inc bx                    ; one more digit
    mov byte ptr [buf+bx], '$'; keep the text ending with $
    mov [len], bl             ; save the new length
    sub al, '0'               ; character -> number (for example '7' -> 7)
    mov ah, 0                 ; AX = the digit as a number
    mov cx, ax                ; keep it in CX
    mov ax, [cur]             ; AX = the number so far
    mov dx, 10                ; DX = 10
    mul dx                    ; AX = AX * 10
    add ax, cx                ; add the new digit
    mov [cur], ax             ; save the bigger number
    call show_entry           ; redraw the display
ad_done:
    ret                       ; back
add_digit endp
del_digit proc                ; removes the last typed digit   
    cmp byte ptr [fresh], 0   ; is the display showing a finished value?
    jne dd_done               ; then there is nothing typed to delete
    mov bl, [len]             ; BL = digits typed
    cmp bl, 0                 ; nothing typed?
    je dd_done                ; then nothing to delete
    dec bl                    ; one digit fewer
    mov bh, 0                 ; BX = BL
    mov byte ptr [buf+bx], '$'; the text now ends here
    mov [len], bl             ; save the new length
    mov ax, [cur]             ; AX = the number
    mov dx, 0                 ; clear DX (it takes part in the division)
    mov cx, 10                ; CX = 10
    div cx                    ; AX = AX / 10 (drops the last digit)
    mov [cur], ax             ; save it
    call show_entry           ; redraw the display
dd_done:
    ret                       ; back
del_digit endp

clear_entry proc              ; AC: wipes everything
    mov byte ptr [buf], '$'   ; the text ends at the very start
    mov byte ptr [len], 0     ; no digits
    mov word ptr [cur], 0     ; typed number = 0
    mov word ptr [first], 0   ; first number = 0
    mov byte ptr [op], 0      ; no operator waiting
    mov byte ptr [fresh], 0   ; nothing old on the display
    call show_entry           ; redraw: shows a plain 0
    ret                       ; back
clear_entry endp
;-----------------------new procedures-----------
press_operator proc           ; AL = the operator key: + - * /
    cmp byte ptr [fresh], 1   ; was the last key an operator or an answer?
    je po_save                ; yes: no second number typed, skip calculating
    cmp byte ptr [op], 0      ; is an operator waiting?
    je po_save                ; no: nothing to calculate yet
    push ax                   ; keep AL, the new operator, safe
    call calculate            ; cur = first (op) cur, and show it
    pop ax                    ; get the new operator back (pop keeps the flags)
    jc po_end                 ; carry set = there was an error, stop here
po_save:
    mov bx, [cur]             ; BX = the current number
    mov [first], bx           ; it becomes the first number
    mov [op], al              ; remember the new operator
    mov byte ptr [fresh], 1   ; the next digit starts a new number
po_end:
    ret                       ; back
press_operator endp

press_equals proc             ; the = key
    cmp byte ptr [fresh], 1   ; nothing new typed?
    je pe_done                ; then nothing to calculate
    cmp byte ptr [op], 0      ; no operator waiting?
    je pe_done                ; then nothing to calculate
    call calculate            ; calculate and show the answer
pe_done:
    ret                       ; back
press_equals endp

calculate proc                ; cur = first (op) cur. Carry flag = error
    call do_more              ; try ^ e k p first: DL = 0 other, 1 = answer in AX, 2 = error
    cmp dl, 0                 ; was it a different operator?
    je ca_basic               ; yes: carry on with + - * /
    cmp dl, 2                 ; was there an error?
    jne ca_to_ok              ; no: AX holds the answer
    jmp ca_error              ; yes: show the E
ca_to_ok:
    jmp ca_ok                 ; show the answer
ca_basic:
    mov ax, [first]           ; AX = first number
    cmp byte ptr [op], '+'    ; plus?
    jne ca_not_add            ; no: try the next one
    add ax, [cur]             ; add
    jo ca_error               ; overflow: result too big
    jmp ca_ok                 ; done
ca_not_add:
    cmp byte ptr [op], '-'    ; minus?
    jne ca_not_sub            ; no: try the next one
    sub ax, [cur]             ; subtract
    jo ca_error               ; overflow: result too big
    jmp ca_ok                 ; done
ca_not_sub:
    cmp byte ptr [op], '*'    ; times?
    jne ca_not_mul            ; no: try the next one
    imul word ptr [cur]       ; DX:AX = AX * cur (signed)
    jo ca_error               ; overflow: result does not fit in AX
    jmp ca_ok                 ; done
ca_not_mul:
    cmp byte ptr [op], '/'    ; divide?
    jne ca_error              ; unknown operator (should not happen)
    cmp word ptr [cur], 0     ; dividing by zero?
    je ca_error               ; yes: error
    cwd                       ; stretch AX into DX:AX (needed before dividing)
    idiv word ptr [cur]       ; AX = DX:AX / cur (signed), DX = remainder
ca_ok:
    mov [ans], ax             ; remember this answer for the Ans button
    mov [cur], ax             ; the answer becomes the current number
    call number_to_text       ; turn it into text in buf
    call show_entry           ; draw it
    mov byte ptr [op], 0      ; no operator waiting any more
    mov byte ptr [fresh], 2   ; the display shows a finished value
    clc                       ; carry = 0: no error
    ret                       ; back
ca_error:
    mov byte ptr [buf], 'E'   ; the text is E ...
    mov byte ptr [buf+1], '$' ; ... followed by $
    mov byte ptr [len], 1     ; one character
    mov word ptr [cur], 0     ; number = 0
    mov byte ptr [op], 0      ; no operator waiting
    mov byte ptr [fresh], 1   ; the next digit starts a new number
    call show_entry           ; draw the E
    stc                       ; carry = 1: there was an error
    ret                       ; back
calculate endp

do_power proc                 ; AX = first ^ cur. Carry flag = error
    cmp word ptr [cur], 0     ; negative exponent?
    jl dp_error               ; yes: whole numbers cannot do that
    mov cx, [cur]             ; CX = how many times to multiply
    mov ax, 1                 ; AX = the result so far
dp_loop:
    cmp cx, 0                 ; any multiplications left?
    je dp_done                ; no: AX holds the result
    imul word ptr [first]     ; AX = AX * first (signed)
    jo dp_error               ; overflow: result too big
    dec cx                    ; one multiplication fewer
    jmp dp_loop               ; repeat
dp_done:
    clc                       ; carry = 0: no error
    ret                       ; back
dp_error:
    stc                       ; carry = 1: there was an error
    ret                       ; back
do_power endp

number_to_text proc           ; AX = signed number -> text in buf, length in len
    mov di, 0                 ; DI = 1 if the number is negative
    cmp ax, 0                 ; below zero?
    jge nt_pos                ; no: leave it alone
    neg ax                    ; make it positive
    mov di, 1                 ; remember it was negative
nt_pos:
    mov cx, 0                 ; CX counts the digits
    mov bx, 10                ; BX = divisor
nt_split:
    mov dx, 0                 ; clear DX before dividing
    div bx                    ; AX = AX / 10, DX = last digit
    push dx                   ; put that digit on the stack
    inc cx                    ; one more digit
    cmp ax, 0                 ; anything left to split?
    jne nt_split              ; yes: repeat
    mov ax, cx                ; AX = number of digits
    add ax, di                ; plus 1 if there is a minus sign
    mov [len], al             ; save the total length
    mov si, 0                 ; SI = position in buf
    cmp di, 0                 ; negative?
    je nt_store               ; no: go straight to the digits
    mov byte ptr [buf], '-'   ; first character is the minus sign
    inc si                    ; digits start at position 1
nt_store:
    pop dx                    ; take a digit off the stack
    add dl, '0'               ; number -> character
    mov [buf+si], dl          ; store it
    inc si                    ; next position
    dec cx                    ; one digit fewer to place
    jne nt_store              ; more left: repeat
    mov byte ptr [buf+si], '$'; end the text
    ret                       ; back
number_to_text endp

show_value proc               ; AX = a number: make it the current value and show it
    mov [cur], ax             ; it becomes the current number
    call number_to_text       ; turn it into text in buf
    call show_entry           ; draw it
    mov byte ptr [fresh], 2   ; the display shows a finished value
    ret                       ; back
show_value endp

show_error proc               ; shows E and resets
    mov byte ptr [buf], 'E'   ; the text is E ...
    mov byte ptr [buf+1], '$' ; ... followed by $
    mov byte ptr [len], 1     ; one character
    mov word ptr [cur], 0     ; number = 0
    mov byte ptr [op], 0      ; no operator waiting
    mov byte ptr [fresh], 1   ; the next digit starts a new number
    call show_entry           ; draw the E
    ret                       ; back
show_error endp

press_negate proc             ; the (-) button
    mov ax, [cur]             ; AX = the current number
    neg ax                    ; flip its sign
    call show_value           ; show it
    ret                       ; back
press_negate endp

press_square proc             ; the x squared button
    mov ax, [cur]             ; AX = the current number
    imul ax                   ; AX = AX * AX (signed)
    jo psq_error              ; overflow: too big
    call show_value           ; show it
    ret                       ; back
psq_error:
    call show_error           ; show E
    ret                       ; back
press_square endp

press_cube proc               ; the x cubed button
    mov ax, [cur]             ; AX = the current number
    imul ax                   ; AX = number squared
    jo pcu_error              ; overflow: too big
    imul word ptr [cur]       ; AX = number squared * number
    jo pcu_error              ; overflow: too big
    call show_value           ; show it
    ret                       ; back
pcu_error:
    call show_error           ; show E
    ret                       ; back
press_cube endp

press_ans proc                ; the Ans button
    mov ax, [ans]             ; AX = the last answer
    call show_value           ; show it
    ret                       ; back
press_ans endp

press_mplus proc              ; the M+ button
    mov ax, [cur]             ; AX = the current number
    add [mem], ax             ; add it to the memory
    mov byte ptr [fresh], 2   ; the next digit starts a new number
    call show_memflag         ; show or hide the M on the top row
    ret                       ; back
press_mplus endp

press_rcl proc                ; the RCL button
    mov ax, [mem]             ; AX = the memory
    call show_value           ; show it
    ret                       ; back
press_rcl endp

press_sqrt proc               ; the square root button
    mov ax, [cur]             ; AX = the current number
    cmp ax, 0                 ; below zero?
    jl psr_error              ; yes: no square root of a negative number
    mov bx, 0                 ; BX = the root found so far
psr_loop:
    mov ax, bx                ; AX = BX
    inc ax                    ; AX = BX + 1
    mul ax                    ; DX:AX = (BX + 1) * (BX + 1)
    cmp ax, [cur]             ; is that bigger than the number?
    ja psr_done               ; yes: BX is the answer
    inc bx                    ; no: try the next root
    jmp psr_loop              ; repeat
psr_done:
    mov ax, bx                ; AX = the root
    call show_value           ; show it
    ret                       ; back
psr_error:
    call show_error           ; show E
    ret                       ; back
press_sqrt endp
do_more proc                  ; works out ^ e k p. DL: 0 = other operator, 1 = AX holds the answer, 2 = error
    cmp byte ptr [op], '^'    ; power?
    jne dm_not_pow            ; no: try the next one
    call do_power             ; AX = first ^ cur
    jc dm_error               ; carry set: error
    jmp dm_ok                 ; done
dm_not_pow:
    cmp byte ptr [op], 'e'    ; EXP?
    jne dm_not_exp            ; no: try the next one
    call do_exp               ; AX = first * 10 ^ cur
    jc dm_error               ; carry set: error
    jmp dm_ok                 ; done
dm_not_exp:
    cmp byte ptr [op], 'k'    ; nCr?
    jne dm_not_ncr            ; no: try the next one
    call do_ncr               ; AX = first nCr cur
    jc dm_error               ; carry set: error
    jmp dm_ok                 ; done
dm_not_ncr:
    cmp byte ptr [op], 'p'    ; nPr?
    jne dm_other              ; no: it is not one of ours
    call do_npr               ; AX = first nPr cur
    jc dm_error               ; carry set: error
    jmp dm_ok                 ; done
dm_other:
    mov dl, 0                 ; not one of ^ e k p
    ret                       ; back
dm_ok:
    mov dl, 1                 ; AX holds the answer
    ret                       ; back
dm_error:
    mov dl, 2                 ; there was an error
    ret                       ; back
do_more endp

do_exp proc                   ; AX = first * 10 ^ cur. Carry flag = error
    cmp word ptr [cur], 0     ; negative exponent?
    jl de_error               ; yes: whole numbers cannot do that
    mov cx, [cur]             ; CX = how many times to multiply by 10
    mov ax, [first]           ; AX = the result so far
de_loop:
    cmp cx, 0                 ; any multiplications left?
    je de_done                ; no: AX holds the result
    mov bx, 10                ; BX = 10
    imul bx                   ; DX:AX = AX * 10 (signed)
    jo de_error               ; overflow: result too big
    dec cx                    ; one multiplication fewer
    jmp de_loop               ; repeat
de_done:
    clc                       ; carry = 0: no error
    ret                       ; back
de_error:
    stc                       ; carry = 1: there was an error
    ret                       ; back
do_exp endp

do_ncr proc                   ; AX = first nCr cur (n choose r). Carry flag = error
    mov ax, [first]           ; AX = n
    cmp ax, 0                 ; n below zero?
    jl dc_error               ; yes: error
    mov bx, [cur]             ; BX = r
    cmp bx, 0                 ; r below zero?
    jl dc_error               ; yes: error
    cmp bx, ax                ; r bigger than n?
    jg dc_error               ; yes: error
    sub ax, bx                ; AX = n - r
    mov si, ax                ; SI = n - r
    mov cx, 1                 ; CX = i, the step we are on
    mov ax, 1                 ; AX = the result so far
dc_loop:
    cmp cx, bx                ; is i past r?
    ja dc_done                ; yes: AX holds the result
    mov di, si                ; DI = n - r
    add di, cx                ; DI = n - r + i
    mul di                    ; DX:AX = result * (n - r + i)
    cmp dx, cx                ; would the division overflow?
    jae dc_error              ; yes: the answer is too big
    div cx                    ; AX = DX:AX / i
    cmp ax, 7FFFh             ; too big for a signed number?
    ja dc_error               ; yes: error
    inc cx                    ; next step
    jmp dc_loop               ; repeat
dc_done:
    clc                       ; carry = 0: no error
    ret                       ; back
dc_error:
    stc                       ; carry = 1: there was an error
    ret                       ; back
do_ncr endp

do_npr proc                   ; AX = first nPr cur. Carry flag = error
    mov ax, [first]           ; AX = n
    cmp ax, 0                 ; n below zero?
    jl dn_error               ; yes: error
    mov bx, [cur]             ; BX = r
    cmp bx, 0                 ; r below zero?
    jl dn_error               ; yes: error
    cmp bx, ax                ; r bigger than n?
    jg dn_error               ; yes: error
    mov cx, [cur]             ; CX = how many factors to multiply
    mov si, [first]           ; SI = the factor we are on (starts at n)
    mov ax, 1                 ; AX = the result so far
dn_loop:
    cmp cx, 0                 ; any factors left?
    je dn_done                ; no: AX holds the result
    imul si                   ; DX:AX = AX * SI (signed)
    jo dn_error               ; overflow: result too big
    dec si                    ; next factor is one smaller
    dec cx                    ; one factor fewer
    jmp dn_loop               ; repeat
dn_done:
    clc                       ; carry = 0: no error
    ret                       ; back
dn_error:
    stc                       ; carry = 1: there was an error
    ret                       ; back
do_npr endp

press_fact proc               ; the ! key (factorial of the current number)
    mov cx, [cur]             ; CX = the number
    cmp cx, 0                 ; below zero?
    jl pf_error               ; yes: error
    mov ax, 1                 ; AX = the result so far
    mov bx, 2                 ; BX = the next factor
pf_loop:
    cmp bx, cx                ; is the factor past the number?
    ja pf_done                ; yes: AX holds the result
    imul bx                   ; DX:AX = AX * BX (signed)
    jo pf_error               ; overflow: result too big
    inc bx                    ; next factor
    jmp pf_loop               ; repeat
pf_done:
    call show_value           ; show it
    ret                       ; back
pf_error:
    call show_error           ; show E
    ret                       ; back
press_fact endp

press_mminus proc             ; the capital M key: subtract from the memory
    mov ax, [cur]             ; AX = the current number
    sub [mem], ax             ; subtract it from the memory
    mov byte ptr [fresh], 2   ; the next digit starts a new number
    call show_memflag         ; show or hide the M on the top row
    ret                       ; back
press_mminus endp

show_memflag proc             ; shows an M on the top row while the memory is not zero
    mov dh, 0                 ; row 0
    mov dl, 40                ; column 40
    call set_cursor           ; go there
    mov al, ' '               ; a blank ...
    cmp word ptr [mem], 0     ; is the memory empty?
    je sm_draw                ; yes: print the blank
    mov al, 'M'               ; no: print an M instead
sm_draw:
    call put_char             ; print it
    ret                       ; back
show_memflag endp

init_mouse proc               ; looks for a mouse driver
    mov ax, 0                 ; mouse job 0: reset and look for a mouse
    int 33h                   ; AX = 0FFFFh when a mouse is installed
    cmp ax, 0FFFFh            ; did we find one?
    jne im_done               ; no: the keyboard still works
    mov byte ptr [mouse_ok], 1; remember that the mouse works
    mov ax, 1                 ; mouse job 1: show the pointer
    int 33h                   ; do it
im_done:
    ret                       ; back
init_mouse endp

delay proc                    ; short flash pause: one clock tick, about 55 ms
    mov ah, 0                 ; clock job 0: read the tick counter
    int 1Ah                   ; DX = current clock tick
    mov bx, dx                ; save the starting tick
dl_wait:
    mov ah, 0                 ; read the clock again
    int 1Ah                   ; DX = current clock tick
    cmp dx, bx                ; has the tick changed?
    je dl_wait                ; no: keep waiting for one tick
    ret                       ; back
delay endp

paint_button proc             ; FAST: changes only the color bytes in video memory
    push ax                   ; preserve registers used by this procedure
    push bx                   ; preserve BX
    push cx                   ; preserve CX
    push dx                   ; preserve DX
    push si                   ; preserve SI
    push di                   ; preserve DI
    push es                   ; preserve the extra segment register
    mov ax, 0B800h             ; color text screen memory starts at B800h
    mov es, ax                 ; ES now points to the screen
    xor ax, ax                ; clear AX before loading the row number
    mov al, [fb_row]          ; AL = first row of the button
    mov bx, 160               ; each screen row uses 160 bytes (80 x 2)
    mul bx                    ; AX = row number multiplied by 160
    mov di, ax                ; DI = byte position of the first row
    xor ax, ax                ; clear AX before loading the column
    mov al, [fb_col]          ; AL = first column of the button
    shl ax, 1                 ; each character cell uses 2 bytes
    add di, ax                ; DI = exact video-memory position
    mov si, 0                 ; SI counts the three button rows
pb_row:
    mov al, [fb_attr]         ; AL = color attribute to apply
    xor cx, cx                ; clear CX before loading the width
    mov cl, [fb_w]            ; CX = total button width
pb_col:
    mov byte ptr es:[di+1], al; change only the color byte, keep the letter
    add di, 2                 ; move to the next character cell
    loop pb_col               ; repeat until this row is colored
    mov bx, 160               ; each screen row is 160 bytes
    xor ax, ax                ; clear AX before loading the width
    mov al, [fb_w]            ; AL = number of columns already painted
    shl ax, 1                 ; convert columns to bytes
    sub bx, ax                ; remaining bytes to the same column next row
    add di, bx                ; move DI to the button's next row
    inc si                    ; one button row is finished
    cmp si, 3                 ; have all three rows been painted?
    jb pb_row                 ; no: paint the next row
    pop es                    ; restore ES
    pop di                    ; restore DI
    pop si                    ; restore SI
    pop dx                    ; restore DX
    pop cx                    ; restore CX
    pop bx                    ; restore BX
    pop ax                    ; restore AX
    ret                       ; back
paint_button endp

do_flash proc                 ; DH = row, DL = column of the button corner, CL = inner width
    mov [fb_row], dh          ; remember the row
    mov [fb_col], dl          ; remember the column
    add cl, 2                 ; CL = whole width of the box
    mov [fb_w], cl            ; remember the width
    cmp byte ptr [mouse_ok], 1; is there a mouse pointer on the screen?
    jne df_nohide             ; no: nothing to hide
    mov ax, 2                 ; mouse job 2: hide the pointer
    int 33h                   ; do it
df_nohide:
    mov byte ptr [fb_attr], 70h; inverse colors
    call paint_button         ; paint the button in the new colors
    call delay                ; wait a moment
    mov byte ptr [fb_attr], 07h; normal colors
    call paint_button         ; paint it back
    cmp byte ptr [mouse_ok], 1; is there a mouse pointer?
    jne df_done               ; no: finished
    mov ax, 1                 ; mouse job 1: show the pointer again
    int 33h                   ; do it
df_done:
    ret                       ; back
do_flash endp

check_mouse proc              ; AL = key code of the clicked button, 0 = nothing
    cmp byte ptr [mouse_ok], 1; is there a mouse?
    je cm_read                ; yes: read it
    mov al, 0                 ; no mouse: nothing was clicked
    ret                       ; back
cm_read:
    mov ax, 3                 ; mouse job 3: read position and buttons
    int 33h                   ; BX = buttons, CX = x, DX = y
    test bx, 1                ; is the left button down?
    jnz cm_down               ; yes
    mov byte ptr [mouse_down], 0; no: remember that the button is up
    mov al, 0                 ; nothing was clicked
    ret                       ; back
cm_down:
    cmp byte ptr [mouse_down], 0; was it already down?
    je cm_new                 ; no: this is a new click
    mov al, 0                 ; it is only being held: nothing new
    ret                       ; back
cm_new:
    mov byte ptr [mouse_down], 1; remember that the button is down
    mov bx, cx                ; BX = x in pixels
    mov cl, 3                 ; shift by 3 = divide by 8
    shr bx, cl                ; BX = column
    shr dx, cl                ; DX = row
    mov dh, dl                ; DH = row of the click
    mov dl, bl                ; DL = column of the click
    cmp dh, 4                 ; button SHIFT: is the click above its top row?
    jb hn01                   ; yes: not this button
    cmp dh, 6                 ; button SHIFT: is the click below its bottom row?
    ja hn01                   ; yes: not this button
    cmp dl, 4                 ; button SHIFT: is the click left of it?
    jb hn01                   ; yes: not this button
    cmp dl, 11                ; button SHIFT: is the click right of it?
    ja hn01                   ; yes: not this button
    mov al, 0                 ; button SHIFT: the key code it stands for (0 = none yet)
    mov dh, 4                 ; button SHIFT: its top row
    mov dl, 4                 ; button SHIFT: its left column
    mov cl, 6                 ; button SHIFT: its inner width
    jmp mouse_hit             ; light it up and report the key
hn01:
    cmp dh, 4                 ; button ALPHA: is the click above its top row?
    jb hn02                   ; yes: not this button
    cmp dh, 6                 ; button ALPHA: is the click below its bottom row?
    ja hn02                   ; yes: not this button
    cmp dl, 12                ; button ALPHA: is the click left of it?
    jb hn02                   ; yes: not this button
    cmp dl, 19                ; button ALPHA: is the click right of it?
    ja hn02                   ; yes: not this button
    mov al, 0                 ; button ALPHA: the key code it stands for (0 = none yet)
    mov dh, 4                 ; button ALPHA: its top row
    mov dl, 12                ; button ALPHA: its left column
    mov cl, 6                 ; button ALPHA: its inner width
    jmp mouse_hit             ; light it up and report the key
hn02:
    cmp dh, 4                 ; button REPLAY: is the click above its top row?
    jb hn03                   ; yes: not this button
    cmp dh, 6                 ; button REPLAY: is the click below its bottom row?
    ja hn03                   ; yes: not this button
    cmp dl, 20                ; button REPLAY: is the click left of it?
    jb hn03                   ; yes: not this button
    cmp dl, 27                ; button REPLAY: is the click right of it?
    ja hn03                   ; yes: not this button
    mov al, 0                 ; button REPLAY: the key code it stands for (0 = none yet)
    mov dh, 4                 ; button REPLAY: its top row
    mov dl, 20                ; button REPLAY: its left column
    mov cl, 6                 ; button REPLAY: its inner width
    jmp mouse_hit             ; light it up and report the key
hn03:
    cmp dh, 4                 ; button MODE: is the click above its top row?
    jb hn04                   ; yes: not this button
    cmp dh, 6                 ; button MODE: is the click below its bottom row?
    ja hn04                   ; yes: not this button
    cmp dl, 28                ; button MODE: is the click left of it?
    jb hn04                   ; yes: not this button
    cmp dl, 35                ; button MODE: is the click right of it?
    ja hn04                   ; yes: not this button
    mov al, 0                 ; button MODE: the key code it stands for (0 = none yet)
    mov dh, 4                 ; button MODE: its top row
    mov dl, 28                ; button MODE: its left column
    mov cl, 6                 ; button MODE: its inner width
    jmp mouse_hit             ; light it up and report the key
hn04:
    cmp dh, 4                 ; button ON: is the click above its top row?
    jb hn05                   ; yes: not this button
    cmp dh, 6                 ; button ON: is the click below its bottom row?
    ja hn05                   ; yes: not this button
    cmp dl, 36                ; button ON: is the click left of it?
    jb hn05                   ; yes: not this button
    cmp dl, 43                ; button ON: is the click right of it?
    ja hn05                   ; yes: not this button
    mov al, 0                 ; button ON: the key code it stands for (0 = none yet)
    mov dh, 4                 ; button ON: its top row
    mov dl, 36                ; button ON: its left column
    mov cl, 6                 ; button ON: its inner width
    jmp mouse_hit             ; light it up and report the key
hn05:
    cmp dh, 4                 ; button x^-1: is the click above its top row?
    jb hn06                   ; yes: not this button
    cmp dh, 6                 ; button x^-1: is the click below its bottom row?
    ja hn06                   ; yes: not this button
    cmp dl, 44                ; button x^-1: is the click left of it?
    jb hn06                   ; yes: not this button
    cmp dl, 51                ; button x^-1: is the click right of it?
    ja hn06                   ; yes: not this button
    mov al, 0                 ; button x^-1: the key code it stands for (0 = none yet)
    mov dh, 4                 ; button x^-1: its top row
    mov dl, 44                ; button x^-1: its left column
    mov cl, 6                 ; button x^-1: its inner width
    jmp mouse_hit             ; light it up and report the key
hn06:
    cmp dh, 4                 ; button nCr: is the click above its top row?
    jb hn07                   ; yes: not this button
    cmp dh, 6                 ; button nCr: is the click below its bottom row?
    ja hn07                   ; yes: not this button
    cmp dl, 52                ; button nCr: is the click left of it?
    jb hn07                   ; yes: not this button
    cmp dl, 59                ; button nCr: is the click right of it?
    ja hn07                   ; yes: not this button
    mov al, 'k'               ; button nCr: the key code it stands for (0 = none yet)
    mov dh, 4                 ; button nCr: its top row
    mov dl, 52                ; button nCr: its left column
    mov cl, 6                 ; button nCr: its inner width
    jmp mouse_hit             ; light it up and report the key
hn07:
    cmp dh, 4                 ; button Pol(: is the click above its top row?
    jb hn08                   ; yes: not this button
    cmp dh, 6                 ; button Pol(: is the click below its bottom row?
    ja hn08                   ; yes: not this button
    cmp dl, 60                ; button Pol(: is the click left of it?
    jb hn08                   ; yes: not this button
    cmp dl, 67                ; button Pol(: is the click right of it?
    ja hn08                   ; yes: not this button
    mov al, 0                 ; button Pol(: the key code it stands for (0 = none yet)
    mov dh, 4                 ; button Pol(: its top row
    mov dl, 60                ; button Pol(: its left column
    mov cl, 6                 ; button Pol(: its inner width
    jmp mouse_hit             ; light it up and report the key
hn08:
    cmp dh, 4                 ; button x^3: is the click above its top row?
    jb hn09                   ; yes: not this button
    cmp dh, 6                 ; button x^3: is the click below its bottom row?
    ja hn09                   ; yes: not this button
    cmp dl, 68                ; button x^3: is the click left of it?
    jb hn09                   ; yes: not this button
    cmp dl, 75                ; button x^3: is the click right of it?
    ja hn09                   ; yes: not this button
    mov al, 'x'               ; button x^3: the key code it stands for (0 = none yet)
    mov dh, 4                 ; button x^3: its top row
    mov dl, 68                ; button x^3: its left column
    mov cl, 6                 ; button x^3: its inner width
    jmp mouse_hit             ; light it up and report the key
hn09:
    cmp dh, 7                 ; button a b/c: is the click above its top row?
    jb hn10                   ; yes: not this button
    cmp dh, 9                 ; button a b/c: is the click below its bottom row?
    ja hn10                   ; yes: not this button
    cmp dl, 4                 ; button a b/c: is the click left of it?
    jb hn10                   ; yes: not this button
    cmp dl, 11                ; button a b/c: is the click right of it?
    ja hn10                   ; yes: not this button
    mov al, 0                 ; button a b/c: the key code it stands for (0 = none yet)
    mov dh, 7                 ; button a b/c: its top row
    mov dl, 4                 ; button a b/c: its left column
    mov cl, 6                 ; button a b/c: its inner width
    jmp mouse_hit             ; light it up and report the key
hn10:
    cmp dh, 7                 ; button v: is the click above its top row?
    jb hn11                   ; yes: not this button
    cmp dh, 9                 ; button v: is the click below its bottom row?
    ja hn11                   ; yes: not this button
    cmp dl, 12                ; button v: is the click left of it?
    jb hn11                   ; yes: not this button
    cmp dl, 19                ; button v: is the click right of it?
    ja hn11                   ; yes: not this button
    mov al, 'q'               ; button v: the key code it stands for (0 = none yet)
    mov dh, 7                 ; button v: its top row
    mov dl, 12                ; button v: its left column
    mov cl, 6                 ; button v: its inner width
    jmp mouse_hit             ; light it up and report the key
hn11:
    cmp dh, 7                 ; button x?: is the click above its top row?
    jb hn12                   ; yes: not this button
    cmp dh, 9                 ; button x?: is the click below its bottom row?
    ja hn12                   ; yes: not this button
    cmp dl, 20                ; button x?: is the click left of it?
    jb hn12                   ; yes: not this button
    cmp dl, 27                ; button x?: is the click right of it?
    ja hn12                   ; yes: not this button
    mov al, 's'               ; button x?: the key code it stands for (0 = none yet)
    mov dh, 7                 ; button x?: its top row
    mov dl, 20                ; button x?: its left column
    mov cl, 6                 ; button x?: its inner width
    jmp mouse_hit             ; light it up and report the key
hn12:
    cmp dh, 7                 ; button ^: is the click above its top row?
    jb hn13                   ; yes: not this button
    cmp dh, 9                 ; button ^: is the click below its bottom row?
    ja hn13                   ; yes: not this button
    cmp dl, 28                ; button ^: is the click left of it?
    jb hn13                   ; yes: not this button
    cmp dl, 35                ; button ^: is the click right of it?
    ja hn13                   ; yes: not this button
    mov al, '^'               ; button ^: the key code it stands for (0 = none yet)
    mov dh, 7                 ; button ^: its top row
    mov dl, 28                ; button ^: its left column
    mov cl, 6                 ; button ^: its inner width
    jmp mouse_hit             ; light it up and report the key
hn13:
    cmp dh, 7                 ; button log: is the click above its top row?
    jb hn14                   ; yes: not this button
    cmp dh, 9                 ; button log: is the click below its bottom row?
    ja hn14                   ; yes: not this button
    cmp dl, 36                ; button log: is the click left of it?
    jb hn14                   ; yes: not this button
    cmp dl, 43                ; button log: is the click right of it?
    ja hn14                   ; yes: not this button
    mov al, 0                 ; button log: the key code it stands for (0 = none yet)
    mov dh, 7                 ; button log: its top row
    mov dl, 36                ; button log: its left column
    mov cl, 6                 ; button log: its inner width
    jmp mouse_hit             ; light it up and report the key
hn14:
    cmp dh, 7                 ; button ln: is the click above its top row?
    jb hn15                   ; yes: not this button
    cmp dh, 9                 ; button ln: is the click below its bottom row?
    ja hn15                   ; yes: not this button
    cmp dl, 44                ; button ln: is the click left of it?
    jb hn15                   ; yes: not this button
    cmp dl, 51                ; button ln: is the click right of it?
    ja hn15                   ; yes: not this button
    mov al, 0                 ; button ln: the key code it stands for (0 = none yet)
    mov dh, 7                 ; button ln: its top row
    mov dl, 44                ; button ln: its left column
    mov cl, 6                 ; button ln: its inner width
    jmp mouse_hit             ; light it up and report the key
hn15:
    cmp dh, 7                 ; button (-): is the click above its top row?
    jb hn16                   ; yes: not this button
    cmp dh, 9                 ; button (-): is the click below its bottom row?
    ja hn16                   ; yes: not this button
    cmp dl, 52                ; button (-): is the click left of it?
    jb hn16                   ; yes: not this button
    cmp dl, 59                ; button (-): is the click right of it?
    ja hn16                   ; yes: not this button
    mov al, 'n'               ; button (-): the key code it stands for (0 = none yet)
    mov dh, 7                 ; button (-): its top row
    mov dl, 52                ; button (-): its left column
    mov cl, 6                 ; button (-): its inner width
    jmp mouse_hit             ; light it up and report the key
hn16:
    cmp dh, 7                 ; button DMS: is the click above its top row?
    jb hn17                   ; yes: not this button
    cmp dh, 9                 ; button DMS: is the click below its bottom row?
    ja hn17                   ; yes: not this button
    cmp dl, 60                ; button DMS: is the click left of it?
    jb hn17                   ; yes: not this button
    cmp dl, 67                ; button DMS: is the click right of it?
    ja hn17                   ; yes: not this button
    mov al, 0                 ; button DMS: the key code it stands for (0 = none yet)
    mov dh, 7                 ; button DMS: its top row
    mov dl, 60                ; button DMS: its left column
    mov cl, 6                 ; button DMS: its inner width
    jmp mouse_hit             ; light it up and report the key
hn17:
    cmp dh, 7                 ; button hyp: is the click above its top row?
    jb hn18                   ; yes: not this button
    cmp dh, 9                 ; button hyp: is the click below its bottom row?
    ja hn18                   ; yes: not this button
    cmp dl, 68                ; button hyp: is the click left of it?
    jb hn18                   ; yes: not this button
    cmp dl, 75                ; button hyp: is the click right of it?
    ja hn18                   ; yes: not this button
    mov al, 0                 ; button hyp: the key code it stands for (0 = none yet)
    mov dh, 7                 ; button hyp: its top row
    mov dl, 68                ; button hyp: its left column
    mov cl, 6                 ; button hyp: its inner width
    jmp mouse_hit             ; light it up and report the key
hn18:
    cmp dh, 10                ; button sin: is the click above its top row?
    jb hn19                   ; yes: not this button
    cmp dh, 12                ; button sin: is the click below its bottom row?
    ja hn19                   ; yes: not this button
    cmp dl, 4                 ; button sin: is the click left of it?
    jb hn19                   ; yes: not this button
    cmp dl, 11                ; button sin: is the click right of it?
    ja hn19                   ; yes: not this button
    mov al, 0                 ; button sin: the key code it stands for (0 = none yet)
    mov dh, 10                ; button sin: its top row
    mov dl, 4                 ; button sin: its left column
    mov cl, 6                 ; button sin: its inner width
    jmp mouse_hit             ; light it up and report the key
hn19:
    cmp dh, 10                ; button cos: is the click above its top row?
    jb hn20                   ; yes: not this button
    cmp dh, 12                ; button cos: is the click below its bottom row?
    ja hn20                   ; yes: not this button
    cmp dl, 12                ; button cos: is the click left of it?
    jb hn20                   ; yes: not this button
    cmp dl, 19                ; button cos: is the click right of it?
    ja hn20                   ; yes: not this button
    mov al, 0                 ; button cos: the key code it stands for (0 = none yet)
    mov dh, 10                ; button cos: its top row
    mov dl, 12                ; button cos: its left column
    mov cl, 6                 ; button cos: its inner width
    jmp mouse_hit             ; light it up and report the key
hn20:
    cmp dh, 10                ; button tan: is the click above its top row?
    jb hn21                   ; yes: not this button
    cmp dh, 12                ; button tan: is the click below its bottom row?
    ja hn21                   ; yes: not this button
    cmp dl, 20                ; button tan: is the click left of it?
    jb hn21                   ; yes: not this button
    cmp dl, 27                ; button tan: is the click right of it?
    ja hn21                   ; yes: not this button
    mov al, 0                 ; button tan: the key code it stands for (0 = none yet)
    mov dh, 10                ; button tan: its top row
    mov dl, 20                ; button tan: its left column
    mov cl, 6                 ; button tan: its inner width
    jmp mouse_hit             ; light it up and report the key
hn21:
    cmp dh, 10                ; button RCL: is the click above its top row?
    jb hn22                   ; yes: not this button
    cmp dh, 12                ; button RCL: is the click below its bottom row?
    ja hn22                   ; yes: not this button
    cmp dl, 28                ; button RCL: is the click left of it?
    jb hn22                   ; yes: not this button
    cmp dl, 35                ; button RCL: is the click right of it?
    ja hn22                   ; yes: not this button
    mov al, 'r'               ; button RCL: the key code it stands for (0 = none yet)
    mov dh, 10                ; button RCL: its top row
    mov dl, 28                ; button RCL: its left column
    mov cl, 6                 ; button RCL: its inner width
    jmp mouse_hit             ; light it up and report the key
hn22:
    cmp dh, 10                ; button ENG: is the click above its top row?
    jb hn23                   ; yes: not this button
    cmp dh, 12                ; button ENG: is the click below its bottom row?
    ja hn23                   ; yes: not this button
    cmp dl, 36                ; button ENG: is the click left of it?
    jb hn23                   ; yes: not this button
    cmp dl, 43                ; button ENG: is the click right of it?
    ja hn23                   ; yes: not this button
    mov al, 0                 ; button ENG: the key code it stands for (0 = none yet)
    mov dh, 10                ; button ENG: its top row
    mov dl, 36                ; button ENG: its left column
    mov cl, 6                 ; button ENG: its inner width
    jmp mouse_hit             ; light it up and report the key
hn23:
    cmp dh, 10                ; button (: is the click above its top row?
    jb hn24                   ; yes: not this button
    cmp dh, 12                ; button (: is the click below its bottom row?
    ja hn24                   ; yes: not this button
    cmp dl, 44                ; button (: is the click left of it?
    jb hn24                   ; yes: not this button
    cmp dl, 51                ; button (: is the click right of it?
    ja hn24                   ; yes: not this button
    mov al, 0                 ; button (: the key code it stands for (0 = none yet)
    mov dh, 10                ; button (: its top row
    mov dl, 44                ; button (: its left column
    mov cl, 6                 ; button (: its inner width
    jmp mouse_hit             ; light it up and report the key
hn24:
    cmp dh, 10                ; button ): is the click above its top row?
    jb hn25                   ; yes: not this button
    cmp dh, 12                ; button ): is the click below its bottom row?
    ja hn25                   ; yes: not this button
    cmp dl, 52                ; button ): is the click left of it?
    jb hn25                   ; yes: not this button
    cmp dl, 59                ; button ): is the click right of it?
    ja hn25                   ; yes: not this button
    mov al, 0                 ; button ): the key code it stands for (0 = none yet)
    mov dh, 10                ; button ): its top row
    mov dl, 52                ; button ): its left column
    mov cl, 6                 ; button ): its inner width
    jmp mouse_hit             ; light it up and report the key
hn25:
    cmp dh, 10                ; button ,: is the click above its top row?
    jb hn26                   ; yes: not this button
    cmp dh, 12                ; button ,: is the click below its bottom row?
    ja hn26                   ; yes: not this button
    cmp dl, 60                ; button ,: is the click left of it?
    jb hn26                   ; yes: not this button
    cmp dl, 67                ; button ,: is the click right of it?
    ja hn26                   ; yes: not this button
    mov al, 0                 ; button ,: the key code it stands for (0 = none yet)
    mov dh, 10                ; button ,: its top row
    mov dl, 60                ; button ,: its left column
    mov cl, 6                 ; button ,: its inner width
    jmp mouse_hit             ; light it up and report the key
hn26:
    cmp dh, 10                ; button M+: is the click above its top row?
    jb hn27                   ; yes: not this button
    cmp dh, 12                ; button M+: is the click below its bottom row?
    ja hn27                   ; yes: not this button
    cmp dl, 68                ; button M+: is the click left of it?
    jb hn27                   ; yes: not this button
    cmp dl, 75                ; button M+: is the click right of it?
    ja hn27                   ; yes: not this button
    mov al, 'm'               ; button M+: the key code it stands for (0 = none yet)
    mov dh, 10                ; button M+: its top row
    mov dl, 68                ; button M+: its left column
    mov cl, 6                 ; button M+: its inner width
    jmp mouse_hit             ; light it up and report the key
hn27:
    cmp dh, 13                ; button 7: is the click above its top row?
    jb hn28                   ; yes: not this button
    cmp dh, 15                ; button 7: is the click below its bottom row?
    ja hn28                   ; yes: not this button
    cmp dl, 5                 ; button 7: is the click left of it?
    jb hn28                   ; yes: not this button
    cmp dl, 18                ; button 7: is the click right of it?
    ja hn28                   ; yes: not this button
    mov al, '7'               ; button 7: the key code it stands for (0 = none yet)
    mov dh, 13                ; button 7: its top row
    mov dl, 5                 ; button 7: its left column
    mov cl, 12                ; button 7: its inner width
    jmp mouse_hit             ; light it up and report the key
hn28:
    cmp dh, 13                ; button 8: is the click above its top row?
    jb hn29                   ; yes: not this button
    cmp dh, 15                ; button 8: is the click below its bottom row?
    ja hn29                   ; yes: not this button
    cmp dl, 19                ; button 8: is the click left of it?
    jb hn29                   ; yes: not this button
    cmp dl, 32                ; button 8: is the click right of it?
    ja hn29                   ; yes: not this button
    mov al, '8'               ; button 8: the key code it stands for (0 = none yet)
    mov dh, 13                ; button 8: its top row
    mov dl, 19                ; button 8: its left column
    mov cl, 12                ; button 8: its inner width
    jmp mouse_hit             ; light it up and report the key
hn29:
    cmp dh, 13                ; button 9: is the click above its top row?
    jb hn30                   ; yes: not this button
    cmp dh, 15                ; button 9: is the click below its bottom row?
    ja hn30                   ; yes: not this button
    cmp dl, 33                ; button 9: is the click left of it?
    jb hn30                   ; yes: not this button
    cmp dl, 46                ; button 9: is the click right of it?
    ja hn30                   ; yes: not this button
    mov al, '9'               ; button 9: the key code it stands for (0 = none yet)
    mov dh, 13                ; button 9: its top row
    mov dl, 33                ; button 9: its left column
    mov cl, 12                ; button 9: its inner width
    jmp mouse_hit             ; light it up and report the key
hn30:
    cmp dh, 13                ; button DEL: is the click above its top row?
    jb hn31                   ; yes: not this button
    cmp dh, 15                ; button DEL: is the click below its bottom row?
    ja hn31                   ; yes: not this button
    cmp dl, 47                ; button DEL: is the click left of it?
    jb hn31                   ; yes: not this button
    cmp dl, 60                ; button DEL: is the click right of it?
    ja hn31                   ; yes: not this button
    mov al, 8                 ; button DEL: the key code it stands for (0 = none yet)
    mov dh, 13                ; button DEL: its top row
    mov dl, 47                ; button DEL: its left column
    mov cl, 12                ; button DEL: its inner width
    jmp mouse_hit             ; light it up and report the key
hn31:
    cmp dh, 13                ; button AC: is the click above its top row?
    jb hn32                   ; yes: not this button
    cmp dh, 15                ; button AC: is the click below its bottom row?
    ja hn32                   ; yes: not this button
    cmp dl, 61                ; button AC: is the click left of it?
    jb hn32                   ; yes: not this button
    cmp dl, 74                ; button AC: is the click right of it?
    ja hn32                   ; yes: not this button
    mov al, 'C'               ; button AC: the key code it stands for (0 = none yet)
    mov dh, 13                ; button AC: its top row
    mov dl, 61                ; button AC: its left column
    mov cl, 12                ; button AC: its inner width
    jmp mouse_hit             ; light it up and report the key
hn32:
    cmp dh, 16                ; button 4: is the click above its top row?
    jb hn33                   ; yes: not this button
    cmp dh, 18                ; button 4: is the click below its bottom row?
    ja hn33                   ; yes: not this button
    cmp dl, 5                 ; button 4: is the click left of it?
    jb hn33                   ; yes: not this button
    cmp dl, 18                ; button 4: is the click right of it?
    ja hn33                   ; yes: not this button
    mov al, '4'               ; button 4: the key code it stands for (0 = none yet)
    mov dh, 16                ; button 4: its top row
    mov dl, 5                 ; button 4: its left column
    mov cl, 12                ; button 4: its inner width
    jmp mouse_hit             ; light it up and report the key
hn33:
    cmp dh, 16                ; button 5: is the click above its top row?
    jb hn34                   ; yes: not this button
    cmp dh, 18                ; button 5: is the click below its bottom row?
    ja hn34                   ; yes: not this button
    cmp dl, 19                ; button 5: is the click left of it?
    jb hn34                   ; yes: not this button
    cmp dl, 32                ; button 5: is the click right of it?
    ja hn34                   ; yes: not this button
    mov al, '5'               ; button 5: the key code it stands for (0 = none yet)
    mov dh, 16                ; button 5: its top row
    mov dl, 19                ; button 5: its left column
    mov cl, 12                ; button 5: its inner width
    jmp mouse_hit             ; light it up and report the key
hn34:
    cmp dh, 16                ; button 6: is the click above its top row?
    jb hn35                   ; yes: not this button
    cmp dh, 18                ; button 6: is the click below its bottom row?
    ja hn35                   ; yes: not this button
    cmp dl, 33                ; button 6: is the click left of it?
    jb hn35                   ; yes: not this button
    cmp dl, 46                ; button 6: is the click right of it?
    ja hn35                   ; yes: not this button
    mov al, '6'               ; button 6: the key code it stands for (0 = none yet)
    mov dh, 16                ; button 6: its top row
    mov dl, 33                ; button 6: its left column
    mov cl, 12                ; button 6: its inner width
    jmp mouse_hit             ; light it up and report the key
hn35:
    cmp dh, 16                ; button *: is the click above its top row?
    jb hn36                   ; yes: not this button
    cmp dh, 18                ; button *: is the click below its bottom row?
    ja hn36                   ; yes: not this button
    cmp dl, 47                ; button *: is the click left of it?
    jb hn36                   ; yes: not this button
    cmp dl, 60                ; button *: is the click right of it?
    ja hn36                   ; yes: not this button
    mov al, '*'               ; button *: the key code it stands for (0 = none yet)
    mov dh, 16                ; button *: its top row
    mov dl, 47                ; button *: its left column
    mov cl, 12                ; button *: its inner width
    jmp mouse_hit             ; light it up and report the key
hn36:
    cmp dh, 16                ; button ?: is the click above its top row?
    jb hn37                   ; yes: not this button
    cmp dh, 18                ; button ?: is the click below its bottom row?
    ja hn37                   ; yes: not this button
    cmp dl, 61                ; button ?: is the click left of it?
    jb hn37                   ; yes: not this button
    cmp dl, 74                ; button ?: is the click right of it?
    ja hn37                   ; yes: not this button
    mov al, '/'               ; button ?: the key code it stands for (0 = none yet)
    mov dh, 16                ; button ?: its top row
    mov dl, 61                ; button ?: its left column
    mov cl, 12                ; button ?: its inner width
    jmp mouse_hit             ; light it up and report the key
hn37:
    cmp dh, 19                ; button 1: is the click above its top row?
    jb hn38                   ; yes: not this button
    cmp dh, 21                ; button 1: is the click below its bottom row?
    ja hn38                   ; yes: not this button
    cmp dl, 5                 ; button 1: is the click left of it?
    jb hn38                   ; yes: not this button
    cmp dl, 18                ; button 1: is the click right of it?
    ja hn38                   ; yes: not this button
    mov al, '1'               ; button 1: the key code it stands for (0 = none yet)
    mov dh, 19                ; button 1: its top row
    mov dl, 5                 ; button 1: its left column
    mov cl, 12                ; button 1: its inner width
    jmp mouse_hit             ; light it up and report the key
hn38:
    cmp dh, 19                ; button 2: is the click above its top row?
    jb hn39                   ; yes: not this button
    cmp dh, 21                ; button 2: is the click below its bottom row?
    ja hn39                   ; yes: not this button
    cmp dl, 19                ; button 2: is the click left of it?
    jb hn39                   ; yes: not this button
    cmp dl, 32                ; button 2: is the click right of it?
    ja hn39                   ; yes: not this button
    mov al, '2'               ; button 2: the key code it stands for (0 = none yet)
    mov dh, 19                ; button 2: its top row
    mov dl, 19                ; button 2: its left column
    mov cl, 12                ; button 2: its inner width
    jmp mouse_hit             ; light it up and report the key
hn39:
    cmp dh, 19                ; button 3: is the click above its top row?
    jb hn40                   ; yes: not this button
    cmp dh, 21                ; button 3: is the click below its bottom row?
    ja hn40                   ; yes: not this button
    cmp dl, 33                ; button 3: is the click left of it?
    jb hn40                   ; yes: not this button
    cmp dl, 46                ; button 3: is the click right of it?
    ja hn40                   ; yes: not this button
    mov al, '3'               ; button 3: the key code it stands for (0 = none yet)
    mov dh, 19                ; button 3: its top row
    mov dl, 33                ; button 3: its left column
    mov cl, 12                ; button 3: its inner width
    jmp mouse_hit             ; light it up and report the key
hn40:
    cmp dh, 19                ; button +: is the click above its top row?
    jb hn41                   ; yes: not this button
    cmp dh, 21                ; button +: is the click below its bottom row?
    ja hn41                   ; yes: not this button
    cmp dl, 47                ; button +: is the click left of it?
    jb hn41                   ; yes: not this button
    cmp dl, 60                ; button +: is the click right of it?
    ja hn41                   ; yes: not this button
    mov al, '+'               ; button +: the key code it stands for (0 = none yet)
    mov dh, 19                ; button +: its top row
    mov dl, 47                ; button +: its left column
    mov cl, 12                ; button +: its inner width
    jmp mouse_hit             ; light it up and report the key
hn41:
    cmp dh, 19                ; button -: is the click above its top row?
    jb hn42                   ; yes: not this button
    cmp dh, 21                ; button -: is the click below its bottom row?
    ja hn42                   ; yes: not this button
    cmp dl, 61                ; button -: is the click left of it?
    jb hn42                   ; yes: not this button
    cmp dl, 74                ; button -: is the click right of it?
    ja hn42                   ; yes: not this button
    mov al, '-'               ; button -: the key code it stands for (0 = none yet)
    mov dh, 19                ; button -: its top row
    mov dl, 61                ; button -: its left column
    mov cl, 12                ; button -: its inner width
    jmp mouse_hit             ; light it up and report the key
hn42:
    cmp dh, 22                ; button 0: is the click above its top row?
    jb hn43                   ; yes: not this button
    cmp dh, 24                ; button 0: is the click below its bottom row?
    ja hn43                   ; yes: not this button
    cmp dl, 5                 ; button 0: is the click left of it?
    jb hn43                   ; yes: not this button
    cmp dl, 18                ; button 0: is the click right of it?
    ja hn43                   ; yes: not this button
    mov al, '0'               ; button 0: the key code it stands for (0 = none yet)
    mov dh, 22                ; button 0: its top row
    mov dl, 5                 ; button 0: its left column
    mov cl, 12                ; button 0: its inner width
    jmp mouse_hit             ; light it up and report the key
hn43:
    cmp dh, 22                ; button .: is the click above its top row?
    jb hn44                   ; yes: not this button
    cmp dh, 24                ; button .: is the click below its bottom row?
    ja hn44                   ; yes: not this button
    cmp dl, 19                ; button .: is the click left of it?
    jb hn44                   ; yes: not this button
    cmp dl, 32                ; button .: is the click right of it?
    ja hn44                   ; yes: not this button
    mov al, '.'               ; button .: the key code it stands for (0 = none yet)
    mov dh, 22                ; button .: its top row
    mov dl, 19                ; button .: its left column
    mov cl, 12                ; button .: its inner width
    jmp mouse_hit             ; light it up and report the key
hn44:
    cmp dh, 22                ; button EXP: is the click above its top row?
    jb hn45                   ; yes: not this button
    cmp dh, 24                ; button EXP: is the click below its bottom row?
    ja hn45                   ; yes: not this button
    cmp dl, 33                ; button EXP: is the click left of it?
    jb hn45                   ; yes: not this button
    cmp dl, 46                ; button EXP: is the click right of it?
    ja hn45                   ; yes: not this button
    mov al, 'e'               ; button EXP: the key code it stands for (0 = none yet)
    mov dh, 22                ; button EXP: its top row
    mov dl, 33                ; button EXP: its left column
    mov cl, 12                ; button EXP: its inner width
    jmp mouse_hit             ; light it up and report the key
hn45:
    cmp dh, 22                ; button Ans: is the click above its top row?
    jb hn46                   ; yes: not this button
    cmp dh, 24                ; button Ans: is the click below its bottom row?
    ja hn46                   ; yes: not this button
    cmp dl, 47                ; button Ans: is the click left of it?
    jb hn46                   ; yes: not this button
    cmp dl, 60                ; button Ans: is the click right of it?
    ja hn46                   ; yes: not this button
    mov al, 'a'               ; button Ans: the key code it stands for (0 = none yet)
    mov dh, 22                ; button Ans: its top row
    mov dl, 47                ; button Ans: its left column
    mov cl, 12                ; button Ans: its inner width
    jmp mouse_hit             ; light it up and report the key
hn46:
    cmp dh, 22                ; button =: is the click above its top row?
    jb hn47                   ; yes: not this button
    cmp dh, 24                ; button =: is the click below its bottom row?
    ja hn47                   ; yes: not this button
    cmp dl, 61                ; button =: is the click left of it?
    jb hn47                   ; yes: not this button
    cmp dl, 74                ; button =: is the click right of it?
    ja hn47                   ; yes: not this button
    mov al, '='               ; button =: the key code it stands for (0 = none yet)
    mov dh, 22                ; button =: its top row
    mov dl, 61                ; button =: its left column
    mov cl, 12                ; button =: its inner width
    jmp mouse_hit             ; light it up and report the key
hn47:
    mov al, 0                 ; the click was not on any button
    ret                       ; back
mouse_hit:
    push ax                   ; keep the key code safe
    call do_flash             ; light up the clicked button
    pop ax                    ; get the key code back
    ret                       ; back to main_loop with AL = key code
check_mouse endp

key_flash proc                ; AL = key code: light up its button, if it has one
    push ax                   ; keep AX safe
    push bx                   ; keep BX safe
    push cx                   ; keep CX safe
    push dx                   ; keep DX safe
    cmp al, 'k'               ; is it key k?
    jne kf_n01                ; no: try the next key
    mov dh, 4                 ; row of the button nCr
    mov dl, 52                ; column of the button
    mov cl, 6                 ; inner width of the button
    jmp kf_go                 ; light it up
kf_n01:
    cmp al, 'x'               ; is it key x?
    jne kf_n02                ; no: try the next key
    mov dh, 4                 ; row of the button x^3
    mov dl, 68                ; column of the button
    mov cl, 6                 ; inner width of the button
    jmp kf_go                 ; light it up
kf_n02:
    cmp al, 'q'               ; is it key q?
    jne kf_n03                ; no: try the next key
    mov dh, 7                 ; row of the button v
    mov dl, 12                ; column of the button
    mov cl, 6                 ; inner width of the button
    jmp kf_go                 ; light it up
kf_n03:
    cmp al, 's'               ; is it key s?
    jne kf_n04                ; no: try the next key
    mov dh, 7                 ; row of the button x?
    mov dl, 20                ; column of the button
    mov cl, 6                 ; inner width of the button
    jmp kf_go                 ; light it up
kf_n04:
    cmp al, '^'               ; is it key ^?
    jne kf_n05                ; no: try the next key
    mov dh, 7                 ; row of the button ^
    mov dl, 28                ; column of the button
    mov cl, 6                 ; inner width of the button
    jmp kf_go                 ; light it up
kf_n05:
    cmp al, 'n'               ; is it key n?
    jne kf_n06                ; no: try the next key
    mov dh, 7                 ; row of the button (-)
    mov dl, 52                ; column of the button
    mov cl, 6                 ; inner width of the button
    jmp kf_go                 ; light it up
kf_n06:
    cmp al, 'r'               ; is it key r?
    jne kf_n07                ; no: try the next key
    mov dh, 10                ; row of the button RCL
    mov dl, 28                ; column of the button
    mov cl, 6                 ; inner width of the button
    jmp kf_go                 ; light it up
kf_n07:
    cmp al, 'm'               ; is it key m?
    jne kf_n08                ; no: try the next key
    mov dh, 10                ; row of the button M+
    mov dl, 68                ; column of the button
    mov cl, 6                 ; inner width of the button
    jmp kf_go                 ; light it up
kf_n08:
    cmp al, '7'               ; is it key 7?
    jne kf_n09                ; no: try the next key
    mov dh, 13                ; row of the button 7
    mov dl, 5                 ; column of the button
    mov cl, 12                ; inner width of the button
    jmp kf_go                 ; light it up
kf_n09:
    cmp al, '8'               ; is it key 8?
    jne kf_n10                ; no: try the next key
    mov dh, 13                ; row of the button 8
    mov dl, 19                ; column of the button
    mov cl, 12                ; inner width of the button
    jmp kf_go                 ; light it up
kf_n10:
    cmp al, '9'               ; is it key 9?
    jne kf_n11                ; no: try the next key
    mov dh, 13                ; row of the button 9
    mov dl, 33                ; column of the button
    mov cl, 12                ; inner width of the button
    jmp kf_go                 ; light it up
kf_n11:
    cmp al, 8                 ; is it Backspace?
    jne kf_n12                ; no: try the next key
    mov dh, 13                ; row of the button DEL
    mov dl, 47                ; column of the button
    mov cl, 12                ; inner width of the button
    jmp kf_go                 ; light it up
kf_n12:
    cmp al, 'C'               ; is it key C?
    jne kf_n13                ; no: try the next key
    mov dh, 13                ; row of the button AC
    mov dl, 61                ; column of the button
    mov cl, 12                ; inner width of the button
    jmp kf_go                 ; light it up
kf_n13:
    cmp al, 'c'               ; is it a small c?
    jne kf_n14                ; no: try the next key
    mov dh, 13                ; row of the button AC
    mov dl, 61                ; column of the button
    mov cl, 12                ; inner width of the button
    jmp kf_go                 ; light it up
kf_n14:
    cmp al, '4'               ; is it key 4?
    jne kf_n15                ; no: try the next key
    mov dh, 16                ; row of the button 4
    mov dl, 5                 ; column of the button
    mov cl, 12                ; inner width of the button
    jmp kf_go                 ; light it up
kf_n15:
    cmp al, '5'               ; is it key 5?
    jne kf_n16                ; no: try the next key
    mov dh, 16                ; row of the button 5
    mov dl, 19                ; column of the button
    mov cl, 12                ; inner width of the button
    jmp kf_go                 ; light it up
kf_n16:
    cmp al, '6'               ; is it key 6?
    jne kf_n17                ; no: try the next key
    mov dh, 16                ; row of the button 6
    mov dl, 33                ; column of the button
    mov cl, 12                ; inner width of the button
    jmp kf_go                 ; light it up
kf_n17:
    cmp al, '*'               ; is it key *?
    jne kf_n18                ; no: try the next key
    mov dh, 16                ; row of the button *
    mov dl, 47                ; column of the button
    mov cl, 12                ; inner width of the button
    jmp kf_go                 ; light it up
kf_n18:
    cmp al, '/'               ; is it key /?
    jne kf_n19                ; no: try the next key
    mov dh, 16                ; row of the button ?
    mov dl, 61                ; column of the button
    mov cl, 12                ; inner width of the button
    jmp kf_go                 ; light it up
kf_n19:
    cmp al, '1'               ; is it key 1?
    jne kf_n20                ; no: try the next key
    mov dh, 19                ; row of the button 1
    mov dl, 5                 ; column of the button
    mov cl, 12                ; inner width of the button
    jmp kf_go                 ; light it up
kf_n20:
    cmp al, '2'               ; is it key 2?
    jne kf_n21                ; no: try the next key
    mov dh, 19                ; row of the button 2
    mov dl, 19                ; column of the button
    mov cl, 12                ; inner width of the button
    jmp kf_go                 ; light it up
kf_n21:
    cmp al, '3'               ; is it key 3?
    jne kf_n22                ; no: try the next key
    mov dh, 19                ; row of the button 3
    mov dl, 33                ; column of the button
    mov cl, 12                ; inner width of the button
    jmp kf_go                 ; light it up
kf_n22:
    cmp al, '+'               ; is it key +?
    jne kf_n23                ; no: try the next key
    mov dh, 19                ; row of the button +
    mov dl, 47                ; column of the button
    mov cl, 12                ; inner width of the button
    jmp kf_go                 ; light it up
kf_n23:
    cmp al, '-'               ; is it key -?
    jne kf_n24                ; no: try the next key
    mov dh, 19                ; row of the button -
    mov dl, 61                ; column of the button
    mov cl, 12                ; inner width of the button
    jmp kf_go                 ; light it up
kf_n24:
    cmp al, '0'               ; is it key 0?
    jne kf_n25                ; no: try the next key
    mov dh, 22                ; row of the button 0
    mov dl, 5                 ; column of the button
    mov cl, 12                ; inner width of the button
    jmp kf_go                 ; light it up
kf_n25:
    cmp al, 'e'               ; is it key e?
    jne kf_n26                ; no: try the next key
    mov dh, 22                ; row of the button EXP
    mov dl, 33                ; column of the button
    mov cl, 12                ; inner width of the button
    jmp kf_go                 ; light it up
kf_n26:
    cmp al, 'a'               ; is it key a?
    jne kf_n27                ; no: try the next key
    mov dh, 22                ; row of the button Ans
    mov dl, 47                ; column of the button
    mov cl, 12                ; inner width of the button
    jmp kf_go                 ; light it up
kf_n27:
    cmp al, '='               ; is it key =?
    jne kf_n28                ; no: try the next key
    mov dh, 22                ; row of the button =
    mov dl, 61                ; column of the button
    mov cl, 12                ; inner width of the button
    jmp kf_go                 ; light it up
kf_n28:
    cmp al, 13                ; is it Enter?
    jne kf_n29                ; no: try the next key
    mov dh, 22                ; row of the button =
    mov dl, 61                ; column of the button
    mov cl, 12                ; inner width of the button
    jmp kf_go                 ; light it up
kf_n29:
    jmp kf_done               ; this key has no button
kf_go:
    call do_flash             ; light up the button
kf_done:
    pop dx                    ; get DX back
    pop cx                    ; get CX back
    pop bx                    ; get BX back
    pop ax                    ; get AX back
    ret                       ; back
key_flash endp
;----------------------------------------------------------------
show_entry proc               ; draws the typed number, right-aligned
    mov dh, 2                 ; row 2
    mov dl, 4                 ; column 4
    call set_cursor           ; go to the left wall of the display
    mov dx, offset dsp_mid    ; the empty display line
    mov ah, 9                 ; DOS job 9: print text
    int 21h                   ; wipe the old number
    mov bl, [len]             ; BL = number of digits
    cmp bl, 0                 ; nothing typed?
    je se_zero                ; then show a plain 0
    mov dh, 2                 ; row 2
    mov dl, 75                ; column 75 ...
    sub dl, bl                ; ... minus the digits = start column
    call set_cursor           ; go there
    mov dx, offset buf        ; the typed digits
    mov ah, 9                 ; DOS job 9: print text
    int 21h                   ; print them, ending at column 74
    ret                       ; back
se_zero:
    mov dh, 2                 ; row 2
    mov dl, 74                ; column 74
    call set_cursor           ; go there
    mov al, '0'               ; the character 0
    call put_char             ; print it
    ret                       ; back
show_entry endp

msg_title db 'SCIENTIFIC CALCULATOR$'   ; title text
msg_exit  db 'Press ESC to exit$'       ; exit text
dsp_mid   db 0B3h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,0B3h,'$'   ; display empty line
dsp_bot   db 0C0h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0D9h,'$'   ; display bottom edge
lbl01    db 'SHIFT ','$'   ; SHIFT
lbl02    db 'ALPHA ','$'   ; ALPHA
lbl03    db 'REPLAY','$'   ; REPLAY
lbl04    db ' MODE ','$'   ; MODE
lbl05    db '  ON  ','$'   ; ON
lbl06    db ' x^-1 ','$'   ; x^-1
lbl07    db ' nCr  ','$'   ; nCr
lbl08    db ' Pol( ','$'   ; Pol(
lbl09    db ' x^3  ','$'   ; x^3
lbl10    db 'a b/c ','$'   ; a b/c
lbl11    db '  ',0FBh,'   ','$'   ; v
lbl12    db '  x',0FDh,'  ','$'   ; x?
lbl13    db '  ^   ','$'   ; ^
lbl14    db ' log  ','$'   ; log
lbl15    db '  ln  ','$'   ; ln
lbl16    db ' (-)  ','$'   ; (-)
lbl17    db ' DMS  ','$'   ; DMS
lbl18    db ' hyp  ','$'   ; hyp
lbl19    db ' sin  ','$'   ; sin
lbl20    db ' cos  ','$'   ; cos
lbl21    db ' tan  ','$'   ; tan
lbl22    db ' RCL  ','$'   ; RCL
lbl23    db ' ENG  ','$'   ; ENG
lbl24    db '  (   ','$'   ; (
lbl25    db '  )   ','$'   ; )
lbl26    db '  ,   ','$'   ; ,
lbl27    db '  M+  ','$'   ; M+
lbl28    db '     7      ','$'   ; 7
lbl29    db '     8      ','$'   ; 8
lbl30    db '     9      ','$'   ; 9
lbl31    db '    DEL     ','$'   ; DEL
lbl32    db '     AC     ','$'   ; AC
lbl33    db '     4      ','$'   ; 4
lbl34    db '     5      ','$'   ; 5
lbl35    db '     6      ','$'   ; 6
lbl36    db '     *      ','$'   ; *
lbl37    db '     ',0F6h,'      ','$'   ; ?
lbl38    db '     1      ','$'   ; 1
lbl39    db '     2      ','$'   ; 2
lbl40    db '     3      ','$'   ; 3
lbl41    db '     +      ','$'   ; +
lbl42    db '     -      ','$'   ; -
lbl43    db '     0      ','$'   ; 0
lbl44    db '     .      ','$'   ; .
lbl45    db '    EXP     ','$'   ; EXP
lbl46    db '    Ans     ','$'   ; Ans
lbl47    db '     =      ','$'   ; =
b_row db 0                    ; row of the button being drawn
b_col db 0                    ; column of the button being drawn
len db 0                      ; how many digits are typed
buf db 17 dup('$')            ; the digits, ending with $ 
cur   dw 0                    ; the number being typed
first dw 0                    ; the number saved when + was pressed
op    db 0                    ; 0 = nothing waiting, '+' = plus waiting
fresh db 0                    ; 1 = the next digit starts a new number
ans   dw 0                    ; the last answer
mem   dw 0                    ; the memory (M+ and RCL)
mouse_ok   db 0               ; 1 = a mouse was found
mouse_down db 0               ; 1 = the left mouse button is held down
fb_row db 0                   ; row of the button being painted
fb_col db 0                   ; column of the button being painted
fb_w   db 0                   ; whole width of the button being painted
fb_attr db 0                  ; color used for painting
fb_i   db 0                   ; row counter while painting
fb_j   db 0                   ; column counter while painting

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
;----------------------------------------
main_loop:
    mov ah, 0                 ; keyboard job 0: wait for a key
    int 16h                   ; AL = the ASCII code of the key
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
    cmp al, '0'               ; below '0'?
    jb main_loop              ; not a digit, wait for the next key
    cmp al, '9'               ; above '9'?
    ja main_loop              ; not a digit, wait for the next key
    call add_digit            ; it is a digit: store it and show it
    jmp main_loop             ; wait for the next key
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
    call do_more              ; try ^ e k first: DL = 0 other, 1 = answer in AX, 2 = error
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

do_more proc                  ; works out ^ e k. DL: 0 = other operator, 1 = AX holds the answer, 2 = error
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
    jne dm_other              ; no: it is not one of ours
    call do_ncr               ; AX = first nCr cur
    jc dm_error               ; carry set: error
    jmp dm_ok                 ; done
dm_other:
    mov dl, 0                 ; not one of ^ e k
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
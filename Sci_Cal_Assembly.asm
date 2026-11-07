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
mov ah, 0                     ; keyboard job 0: wait for a key
int 16h                       ; wait here
mov ax, 4C00h                 ; DOS job 4Ch: close the program
int 21h                       ; exit

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
    mov dh, 7                 ; row 7: button x²
    mov dl, 20                ; column 20
    mov si, offset lbl12      ; address of the text of x²
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
    mov dh, 16                ; row 16: button ÷
    mov dl, 61                ; column 61
    mov si, offset lbl37      ; address of the text of ÷
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

msg_title db 'SCIENTIFIC CALCULATOR$'   ; title text
msg_exit  db 'Press any key to exit$'   ; exit text
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
lbl12    db '  x',0FDh,'  ','$'   ; x²
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
lbl37    db '     ',0F6h,'      ','$'   ; ÷
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
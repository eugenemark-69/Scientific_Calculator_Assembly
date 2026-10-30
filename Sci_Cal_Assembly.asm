
org 100h
jmp start

COLS      equ 6
ROWS      equ 5
CELL_W    equ 8          ; button width incl. borders
CELL_H    equ 3          ; button height incl. borders
GRID_ROW  equ 5
GRID_COL  equ 16

start:
    mov ax, 0003h        ; 80x25 text mode (also clears screen)
    int 10h

    call draw_title
    call draw_display
    call draw_keypad

    mov dh, 21
    mov dl, 16
    call set_cursor
    mov dx, offset msg_exit
    mov ah, 9
    int 21h

    mov ah, 0            ; wait for a key
    int 16h
    mov ax, 4C00h        ; exit to DOS
    int 21h

; ---------- screen sections ----------
draw_title proc
    mov dh, 0
    mov dl, 16
    call set_cursor
    mov dx, offset msg_title
    mov ah, 9
    int 21h
    ret
draw_title endp

draw_display proc
    mov dh, 1
    mov dl, 16
    mov cl, 46           ; inner width
    mov ch, 1            ; inner height
    call draw_box
    mov dh, 2            ; show a placeholder "0" at the right edge
    mov dl, 62
    call set_cursor
    mov al, '0'
    call put_char
    ret
draw_display endp

draw_keypad proc
    mov si, offset labels
    mov byte ptr [k_r], 0
row_loop:
    cmp byte ptr [k_r], ROWS
    jae keypad_done
    mov byte ptr [k_c], 0
col_loop:
    cmp byte ptr [k_c], COLS
    jae next_row

    mov al, [k_r]        ; screen row = GRID_ROW + r*CELL_H
    mov bl, CELL_H
    mul bl
    add al, GRID_ROW
    mov dh, al

    mov al, [k_c]        ; screen col = GRID_COL + c*CELL_W
    mov bl, CELL_W
    mul bl
    add al, GRID_COL
    mov dl, al

    mov cl, 6
    mov ch, 1
    call draw_box
    call print_label     ; SI advances by 4 each button

    inc byte ptr [k_c]
    jmp col_loop
next_row:
    inc byte ptr [k_r]
    jmp row_loop
keypad_done:
    ret
draw_keypad endp

; ---------- reusable helpers ----------
; draw_box: DH=row, DL=col, CL=inner width, CH=inner height
draw_box proc
    mov [b_row], dh
    mov [b_col], dl
    mov [b_w], cl
    mov [b_h], ch

    call set_cursor                  ; top edge
    mov al, 0DAh
    call put_char
    mov al, 0C4h
    mov cl, [b_w]
    xor ch, ch
    call put_repeat
    mov al, 0BFh
    call put_char

    mov byte ptr [b_i], 0            ; side walls
side_loop:
    mov al, [b_i]
    cmp al, [b_h]
    jae side_done
    mov dh, [b_row]
    inc dh
    add dh, [b_i]
    mov dl, [b_col]
    call set_cursor
    mov al, 0B3h
    call put_char
    mov al, ' '
    mov cl, [b_w]
    xor ch, ch
    call put_repeat
    mov al, 0B3h
    call put_char
    inc byte ptr [b_i]
    jmp side_loop
side_done:
    mov dh, [b_row]                  ; bottom edge
    add dh, [b_h]
    inc dh
    mov dl, [b_col]
    call set_cursor
    mov al, 0C0h
    call put_char
    mov al, 0C4h
    mov cl, [b_w]
    xor ch, ch
    call put_repeat
    mov al, 0D9h
    call put_char
    ret
draw_box endp

; print_label: prints 4 chars at SI inside the box just drawn
print_label proc
    mov dh, [b_row]
    inc dh
    mov dl, [b_col]
    add dl, 2
    call set_cursor
    mov cx, 4
lbl_loop:
    lodsb
    call put_char
    loop lbl_loop
    ret
print_label endp

set_cursor proc          ; DH=row, DL=col
    mov ah, 2
    mov bh, 0
    int 10h
    ret
set_cursor endp

put_char proc            ; AL=char
    mov ah, 0Eh
    mov bh, 0
    int 10h
    ret
put_char endp

put_repeat proc          ; AL=char, CX=count
    push ax
    push cx
rep_loop:
    push ax
    call put_char
    pop ax
    loop rep_loop
    pop cx
    pop ax
    ret
put_repeat endp

; ---------- data ----------
msg_title db 'SCIENTIFIC CALCULATOR$'
msg_exit  db 'Press any key to exit$'

; 30 labels, each exactly 4 chars, row by row
labels db 'sin ','cos ','tan ','log ','ln  ','sqrt'
       db '7   ','8   ','9   ','x^2 ','x^y ','/   '
       db '4   ','5   ','6   ','C   ','DEL ','*   '
       db '1   ','2   ','3   ','(   ','),  ','-   '
       db '0   ','.   ','pi  ','e   ','+   ','=   '

k_r db 0
k_c db 0
b_row db 0
b_col db 0
b_w   db 0
b_h   db 0
b_i   db 0
format ELF64 executable 3
entry start

segment readable executable
start:
    mov rax, 4825520901
    xor rbx, rbx
    mov rcx, 10
.loop:
    xor rdx, rdx
    div rcx
    add rbx, rdx
    test rax, rax
    jnz .loop

    mov rax, rbx
    call print_num

    mov rax, 1
    mov rdi, 1
    mov rsi, nl
    mov rdx, 1
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall

print_num:
    mov rdi, buf + 15
    mov rbx, 10
.cnv:
    xor rdx, rdx
    div rbx
    add dl, '0'
    mov [rdi], dl
    dec rdi
    test rax, rax
    jnz .cnv
    inc rdi
    mov rdx, buf + 16
    sub rdx, rdi
    mov rsi, rdi
    mov rax, 1
    mov rdi, 1
    syscall
    ret

segment readable writeable
buf rb 16
nl  db 0x0A

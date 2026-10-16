format ELF executable 3
entry start

segment readable executable
start:
    mov ebp, esp
    mov eax, [ebp]
    cmp eax, 3
    jne .usage

    ; chdir(argv[1])
    mov eax, 12
    mov ebx, [ebp + 8]
    int 0x80
    test eax, eax
    js .chdir_error

    ; parse n = argv[2]
    mov esi, [ebp + 12]
    call parse_int
    mov [n], eax

    ; seed = getpid() ^ time(NULL)
    mov eax, 20
    int 0x80
    mov [seed], eax

    mov eax, 13
    xor ebx, ebx
    int 0x80
    xor [seed], eax

    ; цикл создания файлов
    xor edi, edi
.create_loop:
    cmp edi, [n]
    jge .done
    call gen_random_name

    ; creat(filename, 0644) — ВОСЬМЕРИЧНОЕ!
    mov eax, 8
    mov ebx, filename
    mov ecx, 644o
    int 0x80

    inc edi
    jmp .create_loop

.done:
    mov eax, 4
    mov ebx, 1
    mov ecx, done_msg
    mov edx, done_len
    int 0x80
    mov eax, 1
    xor ebx, ebx
    int 0x80

.usage:
    mov eax, 4
    mov ebx, 1
    mov ecx, usage_msg
    mov edx, usage_len
    int 0x80
    mov eax, 1
    mov ebx, 1
    int 0x80

.chdir_error:
    mov eax, 4
    mov ebx, 1
    mov ecx, chdir_msg
    mov edx, chdir_len
    int 0x80
    mov eax, 1
    mov ebx, 2
    int 0x80

gen_random_name:
    push ebx
    push ecx
    push edx
    push edi
    mov edi, filename
    mov ecx, 0
.gen_char:
    cmp ecx, 8
    jge .suffix
    mov eax, [seed]
    mov ebx, 1103515245
    imul eax, ebx
    add eax, 12345
    mov [seed], eax
    xor edx, edx
    mov ebx, 26
    div ebx
    add dl, 'a'
    mov [edi], dl
    inc edi
    inc ecx
    jmp .gen_char
.suffix:
    mov byte [edi], '.'
    inc edi
    mov byte [edi], 't'
    inc edi
    mov byte [edi], 'x'
    inc edi
    mov byte [edi], 't'
    inc edi
    mov byte [edi], 0
    pop edi
    pop edx
    pop ecx
    pop ebx
    ret

parse_int:
    xor eax, eax
    xor ecx, ecx
    movzx edx, byte [esi]
    cmp dl, '-'
    jne .loop
    mov ecx, 1
    inc esi
.loop:
    movzx edx, byte [esi]
    cmp dl, '0'
    jb .done
    cmp dl, '9'
    ja .done
    imul eax, eax, 10
    sub dl, '0'
    movzx edx, dl
    add eax, edx
    inc esi
    jmp .loop
.done:
    test ecx, ecx
    jz .ret
    neg eax
.ret:
    ret

segment readable writeable
n           dd 0
seed        dd 0
filename    rb 16
usage_msg   db 'Usage: ./make_files <dir> <n>', 0x0A
usage_len   = $ - usage_msg
chdir_msg   db 'Error: cannot chdir', 0x0A
chdir_len   = $ - chdir_msg
done_msg    db 'Files created', 0x0A
done_len    = $ - done_msg

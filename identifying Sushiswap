section .data
    search_string db "sushi.com", 0
    sample_url db "https://app.sushi.com/swap", 0
    found_msg db "SushiSwap URL detected!", 0
    notfound_msg db "No SushiSwap URL.", 0

section .bss
    res resb 1

section .text
    global main
    extern printf

main:
    push ebp
    mov ebp, esp

    ; URL과 탐색 문자열 주소
    mov esi, sample_url
    mov edi, search_string

    call find_substring

    cmp al, 1
    je .found

    push notfound_msg
    call printf
    add esp, 4
    jmp .end

.found:
    push found_msg
    call printf
    add esp, 4

.end:
    mov esp, ebp
    pop ebp
    ret

; --------------------------------------------
; int find_substring(char *haystack, char *needle)
; 결과: AL = 1 (찾음), AL = 0 (못찾음)
find_substring:
    push esi
    push edi
    push ecx
    push edx

.next_char:
    mov ecx, edi     ; needle 시작
    mov edx, esi     ; haystack 현재

.compare:
    mov al, [edx]
    mov bl, [ecx]
    cmp bl, 0
    je .found_match
    cmp al, 0
    je .not_found
    cmp al, bl
    jne .next_haystack

    inc edx
    inc ecx
    jmp .compare

.next_haystack:
    inc esi
    mov ecx, edi
    mov edx, esi
    mov al, [esi]
    cmp al, 0
    je .not_found
    jmp .compare

.found_match:
    mov al, 1
    jmp .done

.not_found:
    mov al, 0

.done:
    pop edx
    pop ecx
    pop edi
    pop esi
    ret

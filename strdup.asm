extern _malloc
extern _ft_strlen
extern _ft_strcpy
extern ___error

section .text
    global _ft_strdup

_ft_strdup :
	call _ft_strlen
	jmp call_malloc

call_malloc :
	inc rax
	push rdi
	mov rdi, rax
	call _malloc
	cmp rax, 0
	je error_malloc
	pop rsi
	mov rdi, rax
	call _ft_strcpy
	ret

error_malloc :
	mov rax, 12
	push rax
	call ___error
	pop qword [rax]
	mov rax, 0
	ret

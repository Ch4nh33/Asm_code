section .text
    global _ft_strcpy

_ft_strcpy :
	mov rcx, 0
	jmp copy

copy :
	cmp BYTE [rsi + rcx], 0
	je end
	mov al, BYTE [rsi + rcx]
	mov BYTE [rdi + rcx], al
	inc rcx
	jmp copy

end :
	mov rax, rdi
	ret

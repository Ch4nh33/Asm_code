section .text
    global _ft_strcmp

_ft_strcmp :
	mov rcx, 0
	jmp compare

compare :
	cmp BYTE [rdi + rcx], 0
	je length_check
	cmp BYTE [rsi + rcx], 0
	je end2
	mov al, BYTE [rsi + rcx]
	cmp BYTE [rdi + rcx], al
	ja end2
	jb end3
	inc rcx
	jmp compare

length_check :
	cmp BYTE [rsi + rcx], 0
	je end
	mov rax, -1
	ret

end :
	mov rax, 0
	ret

end2 :
	mov rax, 1
	ret

end3 :
	mov rax, -1
	ret

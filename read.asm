section .text
    global _ft_read

extern ___error

_ft_read :
	mov rax, 0x2000003
	syscall
	jc end
	ret

end :
	mov rcx, rax
	call ___error
	mov [rax], rcx
	mov rax, -1
	ret

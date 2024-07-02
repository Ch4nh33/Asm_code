;; haribote-ipl
; TAB=4

CYLS	EQU		9				; ������ �о���ϱ�

		ORG		0x7c00			; �� ���α׷��� ��� ������ ���ΰ�

 ���ϴ� ǥ������ FAT12 ���� �÷��� ��ũ�� ���� ���

		JMP		entry
		DB		0x90
		DB		"HARIBOTE"		; boot sector�� �̸��� �����Ӱ� �ᵵ ����(8����Ʈ)
		DW		512			; 1���� ũ��(512�� �ؾ� ��)
		DB		1			; Ŭ������ ũ��(1���ͷ� �ؾ� ��)
		DW		1			; FAT�� ��𿡼� ���۵ɱ�(������ 1����°����)
		DB		2			; FAT ����(2�� �ؾ� ��)
		DW		224			; ��Ʈ ���丮 ������ ũ��(������ 224��Ʈ���� �Ѵ�)
		DW		2880			; ����̺� ũ��(2880���ͷ� �ؾ� ��)
		DB		0xf0			; �̵�� Ÿ��(0xf0�� �ؾ� ��)
		DW		9			; FAT������ ����(9���ͷ� �ؾ� ��)
		DW		18			; 1Ʈ���� ��� ���Ͱ� ������(18�� �ؾ� ��)
		DW		2			; ��� ��(2�� �ؾ� ��)
		DD		0			; ��Ƽ���� ������� �ʱ� ������ ����� �ݵ�� 0
		DD		2880			; ����̺� ũ�⸦ �ѹ� �� write
		DB		0,0,0x29		; �� ������ �� ������ �� �θ� ���� �� ����
		DD		0xffffffff		; �Ƹ�, ���� �ø��� ��ȣ
		DB		"HARIBOTEOS "		; ��ũ �̸�(11����Ʈ)
		DB		"FAT12   "		; ���� �̸�(8����Ʈ)
		RESB	18				; �켱 18����Ʈ�� ��� �д�

; ���α׷� ��ü

entry:
		MOV		AX, 0			; �������� �ʱ�ȭ
		MOV		SS,AX
		MOV		SP,0x7c00
		MOV		DS,AX

; ��ũ�� �д´�

		MOV		AX,0x0820
		MOV		ES,AX
		MOV		CH, 0			; �Ǹ��� 0
		MOV		DH, 0			; ��� 0
		MOV		CL, 2			; ���� 2
		MOV		BX, 18*2*CYLS-1		; �о���̰� ���� �հ� ���ͼ�
		CALL	readfast			; ���� read

; �� �о����Ƿ� haribote.sys�� �����̴�!

		MOV		BYTE [0x0ff0], CYLS	; IPL�� ������ �о������� �޸�
		JMP		0xc200

error:
		MOV		AX,0
		MOV		ES,AX
		MOV		SI,msg
putloop:
		MOV		AL,[SI]
		ADD		SI, 1			; SI�� 1�� ���Ѵ�
		CMP		AL,0
		JE		fin
		MOV		AH, 0x0e		; �� ���� ǥ�� ���
		MOV		BX, 15			; Į�� �ڵ�
		INT		0x10			; ���� BIOS ȣ��
		JMP		putloop
fin:
		HLT					; �����ΰ� ���� ������ CPU�� ������Ų��
		JMP		fin			; endless loop
msg:
		DB		0x0a, 0x0a		; ������ 2��
		DB		"load error"
		DB		0x0a			; ����
		DB		0

readfast:	; AL�� ����� ������ �� ������ �о��
;	ES:read ����, CH:�Ǹ���, DH:���, CL:����, BX:read ���ͼ�

		MOV		AX, ES			; < ES�κ��� AL�� �ִ�ġ�� ��� >
		SHL		AX, 3			; AX�� 32�� ������, �� ����� AH�� ���� ���� �ȴ� (SHL�� left shift ����)
		AND		AH, 0x7f		; AH�� AH�� 128�� ���� ������(512*128=64 K)
		MOV		AL, 128			; AL = 128 - AH; ���� ����� 64KB������ �� �ִ� ����
		SUB		AL,AH

		MOV		AH, BL			; < BX�κ��� AL�� �ִ�ġ�� AH�� ��� >
		CMP		BH, 0			; if (BH ! = 0) { AH = 18; }
		JE		.skip1
		MOV		AH,18
.skip1:
		CMP		AL, AH			; if (AL > AH) { AL = AH; }
		JBE		.skip2
		MOV		AL,AH
.skip2:

		MOV		AH, 19			; < CL�κ��� AL�� �ִ�ġ�� AH�� ��� >
		SUB		AH, CL			; AH = 19 - CL;
		CMP		AL, AH			; if (AL > AH) { AL = AH; }
		JBE		.skip3
		MOV		AL,AH
.skip3:

		PUSH	BX
		MOV		SI, 0			; ���� ȸ���� ���� ��������
retry:
		MOV		AH, 0x02		; AH=0x02 : ��ũ read
		MOV		BX,0
		MOV		DL, 0x00		; A����̺�
		PUSH	ES
		PUSH	DX
		PUSH	CX
		PUSH	AX
		INT		0x13			; ��ũ BIOS ȣ��
		JNC		next			; ������ �Ͼ�� ������ next��
		ADD		SI, 1			; SI�� 1�� ���Ѵ�
		CMP		SI, 5			; SI�� 5�� ��
		JAE		error			; SI >= 5 ��� error��
		MOV		AH,0x00
		MOV		DL, 0x00		; A����̺�
		INT		0x13			; ����̺��� ����Ʈ
		POP		AX
		POP		CX
		POP		DX
		POP		ES
		JMP		retry
next:
		POP		AX
		POP		CX
		POP		DX
		POP		BX			; ES�� ������ BX�� �޴´�
		SHR		BX, 5			; BX�� 16����Ʈ �������� 512����Ʈ ������
		MOV		AH,0
		ADD		BX, AX			; BX += AL;
		SHL		BX, 5			; BX�� 512����Ʈ �������� 16����Ʈ ������
		MOV		ES, BX			; �̰����� ES += AL * 0x20; �� �ȴ�
		POP		BX
		SUB		BX,AX
		JZ		.ret
		ADD		CL, AL			; CL�� AL�� ���Ѵ�
		CMP		CL, 18			; CL�� 18�� ��
		JBE		readfast		; CL <= 18 �̶�� readfast��
		MOV		CL,1
		ADD		DH,1
		CMP		DH,2
		JB		readfast		; DH < 2 ��� readfast��
		MOV		DH,0
		ADD		CH,1
		JMP		readfast
.ret:
		RET

		RESB	0x7dfe-$			; 0x7dfe������ 0x00�� ä��� ����

		DB		0x55, 0xaa

		JE		fin
		MOV		AH, 0x0e		; 한 글자 표시 Function
		MOV		BX, 15			; 컬러 코드
		INT		0x10			; 비디오 BIOS 호출 (인터럽트 추후 설명 예정)
		JMP		putloop
fin:
		HLT					; 무엇인가 있을 때까지 CPU를 정지(대기상태)
		JMP		fin			; Endless Loop

msg:
		DB		0x0a, 0x0a		; 개행을 2개
		DB		"hello, world"
		DB		0x0a			; 개행
		DB		0

		RESB	0x7dfe-$			; 0x7dfe까지를 0x00로 채우는 명령

		DB		0x55, 0xaa

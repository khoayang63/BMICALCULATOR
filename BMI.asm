include 'emu8086.inc'      

.MODEL SMALL
.stack 100h
.data 

MUC1 db 'Thieu can: BMI < 18.5$'
MUC2 db 'Du can: 18.5 <= BMI < 25$'
MUC3 db 'Thua can: BMI >= 25$'   
MSZ db 'Chi so BMI cua ban la: $'
MSA db ' ==================== WELCOME TO OUR PROJECT ====================$' 
MSB db ' ******************** May tinh BMI ********************$'
MSD db ' Nhap chieu cao(cm): $'
MSE db ' Nhap can nang(kg): $'
MSF db ' "Ban dang bi thua can"$'
MSG db ' "Can nang cua ban hoan hao"$'
MSH db ' "Ban dang bi thieu can"$'
MSI db ' Ban nen: $'
MSK1 db ' " 1. An nhieu hon va ngu du 8 tieng moi ngay."$'
MSK2 db ' " 2. Bo sung thuc pham giau calo (khoai tay, gao lut, uc ga, dau ga, hanh nhan, khoai lang, v.v.)"$'
MSK3 db ' " 3. Uong it nhat 2 lit nuoc moi ngay."$'
MSK4 db ' " 4. An rau xanh, uong 1 ly sua va 1 qua trung moi ngay."$'

MSL1 db ' " 1. Co gang tuan thu che do an lanh manh, it calo."$'
MSL2 db ' " 2. An nhieu dam, rau cu va tranh do an nhanh."$'
MSL3 db ' " 3. Tap the duc de giam can (di bo, chay bo, gap bung, nhay day)."$'

MSN db ' Chuc mung..! Hay tiep tuc phat huy.$'

MSM1 db ' " Nhan 1 de tinh lai chi so BMI."$'
MSM2 db ' " Nhan 2 de THOAT."$'
MSM3 db '          ********CAM ON BAN********$'
MSM4 db ' " Nhan phim bat ky de tiep tuc...."$'

INVALIDINPUT db "Nhap sai..! Vui long thu lai..!$"
RANDOMBUTTON db "Nhan nut bat ki de tiep tuc......$"

nl db 13,10,13,10,'$'
  
str1 db 5 dup ('$')
str2 db 5 dup ('$') 
weight dw ? 
height dw ? 
bmi dw ?
rem dw ?  
status dw ?

.code

main proc
    START:
        call CLEAR_SCREEN
        call INTRO
        call WEIGHTHEIGHT
        call CAlCBMI  
        call INSTRUCTION

        WANNATRYAGAIN:
            call ENDING
            mov ah, 1
            int 21h  
            cmp al, '1'
            je START   
            cmp al, '2'
            je ENDMAIN 
            ;nhan nut khong hop le 
            gotoxy 22,15
            mov ah, 9   
            lea dx, INVALIDINPUT
            int 21h     
            jmp WANNATRYAGAIN
        
    
    ENDMAIN: 
    call CLEAR_SCREEN  
    ;thong bao cam on  
    gotoxy 16,10
    mov ah, 9
    lea dx, MSM3
    int 21h 
    mov ah, 4ch
    int 21h 
main endp  


INTRO proc
    ;thong bao      
    mov ax, @data
    mov ds, ax
    
    lea dx, MSA
    gotoxy 6,1
    mov ah, 9
    int 21h 

    ;cho contro den vi tri 11,3
    gotoxy 11,3
    lea dx, MSB
    int 21h
    
    gotoxy 7,5
    lea dx, MUC1
    int 21h
    
    gotoxy 7,7
    lea dx, MUC2
    int 21h
    
    gotoxy 7,9
    lea dx, MUC3
    int 21h  
    
    lea dx, nl
    int 21h
    
    xor ax, ax
    xor bx, bx
    xor cx, cx
    xor dx, dx
    
    ret
INTRO endp   

WEIGHTHEIGHT proc   
    gotoxy 6,11
    mov ah, 9 
    lea dx, MSD
    int 21h            
    
    ;nhap chieu cao bang chuoi
    mov ah, 10
    lea dx, str1
    int 21h
    
    call STR1toINT   
    ;cho vao bien height
    mov height, ax 
    
    mov ah, 9
    lea dx, nl
    int 21h
    
    gotoxy 6,13 
    lea dx, MSE
    int 21h        
    
    ;giong nhu tren
    mov ah, 10
    lea dx, str2
    int 21h
    
    call STR2toINT 
    mov weight, ax   
    ret
WEIGHTHEIGHT endp   

; 2 ham duoi de chuyen xau sang so thap phan
STR1toINT proc
    mov cl, [str1+1]

    lea si, str1+2  
    mov ax, 0
    mov bx, 10
    
    thapphan:
       mul bx
       mov dl, [si]
       sub dl, '0'
       add ax, dx
       inc si
       dec cl
       jnz thapphan    
    ret
STR1toINT endp  

STR2toINT proc
    mov cl, [str2+1]

    lea si, str2+2  
    mov ax, 0
    mov bx, 10
    
    thapphan1:
       mul bx
       mov dl, [si]
       sub dl, '0'
       add ax, dx
       inc si
       dec cl
       jnz thapphan1      
    ret
STR2toINT endp    

;tinh chi so bmi
CALCBMI proc  
    mov ah, 9
    lea dx, nl
    int 21h  
    xor dx,dx
    ;bmi = w*10000/(h*h)
    
    mov ax, height
    mul ax
    mov cx, ax

    mov ax, weight
    mov dx, 0
    mov bx, 10000
    mul bx
    
    div cx  
    mov bmi, ax
    
    ;tinh phan thap phan   
    ;lay phan du trong dx luu vao ax,sau *10 roi chia cho h*h luu o cx  
    mov ax, dx
    mov bx, 10
    mul bx   
    div cx 
    mov rem, ax
    
    call PRINTBMI
    ; nho hon 18 thi thieucan 
    mov ax, bmi  
    cmp ax, 18 
    jl UNDERWEIGHT
    
    ; lon hon = 25 thi thua can
    mov ax, bmi
    cmp ax, 25
    jge OVERWEIGHT
    
    ; 19 <= bmi < 25
    mov ax, bmi
    cmp ax, 18
    jg PERFECT  
        
    ;so sanh phan du voi 5 
    mov ax, rem
    cmp ax, 5
    jl UNDERWEIGHT
    
    PERFECT:
        mov status, 2
        gotoxy 6,17   
        mov ah, 9
        lea dx, MSG  
        int 21h
        jmp ENDBMI
    
    UNDERWEIGHT:  
        gotoxy 6,17 
        mov status, 1  
        mov ah, 9
        lea dx, MSH  
        int 21h
        jmp ENDBMI
        
    OVERWEIGHT:   
        gotoxy 6,17 
        mov status, 3 
        mov ah, 9
        lea dx, MSF 
        int 21h
        jmp ENDBMI
    
    
    ENDBMI: 
    ret
CALCBMI endp 

PRINTBMI proc 
    
    ;Chi so bmi cua ban la: 
    gotoxy 7,15
    mov ah, 9
    lea dx, MSZ
    int 21h                

    ; xoa phan high dx:ax  
    xor dx, dx
    mov ax, bmi
    mov bx, 10
    div bx
    
    ;luu phan du sang cx
    mov cx, dx          
    
    mov dx, ax 
    ;neu dx bang 0 nghia la bmi chi co 1 chu so
    cmp dx, 0
    je PRINTDONVI
    
    add dx, '0'
    mov ah, 2 
    int 21h
    
    PRINTDONVI:
    mov ah, 2
    mov dx, cx
    add dx, '0'
    int 21h    
    
    mov dl, '.'
    int 21h
    
    mov dx, rem   
    add dx, '0'
    int 21h
    
    mov ah, 9
    lea dx, nl
    int 21h
    
    ret
PRINTBMI endp

;loi khuyen
INSTRUCTION proc    
    mov ax, status
    cmp ax, 3
    je INSTRUCTION2
    cmp ax, 1
    je INSTRUCTION1
    
    mov ah, 9 
    lea dx, nl
    int 21h
    lea dx, MSN
    int 21h
    jmp ENDINSTRUCTION
    
    ; thieu can
    INSTRUCTION1:  
        mov ah, 9   
        lea dx, nl
        int 21h
        lea dx, MSI 
        int 21h
        lea dx, nl
        int 21h
        lea dx, MSK1
        int 21h  
        lea dx, nl
        int 21h
        lea dx, MSK2
        int 21h  
        lea dx, nl
        int 21h
        lea dx, MSK3
        int 21h  
        lea dx, nl
        int 21h  
        lea dx, MSK4
        int 21h  
        lea dx, nl
        int 21h  
        jmp ENDINSTRUCTION
    ; beo
    INSTRUCTION2:  
        mov ah, 9  
        lea dx, nl   
        int 21h   
        lea dx, MSI
        int 21h
        lea dx, nl
        int 21h
        lea dx, MSL1
        int 21h  
        lea dx, nl
        int 21h
        lea dx, MSL2
        int 21h  
        lea dx, nl
        int 21h
        lea dx, MSL3
        int 21h  
        lea dx, nl
        int 21h
    
    ENDINSTRUCTION: 
    
    mov ah, 9
    lea dx, nl
    int 21h
    mov ah, 9
    lea dx, RANDOMBUTTON
    int 21h
    mov ah, 7
    int 21h  
    call CLEAR_SCREEN  
    ret
INSTRUCTION ENDP   

;in thong bao ket thuc
ENDING proc
    gotoxy 20,10
    mov ah, 9
    lea dx, MSM1
    int 21h
    lea dx, nl
    int 21h
    gotoxy 20,12
    lea dx, MSM2
    int 21h
    lea dx, nl
    int 21h
    ret
ENDING endp

DEFINE_CLEAR_SCREEN

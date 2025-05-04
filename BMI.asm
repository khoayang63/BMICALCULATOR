include 'emu8086.inc'      

.MODEL SMALL
.stack 100h
.data
MUC1 db 'Thieu can: BMI < 19$'
MUC2 db 'Du can: 19 <= BMI < 25$'
MUC3 db 'Thua can: BMI > 25$'
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

INVALIDINPUT db "Nhap sai..! Vui long thu lai..!"


nl db 13,10,13,10,'$'
  
str1 db 5 dup ('$')
str2 db 5 dup ('$') 
weight dw ? 
height dw ? 
bmi dw ?

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
            mov ah, 9   
            lea dx, nl
            int 21h
            lea dx, INVALIDINPUT
            int 21h
            jmp WANNATRYAGAIN
        
    
    ENDMAIN:    
    mov ah, 4ch
    int 21h 
main endp  


INTRO proc
    ;thong bao      
    mov ax, @data
    mov ds, ax
    
    lea dx, MSA
    mov ah, 9
    int 21h 
    lea dx, nl
    int 21h 
    
    lea dx, MSB
    int 21h
    
    lea dx, nl
    int 21h  
    
    lea dx, MUC1
    int 21h
    lea dx, nl
    int 21h
    
    lea dx, MUC2
    int 21h
    lea dx, nl
    int 21h
    
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
    cmp ax, 19 

    
    jl UNDERWEIGHT
    
    cmp ax, 25
    jge OVERWEIGHT
    
    
    PERFECT:    
        mov ah, 9
        lea dx, MSG  
        int 21h
        jmp ENDBMI
    
    UNDERWEIGHT:   
        mov ah, 9
        lea dx, MSH  
        int 21h
        jmp ENDBMI
        
    OVERWEIGHT:    
        mov ah, 9
        lea dx, MSF 
        int 21h
        jmp ENDBMI
    
    
    ENDBMI: 
    ret
CALCBMI endp 

;loi khuyen
INSTRUCTION proc    
    mov ax, bmi
    cmp ax, 25
    jge INSTRUCTION2
    cmp ax, 19
    jl INSTRUCTION1
    
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
    ret
INSTRUCTION ENDP   

;in thong bao ket thuc
ENDING proc
    mov ah, 9
    lea dx, MSM1
    int 21h
    lea dx, nl
    int 21h
    lea dx, MSM2
    int 21h
    lea dx, nl
    int 21h
    lea dx, MSM3
    int 21h
    lea dx, nl
    int 21h
    lea dx, MSM4
    int 21h
    lea dx, nl
    int 21h
    ret
ENDING endp

DEFINE_CLEAR_SCREEN

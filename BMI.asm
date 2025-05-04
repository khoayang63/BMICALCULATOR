include 'emu8086.inc'      

.MODEL SMALL
.stack 100h
.data 
MSA DB ' ==================== WELCOME TO OUR PROJECT ====================$' 
MSB DB ' ******************** BMI CALCULATOR ********************$'
MSD DB ' Input your height in cm: $'
MSE DB ' Input your weight in kg: $'
MSF DB ' "Your weight is: overweight"$'
MSG DB ' "Your weight is: perfect"$'
MSH DB ' "Your weight is: underweight"$'
MSI DB ' "Press 1 to see the instruction if you are underweight"$'
MSJ DB ' "Press 2 to see the instruction if you are overweight" $'

MSK1 DB ' " 1.Eat more and sleep 8 hours a day."$'
MSK2 DB ' " 2.Absorb high calorie food (potato, brown rice, chicken breast, check peas, almond, sweet potato etc.)"$'
MSK3 DB ' " 3.Drink at least 2L water per day."$'
MSK4 DB ' " 4.Eat vegetables and 1 glass of milk and 1 whole egg each day."$'

MSL1 DB ' " 1.Try to follow a low calorie healthy diet."$'
MSL2 DB ' " 2.Eat high protein, vegetables and avoid fast food."$'
MSL3 DB ' " 3.Do some workout for weight lose (walking, running, crunching, ropping )."$' 

MSN DB ' Congratulation,..! Keep it up.$'

MSM1 DB ' " Press 1 to Recalculate."$'
MSM2 DB ' " Press 2 to EXIT."$' 
MSM3 DB '          ********THANK YOU********$'
MSM4 DB ' " Press any key to continue...."$'

NL DB 13,10,13,10,'$'

SUM DW 0  
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
        call ENDING
        
        mov ah, 1
        int 21h  
        cmp al, '1'
        je START
        
    mov ah, 4ch
    int 21h 
main endp  


INTRO proc     
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
    
    ;nhap so bang chuoi
    mov ah, 10
    lea dx, str1
    int 21h
    
    call STR1toINT
    mov height, ax 
      
    mov ah, 9
    lea dx, nl
    int 21h
    
    lea dx, MSE
    int 21h     

    mov ah, 10
    lea dx, str2
    int 21h
    
    call STR2toINT 
    mov weight, ax   
    ret
WEIGHTHEIGHT endp   


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
    cmp ax, 18 
    mov bmi, ax
    
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
    mov ah, 9
    lea dx, nl
    int 21h  
    ret
CALCBMI endp 

INSTRUCTION proc    
    mov ax, bmi
    cmp ax, 25
    jge CHOOSEBUTTON
    cmp ax, 18
    jl CHOOSEBUTTON
    
    mov ah, 9 
    lea dx, MSN
    int 21h
    jmp ENDINSTRUCTION
    
    CHOOSEBUTTON:
      
    mov ah, 9  
    lea dx, nl
    int 21h
    
    lea dx, MSI
    int 21h
    
    lea dx, nl
    int 21h
    
    lea dx, MSJ
    int 21h
    
    lea dx, nl
    int 21h
    
    mov ah, 1
    int 21h
    
    cmp al, '1'
    
    jne INSTRUCTION2
    
    INSTRUCTION1:
        mov ah, 9
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
    
    INSTRUCTION2:  
        mov ah, 9  
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
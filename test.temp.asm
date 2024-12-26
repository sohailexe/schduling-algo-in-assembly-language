INCLUDE c:\Users\Administrator\.vscode\extensions\istareatscreens.masm-runner-0.4.5\native\irvine\Irvine32.inc

pushRegs MACRO
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi
ENDM ;pushRegs

popRegs MACRO
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
ENDM
printReg MACRO reg
push eax
mov eax, reg
call WriteDec
printSpace
pop eax
ENDM ;printReg

swap MACRO loc1, loc2
pushRegs
mov eax, loc1
mov ebx, loc2
mov ecx, [eax]
mov edx, [ebx]
mov [eax], edx
mov [ebx], ecx
popRegs
ENDM ;swap

printSpace MACRO
    push eax
    mov eax, ' '
    call WriteChar
    pop eax
ENDM ;printSpace

printArray MACRO arr, size
pushRegs
mov ecx, size
mov esi, arr
mov edi, 0

printLoop:

    mov eax, arr[0 + edi * 4]
    call WriteDec
    printSpace
    inc edi
    loop printLoop

popRegs

ENDM ;printArray


sortArray MACRO arr, n
pushRegs
mov ecx, n
dec ecx
mov ebx, ecx
outerLoop:
    push ecx
    mov edi , ecx
    dec edi
    innerLoop:
        mov eax, arr[edi * 4] ;j
        cmp eax , arr[ebx * 4]
        jng noSwap
        ; printReg ebx
        ; printReg edi
        ; printSpace

        ; swap
        push ebx
        lea eax, arr[ebx * 4]
        lea ebx, arr[edi * 4]
        swap eax, ebx
        pop ebx

        noSwap:
        dec edi
    loop innerLoop
    dec ebx
    call Crlf
    pop ecx
loop outerloop

popRegs
ENDM  ;sort array

.data
    arrivalTimes DWORD 3,5, 11, 2       ; Arrival times array
    count DWORD 0
    temp DWORD 0 
    a DWORD 0
    b DWORD 0  
    largest DWORD 0                       ; Number of elements in the array
                        ; Number of elements in the array
    arr DWORD 4,3,2,1,5,6,7,8,9,10
    arrSize DWORD 10 ; Arrival times array
.code


main PROC
    ; mov ebx, arr[1 * TYPE arr]
    sortArray arr, arrSize
    printArray arr, arrSize

    exit
main ENDP
END main




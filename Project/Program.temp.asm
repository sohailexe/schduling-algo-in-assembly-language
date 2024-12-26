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
ENDM ;popRegs

printReg MACRO reg
push eax
mov eax, reg
call WriteDec
printSpace
pop eax
ENDM ;printReg

printString MACRO msg
    push edx
   mov edx, OFFSET msg
   call WriteString
   call Crlf
   pop edx
ENDM ;PrintString

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

printArray MACRO arr, arrSize
pushRegs
mov ecx, arrSize
mov esi, arr
mov edi, 0
mov esi, OFFSET arr
call printArrayLoopLabel
popRegs
ENDM ;printArray

readArray MACRO arr, n, msg
pushRegs
    printString msg
    mov ecx, n
    mov edi, 0
    mov esi, OFFSET arr
    call readArrayLoopLabel
popRegs
ENDM

sortArray MACRO arr, n
pushRegs
mov ecx, n
dec ecx
mov ebx, ecx
mov esi, OFFSET arr
call sortArrayLoops
popRegs
ENDM  ;sort array


.data
    processCount DWORD 4               ; Number of processes
    listArrivalTimes DWORD 4 DUP(0)       ; Arrival times
    listBurstTimes DWORD 4 DUP(0)         ; Burst times


     msgInputArrivalTime byte "Enter the arrival times for process ", 0
     msgInputBurstTime byte "Enter the arrival times for process ", 0

    msgSpace BYTE " ", 0
    arr DWORD 10,5,16,1      ; Arrival times

.code
main PROC 
    ;Take input from user
    readArray listArrivalTimes, processCount, msgInputArrivalTime
    printArray listArrivalTimes, processCount

    readArray listBurstTimes, processCount, msgInputBurstTime
    printArray listBurstTimes, processCount

    sortArray listArrivalTimes, processCount
    sortArray listBurstTimes, processCount

    ; printArray arr, processCount
    printArray listArrivalTimes, processCount
    call Crlf
    printArray listBurstTimes, processCount

    exit
readArrayLoopLabel PROC
    readArrayLoop:
     call readInt
     mov [esi + edi*4], eax
     inc edi
     loop readArrayLoop
ret
readArrayLoopLabel ENDP

sortArrayLoops PROC 
    outerLoop:
    push ecx
    mov edi , ecx
    dec edi
    innerLoop:
        mov eax, [esi + edi *4 ] ;esi[edi * 4] ;j
        cmp eax ,[esi + ebx *4 ] ; esi[ebx * 4]
        jng noSwap
        ; printReg ebx
        ; printReg edi
        ; printSpace
        ; swap
        push ebx
        lea eax, [esi + ebx *4 ];esi[ebx * 4]
        lea ebx, [esi + edi *4 ];esi[edi * 4]
        swap eax, ebx
        pop ebx

        noSwap:
        dec edi
    loop innerLoop
    dec ebx
    call Crlf
    pop ecx
loop outerloop
ret
sortArrayLoops ENDP

printArrayLoopLabel PROC

    loopLabel:
    mov eax, [esi + edi * 4]
    call WriteDec
    printSpace
    inc edi
    loop loopLabel
ret
printArrayLoopLabel ENDP
main ENDP     
END main

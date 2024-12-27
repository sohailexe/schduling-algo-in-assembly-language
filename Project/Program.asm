INCLUDE Irvine32.inc

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


printChar MACRO char
push eax
mov eax, char
 call writeChar
printSpace
pop eax
ENDM ;
printString MACRO msg
    push edx
   mov edx, OFFSET msg
   call WriteString
   
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
    call Crlf

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

sortArray MACRO arr, n, processOrder, burstTimes
pushRegs
mov ecx, n
dec ecx
mov ebx, ecx
mov esi, OFFSET arr
push OFFSET burstTimes
push OFFSET processOrder
call sortArrayLoops
popRegs
ENDM  ;sort array


composeString MACRO processNumber , arrivalTime, burstTime
    ; push edx
   printString strProcess
   printReg processNumber
   printChar '|'
   printString strArrivalTime
   printReg arrivalTime
   printChar '|'
   printString strBurstTime
   printReg burstTime
   call Crlf
    ; pop edx
ENDM ;composeString

printArrayWithComposeString MACRO arr1, arr2, arr3, sizeOfArray,lebel
    pushRegs
    mov ecx, sizeOfArray
    mov edi, 0
lebel:
    composeString [arr1 + edi * 4], [arr2 + edi * 4], [arr3 + edi * 4]
    inc edi
    dec ecx
    jnz lebel
    popRegs
ENDM

.data
    processCount DWORD 4               ; Number of processes
    listArrivalTimes DWORD 4 DUP(0)       ; Arrival times
    listBurstTimes DWORD 4 DUP(0)         ; Burst times


     msgInputArrivalTime byte "Enter the arrival times for process ", 0
     msgInputBurstTime byte "Enter the arrival times for process ", 0
     msgAfterSorting byte "*******AFTER SORTING WITH RESPECT TO ARRIVAL TIME******* ",0

     strProcess byte "Process ",0
     strArrivalTime byte "Arrival-Time ",0
     strBurstTime byte "Burst-Time ",0

    msgSpace BYTE " ", 0
    arr DWORD 10,5,16,1      ; Arrival times
    processOrder DWORD 1,2,3,4

.code
main PROC 
    call takeInput
    call printBeforeAndAfterSorting

    ; printArray listArrivalTimes, processCount
    ; printArray processOrder, processCount
    ; printArray listBurstTimes, processCount


    exit

takeInput PROC
    readArray listArrivalTimes, processCount, msgInputArrivalTime
    printArray listArrivalTimes, processCount

    readArray listBurstTimes, processCount, msgInputBurstTime
    printArray listBurstTimes, processCount

    ret
takeInput ENDP

printBeforeAndAfterSorting proc
    printArrayWithComposeString processOrder, listArrivalTimes ,listBurstTimes, processCount,leb12
    sortArray listArrivalTimes, processCount, processOrder, listBurstTimes
    call Crlf
    printString msgAfterSorting
    call Crlf
    call Crlf
    printArrayWithComposeString processOrder, listArrivalTimes ,listBurstTimes, processCount,leb01
ret
printBeforeAndAfterSorting endp

readArrayLoopLabel PROC
    readArrayLoop:
     call readInt
     mov [esi + edi*4], eax
     inc edi
     loop readArrayLoop
ret
readArrayLoopLabel ENDP

sortArrayLoops PROC 
    push ebp
    mov ebp, esp

    outerLoop:
    push ecx
    mov edi, ecx
    dec edi

    innerLoop:
        mov eax, [esi + edi * 4] ; esi[edi * 4] ; j
        cmp eax, [esi + ebx * 4] ; esi[ebx * 4]
        jng noSwap

        ; Swap
        push ebx
        lea eax, [esi + ebx * 4] ; esi[ebx * 4]
        lea ebx, [esi + edi * 4] ; esi[edi * 4]
        swap eax, ebx
        pop ebx

        ; Process order
        push esi
        push ebx
        mov esi, [ebp + 8]
        lea eax, [esi + ebx * 4] ; esi[ebx * 4]
        lea ebx, [esi + edi * 4] ; esi[edi * 4]
        swap eax, ebx
        pop ebx
        pop esi

        ; Burst times
        push esi
        push ebx
        mov esi, [ebp + 12]
        lea eax, [esi + ebx * 4] ; esi[ebx * 4]
        lea ebx, [esi + edi * 4] ; esi[edi * 4]
        swap eax, ebx
        pop ebx
        pop esi

    noSwap:
        dec edi
        dec ecx
        jnz innerLoop

    dec ebx
    pop ecx
    dec ecx
    jnz outerLoop

    pop ebp
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

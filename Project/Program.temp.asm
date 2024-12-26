INCLUDE c:\Users\Administrator\.vscode\extensions\istareatscreens.masm-runner-0.4.5\native\irvine\Irvine32.inc

PrintString MACRO msg
   mov edx, OFFSET msg
   call WriteString
   call Crlf
ENDM

PrintArray MACRO arrayName, arraySize
   LOCAL index
   mov esi, OFFSET arrayName
   mov ecx, arraySize
   Lp:
      mov eax, [esi]
      call WriteInt
      add esi, 4
      loop Lp
   call Crlf
ENDM

moval  MACRO p1, val
    push eax
    mov eax , val
    mov [p1], eax
    pop eax
ENDM

SortArray MACRO arrayName, arraySize
    outerIndex DWORD ?
     innerIndex DWORD ?
     temp DWORD ?
   mov ecx, arraySize
   dec ecx
   mov esi, OFFSET arrayName
   moval outerIndex, 0
   L1:
        moval innerIndex, 0
      L2:
      push ebx
         mov ebx, innerIndex
         mov eax, [esi + ebx * 4]
         inc ebx
         cmp eax, [esi + (ebx) * 4]
         pop ebx
         jle L3
         push ebx
         mov ebx, innerIndex
         mov eax, [esi + ebx * 4]
         pop ebx
          moval temp, eax
;          mov temp, eax
         push ebx
         mov ebx, innerIndex
         inc ebx
         mov eax, [esi + (ebx) * 4]
         dec ebx
         mov [esi + ebx * 4], eax
         pop ebx
         mov eax, temp
         push ebx
         mov ebx, innerIndex
         inc ebx
         mov [esi + (ebx) * 4], eax
         pop ebx
      L3:
         inc innerIndex
         loop L2
      inc outerIndex
      loop L1
ENDM

.data
    processCount DWORD 4               ; Number of processes
    listArrivalTimes DWORD 4 DUP(0)       ; Arrival times
    listBurstTimes DWORD 4 DUP(0)         ; Burst times
    
    ; completionTime DWORD 4 DUP(0)   
    ; waitingTimes DWORD 4 DUP(0)         ; Array for waiting times
    ; turnaroundTimes DWORD 4 DUP(0)      ; Array for turnaround times
    ; totalWaitingTime DWORD 0            ; Total waiting time
    ; totalTurnaroundTime DWORD 0
     
     count DWORD 0;         ; Total turnaround time


     msgInputArrivalTime byte "Enter the arrival times for process ", 0
     msgInputBurstTime byte "Enter the arrival times for process ", 0


    ; msgProcess BYTE "Process ", 0
    ; msgArrival BYTE "Arrival Time: ", 0
    ; msgBurst BYTE "Burst Time: ", 0
    ; msgWaiting BYTE "Waiting Time: ", 0
    ; msgTurnaround BYTE "Turnaround Time: ", 0
    ; msgTotalWaiting BYTE "Total Waiting Time: ", 0
    ; msgTotalTurnaround BYTE "Total Turnaround Time: ", 0
    msgSpace BYTE " ", 0
    arr DWORD 10,5,16,9       ; Arrival times

.code
main PROC 
    SortArray arr, 4

   PrintArray arr, 4
    exit

; Take input from user
TakeInput proc 
    ; input arrival times
    push OFFSET msgInputArrivalTime
    push OFFSET listArrivalTimes
    call ReadArray
    push OFFSET listArrivalTimes
    call WriteArray

    ; input Burst times
    push OFFSET msgInputBurstTime
    push OFFSET listBurstTimes
    call ReadArray
    push OFFSET listBurstTimes
    call WriteArray
    ret
TakeInput ENDP

; Read array
ReadArray PROC
push ebp
mov ebp, esp
    mov esi, [ebp + 8]  
    mov edx,  [ebp+12]
     call WriteString

    mov ecx, processCount
    mov count, 0
    L:
     mov ebx,count
     call readInt
     mov [esi + ebx * 4], eax
     inc count
     loop L
pop ebp
ret
ReadArray ENDP

; Write array
WriteArray PROC
push ebp
mov ebp, esp
    mov esi, [ebp + 8]    
    mov ecx, processCount
    mov count, 0
         ; mov edx,  [ebp+8]
     ; call WriteString
    L:
     mov ebx,count
     mov eax ,[esi + ebx * 4]
     call WriteDec
     
     mov edx, OFFSET msgSpace
     call WriteString
     inc count
     loop L
     call Crlf
pop ebp
ret
WriteArray ENDP



_test PROC 
   mov eax, 1
   call WriteInt
   ret
_test ENDP

main ENDP     
END main

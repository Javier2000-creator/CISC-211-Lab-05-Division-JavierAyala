/*** asmFunc.s   ***/
/* Tell the assembler to allow both 16b and 32b extended Thumb instructions */
.syntax unified

#include <xc.h>

/* Tell the assembler that what follows is in data memory    */
.data
.align
@ Define the globals so that the C code can access them
/* define and initialize global variables that C can access */
/* create a string */
.global nameStr
.type nameStr,%gnu_unique_object
    
/*** STUDENTS: Change the next line to your name!  **/
nameStr: .asciz "Javier Ayala"  

.align   /* realign so that next mem allocations are on word boundaries */
 
/* initialize a global variable that C can access to print the nameStr */
.global nameStrPtr
.type nameStrPtr,%gnu_unique_object
nameStrPtr: .word nameStr   /* Assign the mem loc of nameStr to nameStrPtr */
 
/* define and initialize global variables that C can access */

.global dividend,divisor,quotient,mod,we_have_a_problem
.type dividend,%gnu_unique_object
.type divisor,%gnu_unique_object
.type quotient,%gnu_unique_object
.type mod,%gnu_unique_object
.type we_have_a_problem,%gnu_unique_object

/* NOTE! These are only initialized ONCE, right before the program runs.
 * If you want these to be 0 every time asmFunc gets called, you must set
 * them to 0 at the start of your code!
 */
dividend:          .word     0  
divisor:           .word     0  
quotient:          .word     0  
mod:               .word     0 
we_have_a_problem: .word     0

 /* Tell the assembler that what follows is in instruction memory    */
.text
.align

    
/********************************************************************
function name: asmFunc
function description:
     output = asmFunc ()
     
where:
     output: 
     
     function description: The C call ..........
     
     notes:
        None
          
********************************************************************/    
.global asmFunc
.type asmFunc,%function
asmFunc:   

    /* save the caller's registers, as required by the ARM calling convention */
    push {r4-r11,LR}
 
.if 0
    /* profs test code. */
    mov r0,r0
.endif
    
    /** note to profs: asmFunc.s solution is in Canvas at:
     *    Canvas Files->
     *        Lab Files and Coding Examples->
     *            Lab 5 Division
     * Use it to test the C test code */
    
    /*** STUDENTS: Place your code BELOW this line!!! **************/
    
    /* This stores the input values from r0 which is our dividend 
    and r1 which is out divisor. */
    ldr r2, =dividend
    str r0, [r2]       
    ldr r2, =divisor
    str r1, [r2]       

    /* This initializes quotient and mod to 0. */
    ldr r2, =quotient
    mov r3, #0
    str r3, [r2]
    ldr r2, =mod
    str r3, [r2]

    /* This checks for errors if either the dividend or divisor is zero. */
    cmp r0, #0
    beq error        /*branches to error if dividend is 0*/
    cmp r1, #0
    beq error        /*branches to error if divisor is 0*/   

    /* This initializes the variables for the division loop below */
    mov r3, #0       /*r3 will hold the quotient which is number of times it will subtract*/
    mov r4, r0       /*r4 is the working dividend which gets reduced inside the divion loop*/
    
division_loop:
    cmp r4, r1    /*compares the current dividend with the divisor*/   
    blo final     /*This exits the loop if the dividend is less than the divisor*/    
    sub r4, r4, r1    /*Subtracts the divisor from the dividend*/
    add r3, r3, #1    /*increments the counter(adds 1 each time it loops*/
    b division_loop   /*this repeats the loop*/

final:
    /* This part stores the calculated quotient and mod into r3 and r4 */
    ldr r2, =quotient
    str r3, [r2]      
    ldr r2, =mod
    str r4, [r2]      

    /* This lets us know if there is an error flag*/
    ldr r2, =we_have_a_problem
    mov r3, #0
    str r3, [r2]

    /* This sets r0 to the adress of r2, which is the quotient, before finishing */
    ldr r2, =quotient
    mov r0, r2
    b done

error:
    /* This loop handles errors if the dividend or divisor was 0 */
    ldr r2, =we_have_a_problem
    mov r3, #1        /* sets the error flag to 1 */
    str r3, [r2]
    
    /* This returns the quotients (r2) memory address and moves it into r0 before returning */
    ldr r2, =quotient
    mov r0, r2
    b done
    
    /*** STUDENTS: Place your code ABOVE this line!!! **************/

done:    
    /* restore the caller's registers, as required by the 
     * ARM calling convention 
     */
    mov r0,r0 /* these are do-nothing lines to deal with IDE mem display bug */
    mov r0,r0 /* this is a do-nothing line to deal with IDE mem display bug */

screen_shot:    pop {r4-r11,LR}

    mov pc, lr	 /* asmFunc return to caller */
   

/**********************************************************************/   
.end  /* The assembler will not process anything after this directive!!! */
           





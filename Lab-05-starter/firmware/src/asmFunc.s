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
    
    ldr r2, =dividend
    str r0, [r2]       
    ldr r2, =divisor
    str r1, [r2]       

    /* Initialize quotient and mod to 0 */
    ldr r2, =quotient
    mov r3, #0
    str r3, [r2]
    ldr r2, =mod
    str r3, [r2]

    /* Check for errors (either dividend or divisor is 0) */
    cmp r0, #0
    beq error          
    cmp r1, #0
    beq error           

    /* Division-by-subtraction method */
    mov r3, #0       
    mov r4, r0        
division_loop:
    cmp r4, r1       
    blo final         
    sub r4, r4, r1    
    add r3, r3, #1    
    b division_loop   

final:
    /* Store quotient and mod results */
    ldr r2, =quotient
    str r3, [r2]      
    ldr r2, =mod
    str r4, [r2]      

    /* Clear error flag */
    ldr r2, =we_have_a_problem
    mov r3, #0
    str r3, [r2]

    /* Set r0 to quotient's address */
    ldr r2, =quotient
    mov r0, r2
    b done

error:
    /* Set error flag and return quotient's address */
    ldr r2, =we_have_a_problem
    mov r3, #1
    str r3, [r2]
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
           





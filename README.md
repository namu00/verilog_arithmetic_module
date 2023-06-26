# verilog arithmetic module
> ### *synthesiseable verilog 32-bit integer arithmetic module design space*

+ ### Target Specs  
|Name|Spec|Description|    
|:--:|:--:|:--:|  
|Clock Freq| 50MHz | Only Divider & Multiplier unit dependants clock |  
|Reset Type| Asynchronous <br/> Active-Low| - | 
|Input Size| 32-bit | - |
|Output Size| 32-bit or 64-bit| Only Multiplier Unit has 64-bit output|
|Support Type| Integer| - | 
|Support Format| Signed or Unsigned | - |  


+ ### Directory_Info.  
|Directory|Tag|  
|:---:|:---:|    
|Adder|Addition/Subtraction Hardware directory|  
|Multiplier|Multiplication Hardware directory|  
|Divider|Division Hardware directory|  

--- 
# Multiplier Algorithm
> ### (Multiplier) * (Multiplicand) == (Product)  
  
+ ## Signed Booth Algorithm SD code
|Q|Q-|Action|  
|:---:|:---:|:---| 
|0|0|Right Shift(Signed Extension)|  
|1|1|Right Shift(Signed Extension)|  
|1|0|SUB Multiplier from Accumulator and Right Shift|  
|0|1|ADD Multiplier to Accumulator and Right Shift|  

### Example   
>    Ex) 1101 * 0011 = 1111_0111  
>    (-3) * 3 = (-9)  

| N | Accumulator | Q | Q-|Description|  
|:---:|:---:|:---:|:---:|:---:|    
|Ready|0000|0011|0|Initialize with <br> A = 0, Q = Multiplicand, Q- = 0|    
|1|0011<br>0001|0011<br>1001|0<br>1|SUB 1101 from Accumulator<br>Signed Right Shift|  
|2|0000|1100|1|Right Shift (Signed Ext)|    
|3|1101<br>1110|1100<br>1110|1<br>0|ADD Accumulator to 1101<br>Signed Right Shift|
|4|1111|0111|0|Right Shift (Signed Ext)|

__RESULT__ = __Accumulator + Q__ = __1111_0111__  

+ ## Unsigned Booth Algorithm SD code  
|LSB of Q|Action|  
|:---:|:---:|  
|0|Righ Shift <br> (With Accumulator Carry)|  
|1|ADD Multiplier to Accumulator and Right Shift <br>(With Accumulation Carry)|  

### Example   
>   Ex) 1101 * 0011 = 0010_0111  
>   13 * 3 = 39  

| N | Carry | Accumulator | Q | LSB of Q|Description|  
|:---:|:---:|:---:|:---:|:---:|:---:|   
|Ready|0|0000|0011|1|Initialize with <br> A = 0, Q = Multiplicand, Q- = 0|    
|1|0<br>0|1101<br>0110|0011<br>1001|1<br>1|ADD Accumulator to 1101<br> Shift Right|  
|2|1<br>0|0011<br>1001|1001<br>1100|1<br>0|ADD Accumulator to 1101<br> Shift Right|    
|3|0|0100|1110|0|Shift Right|    
|4|0|0010|0111|1|Shift Right|  

__RESULT__ = __Accumulator__ + __Q__ = __0010_0111__  

--- 
# Divider Algorithm
> ### (Dividend) / (Divisor) == (Quotient) ... (Remainder)  
+ ## Parameter Description
    ### __Main Register: N, Q, M, A__  
        N: Number of bits of dividend
        Q: Quotient
        A: Accumulator, It has (N+1) bit
        M: Divisor
+ ## Restoring Division Flow
1. Initialize with Q = Dividend, M = Divisor, A = 0

2. Shift Left A, Q

3. IF __MSB of A__ == __1__, __Q[0]__ == __0__ and __Restore A__  
ELSE, __Q[0]__ == __1__

4. Counter update as __N = N - 1__

5. IF __N != 0__, Goto __Step 2.__  
ELSE, Goto __Step 6.__

6. __DONE!__ (__Q: Quotient, A: Remainder__)

### Example
>   1111 / 1011 = 0001 ... 0100  
>   (15) / (11) = 1 ... 4

| N | M | A | Q | Description |  
|:--:|:--:|:--:|:--:|:--:|    
|Ready|1011|00000|1111|Initialize|
|4||00001<br>10110<br>00001|1110<br>1110<br>1110|Shift Left A, Q<br>A = A - M<br>Q[0] = 0 and Restore A|  
|3||00011<br>11000<br>00011|1100<br>1100<br>1100|Shift Left A, Q<br>A = A - M<br>Q[0] = 0 and Restore A|  
|2||00111<br>11100<br>00111|1000<br>1000<br>1000|Shift Left A, Q<br>A = A - M<br>Q[0] = 0 and Restore A|
|1||01111<br>00100<br>00100|0000<br>0000<br>0001|Shift Left A, Q<br>A = A - M<br>Q[0] = 1|  
|RESULT||0_0100|0001| A[3:0] = Remainder<br>Q = Quotient|  
__RESULT__: __Q = register Q__, __R = register A[3:0]__ 

+ ## Non-Restoring Division Flow 
1. Initialize with Q = Dividend, M = Divisor, A = 0

2. IF __MSB of A__ == __1__, Shift __A,Q__ and update __A = A + M__  
ELSE __MSB of A__ == __0__, Shift __A,Q__ and update __A = A - M__  

3. IF __MSB of A__ == __1__, __LSB of Q__ to __0__  
ELSE __MSB of A__ == __0__, __LSB of Q__ to __1__  

4. Counter update as __N = N - 1__

5. IF __N != 0__, Goto __Step 2.__  
ELSE, Goto __Step 6.__

6. IF __MSB of A__ == __1__, update __register A__ to __A + M__  
ELSE, Do Nothing.

7. __DONE!__ (__Q: Quotient, A: Remainder__)

### Example
>   1111 / 1011 = 0001 ... 0100  
>   (15) / (11) = 1 ... 4

| N | M | A | Q | Description |  
|:--:|:--:|:--:|:--:|:--:|    
|Ready|1011|00000|1111|Initialize|
|4||00001<br>10110<br>10110|1110<br>1110<br>1110|SHIFT LEFT {A,Q}<br>__MSB_A was 0__, Update A = A  - M <br> __MSB_A is 1__, Update __LSB_Q = 0__|  
|3||01101<br>11000<br>11000|1100<br>1100<br>1100|SHIFT LEFT {A,Q}<br>__MSB_A was 1__, Update A = A  + M <br> __MSB_A is 1__, Update __LSB_Q = 0__|  
|2||10001<br>11100<br>11100|1000<br>1000<br>1000|SHIFT LEFT {A,Q}<br>__MSB_A was 1__, Update A = A  + M <br> __MSB_A is 1__, Update __LSB_Q = 0__|  
|1||11001<br>00100<br>00100|0000<br>0000<br>0001|SHIFT LEFT {A,Q}<br>__MSB_A was 1__, Update A = A  + M <br> __MSB_A is 0__, Update __LSB_Q = 1__|  
|LAST||00100<br>00100|0001<br>0001|__MSB_A is 0__, Do Nothing|  
|RESULT||0_0100|0001| A[3:0] = Remainder<br>Q = Quotient|

__RESULT__: __Q = register Q__, __R = register A[3:0]__ 

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


# Multiplier Algorithm
(Multiplier) * (Multiplicand) == (Product)  
---  
## Signed Booth Algorithm SD code
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

## Unsigned Booth Algorithm SD code  
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


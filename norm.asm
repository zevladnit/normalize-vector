#{
    ~label 'X' 0x0
    ~label 'Y' 0x1
    ~label 'Z' 0x2
    ~label 'length' 0x6
    ~label 'norm' 0x7
    ~label 'one' 0xA
    ~label 'three' 0xB
}

;power on
.warm

;float mode on 
.ldx &(0x18) <| $(0x1)

;next 5 value in stack
.orb &(0x5)
;X
.val @float_t("5.0")
;Y
.val @float_t("2.0")
;Z
.val @float_t("3.0")
;one
.val @float_t("1.0")
;three
.val @float_t("3.0")

;pulling values from stack to L1-CPU cache (inverted)
.pull &(![~three])
.pull &(![~one])
.pull &(![~Z])
.pull &(![~Y])
.pull &(![~X])

;Math.Sqrt((X * X) + (Y * Y) + (Z * Z))
.mul &(0x3) &(![~X])&(![~X])
.mul &(0x4) &(![~Y])&(![~Y])
.mul &(0x5) &(![~Z])&(![~Z])

.add &(![~length]) &(0x3)&(0x4)
.add &(![~length]) &(![~length])&(0x5)

.sqrt &(![~length])&(![~length])
;end 


;inv_length = 1 / Length
.div &(![~length]) &(![~one]) &(![~length]) 

;(x,y,z) *= inv_length
.mul &(![~X]) &(![~X])&(![~length])
.mul &(![~Y]) &(![~Y])&(![~length])
.mul &(![~Z]) &(![~Z])&(![~length])

;sum vector
.add &(![~norm])&(![~norm])&(![~X])
.add &(![~norm])&(![~norm])&(![~Y])
.add &(![~norm])&(![~norm])&(![~Z])

;sum/3
.div &(![~norm])&(![~norm])&(![~three])

;print result to terminal
.mvj &(0x1) &(0x5) <| @string_t("Normalize value: ")
.mvx &(0x1) &(0x5) |> &(![~norm])
.mva &(0x1) &(0x5) <| $(0x20)

;power off
.halt
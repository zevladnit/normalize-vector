#{
    ~label 'X' 0x0
    ~label 'Y' 0x1
    ~label 'Z' 0x2
    ~label 'length' 0x6
    ~label 'norm' 0x7
    ~label 'one' 0xA
    ~label 'tree' 0xB
}

;hui started

;	float locLength = (float)Math.Sqrt((X * X) + (Y * Y) + (Z * Z));
;	float inv_length = (1 / locLength);
;	x *= inv_length;
;	y *= inv_length;
;	z *= inv_length;
;   return (x+y+z)/3;

.warm
.ldx &(0x18) <| $(0x1)
.orb &(0x5)
.val @float_t("5.0")
.val @float_t("2.0")
.val @float_t("3.0")
.val @float_t("1.0")
.val @float_t("3.0")

.pull &(![~tree])
.pull &(![~one])
.pull &(![~Z])
.pull &(![~Y])
.pull &(![~X])

.mul &(0x3) &(![~X])&(![~X])
.mul &(0x4) &(![~Y])&(![~Y])
.mul &(0x5) &(![~Z])&(![~Z])

.add &(![~length]) &(0x3)&(0x4)
.add &(![~length]) &(![~length])&(0x5)

.sqrt &(![~length])&(![~length])

.div &(![~length]) &(![~one]) &(![~length]) 

.mul &(![~X]) &(![~X])&(![~length])
.mul &(![~Y]) &(![~Y])&(![~length])
.mul &(![~Z]) &(![~Z])&(![~length])

.add &(![~norm])&(![~norm])&(![~X])
.add &(![~norm])&(![~norm])&(![~Y])
.add &(![~norm])&(![~norm])&(![~Z])

.div &(![~norm])&(![~norm])&(![~tree])

.mvj &(0x1) &(0x5) <| @string_t("Normalize value: ")
.mvx &(0x1) &(0x5) |> &(![~norm])
.mva &(0x1) &(0x5) <| $(0x20)

.halt
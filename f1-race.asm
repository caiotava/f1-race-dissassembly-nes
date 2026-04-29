.include "consts.asm"
; .include "header.asm"

.segment "CODE"
.org $8000

Reset:
    LDA PPU_STATUS
    BPL Reset
    SEI
    CLD
    LDX #$ff
    TXS

    LDA #0
    LDX #$14

ClearZeroPage:
    STA $0,x
    INX
    BNE ClearZeroPage

    STA PPU_MASK
    LDA #$1e
    STA $0015
    LDA #$90
    STA PPU_CTRL
    STA $0014
    LDX #$f

LOOP_c023:
    LDA $600,x
    CMP $ff9b,x
    BNE LAB_c030

    DEX
    BPL LOOP_c023
    BMI LAB_c041
LAB_c030:
    LDX #$13
    LDA #$0
LOOP_c034:
    STA $0,x
    DEX
    BPL LOOP_c034
    LDA #$1
    STA $0003
    STA $0008
    STA $000d
LAB_c041:
    JSR LAB_APU_MASTERCTRL_REG_f46e
    LDX #$5e
LOOP_c046:
    LDA $ff9b,x
    STA $600,x
    DEX
    BPL LOOP_c046
    LDX #$7
    LDY #$0
LOOP_c053:
    TXA
    STA $0100,Y
    INY
    BEQ LAB_c063
    TYA
    CMP $fcfe,x
    BCC LOOP_c053
    DEX
    BPL LOOP_c053
LAB_c063:
    JMP LAB_PPUCTRL_e60a
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined vblank()
    PHA
    TXA
    PHA
    TYA
    PHA
    LDA #$0
    STA OAM_ADDR
    LDA $004f
    AND #$1
    ORA #$2
    STA PPU_OAM_DMA
    LDY #$1
    STY  JOYPAD_PORT1
    DEY
    STY  JOYPAD_PORT1
    LDA  JOYPAD_PORT1
    AND  #$3
    STA  $006d
    LDA  JOYPAD_PORT1
    AND  #$3
    STA  $006e
    LDA  JOYPAD_PORT1
    AND  #$3
    STA  $006b
    LDA  JOYPAD_PORT1
    AND  #$3
    STA  $006c
    LDY  #$1
LOOP_JOYPAD_PORT1_c0a0:
    LDA JOYPAD_PORT1
    AND #$3
    BNE LAB_c0aa
    DEY
    BPL LOOP_JOYPAD_PORT1_c0a0
LAB_c0aa:
    STY $006f
    LDY #$1
LOOP_JOYPAD_PORT1_c0ae:
    LDA JOYPAD_PORT1
    AND #$3
    BNE LAB_c0b8
    DEY
    BPL LOOP_JOYPAD_PORT1_c0ae
LAB_c0b8:
    STY $0070
    LDY $0071
    BEQ LAB_c0c8
    STY $006d
    DEY
    STY $006e
    DEY
    STY $0070
    STY $006f
LAB_c0c8:
    LDA  #$1
    STA  $0016
    PLA
    TAY
    PLA
    TAX
    PLA
    RTI
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined irq()
;XREF[2,0]:   Entry Point,c0d2
JMP         irq
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_c0d5()
;XREF[2,0]:   c93f,e80f
    LDA #$1
    STA $00a6
    STA $00a7
    JSR FUN_f39e
    LDY $0033
    LDA DAT_c540,Y
    STA $002d
    LDX #$a
    LDA #$0
LOOP_c0e9:
    STA $71,x
    DEX
    BNE LOOP_c0e9
    STA $007d
    STA $0080
    LDY $0071
    BNE LAB_c0fd
    LDX #$4
LOOP_c0f8:
    STA $f,x
    DEX
    BPL LOOP_c0f8
LAB_c0fd:
    LDA $0071
    BEQ LAB_c10e
    LDY $0036
    STY $002d
    INY
    CPY #$a
    BCC LAB_c10c
    LDY #$0
LAB_c10c:
    STY $0036
LAB_c10e:
    LDA $0071                            ;= ??
    BNE LAB_c11d
    LDA $0033                            ;= ??
    BEQ LAB_c11d
    LDY #$0
    TYA
    LDX #$40
    BNE LAB_c123
LAB_c11d:
    LDY #$3
    LDA #$6
    LDX #$80
LAB_c123:
    STY $00b0
    STA $00b1
    STX $00b2
    LDA #$ff
    JSR FUN_f48e                                ;undefined FUN_f48e()
    LDA #$f8
    STA $008f
    STA $0090
    STA $0091
    LDA #$1
    STA $00b3
LAB_c13a:
    JSR FUN_eb9f                                ;undefined FUN_eb9f()
    LDA #$60
    STA $003c
    LDA #$6
    STA $003c+1
    LDA #$0
    STA $0066
    LDA #$7
    STA $0066+1
    LDX #$23
    LDA #$0
LOOP_c151:
    STA $40,x
    DEX
    BPL LOOP_c151
    LDA #$b
    STA $007c
    JSR FUN_e9ba
    LDA #$f8
    STA $008f
    STA $0090
    STA $0091
    INC $0034
    LDA #$0
    STA $00a7
    STA $00b5
    JSR FUN_f48e
    LDA #$b
    STA $00a6
    STA $007c
    LDA #$fa
    STA $009e
    LDA #$d0
    STA $00b4
LAB_c17e:
    JSR FUN_c91b
    JSR LAB_PPUCTRL_ca38
    JSR LAB_PPUMASK_PPUSCROLL_c906
    LDA $0071
    BEQ LAB_c1c6
    LDA $0072
    BEQ LAB_c198
    DEC $0072
    LDA $0073
    STA $0070
    JMP LAB_c1b6
LAB_c198:
    LDA $004d                            ;= ??
    BNE LAB_c1a6
    LDA $004c                            ;= ??
    CMP #$28
    BCC LAB_c1b6
    LDA #$1
    BNE LAB_c1ae
LAB_c1a6:
    LDA $004c
    CMP #$d8
    BCS LAB_c1b6
    LDA #$0
LAB_c1ae:
    STA $0070
    STA $0073
    LDA #$e
    STA $0072
LAB_c1b6:
    LDA #$0
    STA $0047
    LDA $0050
    BNE LAB_c1c4
    LDA $0051
    CMP #$be
    BCC LAB_c1c6
LAB_c1c4:
    INC $0047
LAB_c1c6:
    JSR FUN_cc75
    JSR FUN_d11b
    JSR FUN_ff14
    INC $004f
    LDA $0056
    CMP #$60
    BCC LAB_c1eb
    JSR FUN_c1fc
    JSR FUN_f48e
    LDA #$b
    STA $007c
    LDA #$fa
    STA $009e
    LDA $0071
    BEQ LAB_c1eb
    STA $0074
LAB_c1eb:
    LDA $0074
    BEQ LAB_c1f2
    JMP FUN_ce47
LAB_c1f2:
    LDA $005b
    BNE LAB_c1f9
    JMP LAB_c17e
LAB_c1f9:
    JMP FUN_cf6c
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_c1fc()
;XREF[2,0]:   c1d7,ce6f
    JSR FUN_f3ac                                ;undefined FUN_f3ac()
    STA $0053
    STA $0054
    STA $0055
    STA $0056
    RTS
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined LAB_PPUCTRL_PPUSCROLL_c208()
;XREF[2,0]:   ce33,d6d7
    LDA $004b
    ASL A
    LDA $004a
    ROL A
    STA PPU_SCROLL
    LDA #$0
    STA PPU_SCROLL
    ADC $0014
    STA PPU_CTRL
    LDA $0034
    BNE LAB_c220
    RTS
LAB_c220:
    LDA $0056
    BNE LAB_c23a
    LDA $006e
    BEQ LAB_c23a
    LDA $0051
    SEC
    SBC #$1
    STA $0051
    LDA $0050
    SBC #$0
    STA $0050
    BPL LAB_c23a
    JSR FUN_f3ac                                ;undefined FUN_f3ac()
LAB_c23a:                     ;XREF[3,0]:   c222,c226,c235
    LDA $0056
    BNE LAB_c2af
    LDA $0050
    STA $00a5
    LDA $0051
    ASL A
    ROL $00a5
    ASL A
    ROL $00a5
    ASL A
    ROL $00a5
    ASL A
    ROL $00a5
    LDY $00a5
    LDA $0047
    BEQ LAB_c25d
    LDA $0075
    CLC
    ADC #$1
    BNE LAB_c260
LAB_c25d:                     ;XREF[1,0]:   c254
    LDA DAT_c41d,Y                              ;= 01h
LAB_c260:                     ;XREF[1,0]:   c25b
    STA $0018
    LDA $0051
    SEC
    SBC $0018
    STA $0051
    LDA $0050
    SBC #$0
    STA $0050
    BPL LAB_c274
    JSR FUN_f3ac                                ;undefined FUN_f3ac()
LAB_c274:                     ;XREF[1,0]:   c26f
    LDA $006d
    BEQ LAB_c2af
    LDA $005c
    BNE LAB_c2af
    LDA $0075
    BEQ LAB_c285
    TYA
    CLC
    ADC #$20
    TAY
LAB_c285:
    LDA $0047
    BNE LAB_c294
    LDA DAT_c43d,Y
    STA $0018
    LDA DAT_c47d,Y
    JMP LAB_c29c
LAB_c294:
    LDA DAT_c4bd,Y
    STA $0018
    LDA DAT_c4fd,Y
LAB_c29c:                     ;XREF[1,0]:   c291
    STA $0019
    CLC
    ADC $0052
    STA $0052
    LDA $0051
    ADC $0018
    STA $0051
    LDA $0050
    ADC #$0
    STA $0050
LAB_c2af:                     ;XREF[3,0]:   c23c,c276,c27a
    LDA $0056
    BEQ LAB_c2ca
    LDA $0051
    SEC
    SBC #$3
    STA $0051
    LDA $0050
    SBC #$0
    STA $0050
    BPL LAB_c2ca
    LDA #$0
    STA $0050
    STA $0051
    STA $0052
LAB_c2ca:                     ;XREF[2,0]:   c2b1,c2c0
    LDA $0050
    STA $0017
    STA $0019
    LDA $0051
    STA $001a
    ASL A
    ROL $0017
    ASL A
    ROL $0017
    STA $0018
    LDA $0056
    BEQ LAB_c2e3
LOOP_c2e0:                    ;XREF[1,0]:   c2e5
    JMP LAB_c397
LAB_c2e3:                     ;XREF[1,0]:   c2de
    LDA $0070
    BMI LOOP_c2e0
    LDA $0075
    BEQ LAB_c300
    LDA $001a
    SEC
    SBC #$8c
    STA $001a
    LDA $0019
    SBC #$0
    STA $0019
    BPL LAB_c300
    LDA #$0
    STA $0019
    STA $001a
LAB_c300:                     ;XREF[2,0]:   c2e9,c2f8
LDY         #$0
LDA         $0071                            ;= ??
BNE         LAB_c308
LDY         $0033                            ;= ??
LAB_c308:                     ;XREF[1,0]:   c304
LDA         DAT_c53d,Y
CLC
ADC         $001a                            ;= ??
STA         $001a                            ;= ??
BCC         LAB_c314
INC         $0019                            ;= ??
LAB_c314:                     ;XREF[1,0]:   c310
LDA         $0019                            ;= ??
BEQ         LAB_c34d
LDY         #$0
LDA         ($003c),Y                        ;= ??
BPL         LAB_c323
EOR         #$ff
CLC
ADC         #$1
LAB_c323:                     ;XREF[1,0]:   c31c
CMP         #$28
BCS         LAB_c33f
CMP         #$18
BCS         LAB_c337
CMP         #$8
BCC         LAB_c34d
LDA         $001a                            ;= ??
CMP         #$72
BCS         LAB_c345
BCC         LAB_c34d
LAB_c337:                     ;XREF[1,0]:   c329
LDA         $001a                            ;= ??
CMP         #$54
BCS         LAB_c345
BCC         LAB_c34d
LAB_c33f:                     ;XREF[1,0]:   c325
LDA         $001a                            ;= ??
CMP         #$36
BCC         LAB_c34d
LAB_c345:                     ;XREF[2,0]:   c333,c33b
LDA         #$4
JSR         FUN_f48e                                ;undefined FUN_f48e()
JMP         LAB_c37a
LAB_c34d:                     ;XREF[5,0]:   c316,c32d,c335,c33d,c343
LDA         $0070                            ;= ??
BNE         LAB_c367
LDA         $004e                            ;= ??
CLC
ADC         $0018                            ;= ??
STA         $004e                            ;= ??
LDA         $004c                            ;= ??
ADC         $0017                            ;= ??
STA         $004c                            ;= ??
LDA         $004d                            ;= ??
ADC         #$0
STA         $004d                            ;= ??
JMP         LAB_c37a
LAB_c367:                     ;XREF[1,0]:   c34f
LDA         $004e                            ;= ??
SEC
SBC         $0018                            ;= ??
STA         $004e                            ;= ??
LDA         $004c                            ;= ??
SBC         $0017                            ;= ??
STA         $004c                            ;= ??
LDA         $004d                            ;= ??
SBC         #$0
STA         $004d                            ;= ??
LAB_c37a:                     ;XREF[2,0]:   c34a,c364
LDA         $0050                            ;= ??
BNE         LAB_c384
LDA         $0051                            ;= ??
CMP         #$c8
BCC         LAB_c397
LAB_c384:                     ;XREF[1,0]:   c37c
LDA         $0052                            ;= ??
SEC
SBC         #$40
STA         $0052                            ;= ??
LDA         $0051                            ;= ??
SBC         #$0
STA         $0051                            ;= ??
LDA         $0050                            ;= ??
SBC         #$0
STA         $0050                            ;= ??
LAB_c397:                     ;XREF[2,0]:   c2e0,c382
LDY         #$0
LDA         ($003c),Y                        ;= ??
BPL         LAB_c3a2
EOR         #$ff
CLC
ADC         #$1
LAB_c3a2:                     ;XREF[1,0]:   c39b
STA         $0017                            ;= ??
LDA         $0050                            ;= ??
LSR         A
LDA         $0051                            ;= ??
ROR         A
LSR         A
LSR         A
LSR         A
STA         $0018                            ;= ??
LDA         #$0
STA         $0019                            ;= ??
STA         $001a                            ;= ??
STA         $001b                            ;= ??
LDX         #$5
LOOP_c3b9:                    ;XREF[1,0]:   c3cf
LSR         $0017                            ;= ??
BCC         LAB_c3ca
LDA         $001a                            ;= ??
CLC
ADC         $0018                            ;= ??
STA         $001a                            ;= ??
LDA         $001b                            ;= ??
ADC         $0019                            ;= ??
STA         $001b                            ;= ??
LAB_c3ca:                     ;XREF[1,0]:   c3bb
ASL         $0018                            ;= ??
ROL         $0019                            ;= ??
DEX
BPL         LOOP_c3b9
LDA         ($003c),Y                        ;= ??
BMI         LAB_c3eb
LDA         $004e                            ;= ??
SEC
SBC         $001a                            ;= ??
STA         $004e                            ;= ??
LDA         $004c                            ;= ??
SBC         $001b                            ;= ??
STA         $004c                            ;= ??
LDA         $004d                            ;= ??
SBC         #$0
STA         $004d                            ;= ??
JMP         LAB_c3fe
LAB_c3eb:                     ;XREF[1,0]:   c3d3
LDA         $004e                            ;= ??
CLC
ADC         $001a                            ;= ??
STA         $004e                            ;= ??
LDA         $004c                            ;= ??
ADC         $001b                            ;= ??
STA         $004c                            ;= ??
LDA         $004d                            ;= ??
ADC         #$0
STA         $004d                            ;= ??
LAB_c3fe:                     ;XREF[1,0]:   c3e8
LDA         $004d                            ;= ??
BMI         LAB_c40e
LDA         $004c                            ;= ??
CMP         #$a0
BCC         LAB_c41c
LDA         #$a0
STA         $004c                            ;= ??
BNE         LAB_c418
LAB_c40e:                     ;XREF[1,0]:   c400
LDA         $004c                            ;= ??
CMP         #$60
BCS         LAB_c41c
LDA         #$60
STA         $004c                            ;= ??
LAB_c418:                     ;XREF[1,0]:   c40c
LDA         #$0
STA         $004e                            ;= ??
LAB_c41c:                     ;XREF[2,0]:   c406,c412
RTS

DAT_c41d:                     ;XREF[2,0]:   c25d,d276
.byte $01, $01, $01, $01, $01, $01, $01, $01, $02, $02, $02, $02, $02, $02, $02, $02, $03, $03, $03, $03, $04, $04, $04, $04, $05, $05, $06, $06, $07, $07, $08, $08

DAT_c43d:                     ;XREF[2,0]:   c289,d272
.byte $02, $02, $02, $02, $02, $02, $02, $02, $03, $03, $03, $02, $02, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $02, $02, $02, $03, $03, $03, $03, $03, $04, $04, $04, $04, $03, $02, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

DAT_c47d:                     ;XREF[2,0]:   c28e,d26d
.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$40,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$20,$40,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$40,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

DAT_c4bd:                     ;XREF[2,0]:   c294,d281
.byte $01,01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$02,$02,$02,$02,$02,$02,$02,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$00,$02,$02,$02,$02,$02,$02,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$02,$03,$03,$03,$03,$03,$03,$03,$00

DAT_c4fd:                     ;XREF[2,0]:   c299,d27c
.byte $20,$30,$40,$50,$60,$70,$80,$98,$B0,$C8,$E0,$F8,$10,$30,$50,$70,$40,$20,$F0,$C0,$90,$68,$40,$20,$18,$10,$40,$80,$80,$80,$40,$FF,$40,$60,$80,$A0,$C0,$E0,$00,$20,$40,$60,$80,$A0,$B0,$C0,$D0,$E0,$C0,$A0,$80,$60,$40,$20,$00,$E0,$00,$20,$40,$40,$40,$40,$20,$FF

DAT_c53d:                     ;XREF[1,0]:   c308
.byte  $00, $14, $28
DAT_c540:                     ;XREF[1,0]:   c0e0
.byte $00, $02, $05
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined LAB_PPUMASK_c543()
;XREF[1,0]:   e9c3
JSR         FUN_c91b                                ;undefined FUN_c91b()
LDX         #$0
STX         $0015                            ;= ??
STX         PPU_MASK
LDA         #$20
STA         $0022                            ;= ??
STX         $0022+1
INX
LOOP_c554:                    ;XREF[1,0]:   c570
LDA         $0022                            ;= ??
LDY         $0022+1
JSR         LAB_PPUADDR_e964                        ;undefined LAB_PPUADDR_e964()
LDY         #$0
LDA         #$2d
LOOP_c55f:                    ;XREF[1,0]:   c563
JSR         LAB_PPUDATA_d0fb                        ;undefined LAB_PPUDATA_d0fb()
INY
BNE         LOOP_c55f
JSR         FUN_c91b                                ;undefined FUN_c91b()
LDA         $0022                            ;= ??
CLC
ADC         #$4
STA         $0022                            ;= ??
DEX
BPL         LOOP_c554
LDA         #$3f
LDY         #$0
JSR         LAB_PPUADDR_e964                        ;undefined LAB_PPUADDR_e964()
JSR         FUN_e96b                                ;undefined FUN_e96b()
LDA         $002e                            ;= ??
AND         #$f
CMP         #$6
BCC         LAB_c586
LDA         #$0
LAB_c586:                     ;XREF[1,0]:   c582
ASL         A
ASL         A
ASL         A
TAX
LDY         #$7
LOOP_PPUDATA_c58c:            ;XREF[1,0]:   c594
LDA         DAT_c8c6,X
STA         PPU_DATA
INX
DEY
BPL         LOOP_PPUDATA_c58c
LDY         #$0
LOOP_PPUDATA_c598:            ;XREF[1,0]:   c5a1
LDA         DAT_c8ae,Y
STA         PPU_DATA
INY
CPY         #$18
BCC         LOOP_PPUDATA_c598
LDA         #$3f
LDY         #$0
JSR         LAB_PPUADDR_e964                        ;undefined LAB_PPUADDR_e964()
TYA
JSR         LAB_PPUADDR_e964                        ;undefined LAB_PPUADDR_e964()
LDX         #$1
LOOP_c5b0:                    ;XREF[1,0]:   c5f6
LDA         #$23
LDY         #$c0
JSR         LAB_PPUADDR_e964                        ;undefined LAB_PPUADDR_e964()
LDY         #$0
LOOP_c5b9:                    ;XREF[1,0]:   c5d4
LDA         #$0
CPY         #$20
BCS         LAB_PPUDATA_c5ce
LDA         #$5
CPY         #$18
BCS         LAB_PPUDATA_c5ce
LDA         #$55
CPY         #$10
BCS         LAB_PPUDATA_c5ce
LDA         DAT_c8f6,Y                              ;= 95h
LAB_PPUDATA_c5ce:             ;XREF[3,0]:   c5bd,c5c3,c5c9
STA         PPU_DATA
INY
CPY         #$40
BCC         LOOP_c5b9
LDA         #$27
LDY         #$c0
JSR         LAB_PPUADDR_e964                        ;undefined LAB_PPUADDR_e964()
LDA         #$55
LDY         #$0
LOOP_PPUDATA_c5e1:            ;XREF[1,0]:   c5f3
STA         PPU_DATA
CPY         #$17
BNE         LAB_c5ea
LDA         #$5
LAB_c5ea:                     ;XREF[1,0]:   c5e6
CPY         #$1f
BNE         LAB_PPUDATA_c5f0
LDA         #$0
LAB_PPUDATA_c5f0:             ;XREF[1,0]:   c5ec
INY
CPY         #$40
BCC         LOOP_PPUDATA_c5e1
DEX
BPL         LOOP_c5b0
JSR         FUN_c91b                                ;undefined FUN_c91b()
LDA         #$20
LDY         #$89
JSR         LAB_PPUADDR_e964                        ;undefined LAB_PPUADDR_e964()
LDY         #$3d
STY         PPU_DATA
INY
STY         PPU_DATA
LDA         #$20
LDY         #$a9
JSR         LAB_PPUADDR_e964                        ;undefined LAB_PPUADDR_e964()
LDY         #$3f
STY         PPU_DATA
INY
STY         PPU_DATA
LDA         #$20
LDY         #$ac
JSR         LAB_PPUADDR_e964                        ;undefined LAB_PPUADDR_e964()
LDY         #$11
STY         PPU_DATA
INY
STY         PPU_DATA
LDA         #$20
LDY         #$4c
JSR         LAB_PPUADDR_e964                        ;undefined LAB_PPUADDR_e964()
LDY         #$7
LOOP_PPUDATA_c634:            ;XREF[1,0]:   c63b
; FWD[2,0]:   c805,c806
LDA         $c7ff,y
STA         PPU_DATA
DEY
BPL         LOOP_PPUDATA_c634
LDA         #$20
LDY         #$8f
JSR         LAB_PPUADDR_e964                        ;undefined LAB_PPUADDR_e964()
LDY         #$4
LOOP_PPUDATA_c646:            ;XREF[1,0]:   c64d
; FWD[2,0]:   c80a,c80b
LDA         $c807,y
STA         PPU_DATA
DEY
BPL         LOOP_PPUDATA_c646
JSR         FUN_c91b                                ;undefined FUN_c91b()
LDA         #$21
LDY         #$c0
JSR         LAB_PPUADDR_e964                        ;undefined LAB_PPUADDR_e964()
LDY         #$1f
LDA         #$2b
LOOP_PPUDATA_c65d:            ;XREF[1,0]:   c661
STA         PPU_DATA
DEY
BPL         LOOP_PPUDATA_c65d
LDA         #$25
LDY         #$c0
JSR         LAB_PPUADDR_e964                        ;undefined LAB_PPUADDR_e964()
LDY         #$1f
LDA         #$2b
LOOP_PPUDATA_c66e:            ;XREF[1,0]:   c672
STA         PPU_DATA
DEY
BPL         LOOP_PPUDATA_c66e
JSR         FUN_c91b                                ;undefined FUN_c91b()
LDA         #$23
STA         $0022                            ;= ??
LDA         #$b0
STA         $0022+1
LDX         #$e
LOOP_c681:                    ;XREF[1,0]:   c69e
LDA         $0022                            ;= ??
LDY         $0022+1
JSR         LAB_PPUADDR_e964                        ;undefined LAB_PPUADDR_e964()
TXA
TAY
LDA         #$2c
LOOP_PPUDATA_c68c:            ;XREF[1,0]:   c690
STA         PPU_DATA
DEY
BPL         LOOP_PPUDATA_c68c
LDA         $0022+1
SEC
SBC         #$1f
STA         $0022+1
BCS         LAB_c69d
DEC         $0022                            ;= ??
LAB_c69d:                     ;XREF[1,0]:   c699
DEX
BPL         LOOP_c681
LDX         #$e
LDA         #$27
STA         $0022                            ;= ??
LDA         #$a0
STA         $0022+1
LOOP_c6aa:                    ;XREF[1,0]:   c6c7
LDA         $0022                            ;= ??
LDY         $0022+1
JSR         LAB_PPUADDR_e964                        ;undefined LAB_PPUADDR_e964()
TXA
TAY
LDA         #$2c
LOOP_PPUDATA_c6b5:            ;XREF[1,0]:   c6b9
STA         PPU_DATA
DEY
BPL         LOOP_PPUDATA_c6b5
LDA         $0022+1
SEC
SBC         #$20
STA         $0022+1
BCS         LAB_PPUCTRL_c6c6
DEC         $0022                            ;= ??
LAB_PPUCTRL_c6c6:             ;XREF[1,0]:   c6c2
DEX
BPL         LOOP_c6aa
LDA         $0014                            ;= ??
ORA         #$4
STA         PPU_CTRL
LDA         #$21
STA         $0022                            ;= ??
LDA         #$de
STA         $0022+1
LDY         #$0
LDX         #$0
LOOP_PPUADDR_c6dc:            ;XREF[1,0]:   c70b
STX         $0018                            ;= ??
LDA         DAT_c80c,X                              ;= 02h
STA         $0017                            ;= ??
LDA         $0022                            ;= ??
STA         PPU_ADDR
LDA         $0022+1
STA         PPU_ADDR
LDX         #$0
LOOP_PPUDATA_c6ef:            ;XREF[1,0]:   c6f9
LDA         DAT_c81c,Y                              ;= A0h
STA         PPU_DATA
INY
INX
CPX         $0017                            ;= ??
BCC         LOOP_PPUDATA_c6ef
LDA         $0022+1
CLC
ADC         #$1f
STA         $0022+1
BCC         LAB_c706
INC         $0022                            ;= ??
LAB_c706:                     ;XREF[1,0]:   c702
LDX         $0018                            ;= ??
INX
CPX         #$10
BCC         LOOP_PPUADDR_c6dc
LDA         #$25
STA         $0022                            ;= ??
LDA         #$c0
STA         $0022+1
LDY         #$0
LDX         #$0
LOOP_PPUADDR_c719:            ;XREF[1,0]:   c74d
STX         $0018                            ;= ??
LDA         DAT_c80c,X                              ;= 02h
STA         $0017                            ;= ??
LDA         $0022                            ;= ??
STA         PPU_ADDR
LDA         $0022+1
STA         PPU_ADDR
LDX         #$0
LOOP_c72c:                    ;XREF[1,0]:   c73b
LDA         DAT_c81c,Y                              ;= A0h
BPL         LAB_PPUDATA_c734
CLC
ADC         #$11
LAB_PPUDATA_c734:             ;XREF[1,0]:   c72f
STA         PPU_DATA
INY
INX
CPX         $0017                            ;= ??
BCC         LOOP_c72c
LDA         $0022+1
CLC
ADC         #$21
STA         $0022+1
BCC         LAB_PPUCTRL_PPUDATA_c748
INC         $0022                            ;= ??
LAB_PPUCTRL_PPUDATA_c748:     ;XREF[1,0]:   c744
LDX         $0018                            ;= ??
INX
CPX         #$10
BCC         LOOP_PPUADDR_c719
LDA         #$21
LDY         #$df
JSR         LAB_PPUADDR_e964                        ;undefined LAB_PPUADDR_e964()
LDA         #$60
STA         PPU_DATA
LDA         $0014                            ;= ??
STA         PPU_CTRL
JSR         FUN_c91b                                ;undefined FUN_c91b()
LDA         #$21
LDY         #$40
JSR         LAB_PPUADDR_e964                        ;undefined LAB_PPUADDR_e964()
LDY         #$0
LAB_c76c:                     ;XREF[1,0]:   c774
LDA         DAT_c849,Y                              ;= 08h
BEQ         LAB_c777
JSR         FUN_c7df                                ;undefined FUN_c7df()
JMP         LAB_c76c
LAB_c777:                     ;XREF[1,0]:   c76f
LDA         #$25
LDY         #$40
JSR         LAB_PPUADDR_e964                        ;undefined LAB_PPUADDR_e964()
LDY         #$0
LAB_c780:                     ;XREF[1,0]:   c788
LDA         DAT_c878,Y                              ;= 03h
BEQ         LAB_c78b
JSR         FUN_c7df                                ;undefined FUN_c7df()
JMP         LAB_c780
LAB_c78b:                     ;XREF[1,0]:   c783
LDA         #$6d
STA         $0200                            ;= ??
STA         $0300                            ;= ??
LDA         #$20
STA         $0202                            ;= ??
STA         $0302                            ;= ??
LDA         #$0
STA         $0203                            ;= ??
STA         $0303                            ;= ??
LDA         #$fb
STA         $0201                            ;= ??
STA         $0301                            ;= ??
JSR         FUN_c91b                                ;undefined FUN_c91b()
JSR         FUN_f095                                ;undefined FUN_f095()
JSR         LAB_PPUCTRL_ca38                        ;undefined LAB_PPUCTRL_ca38()
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_c7b4()
;XREF[1,0]:   cd24
LDY         $002d                            ;= ??
LDA         DAT_c7cb,Y                              ;= C0h
STA         $00c4                            ;= ??
LDA         DAT_c7d5,Y                              ;= 0Fh
STA         $00c6                            ;= ??
LDA         #$80
STA         $00c5                            ;= ??
STA         $00c7                            ;= ??
LDA         #$0
STA         $00c8                            ;= ??
RTS
DAT_c7cb:                     ;XREF[1,0]:   c7b6
.byte $C0,$B3,$C0,$B8,$C0,$D8,$B3,$D8,$B3,$D0
DAT_c7d5:                     ;XREF[1,0]:   c7bb
.byte $0F,$0F,$0F,$1F,$0F,$0F,$0F,$0F,$0F,$0F

;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_c7df()
;XREF[2,0]:   c771,c785
CMP         #$20
BCS         LAB_PPUDATA_c7fa
PHA
AND         #$f
TAX
PLA
AND         #$10
BNE         LAB_c7f0
LDA         #$2d
BNE         LOOP_PPUDATA_c7f2
LAB_c7f0:                     ;XREF[1,0]:   c7ea
LDA         #$2f
LOOP_PPUDATA_c7f2:            ;XREF[2,0]:   c7ee,c7f6
STA         PPU_DATA
DEX
BPL         LOOP_PPUDATA_c7f2
BMI         LAB_c7fd
LAB_PPUDATA_c7fa:             ;XREF[1,0]:   c7e1
STA         PPU_DATA
LAB_c7fd:                     ;XREF[1,0]:   c7f8
INY
RTS
.byte $0E,$16,$12,$1D,$2D,$2D
DAT_c805:                     ;XREF[1,0]:   c634
.byte $2A
DAT_c806:                     ;XREF[1,0]:   c634
.byte $29,$0E,$1B,$18
DAT_c80a:                     ;XREF[1,0]:   c646
.byte $0C
DAT_c80b:                     ;XREF[1,0]:   c646
.byte $1C
DAT_c80c:                     ;XREF[2,0]:   c6de,c71b
.byte $02,$02,$02,$02,$03,$03,$03,$03,$03,$04,$04,$04,$04,$03,$02,$01
DAT_c81c:                     ;XREF[2,0]:   c6ef,c72c
.byte $A0,$A2,$A1,$A4,$A3,$A6,$A5,$A8,$A7,$AA,$AC,$A9,$AB,$A2,$A9,$AD,$A4,$A9,$AE,$A6,$A9,$AF,$A8,$A9,$B0,$AA,$AC,$A9,$2E,$AB,$A2,$A9,$2E,$AD,$A4,$A9,$2E,$AE,$A6,$A9,$2E,$AF,$A9,$2E,$A9
DAT_c849:                     ;XREF[1,0]:   c76c
.byte $08,$5C,$5D,$5E,$5F,$0F,$09,$5A,$5B,$0A,$EC,$E7,$ED,$EF,$E7,$0A,$E5,$E6,$E7,$2D,$0A,$E5,$11,$EE,$11,$EF,$E4,$EF,$E7,$EC,$E7,$02,$E3,$E4,$12,$E8,$E9,$EA,$05,$EB,$E8,$E4,$16,$EE,$13,$F0,$00
DAT_c878:                     ;XREF[1,0]:   c780
.byte $03,$5A,$5B,$0F,$0F,$01,$5C,$5D,$5E,$5B,$08,$5C,$5D,$5E,$5F,$0A,$ED,$EF,$E7,$2D,$F1,$F3,$04,$55,$56,$57,$58,$59,$04,$ED,$EF,$E6,$F3,$04,$EC,$E4,$12,$F2,$11,$EF,$E9,$EA,$F3,$01,$54,$54,$54,$03,$EB,$F2,$13,$F4,$01,$00
DAT_c8ae:                     ;XREF[1,0]:   c598
.byte $00,$0F,$26,$2C,$00,$0F,$38,$30,$00,$0F,$16,$30,$00,$0F,$12,$38,$00,$0F,$27,$30,$00,$30,$16,$38
DAT_c8c6:                     ;XREF[1,0]:   c58c
.byte $00,$2A,$01,$30,$00,$21,$30,$1C,$00,$17,$29,$30,$00,$22,$30,$1B,$00,$19,$17,$30,$00,$21,$30,$08,$00,$16,$07,$35,$00,$25,$36,$06,$00,$22,$0C,$31,$00,$01,$11,$0F,$00,$28,$08,$30,$00,$37,$30,$07
DAT_c8f6:                     ;XREF[1,0]:   c5cb
.byte $95,$A5,$B5,$E5,$F5,$A5,$A5,$65,$59,$5A,$5A,$5E,$5F,$5A,$5A,$56
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined LAB_PPUMASK_PPUSCROLL_c906()
;XREF[12,0]:  c184,ca04,ce51,cf00,cf40,cf89,d0bb,d0dc
;             e7cd,ea72,eb4c,eb64
LDA         #$20
LDY         #$0
JSR         LAB_PPUADDR_e964                        ;undefined LAB_PPUADDR_e964()
STY         PPU_SCROLL
STY         PPU_SCROLL
LDA         #$1e
STA         $0015                            ;= ??
STA         PPU_MASK
RTS
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_c91b()
;XREF[36,0]:  c17e,c543,c565,c5f8,c64f,c674,c760,c7ab
;             c9c8,c9db,ca01,ce4b,cebd,cf3a,cf83,cfd9
;             d034,d0c9,d0d6,e623,e65b,e6c5,e727,e748
;             e797,e7c7,e9d6,e9df,e9eb,e9f4,ea00,ea23
;             eafa,eb5e,f36e,f38c
LDY         #$1
LOOP_c91d:                    ;XREF[1,0]:   c953
LDA         #$0
STA         $0016                            ;= ??
LDA         $0071                            ;= ??
BEQ         LOOP_c942
LDA         $002a                            ;= ??
BNE         LAB_c933
LDA         $006b                            ;= ??
BEQ         LAB_c933
LDX         #$ff
TXS
JMP         LAB_PPUCTRL_e60a                        ;undefined LAB_PPUCTRL_e60a()
LAB_c933:                     ;XREF[2,0]:   c927,c92b
LDA         $006c                            ;= ??
BEQ         LOOP_c942
LDX         #$ff
TXS
INX
STX         $0071                            ;= ??
STX         $002a                            ;= ??
JMP         FUN_c0d5                                ;undefined FUN_c0d5()
LOOP_c942:                    ;XREF[3,0]:   c923,c935,c944
LDA         $0016                            ;= ??
BEQ         LOOP_c942
LDA         $00a7                            ;= ??
BNE         LOOP_c952
LDA         $00a6                            ;= ??
BNE         LAB_c956
LDA         $0071                            ;= ??
BEQ         LAB_c95d
LOOP_c952:                    ;XREF[4,0]:   c948,c95a,c961,c9ef
DEY
BNE         LOOP_c91d
RTS
LAB_c956:                     ;XREF[1,0]:   c94c
LDA         $006c                            ;= ??
STA         $00a6                            ;= ??
JMP         LOOP_c952
LAB_c95d:                     ;XREF[1,0]:   c950
LDA         $006c                            ;= ??
BNE         LAB_c964
JMP         LOOP_c952
LAB_c964:                     ;XREF[1,0]:   c95f
STA         $00a7                            ;= ??
TYA
PHA
TXA
PHA
LDA         #$1
STA         $0032                            ;= ??
LDA         #$20
STA         $00a8                            ;= ??
LDA         #$55
STA         $00a9                            ;= ??
LDX         #$3
LOOP_c978:                    ;XREF[1,0]:   c991
LDA         $00a8                            ;= ??
LDY         $00a9                            ;= ??
JSR         LAB_PPUADDR_e964                        ;undefined LAB_PPUADDR_e964()
LDY         #$8
LOOP_PPUDATA_c981:            ;XREF[1,0]:   c987
LDA         #$2d
STA         PPU_DATA
DEY
BPL         LOOP_PPUDATA_c981
LDA         $00a9                            ;= ??
CLC
ADC         #$20
STA         $00a9                            ;= ??
DEX
BPL         LOOP_c978
LDA         #$20
LDY         #$77
JSR         LAB_PPUADDR_e964                        ;undefined LAB_PPUADDR_e964()
LDY         #$4
LOOP_PPUDATA_c99c:            ;XREF[1,0]:   c9a3
; FWD[2,0]:   c9f5,c9f6
LDA         $c9f2,y
STA         PPU_DATA
DEY
BPL         LOOP_PPUDATA_c99c
LDA         #$8
JSR         FUN_f48e                                ;undefined FUN_f48e()
JSR         FUN_ca04                                ;undefined FUN_ca04()
LDA         #$1e
JSR         FUN_c9f7                                ;undefined FUN_c9f7()
LDA         #$1
STA         $00a8                            ;= ??
LAB_c9b6:                     ;XREF[1,0]:   c9c5
LDA         $00a8                            ;= ??
BNE         LAB_c9be
LDA         $006c                            ;= ??
BNE         LAB_c9c8
LAB_c9be:                     ;XREF[1,0]:   c9b8
LDA         $006c                            ;= ??
STA         $00a8                            ;= ??
JSR         FUN_ca01                                ;undefined FUN_ca01()
JMP         LAB_c9b6
LAB_c9c8:                     ;XREF[1,0]:   c9bc
JSR         FUN_c91b                                ;undefined FUN_c91b()
JSR         FUN_f095                                ;undefined FUN_f095()
JSR         FUN_ca04                                ;undefined FUN_ca04()
LDA         #$8
JSR         FUN_f48e                                ;undefined FUN_f48e()
LDA         #$1e
JSR         FUN_c9f7                                ;undefined FUN_c9f7()
JSR         FUN_c91b                                ;undefined FUN_c91b()
LDA         #$0
STA         $00a7                            ;= ??
STA         $0032                            ;= ??
JSR         FUN_f48e                                ;undefined FUN_f48e()
LDA         #$1
STA         $00a6                            ;= ??
PLA
TAX
PLA
TAY
JMP         LOOP_c952
.byte $0E, $1C, $1E
DAT_c9f5:                     ;XREF[1,0]:   c99c
.byte $0A
DAT_c9f6:                     ;XREF[1,0]:   c99c
.byte $19
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_c9f7()
;XREF[2,0]:   c9af,c9d8
STA         $00ac                            ;= ??
JSR         FUN_ca01                                ;undefined FUN_ca01()
DEC         $00ac                            ;= ??
BNE         FUN_ca01
RTS
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_ca01()
;XREF[3,0]:   c9c2,c9f9,c9fe
JSR         FUN_c91b                                ;undefined FUN_c91b()
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_ca04()
;XREF[2,0]:   c9aa,c9ce
JSR         LAB_PPUMASK_PPUSCROLL_c906              ;undefined LAB_PPUMASK_PPUSCROLL_c906()
JSR         LAB_JOYPAD_PORT2_f505                   ;undefined LAB_JOYPAD_PORT2_f505()
LDY         #$4
LDA         #$f0
LOOP_PPUCTRL_PPUSCROLL_ca0e:  ;XREF[1,0]:   ca15
; FWD[2,0]:   0204,0205
STA         $200,Y
; FWD[2,0]:   0304,0305
STA         $300,Y
INY
BNE         LOOP_PPUCTRL_PPUSCROLL_ca0e
LDY         #$0
JSR         FUN_ff08                                ;undefined FUN_ff08()
JSR         FUN_ff08                                ;undefined FUN_ff08()
JSR         FUN_ff08                                ;undefined FUN_ff08()
LDA         $004b                            ;= ??
ASL         A
LDA         $004a                            ;= ??
ROL         A
STA         PPU_SCROLL
LDA         #$0
STA         PPU_SCROLL
ADC         $0014                            ;= ??
STA         PPU_CTRL
JMP         FUN_ff14                                ;undefined FUN_ff14()
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined LAB_PPUCTRL_ca38()
;XREF[9,0]:   c181,c7b1,ce4e,cf3d,cf86,d0d9,e9ca,ea05
;             eb61
LDA         $004f                            ;= ??
AND         #$1
BNE         LAB_PPUCTRL_caa6
LDA         $0014                            ;= ??
STA         PPU_CTRL
LDA         #$20
LDY         #$71
JSR         LAB_PPUADDR_e964                        ;undefined LAB_PPUADDR_e964()
LDA         $0078                            ;= ??
BNE         LAB_PPUDATA_ca50
LDA         #$2d
LAB_PPUDATA_ca50:             ;XREF[1,0]:   ca4c
STA         PPU_DATA
LDA         $0077                            ;= ??
STA         PPU_DATA
LDA         #$0
STA         $0038                            ;= ??
LDA         #$20
LDY         #$ae
JSR         LAB_PPUADDR_e964                        ;undefined LAB_PPUADDR_e964()
LDY         #$4
LOOP_ca65:                    ;XREF[1,0]:   ca78
; FWD[2,0]:   0012,0013
LDA         $f,Y
BNE         LAB_ca72
LDX         $0038                            ;= ??
BNE         LAB_PPUCTRL_PPUDATA_ca74
LDA         #$2d
BNE         LAB_PPUCTRL_PPUDATA_ca74
LAB_ca72:                     ;XREF[1,0]:   ca68
STA         $0038                            ;= ??
LAB_PPUCTRL_PPUDATA_ca74:     ;XREF[2,0]:   ca6c,ca70
STA         PPU_DATA
DEY
BPL         LOOP_ca65
LDA         #$0
STA         PPU_DATA
LDA         $0014                            ;= ??
ORA         #$4
STA         PPU_CTRL
LDY         $0048                            ;= ??
LDA         DAT_cba9,Y                              ;= C1h
STA         $0022                            ;= ??
LDA         DAT_cbb5,Y                              ;= CBh
STA         $0022+1
LDA         #$21
LDY         #$ff
JSR         LAB_PPUADDR_e964                        ;undefined LAB_PPUADDR_e964()
LDY         #$0
LOOP_PPUDATA_ca9b:            ;XREF[1,0]:   caa3
LDA         ($0022),Y                        ;= ??
STA         PPU_DATA
INY
CPY         #$f
BCC         LOOP_PPUDATA_ca9b
RTS
LAB_PPUCTRL_caa6:             ;XREF[1,0]:   ca3c
LDA         $0014                            ;= ??
STA         PPU_CTRL
LDA         $0053                            ;= ??
LSR         A
LSR         A
LSR         A
CMP         #$10
BCC         LAB_PPUDATA_cab6
LDA         #$10
LAB_PPUDATA_cab6:             ;XREF[1,0]:   cab2
STA         $0017                            ;= ??
LDA         #$20
LDY         #$a3
JSR         LAB_PPUADDR_e964                        ;undefined LAB_PPUADDR_e964()
LDA         $0017                            ;= ??
JSR         FUN_cb64                                ;undefined FUN_cb64()
ASL         A
PHA
CLC
ADC         #$42
STA         PPU_DATA
LDA         #$20
LDY         #$83
JSR         LAB_PPUADDR_e964                        ;undefined LAB_PPUADDR_e964()
PLA
CLC
ADC         #$41
STA         PPU_DATA
JSR         FUN_cb59                                ;undefined FUN_cb59()
ASL         A
PHA
CLC
ADC         #$42
STA         PPU_DATA
LDA         #$20
LDY         #$64
JSR         LAB_PPUADDR_e964                        ;undefined LAB_PPUADDR_e964()
PLA
CLC
ADC         #$41
STA         PPU_DATA
LDY         #$2
LOOP_PPUDATA_caf5:            ;XREF[1,0]:   caff
JSR         FUN_cb59                                ;undefined FUN_cb59()
CLC
ADC         #$47
STA         PPU_DATA
DEY
BPL         LOOP_PPUDATA_caf5
LDY         #$2
LOOP_cb03:                    ;XREF[1,0]:   cb13
JSR         FUN_cb59                                ;undefined FUN_cb59()
CLC
ADC         #$49
CMP         #$49
BNE         LAB_PPUCTRL_PPUDATA_cb0f
LDA         #$47
LAB_PPUCTRL_PPUDATA_cb0f:     ;XREF[1,0]:   cb0b
STA         PPU_DATA
DEY
BPL         LOOP_cb03
LDA         $0014                            ;= ??
ORA         #$4
STA         PPU_CTRL
LDA         #$0
STA         $0039                            ;= ??
TAX
JSR         LAB_PPUADDR_cb6b                        ;undefined LAB_PPUADDR_cb6b()
INX
JSR         LAB_PPUADDR_cb6b                        ;undefined LAB_PPUADDR_cb6b()
INC         $0039                            ;= ??
INX
JSR         LAB_PPUADDR_cb6b                        ;undefined LAB_PPUADDR_cb6b()
LDA         $0014                            ;= ??
STA         PPU_CTRL
LDA         $0047                            ;= ??
ASL         A
ASL         A
CLC
ADC         #$4c
TAX
LDA         #$20
LDY         #$6c
JSR         LAB_PPUADDR_e964                        ;undefined LAB_PPUADDR_e964()
STX         PPU_DATA
INX
STX         PPU_DATA
LDA         #$20
LDY         #$8c
JSR         LAB_PPUADDR_e964                        ;undefined LAB_PPUADDR_e964()
INX
STX         PPU_DATA
INX
STX         PPU_DATA
RTS
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_cb59()
;XREF[3,0]:   cada,caf5,cb03
LDA         $0017                            ;= ??
SEC
SBC         #$2
BPL         LAB_cb62
LDA         #$0
LAB_cb62:                     ;XREF[1,0]:   cb5e
STA         $0017                            ;= ??
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_cb64()
;XREF[1,0]:   cac1
CMP         #$2
BCC         LAB_cb6a
LDA         #$2
LAB_cb6a:                     ;XREF[1,0]:   cb66
RTS
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined LAB_PPUADDR_cb6b()
;XREF[3,0]:   cb21,cb25,cb2b
LDA         #$20
STA         PPU_ADDR
TXA
CLC
ADC         #$86
STA         PPU_ADDR
LDA         $61,X
BNE         LAB_cb83
LDY         $0039                            ;= ??
BNE         LAB_cb83
LDA         #$a
BNE         LAB_PPUDATA_cb85
LAB_cb83:                     ;XREF[2,0]:   cb79,cb7d
STA         $0039                            ;= ??
LAB_PPUDATA_cb85:             ;XREF[1,0]:   cb81
TAY
; FWD[2,0]:   cb93,cb9d
LDA         $cb93,Y
STA         PPU_DATA
; FWD[2,0]:   cb9e,cba8
LDA         $cb9e,Y
STA         PPU_DATA
RTS
DAT_cb93:                     ;XREF[1,0]:   cb86
.byte $39,$30,$31,$31,$34,$35,$35,$37,$38,$38
DAT_cb9d:                     ;XREF[1,0]:   cb86
.byte $2D
DAT_cb9e:                     ;XREF[1,0]:   cb8c
.byte $36,$3A,$32,$33,$3A,$33,$36,$3A,$36,$33
DAT_cba8:                     ;XREF[1,0]:   cb8c
.byte $2D
DAT_cba9:                     ;XREF[1,0]:   ca88
.byte $C1,$D0,$DF,$EE,$FD,$0C,$1B,$2A,$39,$48,$57,$66
DAT_cbb5:                     ;XREF[1,0]:   ca8d
.byte $CB,$CB,$CB,$CB,$CB,$CC,$CC,$CC,$CC,$CC,$CC,$CC,$61,$63,$68,$71,$77,$7F,$2C,$89,$8F,$92,$2C,$2C,$2C,$99,$92,$61,$64,$69,$72,$78,$7F,$84,$8A,$8F,$92,$94,$2C,$2C,$2C,$9B,$61,$65,$69,$73,$79,$7F,$85,$2C,$90,$92,$92,$2C,$2C,$2C,$2C,$61,$65,$6A,$74,$7A,$7F,$86,$2C,$91,$92,$92,$94,$2C,$2C,$2C,$62,$66,$6B,$77,$7B,$7F,$87,$2C,$2C,$92,$92,$92,$96,$2C,$2C,$62,$66,$6B,$78,$7C,$80,$7F,$8B,$2C,$99,$92,$92,$97,$2C,$2C,$62,$67,$6C,$79,$69,$81,$7F,$8C,$2C,$2C,$92,$92,$92,$9A,$2C,$62,$67,$77,$7A,$72,$82,$7F,$8D,$2C,$2C,$99,$92,$92,$92,$96,$62,$67,$6D,$75,$7D,$2C,$7F,$8F,$8B,$2C,$2C,$92,$92,$92,$97,$62,$67,$6E,$7C,$7D,$84,$88,$8F,$8C,$2C,$2C,$95,$92,$92,$92,$61,$63,$6F,$76,$7E,$85,$82,$8F,$8F,$2C,$2C,$2C,$9B,$92,$92,$61,$63,$70,$69,$74,$83,$2C,$8E,$8F,$93,$2C,$2C,$98,$92,$92
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_cc75()
;XREF[6,0]:   c1c6,ce60,cf8f,e9d0,e9e5,e9fa
LDA         $004f                            ;= ??
AND         #$1
BEQ         LAB_cc7c
RTS
LAB_cc7c:                     ;XREF[1,0]:   cc79
JSR         FUN_cc82                                ;undefined FUN_cc82()
JMP         FUN_fdc8                                ;undefined FUN_fdc8()
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_cc82()
;XREF[1,0]:   cc7c
LDA         #$0
STA         $005f                            ;= ??
STA         $0060                            ;= ??
LDA         $0050                            ;= ??
BNE         LAB_cc93
LDA         $0051                            ;= ??
BNE         LAB_cc93
JMP         LAB_cd72
LAB_cc93:                     ;XREF[2,0]:   cc8a,cc8e
LDA         $0050                            ;= ??
STA         $0017                            ;= ??
LDA         $0051                            ;= ??
ASL         A
ROL         $0017                            ;= ??
CLC
ADC         $0041                            ;= ??
STA         $0041                            ;= ??
LDA         $0042                            ;= ??
ADC         $0017                            ;= ??
STA         $0042                            ;= ??
SEC
SBC         $0045                            ;= ??
STA         $0060                            ;= ??
LDA         $0042                            ;= ??
STA         $0045                            ;= ??
LDA         $0060                            ;= ??
BEQ         LAB_ccc5
CLC
ADC         $0040                            ;= ??
STA         $0040                            ;= ??
CMP         #$8
BCC         LAB_ccc5
SBC         #$8
STA         $0040                            ;= ??
INC         $005f                            ;= ??
INC         $0043                            ;= ??
LAB_ccc5:                     ;XREF[2,0]:   ccb2,ccbb
LDY         #$1
LDA         ($003c),Y                        ;= ??
CMP         $0043                            ;= ??
BCC         LOOP_ccd0
JMP         LAB_cd72
LOOP_ccd0:                    ;XREF[3,0]:   cccb,ccf3,ccfb
LDA         #$0
STA         $0043                            ;= ??
LDA         $003c                            ;= ??
CLC
ADC         #$2
STA         $003c                            ;= ??
BCC         LAB_ccdf
INC         $003c+1
LAB_ccdf:                     ;XREF[1,0]:   ccdb
LDY         #$0
LDA         ($003c),Y                        ;= ??
CMP         #$80
BNE         LAB_ccfd
INC         $0059                            ;= ??
LDA         #$0
STA         $004a                            ;= ??
STA         $004b                            ;= ??
LDA         $00b3                            ;= ??
CMP         #$5
BCC         LOOP_ccd0
INC         $005e                            ;= ??
LDA         #$1
STA         $0059                            ;= ??
BNE         LOOP_ccd0
LAB_ccfd:                     ;XREF[1,0]:   cce5
INY
LDA         ($003c),Y                        ;= ??
BNE         LAB_cd72
LDA         #$60
STA         $003c                            ;= ??
LDA         #$6
STA         $003c+1
LDA         #$0
STA         $0066                            ;= ??
LDA         #$7
STA         $0066+1
LDA         #$0
STA         $0074                            ;= ??
STA         $0043                            ;= ??
STA         $0044                            ;= ??
STA         $0040                            ;= ??
STA         $0045                            ;= ??
STA         $0046                            ;= ??
STA         $0041                            ;= ??
STA         $0042                            ;= ??
JSR         FUN_c7b4                                ;undefined FUN_c7b4()
LDA         $0059                            ;= ??
CMP         #$2
BCC         LAB_cd31
STA         $005b                            ;= ??
BCS         LAB_cd72
LAB_cd31:                     ;XREF[1,0]:   cd2b
LDY         $002d                            ;= ??
LDA         DAT_f074,Y                              ;= 05h
STA         $0017                            ;= ??
LDA         DAT_f07e,Y                              ;= 03h
STA         $0018                            ;= ??
LDA         $005e                            ;= ??
ASL         A
ASL         A
STA         $0019                            ;= ??
LDA         $0017                            ;= ??
SEC
SBC         $0019                            ;= ??
LAB_cd48:                     ;XREF[1,0]:   cd51
STA         $0017                            ;= ??
BPL         LAB_cd54
DEC         $0018                            ;= ??
CLC
ADC         #$a
JMP         LAB_cd48
LAB_cd54:                     ;XREF[1,0]:   cd4a
LDA         $0018                            ;= ??
BPL         LAB_cd5e
LDA         #$0
STA         $0017                            ;= ??
STA         $0018                            ;= ??
LAB_cd5e:                     ;XREF[1,0]:   cd56
LDA         $0077                            ;= ??
CLC
ADC         $0017                            ;= ??
CMP         #$a
BCC         LAB_cd6a
SBC         #$a
SEC
LAB_cd6a:                     ;XREF[1,0]:   cd65
STA         $0077                            ;= ??
LDA         $0078                            ;= ??
ADC         $0018                            ;= ??
STA         $0078                            ;= ??
LAB_cd72:                     ;XREF[4,0]:   cc90,cccd,cd00,cd2f
LDA         #$0
STA         $0018                            ;= ??
STA         $0019                            ;= ??
STA         $001a                            ;= ??
STA         $001b                            ;= ??
LDA         #$14
STA         $001c                            ;= ??
LDA         #$80
STA         $0017                            ;= ??
LDA         $003c                            ;= ??
STA         $003e                            ;= ??
LDA         $003c+1
STA         $003e+1
LDA         $0043                            ;= ??
STA         $0064                            ;= ??
LDX         #$7f
LOOP_cd92:                    ;XREF[1,0]:   cdf7
LDA         $0018                            ;= ??
; FWD[2,0]:   057e,057f
STA         $500,X
LDA         $0017                            ;= ??
CLC
ADC         $0019                            ;= ??
STA         $0017                            ;= ??
LDA         $0018                            ;= ??
ADC         $001a                            ;= ??
STA         $0018                            ;= ??
INC         $001b                            ;= ??
LDA         $001c                            ;= ??
BMI         LAB_cdaf
LSR         A
CMP         $001b                            ;= ??
BCS         LAB_cdf6
LAB_cdaf:                     ;XREF[1,0]:   cda8
LDA         #$0
STA         $001b                            ;= ??
DEC         $001c                            ;= ??
LDY         #$0
STY         $001d                            ;= ??
LDA         ($003e),Y                        ;= ??
BPL         LAB_cdbf
DEC         $001d                            ;= ??
LAB_cdbf:                     ;XREF[1,0]:   cdbb
CLC
ADC         $0019                            ;= ??
STA         $0019                            ;= ??
LDA         $001a                            ;= ??
ADC         $001d                            ;= ??
STA         $001a                            ;= ??
INC         $0064                            ;= ??
INY
LDA         ($003e),Y                        ;= ??
CMP         $0064                            ;= ??
BCS         LAB_cdf6
LOOP_cdd3:                    ;XREF[1,0]:   cde7
LDA         #$0
STA         $0064                            ;= ??
LDA         $003e                            ;= ??
CLC
ADC         #$2
STA         $003e                            ;= ??
BCC         LAB_cde2
INC         $003e+1
LAB_cde2:                     ;XREF[1,0]:   cdde
DEY
LDA         ($003e),Y                        ;= ??
CMP         #$80
BEQ         LOOP_cdd3
INY
LDA         ($003e),Y                        ;= ??
BNE         LAB_cdf6
LDA         #$60
STA         $003e                            ;= ??
LDA         #$6
STA         $003e+1
LAB_cdf6:                     ;XREF[3,0]:   cdad,cdd1,cdec
DEX
BPL         LOOP_cd92
LDA         $005f                            ;= ??
BEQ         LAB_ce33
LDY         #$0
STY         $0017                            ;= ??
LDA         ($003c),Y                        ;= ??
BPL         LAB_ce0c
INC         $0017                            ;= ??
EOR         #$ff
CLC
ADC         #$1
LAB_ce0c:                     ;XREF[1,0]:   ce03
STA         $009f                            ;= ??
LDA         #$20
STA         $00a1                            ;= ??
JSR         FUN_e997                                ;undefined FUN_e997()
LDA         $0017                            ;= ??
BEQ         LAB_ce26
LDA         #$0
SEC
SBC         $00a2                            ;= ??
STA         $00a2                            ;= ??
LDA         #$0
SBC         $00a3                            ;= ??
STA         $00a3                            ;= ??
LAB_ce26:                     ;XREF[1,0]:   ce17
LDA         $00a2                            ;= ??
CLC
ADC         $004b                            ;= ??
STA         $004b                            ;= ??
LDA         $004a                            ;= ??
ADC         $00a3                            ;= ??
STA         $004a                            ;= ??
LAB_ce33:                     ;XREF[1,0]:   cdfb
JSR         LAB_PPUCTRL_PPUSCROLL_c208              ;undefined LAB_PPUCTRL_PPUSCROLL_c208()
JMP         FUN_e1de                                ;undefined FUN_e1de()
LOOP_ce39:                    ;XREF[2,0]:   ce83,ce87
LDA         #$0
STA         $0074                            ;= ??
JMP         LAB_c17e
LOOP_ce40:                    ;XREF[1,0]:   ce8b
LDA         #$0
STA         $0074                            ;= ??
JMP         FUN_cf6c                                ;undefined FUN_cf6c()
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_ce47()
;XREF[1,0]:   c1ef
LDA         #$8
STA         $00a4                            ;= ??
LOOP_ce4b:                    ;XREF[7,0]:   ce8f,ce93,ce99,ce9f,cea5,cea9,cead
JSR         FUN_c91b                                ;undefined FUN_c91b()
JSR         LAB_PPUCTRL_ca38                        ;undefined LAB_PPUCTRL_ca38()
JSR         LAB_PPUMASK_PPUSCROLL_c906              ;undefined LAB_PPUMASK_PPUSCROLL_c906()
STY         $006d                            ;= ??
INY
STY         $006e                            ;= ??
LDY         #$40
JSR         FUN_ff08                                ;undefined FUN_ff08()
INC         $004f                            ;= ??
JSR         FUN_cc75                                ;undefined FUN_cc75()
JSR         FUN_d11b                                ;undefined FUN_d11b()
JSR         FUN_ff14                                ;undefined FUN_ff14()
LDA         $0056                            ;= ??
CMP         #$60
BCC         LAB_ce7a
JSR         FUN_c1fc                                ;undefined FUN_c1fc()
LDA         #$b
STA         $007c                            ;= ??
LDA         #$fa
STA         $009e                            ;= ??
LAB_ce7a:                     ;XREF[1,0]:   ce6d
LDA         $005b                            ;= ??
BEQ         LAB_ce81
JMP         FUN_cf6c                                ;undefined FUN_cf6c()
LAB_ce81:                     ;XREF[1,0]:   ce7c
LDA         $0077                            ;= ??
BNE         LOOP_ce39
LDA         $0078                            ;= ??
BNE         LOOP_ce39
LDA         $005a                            ;= ??
BNE         LOOP_ce40
LDA         $0050                            ;= ??
BNE         LOOP_ce4b
LDA         $0051                            ;= ??
BNE         LOOP_ce4b
LDA         $008f                            ;= ??
CMP         #$f0
BCC         LOOP_ce4b
LDA         $0090                            ;= ??
CMP         #$f0
BCC         LOOP_ce4b
LDA         $0091                            ;= ??
CMP         #$f0
BCC         LOOP_ce4b
LDA         $0056                            ;= ??
BNE         LOOP_ce4b
DEC         $00a4                            ;= ??
BPL         LOOP_ce4b
LDA         #$0
STA         $0034                            ;= ??
STA         $0061                            ;= ??
STA         $0062                            ;= ??
STA         $0063                            ;= ??
LDA         #$1
STA         $00a7                            ;= ??
JSR         FUN_c91b                                ;undefined FUN_c91b()
LDA         #$23
LDY         #$d2
JSR         LAB_PPUADDR_e964                        ;undefined LAB_PPUADDR_e964()
LDA         #$ff
JSR         LAB_PPUDATA_d0fb                        ;undefined LAB_PPUDATA_d0fb()
LDA         #$21
LDY         #$2a
JSR         LAB_PPUADDR_e964                        ;undefined LAB_PPUADDR_e964()
LDY         #$b
LOOP_PPUDATA_ced5:            ;XREF[1,0]:   cedc
; FWD[2,0]:   cf67,cf68
LDA         $cf5d,Y=>DAT_cf68                      ;= 10h
                          ;= 2Dh
STA         PPU_DATA
DEY
BPL         LOOP_PPUDATA_ced5
LDA         #$21
LDY         #$49
JSR         LAB_PPUADDR_e964                        ;undefined LAB_PPUADDR_e964()
LDA         #$2d
LDY         #$e
LOOP_PPUDATA_cee9:            ;XREF[1,0]:   ceed
STA         PPU_DATA
DEY
BPL         LOOP_PPUDATA_cee9
LDA         #$21
LDY         #$68
JSR         LAB_PPUADDR_e964                        ;undefined LAB_PPUADDR_e964()
LDY         #$f
LDA         #$2d
LOOP_PPUDATA_cefa:            ;XREF[1,0]:   cefe
STA         PPU_DATA
DEY
BPL         LOOP_PPUDATA_cefa
JSR         LAB_PPUMASK_PPUSCROLL_c906              ;undefined LAB_PPUMASK_PPUSCROLL_c906()
JSR         FUN_ff08                                ;undefined FUN_ff08()
LDA         #$2
JSR         FUN_f48e                                ;undefined FUN_f48e()
JSR         FUN_ff14                                ;undefined FUN_ff14()
LDA         $00c6                            ;= ??
STA         $0204                            ;= ??
STA         $0304                            ;= ??
LDA         #$fc
STA         $0205                            ;= ??
STA         $0305                            ;= ??
LDA         #$0
STA         $0206                            ;= ??
STA         $0306                            ;= ??
LDA         $00c4                            ;= ??
STA         $0207                            ;= ??
STA         $0307                            ;= ??
LDA         $0071                            ;= ??
BNE         LAB_cf55
STA         $0036                            ;= ??
STA         $0037                            ;= ??
LDA         #$2
STA         $0071                            ;= ??
LOOP_cf3a:                    ;XREF[1,0]:   cf4b
JSR         FUN_c91b                                ;undefined FUN_c91b()
JSR         LAB_PPUCTRL_ca38                        ;undefined LAB_PPUCTRL_ca38()
JSR         LAB_PPUMASK_PPUSCROLL_c906              ;undefined LAB_PPUMASK_PPUSCROLL_c906()
JSR         FUN_ff08                                ;undefined FUN_ff08()
JSR         FUN_ff14                                ;undefined FUN_ff14()
LDA         $00b8                            ;= ??
BPL         LOOP_cf3a
LDA         #$14
JSR         FUN_d0d4                                ;undefined FUN_d0d4()
JMP         LAB_PPUCTRL_e60a                        ;undefined LAB_PPUCTRL_e60a()
LAB_cf55:                     ;XREF[1,0]:   cf30
LDA         #$3c
JSR         FUN_d0d4                                ;undefined FUN_d0d4()
JMP         LAB_PPUCTRL_e60a                        ;undefined LAB_PPUCTRL_e60a()
.byte $2D,$1B,$0E,$1F,$18,$2D,$2D,$0E,$16,$0A
DAT_cf67:                     ;XREF[1,0]:   ced5
.byte $10
DAT_cf68:                     ;XREF[1,0]:   ced5
.byte $2D
DAT_cf69:                     ;XREF[2,0]:   d21e,e831
.byte $00,$05,$0A
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_cf6c()
;XREF[3,0]:   c1f9,ce44,ce7e
LDA         $0050                            ;= ??
STA         $00b6                            ;= ??
LDA         $0051                            ;= ??
STA         $00b7                            ;= ??
JSR         FUN_f3ac                                ;undefined FUN_f3ac()
STA         $0056                            ;= ??
STA         $00b5                            ;= ??
STA         $0034                            ;= ??
LDA         #$a
STA         $005a                            ;= ??
STA         $00a4                            ;= ??
LOOP_cf83:                    ;XREF[5,0]:   cfa3,cfa9,cfaf,cfb5,cfb9
JSR         FUN_c91b                                ;undefined FUN_c91b()
JSR         LAB_PPUCTRL_ca38                        ;undefined LAB_PPUCTRL_ca38()
JSR         LAB_PPUMASK_PPUSCROLL_c906              ;undefined LAB_PPUMASK_PPUSCROLL_c906()
JSR         FUN_e957                                ;undefined FUN_e957()
JSR         FUN_cc75                                ;undefined FUN_cc75()
JSR         FUN_d11b                                ;undefined FUN_d11b()
INC         $004f                            ;= ??
LDA         #$ff
JSR         FUN_f48e                                ;undefined FUN_f48e()
JSR         FUN_ff14                                ;undefined FUN_ff14()
LDA         $00b4                            ;= ??
CMP         #$f0
BCC         LOOP_cf83
LDA         $008f                            ;= ??
CMP         #$f0
BCC         LOOP_cf83
LDA         $0090                            ;= ??
CMP         #$f0
BCC         LOOP_cf83
LDA         $0091                            ;= ??
CMP         #$f0
BCC         LOOP_cf83
DEC         $00a4                            ;= ??
BNE         LOOP_cf83
INC         $0034                            ;= ??
LDA         #$0
STA         $004f                            ;= ??
LDA         #$ff
JSR         FUN_f48e                                ;undefined FUN_f48e()
LDA         #$5a
JSR         FUN_d0d4                                ;undefined FUN_d0d4()
INC         $002d                            ;= ??
INC         $00b3                            ;= ??
JMP         LAB_c13a
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_cfd2()
;XREF[1,0]:   e9c0
LDA         #$1
STA         $00a7                            ;= ??
JSR         LAB_PPUCTRL_PPUMASK_f36e                ;undefined LAB_PPUCTRL_PPUMASK_f36e()
JSR         FUN_c91b                                ;undefined FUN_c91b()
LDA         #$21
STA         $0022                            ;= ??
LDA         #$6
STA         $0022+1
LDX         #$d
LOOP_PPUADDR_cfe6:            ;XREF[1,0]:   d006
LDA         $0022                            ;= ??
STA         PPU_ADDR
LDA         $0022+1
STA         PPU_ADDR
LDA         #$9f
LDY         #$13
LOOP_PPUDATA_cff4:            ;XREF[1,0]:   cff8
STA         PPU_DATA
DEY
BPL         LOOP_PPUDATA_cff4
LDA         $0022+1
CLC
ADC         #$20
STA         $0022+1
BCC         LAB_d005
INC         $0022                            ;= ??
LAB_d005:                     ;XREF[1,0]:   d001
DEX
BPL         LOOP_PPUADDR_cfe6
LDA         #$21
STA         $0022                            ;= ??
LDA         #$69
STA         $0022+1
LDX         #$7
LOOP_PPUADDR_d012:            ;XREF[1,0]:   d032
LDA         $0022                            ;= ??
STA         PPU_ADDR
LDA         $0022+1
STA         PPU_ADDR
LDA         #$2d
LDY         #$d
LOOP_PPUDATA_d020:            ;XREF[1,0]:   d024
STA         PPU_DATA
DEY
BPL         LOOP_PPUDATA_d020
LDA         $0022+1
CLC
ADC         #$20
STA         $0022+1
BCC         LAB_PPUDATA_d031
INC         $0022                            ;= ??
LAB_PPUDATA_d031:             ;XREF[1,0]:   d02d
DEX
BPL         LOOP_PPUADDR_d012
JSR         FUN_c91b                                ;undefined FUN_c91b()
LDA         #$3f
LDY         #$0
JSR         LAB_PPUADDR_e964                        ;undefined LAB_PPUADDR_e964()
LDA         #$f
JSR         LAB_PPUDATA_d101                        ;undefined LAB_PPUDATA_d101()
LDA         #$2a
JSR         LAB_PPUDATA_d101                        ;undefined LAB_PPUDATA_d101()
LDA         #$f
JSR         LAB_PPUDATA_d0fe                        ;undefined LAB_PPUDATA_d0fe()
LDA         #$30
STA         PPU_DATA
LDA         #$f
JSR         LAB_PPUDATA_d101                        ;undefined LAB_PPUDATA_d101()
LDA         #$26
STA         PPU_DATA
LDA         #$2c
STA         PPU_DATA
LDA         #$21
STA         $0017                            ;= ??
LDA         #$8c
STA         $0018                            ;= ??
JSR         FUN_f09d                                ;undefined FUN_f09d()
LDA         #$23
LDY         #$c0
JSR         LAB_PPUADDR_e964                        ;undefined LAB_PPUADDR_e964()
LDY         #$3f
LDA         #$55
LOOP_PPUDATA_d077:            ;XREF[1,0]:   d07b
STA         PPU_DATA
DEY
BPL         LOOP_PPUDATA_d077
LDA         #$23
LDY         #$db
JSR         LAB_PPUADDR_e964                        ;undefined LAB_PPUADDR_e964()
LDA         #$aa
JSR         LAB_PPUDATA_d101                        ;undefined LAB_PPUDATA_d101()
LDA         #$ee
STA         PPU_DATA
LDA         #$23
LDY         #$e2
JSR         LAB_PPUADDR_e964                        ;undefined LAB_PPUADDR_e964()
LDA         #$53
STA         PPU_DATA
LDA         #$50
JSR         LAB_PPUDATA_d101                        ;undefined LAB_PPUDATA_d101()
LDA         #$5c
STA         PPU_DATA
LDA         #$22
LDY         #$2a
JSR         LAB_PPUADDR_e964                        ;undefined LAB_PPUADDR_e964()
LDY         #$a
LOOP_PPUDATA_d0ad:            ;XREF[1,0]:   d0b4
; FWD[2,0]:   d0f3,d0f4
LDA         $d0ea,Y=>DAT_d0f4                      ;= 12h
                          ;= 0Ch
STA         PPU_DATA
DEY
BPL         LOOP_PPUDATA_d0ad
LDA         $00b3                            ;= ??
STA         PPU_DATA
JSR         LAB_PPUMASK_PPUSCROLL_c906              ;undefined LAB_PPUMASK_PPUSCROLL_c906()
JSR         LAB_APU_MASTERCTRL_REG_f46e             ;undefined LAB_APU_MASTERCTRL_REG_f46e()
LDA         #$1
JSR         FUN_f48e                                ;undefined FUN_f48e()
JSR         LAB_JOYPAD_PORT2_f505                   ;undefined LAB_JOYPAD_PORT2_f505()
LOOP_d0c9:                    ;XREF[1,0]:   d0d1
JSR         FUN_c91b                                ;undefined FUN_c91b()
JSR         LAB_JOYPAD_PORT2_f505                   ;undefined LAB_JOYPAD_PORT2_f505()
LDA         $00b8                            ;= ??
BPL         LOOP_d0c9
RTS
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_d0d4()
;XREF[3,0]:   cf4f,cf57,cfc8
STA         $00a4                            ;= ??
LOOP_d0d6:                    ;XREF[1,0]:   d0e7
JSR         FUN_c91b                                ;undefined FUN_c91b()
JSR         LAB_PPUCTRL_ca38                        ;undefined LAB_PPUCTRL_ca38()
JSR         LAB_PPUMASK_PPUSCROLL_c906              ;undefined LAB_PPUMASK_PPUSCROLL_c906()
JSR         FUN_ff08                                ;undefined FUN_ff08()
JSR         FUN_ff14                                ;undefined FUN_ff14()
DEC         $00a4                            ;= ??
BNE         LOOP_d0d6
RTS
.byte $27,$3C,$17,$2D,$1D,$12,$1E,$0C,$1B
DAT_d0f3:                     ;XREF[1,0]:   d0ad
.byte $12
DAT_d0f4:                     ;XREF[1,0]:   d0ad
.byte $0C
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined LAB_PPUDATA_d0f5()
;XREF[1,0]:   ea2e
STA         PPU_DATA
STA         PPU_DATA
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined LAB_PPUDATA_d0fb()
;XREF[4,0]:   c55f,cec9,f386,f398
STA         PPU_DATA
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined LAB_PPUDATA_d0fe()
;XREF[1,0]:   d04a
STA         PPU_DATA
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined LAB_PPUDATA_d101()
;XREF[9,0]:   d040,d045,d054,d086,d09c,e861,e869,ea6f
;             eb49
STA         PPU_DATA
STA         PPU_DATA
RTS
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_d108()
;XREF[2,0]:   d331,d33c
STA         $0200,X                          ;= ??
STA         $0300,X                          ;= ??
STA         $0204,X                          ;= ??
STA         $0304,X                          ;= ??
RTS
DAT_d115:                     ;XREF[2,0]:   d165,d17b
.byte $64,$0A,$01
DAT_d118:                     ;XREF[2,0]:   d16c,d182
.byte $00,$00,$00
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_d11b()
;XREF[6,0]:   c1c9,ce63,cf92,e9d9,e9ee,ea08
LDA         $004f                            ;= ??
AND         #$1
BNE         LAB_d122
RTS
LAB_d122:                     ;XREF[1,0]:   d11f
LDA         $0071                            ;= ??
BNE         LAB_d14d
LDA         $005a                            ;= ??
BNE         LAB_d14d
INC         $0076                            ;= ??
LDA         $0076                            ;= ??
CMP         #$1e
BCC         LAB_d14d
LDA         #$0
STA         $0076                            ;= ??
DEC         $0077                            ;= ??
BPL         LAB_d14d
LDA         #$9
STA         $0077                            ;= ??
DEC         $0078                            ;= ??
BPL         LAB_d14d
LDY         #$0
STY         $0076                            ;= ??
STY         $0077                            ;= ??
STY         $0078                            ;= ??
INY
STY         $0074                            ;= ??
LAB_d14d:                     ;XREF[5,0]:   d124,d128,d130,d138,d140
LDA         $005a                            ;= ??
BNE         LAB_d18c
LDA         #$0
STA         $0061                            ;= ??
STA         $0062                            ;= ??
STA         $0063                            ;= ??
TAX
LDA         $0050                            ;= ??
STA         $0017                            ;= ??
LDA         $0051                            ;= ??
STA         $0018                            ;= ??
LAB_d162:                     ;XREF[2,0]:   d175,d18a
LDA         $0018                            ;= ??
SEC
SBC         DAT_d115,X                              ;= 64h    d
STA         $0018                            ;= ??
LDA         $0017                            ;= ??
SBC         DAT_d118,X
STA         $0017                            ;= ??
BCC         LAB_d178
INC         $61,X
JMP         LAB_d162
LAB_d178:                     ;XREF[1,0]:   d171
LDA         $0018                            ;= ??
CLC
ADC         DAT_d115,X                              ;= 64h    d
STA         $0018                            ;= ??
LDA         $0017                            ;= ??
ADC         DAT_d118,X
STA         $0017                            ;= ??
INX
CPX         #$3
BCC         LAB_d162
LAB_d18c:                     ;XREF[1,0]:   d14f
LDA         $0050                            ;= ??
STA         $0065                            ;= ??
LDA         $0051                            ;= ??
ASL         A
ROL         $0065                            ;= ??
ASL         A
ROL         $0065                            ;= ??
CLC
ADC         $0049                            ;= ??
STA         $0049                            ;= ??
LDA         $0065                            ;= ??
ADC         $0048                            ;= ??
CMP         #$c
BCC         LAB_d1a8
SEC
SBC         #$c
LAB_d1a8:                     ;XREF[1,0]:   d1a3
STA         $0048                            ;= ??
LDA         $006f                            ;= ??
BMI         LAB_d1b2
EOR         #$1
STA         $0047                            ;= ??
LAB_d1b2:                     ;XREF[1,0]:   d1ac
LDA         $0056                            ;= ??
ORA         $005a                            ;= ??
BNE         LAB_d1f9
LDA         $0050                            ;= ??
LSR         A
LDA         $0051                            ;= ??
ROR         A
LDY         $0047                            ;= ??
BEQ         LAB_d1c3
LSR         A
LAB_d1c3:                     ;XREF[1,0]:   d1c0
STA         $0053                            ;= ??
LDA         #$0
STA         $005c                            ;= ??
LDA         $007a                            ;= ??
BEQ         LAB_d1f9
DEC         $007a                            ;= ??
LDA         #$4
STA         $005c                            ;= ??
JSR         FUN_f48e                                ;undefined FUN_f48e()
LDA         #$4
LDY         $0047                            ;= ??
BEQ         LAB_d1de
LDA         #$3
LAB_d1de:                     ;XREF[1,0]:   d1da
STA         $0017                            ;= ??
LDA         $0051                            ;= ??
CLC
ADC         $0017                            ;= ??
STA         $0051                            ;= ??
LDA         $0050                            ;= ??
ADC         #$0
STA         $0050                            ;= ??
LDA         $007a                            ;= ??
CMP         $0053                            ;= ??
STA         $0053                            ;= ??
BCS         LAB_d1f9
LDA         #$0
STA         $007a                            ;= ??
LAB_d1f9:                     ;XREF[3,0]:   d1b6,d1cb,d1f3
LDA         $0079                            ;= ??
EOR         #$7
STA         $0079                            ;= ??
LDA         $0071                            ;= ??
BNE         LAB_d245
LDA         $005f                            ;= ??
BEQ         LAB_d21c
INC         $000f                            ;= ??
LDX         #$0
LOOP_d20b:                    ;XREF[1,0]:   d21a
LDA         $f,X
CMP         #$a
BCC         LAB_d21c
LDA         #$0
STA         $f,X
INC         $10,X
INX
CPX         #$5
BCC         LOOP_d20b
LAB_d21c:                     ;XREF[2,0]:   d205,d20f
LDY         $0033                            ;= ??
LDX         DAT_cf69,Y
LDA         $000f                            ;= ??
SEC
SBC         $0,X
LDA         $0010                            ;= ??
SBC         $1,X
LDA         $0011                            ;= ??
SBC         $2,X
LDA         $0012                            ;= ??
SBC         $3,X
LDA         $0013                            ;= ??
SBC         $4,X
BCC         LAB_d245
LDY         #$0
LOOP_d23a:                    ;XREF[1,0]:   d243
LDA         $f,Y
STA         $0,X
INX
INY
CPY         #$5
BCC         LOOP_d23a
LAB_d245:                     ;XREF[2,0]:   d201,d236
LDA         $005a                            ;= ??
BNE         LAB_d2b2
LDA         #$0
STA         $00c3                            ;= ??
LDA         $004d                            ;= ??
BNE         LAB_d259
LDA         $004c                            ;= ??
CMP         #$62
BCC         LAB_d2b2
BCS         LAB_d25f
LAB_d259:                     ;XREF[1,0]:   d24f
LDA         $004c                            ;= ??
CMP         #$a2
BCS         LAB_d2b2
LAB_d25f:                     ;XREF[1,0]:   d257
INC         $00c3                            ;= ??
LDA         $0053                            ;= ??
CMP         #$44
BCS         LAB_d2a0
LDY         $00a5                            ;= ??
LDA         $0047                            ;= ??
BNE         LAB_d27c
LDA         DAT_c47d,Y
STA         $0017                            ;= ??
LDA         DAT_c43d,Y                              ;= 02h
SEC
SBC         DAT_c41d,Y                              ;= 01h
JMP         LAB_d287
LAB_d27c:                     ;XREF[1,0]:   d26b
LDA         DAT_c4fd,Y                              ;= 20h
STA         $0017                            ;= ??
LDA         DAT_c4bd,Y                              ;= 01h
SEC
SBC         #$1
LAB_d287:                     ;XREF[1,0]:   d279
STA         $0018                            ;= ??
LDA         $0052                            ;= ??
SEC
SBC         $0017                            ;= ??
STA         $0052                            ;= ??
LDA         $0051                            ;= ??
SBC         $0018                            ;= ??
STA         $0051                            ;= ??
LDA         $0050                            ;= ??
SBC         #$0
STA         $0050                            ;= ??
BPL         LAB_d2b2
BMI         LAB_d2af
LAB_d2a0:                     ;XREF[1,0]:   d265
LDA         $0051                            ;= ??
SEC
SBC         #$3
STA         $0051                            ;= ??
LDA         $0050                            ;= ??
SBC         #$0
STA         $0050                            ;= ??
BPL         LAB_d2b2
LAB_d2af:                     ;XREF[1,0]:   d29e
JSR         FUN_f3ac                                ;undefined FUN_f3ac()
LAB_d2b2:                     ;XREF[5,0]:   d247,d255,d25d,d29c,d2ad
LDA         $0050                            ;= ??
BEQ         LAB_d2c0
LDA         $0051                            ;= ??
CMP         #$a0
BCC         LAB_d2c0
LDA         #$1
STA         $0075                            ;= ??
LAB_d2c0:                     ;XREF[2,0]:   d2b4,d2ba
LDA         $0056                            ;= ??
BEQ         LAB_d2c7
JMP         FUN_f254                                ;undefined FUN_f254()
LAB_d2c7:                     ;XREF[1,0]:   d2c2
LDA         $005a                            ;= ??
BEQ         LAB_d2ce
JMP         FUN_f3b5                                ;undefined FUN_f3b5()
LAB_d2ce:                     ;XREF[1,0]:   d2c9
LDA         #$b
LDY         $0070                            ;= ??
BMI         LAB_d2ea
BEQ         LAB_d2e0
DEC         $007c                            ;= ??
LDA         $007c                            ;= ??
BPL         LAB_d2ea
LDA         #$0
BEQ         LAB_d2ea
LAB_d2e0:                     ;XREF[1,0]:   d2d4
INC         $007c                            ;= ??
LDA         $007c                            ;= ??
CMP         #$16
BCC         LAB_d2ea
LDA         #$16
LAB_d2ea:                     ;XREF[4,0]:   d2d2,d2da,d2de,d2e6
STA         $007c                            ;= ??
LDA         $0050                            ;= ??
LSR         A
LDA         $0051                            ;= ??
ROR         A
CLC
ADC         $0055                            ;= ??
STA         $0055                            ;= ??
BCC         LAB_d2ff
LDA         $0054                            ;= ??
EOR         #$5
STA         $0054                            ;= ??
LAB_d2ff:                     ;XREF[1,0]:   d2f7
LDY         $007c                            ;= ??
LDA         $da45,Y=>DAT_da5b                      ;= 04h
CLC
ADC         $0054                            ;= ??
STA         $0019                            ;= ??
TAY
LDA         DAT_da13,Y                              ;= 5Ch    \
STA         $0022                            ;= ??
LDA         DAT_da1d,Y                              ;= DAh
STA         $0022+1
LDA         DAT_da27,Y                              ;= 30h    0
STA         $0017                            ;= ??
LDA         DAT_da31,Y                              ;= 48h    H
STA         $0018                            ;= ??
LDA         DAT_da3b,Y                              ;= 3Ch    <
STA         $001a                            ;= ??
LDX         #$8
LDA         $005c                            ;= ??
BEQ         LAB_d37b
LDA         $007b                            ;= ??
EOR         #$1
STA         $007b                            ;= ??
LDA         #$d2
JSR         FUN_d108                                ;undefined FUN_d108()
LDA         $007b                            ;= ??
BEQ         LAB_d33a
LDA         #$40
LAB_d33a:                     ;XREF[1,0]:   d336
LDX         #$a
JSR         FUN_d108                                ;undefined FUN_d108()
LDA         $007b                            ;= ??
BNE         LAB_d34a
LDA         #$66
LDX         #$6e
JMP         LAB_d34e
LAB_d34a:                     ;XREF[1,0]:   d341
LDA         #$92
LDX         #$8a
LAB_d34e:                     ;XREF[1,0]:   d347
STA         $020b                            ;= ??
STA         $030b                            ;= ??
STX         $020f                            ;= ??
STX         $030f                            ;= ??
LDA         $005d                            ;= ??
TAY
ASL         A
CLC
ADC         #$f3
STA         $0209                            ;= ??
STA         $0309                            ;= ??
ADC         #$1
STA         $020d                            ;= ??
STA         $030d                            ;= ??
LDA         $007b                            ;= ??
BNE         LAB_d379
INY
TYA
AND         #$3
STA         $005d                            ;= ??
LAB_d379:                     ;XREF[1,0]:   d371
LDX         #$10
LAB_d37b:                     ;XREF[1,0]:   d327
LDY         #$0
LOOP_d37d:                    ;XREF[1,0]:   d3ad
LDA         ($0022),Y                        ;= ??
CLC
ADC         #$b8
; FWD[3,0]:   0208,0210,0214
STA         $200,X=>$0210                   ;= ??
; FWD[3,0]:   0308,0310,0314
STA         $300,X=>$0310                   ;= ??
INX
INY
LDA         ($0022),Y                        ;= ??
; FWD[3,0]:   0209,0211,0215
STA         $200,X=>$0211                   ;= ??
; FWD[3,0]:   0309,0311,0315
STA         $300,X=>$0311                   ;= ??
INX
INY
LDA         ($0022),Y                        ;= ??
; FWD[3,0]:   020a,0212,0216
STA         $200,X=>$0212                   ;= ??
; FWD[3,0]:   030a,0312,0316
STA         $300,X=>$0312                   ;= ??
INX
INY
LDA         ($0022),Y                        ;= ??
CLC
ADC         #$80
; FWD[3,0]:   020b,0213,0217
STA         $200,X=>$0213                   ;= ??
; FWD[3,0]:   030b,0313,0317
STA         $300,X=>$0313                   ;= ??
INX
INY
CPY         $0017                            ;= ??
BCC         LOOP_d37d
STX         $002b                            ;= ??
LOOP_d3b1:                    ;XREF[1,0]:   d3d5
LDA         ($0022),Y                        ;= ??
CLC
ADC         #$b8
; FWD[2,0]:   0214,0218
STA         $200,X=>$0214                   ;= ??
INX
INY
LDA         ($0022),Y                        ;= ??
; FWD[2,0]:   0215,0219
STA         $200,X=>$0215                   ;= ??
INX
INY
LDA         ($0022),Y                        ;= ??
; FWD[2,0]:   0216,021a
STA         $200,X=>$0216                   ;= ??
INX
INY
LDA         ($0022),Y                        ;= ??
CLC
ADC         #$80
; FWD[2,0]:   0217,021b
STA         $200,X=>$0217                   ;= ??
INX
INY
CPY         $001a                            ;= ??
BCC         LOOP_d3b1
LDX         $002b                            ;= ??
LOOP_d3d9:                    ;XREF[1,0]:   d3fd
LDA         ($0022),Y                        ;= ??
CLC
ADC         #$b8
; FWD[2,0]:   0314,0318
STA         $300,X=>$0314                   ;= ??
INX
INY
LDA         ($0022),Y                        ;= ??
; FWD[2,0]:   0315,0319
STA         $300,X=>$0315                   ;= ??
INX
INY
LDA         ($0022),Y                        ;= ??
; FWD[2,0]:   0316,031a
STA         $300,X=>$0316                   ;= ??
INX
INY
LDA         ($0022),Y                        ;= ??
CLC
ADC         #$80
; FWD[2,0]:   0317,031b
STA         $300,X=>$0317                   ;= ??
INX
INY
CPY         $0018                            ;= ??
BCC         LOOP_d3d9
LAB_d3ff:                     ;XREF[3,0]:   f28b,f466,f46b
STX         $002b                            ;= ??
LDX         #$2
LAB_d403:                     ;XREF[1,0]:   d5fe
STX         $002c                            ;= ??
; FWD[2,0]:   007e,007f
LDA         $7d,X=>$007f                    ;= ??
; FWD[2,0]:   009c,009d
LDY         $9b,X=>$009d                    ;= ??
BNE         LAB_d40d
LDA         #$3
LAB_d40d:                     ;XREF[1,0]:   d409
STA         $001b                            ;= ??
LDA         $80,X=>$0082                    ;= ??
STA         $001c                            ;= ??
LDA         $89,X=>$008b                    ;= ??
STA         $001d                            ;= ??
LDA         $83,X=>$0085                    ;= ??
LDY         $9b,X=>$009d                    ;= ??
BNE         LAB_d41f
LDA         #$80
LAB_d41f:                     ;XREF[1,0]:   d41b
STA         $001e                            ;= ??
STY         $001f                            ;= ??
LDA         $86,X=>$0088                    ;= ??
STA         $0020                            ;= ??
LDX         $002b                            ;= ??
LDY         $001c                            ;= ??
BNE         LAB_d430
JMP         LAB_d4c0
LAB_d430:                     ;XREF[1,0]:   d42b
LDA         DAT_dd0b,Y                              ;= 08h
CLC
ADC         $001b                            ;= ??
ADC         $0079                            ;= ??
TAY
LDA         DAT_dd14,Y
STA         $0022                            ;= ??
LDA         DAT_dd84,Y
STA         $0022+1
LDA         DAT_de1e,Y
STA         $0018                            ;= ??
LDA         DAT_de2c,Y
STA         $0021                            ;= ??
LDA         DAT_ddf4,Y
CPY         #$2a
BCC         LAB_d462
LDA         #$14
CPY         #$38
BCC         LAB_d462
LDA         #$8
CPY         #$54
BCC         LAB_d462
LDA         #$4
LAB_d462:                     ;XREF[3,0]:   d452,d458,d45e
STA         $0017                            ;= ??
LDY         #$0
LOOP_d466:                    ;XREF[1,0]:   d4be
LDA         ($0022),Y                        ;= ??
CLC
ADC         $001d                            ;= ??
; FWD[2,0]:   0218,021c
STA         $200,X=>$0218                   ;= ??
; FWD[2,0]:   0318,031c
STA         $300,X=>$0318                   ;= ??
CMP         #$50
BCS         LAB_d47d
LDA         #$f0
STA         $200,X=>$0218                   ;= ??
STA         $300,X=>$0318                   ;= ??
LAB_d47d:                     ;XREF[1,0]:   d473
INX
INY
LDA         ($0022),Y                        ;= ??
STA         $200,X=>$0219                   ;= ??
STA         $300,X=>$0319                   ;= ??
INX
INY
LDA         ($0022),Y                        ;= ??
ORA         $001f                            ;= ??
STA         $200,X=>$021a                   ;= ??
STA         $300,X=>$031a                   ;= ??
INX
INY
LDA         ($0022),Y                        ;= ??
CLC
ADC         $001e                            ;= ??
STA         $200,X=>$021b                   ;= ??
STA         $300,X=>$031b                   ;= ??
LDA         #$0
STA         $001a                            ;= ??
LDA         ($0022),Y                        ;= ??
BPL         LAB_d4aa
INC         $001a                            ;= ??
LAB_d4aa:                     ;XREF[1,0]:   d4a6
LDA         $001a                            ;= ??
ADC         $0020                            ;= ??
AND         #$1
BEQ         LAB_d4ba
LDA         #$f0
STA         $1fd,X=>$0218                   ;= ??
STA         $2fd,X=>$0318                   ;= ??
LAB_d4ba:                     ;XREF[1,0]:   d4b0
INX
INY
CPY         $0017                            ;= ??
BCC         LOOP_d466
LAB_d4c0:                     ;XREF[1,0]:   d42d
LDA         $001c                            ;= ??
CMP         #$8
BNE         LAB_d4ca
LDA         $0017                            ;= ??
BNE         LAB_d4cd
LAB_d4ca:                     ;XREF[1,0]:   d4c4
JMP         LAB_d5f7
LAB_d4cd:                     ;XREF[1,0]:   d4c8
STX         $002b                            ;= ??
LOOP_d4cf:                    ;XREF[1,0]:   d515
LDA         ($0022),Y                        ;= ??
CLC
ADC         $001d                            ;= ??
; FWD[2,0]:   0218,021c
STA         $200,X=>$0218                   ;= ??
CMP         #$50
BCS         LAB_d4e0
LDA         #$f0
STA         $200,X=>$0218                   ;= ??
LAB_d4e0:                     ;XREF[1,0]:   d4d9
INX
INY
LDA         ($0022),Y                        ;= ??
STA         $200,X=>$0219                   ;= ??
INX
INY
LDA         ($0022),Y                        ;= ??
ORA         $001f                            ;= ??
STA         $200,X=>$021a                   ;= ??
INX
INY
LDA         ($0022),Y                        ;= ??
CLC
ADC         $001e                            ;= ??
STA         $200,X=>$021b                   ;= ??
LDA         #$0
STA         $001a                            ;= ??
LDA         ($0022),Y                        ;= ??
BPL         LAB_d504
INC         $001a                            ;= ??
LAB_d504:                     ;XREF[1,0]:   d500
LDA         $001a                            ;= ??
ADC         $0020                            ;= ??
AND         #$1
BEQ         LAB_d511
LDA         #$f0
STA         $1fd,X=>$0218                   ;= ??
LAB_d511:                     ;XREF[1,0]:   d50a
INX
INY
CPY         $0021                            ;= ??
BCC         LOOP_d4cf
LDX         $002b                            ;= ??
LOOP_d519:                    ;XREF[1,0]:   d55f
LDA         ($0022),Y                        ;= ??
CLC
ADC         $001d                            ;= ??
; FWD[2,0]:   0318,031c
STA         $300,X=>$0318                   ;= ??
CMP         #$50
BCS         LAB_d52a
LDA         #$f0
STA         $300,X=>$0318                   ;= ??
LAB_d52a:                     ;XREF[1,0]:   d523
INX
INY
LDA         ($0022),Y                        ;= ??
STA         $300,X=>$0319                   ;= ??
INX
INY
LDA         ($0022),Y                        ;= ??
ORA         $001f                            ;= ??
STA         $300,X=>$031a                   ;= ??
INX
INY
LDA         ($0022),Y                        ;= ??
CLC
ADC         $001e                            ;= ??
STA         $300,X=>$031b                   ;= ??
LDA         #$0
STA         $001a                            ;= ??
LDA         ($0022),Y                        ;= ??
BPL         LAB_d54e
INC         $001a                            ;= ??
LAB_d54e:                     ;XREF[1,0]:   d54a
LDA         $001a                            ;= ??
ADC         $0020                            ;= ??
AND         #$1
BEQ         LAB_d55b
LDA         #$f0
STA         $2fd,X=>$0318                   ;= ??
LAB_d55b:                     ;XREF[1,0]:   d554
INX
INY
CPY         $0018                            ;= ??
BCC         LOOP_d519
LDY         $0017                            ;= ??
STX         $002b                            ;= ??
LOOP_d565:                    ;XREF[1,0]:   d5ab
LDA         ($0022),Y                        ;= ??
CLC
ADC         $001d                            ;= ??
; FWD[2,0]:   031c,0320
STA         $300,X=>$031c                   ;= ??
CMP         #$50
BCS         LAB_d576
LDA         #$f0
STA         $300,X=>$031c                   ;= ??
LAB_d576:                     ;XREF[1,0]:   d56f
INX
INY
LDA         ($0022),Y                        ;= ??
STA         $300,X=>$031d                   ;= ??
INX
INY
LDA         ($0022),Y                        ;= ??
ORA         $001f                            ;= ??
STA         $300,X=>$031e                   ;= ??
INX
INY
LDA         ($0022),Y                        ;= ??
CLC
ADC         $001e                            ;= ??
STA         $300,X=>$031f                   ;= ??
LDA         #$0
STA         $001a                            ;= ??
LDA         ($0022),Y                        ;= ??
BPL         LAB_d59a
INC         $001a                            ;= ??
LAB_d59a:                     ;XREF[1,0]:   d596
LDA         $001a                            ;= ??
ADC         $0020                            ;= ??
AND         #$1
BEQ         LAB_d5a7
LDA         #$f0
STA         $2fd,X=>$031c                   ;= ??
LAB_d5a7:                     ;XREF[1,0]:   d5a0
INX
INY
CPY         $0021                            ;= ??
BCC         LOOP_d565
LDX         $002b                            ;= ??
LOOP_d5af:                    ;XREF[1,0]:   d5f5
LDA         ($0022),Y                        ;= ??
CLC
ADC         $001d                            ;= ??
; FWD[2,0]:   021c,0220
STA         $200,X=>$021c                   ;= ??
CMP         #$50
BCS         LAB_d5c0
LDA         #$f0
STA         $200,X=>$021c                   ;= ??
LAB_d5c0:                     ;XREF[1,0]:   d5b9
INX
INY
LDA         ($0022),Y                        ;= ??
STA         $200,X=>$021d                   ;= ??
INX
INY
LDA         ($0022),Y                        ;= ??
ORA         $001f                            ;= ??
STA         $200,X=>$021e                   ;= ??
INX
INY
LDA         ($0022),Y                        ;= ??
CLC
ADC         $001e                            ;= ??
STA         $200,X=>$021f                   ;= ??
LDA         #$0
STA         $001a                            ;= ??
LDA         ($0022),Y                        ;= ??
BPL         LAB_d5e4
INC         $001a                            ;= ??
LAB_d5e4:                     ;XREF[1,0]:   d5e0
LDA         $001a                            ;= ??
ADC         $0020                            ;= ??
AND         #$1
BEQ         LAB_d5f1
LDA         #$f0
STA         $1fd,X=>$021c                   ;= ??
LAB_d5f1:                     ;XREF[1,0]:   d5ea
INX
INY
CPY         $0018                            ;= ??
BCC         LOOP_d5af
LAB_d5f7:                     ;XREF[1,0]:   d4ca
STX         $002b                            ;= ??
LDX         $002c                            ;= ??
DEX
BMI         LAB_d601
JMP         LAB_d403
LAB_d601:                     ;XREF[1,0]:   d5fc
LDX         $002b                            ;= ??
LDA         $0056                            ;= ??
ORA         $005a                            ;= ??
BNE         LAB_d673
LDY         $0019                            ;= ??
LDA         DAT_da13,Y                              ;= 5Ch    \
STA         $0022                            ;= ??
LDA         DAT_da1d,Y                              ;= DAh
STA         $0022+1
LDA         DAT_da31,Y                              ;= 48h    H
STA         $0017                            ;= ??
LDA         DAT_da3b,Y                              ;= 3Ch    <
STA         $001a                            ;= ??
LDA         DAT_da27,Y                              ;= 30h    0
TAY
STX         $002b                            ;= ??
LOOP_d625:                    ;XREF[1,0]:   d649
LDA         ($0022),Y                        ;= ??
CLC
ADC         #$b8
; FWD[2,0]:   0318,031c
STA         $300,X=>$0318                   ;= ??
INX
INY
LDA         ($0022),Y                        ;= ??
; FWD[2,0]:   0319,031d
STA         $300,X=>$0319                   ;= ??
INX
INY
LDA         ($0022),Y                        ;= ??
; FWD[2,0]:   031a,031e
STA         $300,X=>$031a                   ;= ??
INX
INY
LDA         ($0022),Y                        ;= ??
CLC
ADC         #$80
; FWD[2,0]:   031b,031f
STA         $300,X=>$031b                   ;= ??
INX
INY
CPY         $001a                            ;= ??
BCC         LOOP_d625
LDX         $002b                            ;= ??
LOOP_d64d:                    ;XREF[1,0]:   d671
LDA         ($0022),Y                        ;= ??
CLC
ADC         #$b8
; FWD[2,0]:   0218,021c
STA         $200,X=>$0218                   ;= ??
INX
INY
LDA         ($0022),Y                        ;= ??
; FWD[2,0]:   0219,021d
STA         $200,X=>$0219                   ;= ??
INX
INY
LDA         ($0022),Y                        ;= ??
; FWD[2,0]:   021a,021e
STA         $200,X=>$021a                   ;= ??
INX
INY
LDA         ($0022),Y                        ;= ??
CLC
ADC         #$80
; FWD[2,0]:   021b,021f
STA         $200,X=>$021b                   ;= ??
INX
INY
CPY         $0017                            ;= ??
BCC         LOOP_d64d
LAB_d673:                     ;XREF[1,0]:   d607
STX         $002b                            ;= ??
LDA         $0046                            ;= ??
CLC
ADC         $0060                            ;= ??
STA         $0046                            ;= ??
LDY         #$1
LDA         ($0066),Y                        ;= ??
STA         $0017                            ;= ??
CMP         $0046                            ;= ??
BCS         LAB_d6a6
LDA         $0046                            ;= ??
SEC
SBC         $0017                            ;= ??
STA         $0046                            ;= ??
LDA         $0066                            ;= ??
CLC
ADC         #$2
STA         $0066                            ;= ??
BCC         LOOP_d698
INC         $0066+1
LOOP_d698:                    ;XREF[2,0]:   d694,d6a4
LDA         ($0066),Y                        ;= ??
BNE         LAB_d6a6
LDA         #$0
STA         $0066                            ;= ??
LDA         #$7
STA         $0066+1
BNE         LOOP_d698
LAB_d6a6:                     ;XREF[2,0]:   d684,d69a
LDA         $0066                            ;= ??
STA         $0068                            ;= ??
LDA         $0066+1
STA         $0068+1
LDA         $0046                            ;= ??
STA         $006a                            ;= ??
LDX         $002b                            ;= ??
LDA         $0056                            ;= ??
ORA         $005a                            ;= ??
BNE         LAB_d6c2
LOOP_d6ba:                    ;XREF[1,0]:   d6c0
JSR         FUN_ff0b                                ;undefined FUN_ff0b()
INX
CPX         #$a0
BCC         LOOP_d6ba
LAB_d6c2:                     ;XREF[1,0]:   d6b8
LDX         $002b                            ;= ??
CPX         #$b0
BCS         LAB_d6d5
LOOP_d6c8:                    ;XREF[1,0]:   d6d3
LDA         #$ff
; FWD[2,0]:   021c,021d
STA         $200,X=>$021c                   ;= ??
; FWD[2,0]:   031c,031d
STA         $300,X=>$031c                   ;= ??
INX
CPX         #$b0
BCC         LOOP_d6c8
LAB_d6d5:                     ;XREF[1,0]:   d6c6
STX         $002b                            ;= ??
JSR         LAB_PPUCTRL_PPUSCROLL_c208              ;undefined LAB_PPUCTRL_PPUSCROLL_c208()
LDX         #$36
LOOP_d6dc:                    ;XREF[1,0]:   d712
INC         $006a                            ;= ??
LDY         #$1
LDA         ($0068),Y                        ;= ??
STA         $0017                            ;= ??
CMP         $006a                            ;= ??
BCS         LAB_d711
JSR         FUN_d722                                ;undefined FUN_d722()
LDA         $002b                            ;= ??
BPL         LAB_d721
LDA         $006a                            ;= ??
SEC
SBC         $0017                            ;= ??
STA         $006a                            ;= ??
LDA         $0068                            ;= ??
CLC
ADC         #$2
STA         $0068                            ;= ??
BCC         LOOP_d701
INC         $0068+1
LOOP_d701:                    ;XREF[2,0]:   d6fd,d70f
LDY         #$1
LDA         ($0068),Y                        ;= ??
BNE         LAB_d711
LDA         #$0
STA         $0068                            ;= ??
LDA         #$7
STA         $0068+1
BNE         LOOP_d701
LAB_d711:                     ;XREF[2,0]:   d6e6,d705
DEX
BNE         LOOP_d6dc
LDX         $002b                            ;= ??
LDA         #$f0
LOOP_d718:                    ;XREF[1,0]:   d71f
; FWD[2,0]:   021d,021e
STA         $200,X=>$021d                   ;= ??
; FWD[2,0]:   031d,031e
STA         $300,X=>$031d                   ;= ??
INX
BNE         LOOP_d718
LAB_d721:                     ;XREF[1,0]:   d6ed
RTS
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_d722()
;XREF[1,0]:   d6e8
LDY         #$0
LDA         ($0068),Y                        ;= ??
BNE         LAB_d729
RTS
LAB_d729:                     ;XREF[1,0]:   d726
STA         $0019                            ;= ??
STX         $0018                            ;= ??
TXA
ASL         A
ASL         A
TAY
LDA         DAT_e449,Y                              ;= 54h    T
CLC
ADC         #$1c
STA         $001a                            ;= ??
SEC
SBC         #$6b
STA         $001b                            ;= ??
TAY
LSR         A
LSR         A
LSR         A
STA         $0020                            ;= ??
LDA         DAT_e569,Y                              ;= 0Ah
STA         $009f                            ;= ??
LDA         #$b0
STA         $00a1                            ;= ??
JSR         FUN_e997                                ;undefined FUN_e997()
LDA         $0056                            ;= ??
ORA         $005a                            ;= ??
BNE         LAB_d789
LDA         $001a                            ;= ??
CMP         #$c0
BCC         LAB_d789
CMP         #$db
BCS         LAB_d789
LDA         $004d                            ;= ??
BNE         LAB_d770
LDA         $0019                            ;= ??
BMI         LAB_d789
LDA         $004c                            ;= ??
CMP         #$80
BCC         LAB_d789
BCS         LAB_d77a
LAB_d770:                     ;XREF[1,0]:   d762
LDA         $0019                            ;= ??
BPL         LAB_d789
LDA         $004c                            ;= ??
CMP         #$80
BCS         LAB_d789
LAB_d77a:                     ;XREF[1,0]:   d76e
LDA         $0019                            ;= ??
CMP         $0057                            ;= ??
BEQ         LAB_d789
STA         $0057                            ;= ??
JSR         FUN_e40d                                ;undefined FUN_e40d()
LDA         #$3
STA         $0058                            ;= ??
LAB_d789:                     ;XREF[8,0]:   d754,d75a,d75e,d766,d76c,d772,d778,d77e
LDA         $005f                            ;= ??
BEQ         LAB_d797
LDA         $0058                            ;= ??
BEQ         LAB_d797
DEC         $0058                            ;= ??
BNE         LAB_d797
INC         $0057                            ;= ??
LAB_d797:                     ;XREF[3,0]:   d78b,d78f,d793
LDY         $001b                            ;= ??
LDA         #$7c
SEC
SBC         ($003a),Y                        ;= ??
ASL         A
STA         $001c                            ;= ??
LDA         #$0
ADC         #$0
STA         $001d                            ;= ??
LDA         $0019                            ;= ??
BMI         LAB_d7bd
LDA         $001c                            ;= ??
CLC
ADC         $00a3                            ;= ??
STA         $001c                            ;= ??
BCC         LAB_d7ca
LDA         $001d                            ;= ??
EOR         #$1
STA         $001d                            ;= ??
JMP         LAB_d7ca
LAB_d7bd:                     ;XREF[1,0]:   d7a9
LDA         $001c                            ;= ??
SEC
SBC         $00a3                            ;= ??
STA         $001c                            ;= ??
LDA         $001d                            ;= ??
SBC         #$0
STA         $001d                            ;= ??
LAB_d7ca:                     ;XREF[2,0]:   d7b2,d7ba
LDA         $001d                            ;= ??
BEQ         LAB_d7d1
LOOP_d7ce:                    ;XREF[1,0]:   d7d5
JMP         LAB_d8cf
LAB_d7d1:                     ;XREF[1,0]:   d7cc
LDA         $001c                            ;= ??
CMP         #$f8
BCS         LOOP_d7ce
LDA         $0019                            ;= ??
AND         #$f
CMP         #$2
BCS         LAB_d824
LDY         $0020                            ;= ??
LDX         DAT_d8e8,Y
LDA         DAT_d8d2,X                              ;= 01h
STA         $001e                            ;= ??
LDY         DAT_d8d7,X
LDX         $002b                            ;= ??
LOOP_d7ee:                    ;XREF[1,0]:   d81f
LDA         $001a                            ;= ??
STA         $0200,X                          ;= ??
STA         $0300,X                          ;= ??
LDA         $001a                            ;= ??
SEC
SBC         #$8
STA         $001a                            ;= ??
INX
LDA         DAT_d8dc,Y                              ;= D1h
STA         $0200,X                          ;= ??
STA         $0300,X                          ;= ??
INY
INX
LDA         #$0
STA         $0200,X                          ;= ??
STA         $0300,X                          ;= ??
INX
LDA         $001c                            ;= ??
STA         $0200,X                          ;= ??
STA         $0300,X                          ;= ??
INX
BPL         LAB_d821
DEC         $001e                            ;= ??
BNE         LOOP_d7ee
LAB_d821:                     ;XREF[1,0]:   d81b
JMP         LAB_d8cd
LAB_d824:                     ;XREF[1,0]:   d7dd
CMP         #$2
BNE         LAB_d875
LDY         $0020                            ;= ??
LDX         DAT_d8e8,Y
LDA         DAT_d8f8,X                              ;= 01h
STA         $001e                            ;= ??
LDY         $0059                            ;= ??
LDA         DAT_d9ca,Y                              ;= F6h
CLC
ADC         DAT_d8fd,X
TAY
LDX         $002b                            ;= ??
LOOP_d83e:                    ;XREF[1,0]:   d871
LDA         DAT_d902,Y                              ;= E0h
CLC
ADC         $001a                            ;= ??
STA         $0200,X                          ;= ??
STA         $0300,X                          ;= ??
INX
LDA         DAT_d934,Y                              ;= EFh
STA         $0200,X                          ;= ??
STA         $0300,X                          ;= ??
INX
LDA         DAT_d966,Y
STA         $0200,X                          ;= ??
STA         $0300,X                          ;= ??
INX
LDA         DAT_d998,Y                              ;= FCh
CLC
ADC         $001c                            ;= ??
STA         $0200,X                          ;= ??
STA         $0300,X                          ;= ??
INY
INX
BPL         LAB_d8cd
DEC         $001e                            ;= ??
BNE         LOOP_d83e
BEQ         LAB_d8cd
LAB_d875:                     ;XREF[1,0]:   d826
LDY         $0020                            ;= ??
LDX         DAT_d8e8,Y
LDA         DAT_d9cd,X                              ;= 01h
STA         $001e                            ;= ??
LDA         #$1
LDY         $0019                            ;= ??
BMI         LAB_d887
LDA         #$41
LAB_d887:                     ;XREF[1,0]:   d883
STA         $0021                            ;= ??
LDA         DAT_d9d2,X
TAY
LDX         $002b                            ;= ??
LOOP_d88f:                    ;XREF[1,0]:   d8cb
LDA         DAT_d9d7,Y
CLC
ADC         $001a                            ;= ??
STA         $0200,X                          ;= ??
STA         $0300,X                          ;= ??
INX
LDA         DAT_d9e6,Y                              ;= 01h
STA         $0200,X                          ;= ??
STA         $0300,X                          ;= ??
INX
LDA         $0021                            ;= ??
STA         $0200,X                          ;= ??
STA         $0300,X                          ;= ??
INX
LDA         $0019                            ;= ??
BMI         LAB_d8b9
LDA         DAT_da04,Y                              ;= 04h
JMP         LAB_d8bc
LAB_d8b9:                     ;XREF[1,0]:   d8b1
LDA         DAT_d9f5,Y                              ;= 04h
LAB_d8bc:                     ;XREF[1,0]:   d8b6
CLC
ADC         $001c                            ;= ??
STA         $0200,X                          ;= ??
STA         $0300,X                          ;= ??
INY
INX
BPL         LAB_d8cd
DEC         $001e                            ;= ??
BNE         LOOP_d88f
LAB_d8cd:                     ;XREF[4,0]:   d821,d86d,d873,d8c7
STX         $002b                            ;= ??
LAB_d8cf:                     ;XREF[1,0]:   d7ce
LDX         $0018                            ;= ??
RTS
DAT_d8d2:                     ;XREF[1,0]:   d7e4
.byte $01,$01,$02,$03,$05
DAT_d8d7:                     ;XREF[1,0]:   d7e9
.byte $00,$01,$02,$04,$07
DAT_d8dc:                     ;XREF[1,0]:   d7fe
.byte $D1,$D2,$D4,$D3,$D7,$D6,$D5,$DB,$D9,$DA,$D9,$D8
DAT_d8e8:                     ;XREF[3,0]:   d7e1,d82a,d877
.byte $00,$00,$01,$02,$02,$03,$03,$03,$04,$04,$04,$04,$04,$04,$04,$04
DAT_d8f8:                     ;XREF[1,0]:   d82d
.byte $01,$01,$02,$06,$0A
DAT_d8fd:                     ;XREF[1,0]:   d838
.bbyte $00,$01,$02,$04,$0A
DAT_d902:                     ;XREF[1,0]:   d83e
.byte $E0,$E0,$E8,$E8,$F0,$F0,$F8,$F8,$00,$00,$00,$00,$F8,$00,$F0,$F0,$F8,$F8,$00,$00,$E0,$E0,$E8,$E8,$F0,$F0,$F8,$F8,$00,$00,$00,$00,$F8,$00,$F0,$F0,$F8,$F8,$00,$00,$E0,$E0,$E8,$E8,$F0,$F0,$F8,$F8,$00,$00
DAT_d934:                     ;XREF[1,0]:   d84b
.byte $EF,$39,$F0,$F0,$E6,$E6,$F1,$F2,$F0,$F0,$DC,$DD,$EA,$EB,$E0,$EC,$E0,$ED,$E0,$EE,$E9,$E9,$E4,$E5,$E4,$E4,$E9,$E9,$E9,$E9,$DC,$DD,$DE,$DF,$E0,$E1,$E0,$E2,$E0,$E3,$E4,$E5,$E4,$E4,$E6,$E6,$E7,$E8,$E9,$E9
DAT_d966:                     ;XREF[1,0]:   d855
.byte $00,$00,$00,$40,$00,$40,$00,$00,$00,$40,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$40,$00,$00,$00,$40,$00,$40,$00,$40,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$40,$00,$40,$00,$00,$00,$40
DAT_d998:                     ;XREF[1,0]:   d85f
.byte $FC,$04,$FC,$04,$FC,$04,$FC,$04,$FC,$04,$04,$04,$04,$04,$FC,$04,$FC,$04,$FC,$04,$FC,$04,$FC,$04,$FC,$04,$FC,$04,$FC,$04,$04,$04,$04,$04,$FC,$04,$FC,$04,$FC,$04,$FC,$04,$FC,$04,$FC,$04,$FC,$04,$FC,$04
DAT_d9ca:                     ;XREF[1,0]:   d834
.byte $F6,$0A,$1E
DAT_d9cd:                     ;XREF[1,0]:   d87a
.byte $01,$01,$02,$04,$07
DAT_d9d2:                     ;XREF[1,0]:   d889
.byte $00,$01,$02,$04,$08
DAT_d9d7:                     ;XREF[1,0]:   d88f
.byte $00,$00,$F8,$00,$F0,$F0,$F8,$00,$E0,$E0,$E8,$E8,$F0,$F8,$00
DAT_d9e6:                     ;XREF[1,0]:   d89c
.byte $01,$0B,$0C,$0D,$47,$55,$85,$85,$8D,$91,$2F,$34,$32,$32,$32
DAT_d9f5:                     ;XREF[1,0]:   d8b9
.byte $04,$04,$04,$04,$03,$0B,$03,$03,$00,$08,$00,$08,$04,$04,$04
DAT_da04:                     ;XREF[1,0]:   d8b3
.byte $04,$04,$04,$04,$04,$FC,$03,$03,$08,$00,$08,$00,$04,$04,$04
DAT_da13:                     ;XREF[2,0]:   d30a,d60b
.byte $5C,$A4,$E8,$28,$6C,$B4,$FC,$40,$80,$C4
DAT_da1d:                     ;XREF[2,0]:   d30f,d610
.byte $DA,$DA,$DA,$DB,$DB,$DB,$DB,$DC,$DC,$DC
DAT_da27:                     ;XREF[2,0]:   d314,d61f
.byte $30,$2C,$30,$2C,$30,$30,$2C,$30,$2C,$30
DAT_da31:                     ;XREF[2,0]:   d319,d615
.byte $48,$44,$40,$44,$48,$48,$44,$40,$44,$48
DAT_da3b:                     ;XREF[2,0]:   d31e,d61a
.byte $3C,$38,$38,$38,$3C,$3C,$38,$38,$38,$3C,$00,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$02,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03
DAT_da5b:                     ;XREF[1,0]:   d301
.byte $04,$00,$1F,$40,$E8,$00,$1D,$40,$F8,$00,$1C,$40,$00,$08,$23,$40,$F0,$08,$22,$40,$F8,$08,$21,$40,$00,$10,$28,$40,$F8,$10,$27,$40,$00,$10,$26,$40,$08,$18,$2D,$40,$F8,$18,$2C,$40,$00,$18,$2B,$40,$08,$08,$20,$40,$08,$10,$25,$40,$10,$18,$2A,$40,$10,$08,$24,$40,$E8,$10,$29,$40,$F0,$18,$2E,$40,$F0,$00,$00,$40,$EE,$00,$0A,$40,$06,$08,$11,$40,$F6,$08,$10,$40,$FE,$08,$0F,$40,$06,$10,$16,$40,$F6,$10,$15,$40,$FE,$10,$14,$40,$06,$18,$1A,$40,$F6,$18,$19,$40,$FE,$18,$18,$40,$06,$08,$0E,$40,$0E,$10,$13,$40,$0E,$18,$07,$40,$0E,$08,$12,$40,$EE,$10,$17,$40,$EE,$18,$1B,$40,$EE,$00,$00,$00,$F0,$00,$00,$40,$08,$08,$02,$00,$F0,$08,$03,$00,$F8,$08,$03,$40,$00,$08,$02,$40,$08,$10,$05,$00,$F4,$10,$06,$00,$FC,$10,$05,$40,$04,$18,$08,$00,$F4,$18,$09,$00,$FC,$18,$08,$40,$04,$10,$04,$00,$EC,$18,$07,$00,$EC,$10,$04,$40,$0C,$18,$07,$40,$0C,$00,$0A,$00,$F2,$00,$00,$00,$0A,$08,$0F,$00,$F2,$08,$10,$00,$FA,$08,$11,$00,$02,$10,$14,$00,$F2,$10,$15,$00,$FA,$10,$16,$00,$02,$18,$18,$00,$F2,$18,$19,$00,$FA,$18,$1A,$00,$02,$08,$0E,$00,$EA,$10,$13,$00,$EA,$18,$07,$00,$EA,$08,$12,$00,$0A,$10,$17,$00,$0A,$18,$1B,$00,$0A,$00,$1C,$00,$F8,$00,$1D,$00,$00,$00,$1F,$00,$10,$08,$21,$00,$F8,$08,$22,$00,$00,$08,$23,$00,$08,$10,$26,$00,$F0,$10,$27,$00,$F8,$10,$28,$00,$00,$18,$2B,$00,$F0,$18,$2C,$00,$F8,$18,$2D,$00,$00,$08,$20,$00,$F0,$10,$25,$00,$E8,$18,$2A,$00,$E8,$08,$24,$00,$10,$10,$29,$00,$08,$18,$2E,$00,$08,$00,$3B,$40,$E8,$00,$1D,$40,$F8,$00,$1E,$40,$00,$08,$23,$40,$F0,$08,$22,$40,$F8,$08,$3A,$40,$00,$10,$3E,$40,$F8,$10,$27,$40,$00,$10,$26,$40,$08,$18,$2D,$40,$F8,$18,$2C,$40,$00,$18,$2B,$40,$08,$08,$20,$40,$08,$10,$3D,$40,$10,$18,$2A,$40,$10,$08,$3C,$40,$E8,$10,$3F,$40,$F0,$18,$2E,$40,$F0,$00,$00,$40,$EE,$00,$0A,$40,$06,$08,$11,$40,$F6,$08,$10,$40,$FE,$08,$33,$40,$06,$10,$37,$40,$F6,$10,$15,$40,$FE,$10,$14,$40,$06,$18,$1A,$40,$F6,$18,$19,$40,$FE,$18,$18,$40,$06,$08,$0E,$40,$0E,$10,$36,$40,$0E,$18,$07,$40,$0E,$08,$35,$40,$EE,$10,$38,$40,$EE,$18,$1B,$40,$EE,$00,$00,$00,$F0,$00,$00,$40,$08,$08,$30,$00,$F0,$08,$03,$00,$F8,$08,$03,$40,$00,$08,$30,$40,$08,$10,$05,$00,$F4,$10,$06,$00,$FC,$10,$05,$40,$04,$18,$08,$00,$F4,$18,$09,$00,$FC,$18,$08,$40,$04,$10,$31,$00,$EC,$18,$07,$00,$EC,$10,$31,$40,$0C,$18,$07,$40,$0C,$00,$0A,$00,$F2,$00,$00,$00,$0A,$08,$33,$00,$F2,$08,$10,$00,$FA,$08,$11,$00,$02,$10,$14,$00,$F2,$10,$15,$00,$FA,$10,$37,$00,$02,$18,$18,$00,$F2,$18,$19,$00,$FA,$18,$1A,$00,$02,$08,$0E,$00,$EA,$10,$36,$00,$EA,$18,$07,$00,$EA,$08,$35,$00,$0A,$10,$38,$00,$0A,$18,$1B,$00,$0A,$00,$1E,$00,$F8,$00,$1D,$00,$00,$00,$3B,$00,$10,$08,$3A,$00,$F8,$08,$22,$00,$00,$08,$23,$00,$08,$10,$26,$00,$F0,$10,$27,$00,$F8,$10,$3E,$00,$00,$18,$2B,$00,$F0,$18,$2C,$00,$F8,$18,$2D,$00,$00,$08,$20,$00,$F0,$10,$3D,$00,$E8,$18,$2A,$00,$E8,$08,$3C,$00,$10,$10,$3F,$00,$08,$18,$2E,$00
DAT_dd0b:                     ;XREF[2,0]:   d430,f3f9
.byte $08,$62,$54,$46,$38,$2A,$1C,$0E,$00
DAT_dd14:                     ;XREF[1,0]:   d439
.byte $00,$5C,$A4
DAT_dd17:                     ;XREF[1,0]:   f3fc
.byte $E8,$28,$6C,$00,$00,$B4,$FC,$40,$80,$C4,$00,$00,$3A,$6A,$96,$C2,$EE,$00,$00,$1E,$4E,$7A,$A6,$D2,$00,$02,$22,$3A,$52,$6A,$82,$9A,$02,$22,$3A,$52,$6A,$82,$9A,$BA,$CE,$E2,$F6,$0A,$1E,$32,$BA,$CE,$E2,$F6,$0A,$1E,$32,$46,$52,$5A,$62,$6A,$72,$7A,$46,$52,$5A,$62,$6A,$72,$7A,$86,$8E,$96,$9E,$A6,$AE,$B6,$86,$8E,$96,$9E,$A6,$AE,$B6,$BE,$C2,$C6,$CA,$CE,$D2,$D6,$BE,$C2,$C6,$CA,$CE,$D2,$D6,$DA,$DA,$DA,$DA,$DA,$DA,$DA,$DA,$DA,$DA,$DA,$DA,$DA,$DA
DAT_dd84:                     ;XREF[1,0]:   d43e
.byte $00,$DA,$DA
DAT_dd87:                     ;XREF[1,0]:   f401
.byte $DA,$DB,$DB,$00,$00,$DB,$DB,$DC,$DC,$DC,$00,$00,$DE,$DE,$DE,$DE,$DE,$00,$00,$DF,$DF,$DF,$DF,$DF,$00,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E1,$E1,$E1,$E0,$E0,$E0,$E0,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1
DAT_ddf4:                     ;XREF[1,0]:   d44d
.byte $00,$30,$2C
DAT_ddf7:                     ;XREF[1,0]:   f40d
.byte $30,$2C,$30,$00,$00,$30,$2C,$30,$2C,$30,$00,$00,$30,$2C,$2C,$2C,$30,$00,$00,$30,$2C,$2C,$2C,$30,$00,$20,$18,$18,$18,$18,$18,$20,$20,$18,$18,$18,$18,$18,$20
DAT_de1e:                     ;XREF[1,0]:   d443
.byte $00,$48,$44
DAT_de21:                     ;XREF[1,0]:   f406
.byte $40,$44,$48,$00,$00,$48,$44,$40,$44,$48,$00
DAT_de2c:                     ;XREF[1,0]:   d448
.byte $00,$3C,$38,$38,$38,$3C,$00,$00,$3C,$38,$38,$38,$3C,$00,$08,$58,$40,$F0,$08,$57,$40,$F8,$08,$56,$40,$00,$10,$5D,$40,$EC,$10,$5C,$40,$F4,$10,$5B,$40,$FC,$10,$5A,$40,$04,$10,$59,$40,$0C,$18,$61,$40,$F4,$18,$60,$40,$FC,$18,$5F,$40,$04,$18,$5E,$40,$0C,$08,$4A,$40,$F1,$08,$49,$40,$F9,$08,$48,$40,$01,$10,$4E,$40,$F1,$10,$4D,$40,$F9,$10,$4C,$40,$01,$10,$4B,$40,$09,$18,$52,$40,$F1,$18,$51,$40,$F9,$18,$50,$40,$01,$18,$4F,$40,$09,$08,$40,$00,$F4,$08,$41,$00,$FC,$08,$40,$40,$04,$10,$42,$00,$F0,$10,$43,$00,$F8,$10,$43,$40,$00,$10,$42,$40,$08,$18,$44,$00,$F0,$18,$45,$00,$F8,$18,$45,$40,$00,$18,$44,$40,$08,$08,$48,$00,$F7,$08,$49,$00,$FF,$08,$4A,$00,$07,$10,$4B,$00,$EF,$10,$4C,$00,$F7,$10,$4D,$00,$FF,$10,$4E,$00,$07,$18,$4F,$00,$EF,$18,$50,$00,$F7,$18,$51,$00,$FF,$18,$52,$00,$07,$08,$56,$00,$F8,$08,$57,$00,$00,$08,$58,$00,$08,$10,$59,$00,$EC,$10,$5A,$00,$F4,$10,$5B,$00,$FC,$10,$5C,$00,$04,$10,$5D,$00,$0C,$18,$5E,$00,$EC,$18,$5F,$00,$F4,$18,$60,$00,$FC,$18,$61,$00,$04,$08,$58,$40,$F0,$08,$57,$40,$F8,$08,$56,$40,$00,$10,$5D,$40,$EC,$10,$5C,$40,$F4,$10,$5B,$40,$FC,$10,$5A,$40,$04,$10,$59,$40,$0C,$18,$64,$40,$F4,$18,$63,$40,$FC,$18,$5F,$40,$04,$18,$62,$40,$0C,$08,$4A,$40,$F1,$08,$49,$40,$F9,$08,$48,$40,$01,$10,$4E,$40,$F1,$10,$4D,$40,$F9,$10,$4C,$40,$01,$10,$4B,$40,$09,$18,$54,$40,$F1,$18,$51,$40,$F9,$18,$50,$40,$01,$18,$53,$40,$09,$08,$40,$00,$F4,$08,$41,$00,$FC,$08,$40,$40,$04,$10,$42,$00,$F0,$10,$43,$00,$F8,$10,$43,$40,$00,$10,$42,$40,$08,$18,$44,$00,$F0,$18,$45,$00,$F8,$18,$45,$40,$00,$18,$44,$40,$08,$08,$48,$00,$F7,$08,$49,$00,$FF,$08,$4A,$00,$07,$10,$4B,$00,$EF,$10,$4C,$00,$F7,$10,$4D,$00,$FF,$10,$4E,$00,$07,$18,$53,$00,$EF,$18,$50,$00,$F7,$18,$51,$00,$FF,$18,$54,$00,$07,$08,$56,$00,$F8,$08,$57,$00,$00,$08,$58,$00,$08,$10,$59,$00,$EC,$10,$5A,$00,$F4,$10,$5B,$00,$FC,$10,$5C,$00,$04,$10,$5D,$00,$0C,$18,$62,$00,$EC,$18,$5F,$00,$F4,$18,$63,$00,$FC,$18,$64,$00,$04,$10,$78,$40,$F0,$10,$77,$40,$F8,$10,$76,$40,$00,$10,$75,$40,$08,$18,$7C,$40,$F0,$18,$7B,$40,$F8,$18,$7A,$40,$00,$18,$79,$40,$08,$10,$71,$40,$F2,$10,$70,$40,$FA,$10,$6F,$40,$02,$18,$74,$40,$F6,$18,$73,$40,$FE,$18,$72,$40,$06,$10,$6B,$40,$F4,$10,$6A,$40,$FC,$10,$69,$40,$04,$18,$6E,$40,$F4,$18,$6D,$40,$FC,$18,$6C,$40,$04,$10,$65,$00,$F4,$10,$66,$00,$FC,$10,$65,$40,$04,$18,$67,$00,$F4,$18,$68,$00,$FC,$18,$67,$40,$04,$10,$69,$00,$F4,$10,$6A,$00,$FC,$10,$6B,$00,$04,$18,$6C,$00,$F4,$18,$6D,$00,$FC,$18,$6E,$00,$04,$10,$6F,$00,$F6,$10,$70,$00,$FD,$10,$71,$00,$06,$18,$72,$00,$F2,$18,$73,$00,$FA,$18,$74,$00,$02,$10,$75,$00,$F0,$10,$76,$00,$F8,$10,$77,$00,$00,$10,$78,$00,$08,$18,$79,$00,$F0,$18,$7A,$00,$F8,$18,$7B,$00,$00,$18,$7C,$00,$08,$10,$8C,$40,$FC,$10,$8B,$40,$04,$18,$90,$40,$F4,$18,$8F,$40,$FC,$18,$8E,$40,$04,$10,$87,$40,$F4,$10,$86,$40,$FC,$18,$8A,$40,$F4,$18,$89,$40,$FC,$18,$88,$40,$04,$10,$81,$40,$F8,$10,$80,$40,$00,$18,$84,$40,$F4,$18,$83,$40,$FC,$18,$82,$40,$04,$10,$7D,$00,$F8,$10,$7D,$40,$00,$18,$7E,$00,$F4,$18,$7F,$00,$FC,$18,$7E,$40,$04,$10,$80,$00,$F8,$10,$81,$00,$00,$18,$82,$00,$F4,$18,$83,$00,$FC,$18,$84,$00,$04,$10,$86,$00,$FC,$10,$87,$00,$04,$18,$88,$00,$F4,$18,$89,$00,$FC,$18,$8A,$00,$04,$10,$8B,$00,$F4,$10,$8C,$00,$FC,$18,$8E,$00,$F4,$18,$8F,$00,$FC,$18,$90,$00,$04,$18,$99,$40,$F4,$18,$98,$40,$FC,$18,$97,$40,$04,$18,$96,$40,$F7,$18,$95,$40,$FF,$18,$94,$40,$F8,$18,$93,$40,$00,$18,$92,$00,$F8,$18,$92,$40,$00,$18,$93,$00,$F8,$18,$94,$00,$00,$18,$95,$00,$F9,$18,$96,$00,$01,$18,$97,$00,$F4,$18,$98,$00,$FC,$18,$99,$00,$04,$18,$A0,$40,$F8,$18,$9F,$40,$00,$18,$9E,$40,$F8,$18,$9D,$40,$00,$18,$9C,$40,$F8,$18,$9B,$40,$00,$18,$9A,$00,$F8,$18,$9A,$40,$00,$18,$9B,$00,$F8,$18,$9C,$00,$00,$18,$9D,$00,$F8,$18,$9E,$00,$00,$18,$9F,$00,$F8,$18,$A0,$00,$00,$18,$A4,$40,$FC,$18,$A3,$40,$FC,$18,$A2,$40,$FC,$18,$A1,$00,$FC,$18,$A2,$00,$FC,$18,$A3,$00,$FC,$18,$A4,$00,$FC,$18,$A5,$00,$FC
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_e1de()
;XREF[1,0]:   ce36
LDA         $0050                            ;= ??
STA         $001f                            ;= ??
LDA         $0051                            ;= ??
ASL         A
ROL         $001f                            ;= ??
ASL         A
ROL         $001f                            ;= ??
STA         $001e                            ;= ??
SEC
SBC         #$20
STA         $001e                            ;= ??
LDA         $001f                            ;= ??
SBC         #$3
STA         $001f                            ;= ??
LDX         #$2
LAB_e1f9:                     ;XREF[1,0]:   e3fd
; FWD[2,0]:   0090,0091
LDA         $8f,X=>$0091                    ;= ??
CMP         #$f0
BCS         LAB_e202
JMP         LAB_e2aa
LAB_e202:                     ;XREF[1,0]:   e1fd
LDA         #$f8
STA         $8f,X=>$0091                    ;= ??
LDA         #$80
STA         $92,X=>$0094                    ;= ??
JSR         FUN_e96b                                ;undefined FUN_e96b()
LDA         $002e                            ;= ??
AND         #$1
CLC
ADC         #$1
STA         $9b,X=>$009d                    ;= ??
LDA         $002e                            ;= ??
AND         #$f
LSR         A
STA         $95,X=>$0097                    ;= ??
LDA         $001f                            ;= ??
BMI         LAB_e251
LDA         $008f                            ;= ??
CMP         #$30
BCS         LAB_e22a
JMP         LAB_e300
LAB_e22a:                     ;XREF[1,0]:   e225
LDA         $0090                            ;= ??
CMP         #$30
BCS         LAB_e233
JMP         LAB_e300
LAB_e233:                     ;XREF[1,0]:   e22e
LDA         $0091                            ;= ??
CMP         #$30
BCS         LAB_e23c
JMP         LAB_e300
LAB_e23c:                     ;XREF[1,0]:   e237
JSR         FUN_e981                                ;undefined FUN_e981()
LDA         $0030                            ;= ??
AND         #$1f
BEQ         LAB_e248
JMP         LAB_e300
LAB_e248:                     ;XREF[1,0]:   e243
LDA         #$0
STA         $8f,X=>$0091                    ;= ??
STA         $92,X=>$0094                    ;= ??
JMP         LAB_e300
LAB_e251:                     ;XREF[1,0]:   e21f
LDA         $008f                            ;= ??
CMP         #$f0
BCS         LAB_e25e
CMP         #$60
BCC         LAB_e25e
JMP         LAB_e300
LAB_e25e:                     ;XREF[2,0]:   e255,e259
LDA         $0090                            ;= ??
CMP         #$f0
BCS         LAB_e26b
CMP         #$60
BCC         LAB_e26b
JMP         LAB_e300
LAB_e26b:                     ;XREF[2,0]:   e262,e266
LDA         $0091                            ;= ??
CMP         #$f0
BCS         LAB_e278
CMP         #$60
BCC         LAB_e278
JMP         LAB_e300
LAB_e278:                     ;XREF[2,0]:   e26f,e273
LDA         $0056                            ;= ??
ORA         $005a                            ;= ??
BNE         LAB_e28c
LDA         $0074                            ;= ??
BNE         LAB_e28c
LDA         $0034                            ;= ??
BEQ         LAB_e28c
LDA         $009e                            ;= ??
BEQ         LAB_e28f
DEC         $009e                            ;= ??
LAB_e28c:                     ;XREF[3,0]:   e27c,e280,e284
JMP         LAB_e300
LAB_e28f:                     ;XREF[1,0]:   e288
LDA         $95,X=>$0097                    ;= ??
CMP         #$4
BCS         LAB_e300
JSR         FUN_e981                                ;undefined FUN_e981()
LDA         $0030                            ;= ??
BNE         LAB_e300
LDA         $0031                            ;= ??
AND         #$1
BNE         LAB_e300
LDA         #$ef
STA         $8f,X=>$0091                    ;= ??
STA         $92,X=>$0094                    ;= ??
BNE         LAB_e300
LAB_e2aa:                     ;XREF[1,0]:   e1ff
LDA         $92,X=>$0094                    ;= ??
CLC
ADC         $001e                            ;= ??
STA         $92,X=>$0094                    ;= ??
LDA         $8f,X=>$0091                    ;= ??
ADC         $001f                            ;= ??
STA         $8f,X=>$0091                    ;= ??
LDA         $9b,X=>$009d                    ;= ??
BEQ         LAB_e300
LDA         $95,X=>$0097                    ;= ??
CMP         $00b0                            ;= ??
BCS         LAB_e2c5
LDA         #$38
BNE         LAB_e2fe
LAB_e2c5:                     ;XREF[1,0]:   e2bf
CMP         $00b1                            ;= ??
BCS         LAB_e2cd
LDA         #$c8
BNE         LAB_e2fe
LAB_e2cd:                     ;XREF[1,0]:   e2c7
LDA         $8f,X=>$0091                    ;= ??
BMI         LAB_e2d3
INC         $98,X=>$009a                    ;= ??
LAB_e2d3:                     ;XREF[1,0]:   e2cf
LDA         $98,X=>$009a                    ;= ??
AND         $00b2                            ;= ??
BNE         LAB_e2ed
LDA         $8c,X=>$008e                    ;= ??
BMI         LAB_e2e5
CMP         #$38
BCC         LAB_e2e5
LDA         #$38
BNE         LAB_e2fe
LAB_e2e5:                     ;XREF[2,0]:   e2db,e2df
LDA         $8c,X=>$008e                    ;= ??
CLC
ADC         #$7
JMP         LAB_e2fe
LAB_e2ed:                     ;XREF[1,0]:   e2d7
LDA         $8c,X=>$008e                    ;= ??
BPL         LAB_e2f9
CMP         #$c9
BCS         LAB_e2f9
LDA         #$c8
BNE         LAB_e2fe
LAB_e2f9:                     ;XREF[2,0]:   e2ef,e2f3
LDA         $8c,X=>$008e                    ;= ??
SEC
SBC         #$7
LAB_e2fe:                     ;XREF[5,0]:   e2c3,e2cb,e2e3,e2ea,e2f7
STA         $8c,X=>$008e                    ;= ??
LAB_e300:                     ;XREF[14,0]:  e227,e230,e239,e245,e24e,e25b,e268,e275
;             e28c,e293,e29a,e2a0,e2a8,e2b9
LDA         $8f,X=>$0091                    ;= ??
LSR         A
LSR         A
LSR         A
TAY
; FWD[3,0]:   e549,e566,e568
LDA         DAT_e549,Y                              ;= 01h
                          ;= 08h
STA         $80,X=>$0082                    ;= ??
LDY         $8f,X=>$0091                    ;= ??
; FWD[3,0]:   e449,e538,e541
LDA         DAT_e449,Y                              ;= 54h    T
                          ;= F0h
STA         $89,X=>$008b                    ;= ??
SEC
SBC         #$50
CMP         #$80
BCC         LAB_e31b
LDA         #$7f
LAB_e31b:                     ;XREF[1,0]:   e317
TAY
LDA         #$7e
SEC
SBC         ($003a),Y                        ;= ??
ASL         A
STA         $83,X=>$0085                    ;= ??
LDA         #$0
ADC         #$0
STA         $86,X=>$0088                    ;= ??
LDA         #$3
STA         $7d,X=>$007f                    ;= ??
LDA         $89,X=>$008b                    ;= ??
SEC
SBC         #$50
STA         $001c                            ;= ??
TAY
LDA         DAT_e569,Y                              ;= 0Ah
STA         $009f                            ;= ??
LDA         #$0
STA         $001b                            ;= ??
LDA         $8c,X=>$008e                    ;= ??
BPL         LAB_e34a
INC         $001b                            ;= ??
EOR         #$ff
CLC
ADC         #$1
LAB_e34a:                     ;XREF[1,0]:   e341
STA         $00a1                            ;= ??
LDY         #$6
JSR         FUN_e999                                ;undefined FUN_e999()
LDA         $001b                            ;= ??
BEQ         LAB_e365
LDA         $83,X=>$0085                    ;= ??
SEC
SBC         $00a3                            ;= ??
STA         $83,X=>$0085                    ;= ??
LDA         $86,X=>$0088                    ;= ??
SBC         #$0
STA         $86,X=>$0088                    ;= ??
JMP         LAB_e372
LAB_e365:                     ;XREF[1,0]:   e353
LDA         $83,X=>$0085                    ;= ??
CLC
ADC         $00a3                            ;= ??
STA         $83,X=>$0085                    ;= ??
LDA         $86,X=>$0088                    ;= ??
ADC         #$0
STA         $86,X=>$0088                    ;= ??
LAB_e372:                     ;XREF[1,0]:   e362
LDY         $001c                            ;= ??
CPY         #$70
BCC         LAB_e37c
LDA         #$3
BNE         LAB_e3a3
LAB_e37c:                     ;XREF[1,0]:   e376
LDA         ($003a),Y                        ;= ??
DEY
DEY
DEY
DEY
SEC
SBC         ($003a),Y                        ;= ??
STA         $001d                            ;= ??
LDA         ($003a),Y                        ;= ??
DEY
DEY
DEY
DEY
SEC
SBC         ($003a),Y                        ;= ??
CLC
ADC         $001d                            ;= ??
CLC
ADC         #$80
LSR         A
LSR         A
SEC
SBC         #$20
BPL         LAB_e3a0
CLC
ADC         #$1
LAB_e3a0:                     ;XREF[1,0]:   e39b
CLC
ADC         $7d,X=>$007f                    ;= ??
LAB_e3a3:                     ;XREF[1,0]:   e37a
JSR         FUN_e42a                                ;undefined FUN_e42a()
LDA         $001c                            ;= ??
CMP         #$30
BCC         LAB_e3d9
SBC         #$30
LSR         A
LSR         A
LSR         A
STA         $00a1                            ;= ??
LDY         #$3
LDA         $83,X=>$0085                    ;= ??
BMI         LAB_e3c5
EOR         #$7f
STA         $009f                            ;= ??
JSR         FUN_e999                                ;undefined FUN_e999()
LDA         $00a3                            ;= ??
JMP         LAB_e3d3
LAB_e3c5:                     ;XREF[1,0]:   e3b7
EOR         #$80
STA         $009f                            ;= ??
JSR         FUN_e999                                ;undefined FUN_e999()
LDA         $00a3                            ;= ??
EOR         #$ff
CLC
ADC         #$1
LAB_e3d3:                     ;XREF[1,0]:   e3c2
CLC
ADC         $7d,X=>$007f                    ;= ??
JSR         FUN_e42a                                ;undefined FUN_e42a()
LAB_e3d9:                     ;XREF[1,0]:   e3aa
LDA         $0056                            ;= ??
ORA         $005a                            ;= ??
BNE         LAB_e3fa
LDA         $8f,X=>$0091                    ;= ??
CMP         #$f0
BCS         LAB_e3fa
LDA         $89,X=>$008b                    ;= ??
SEC
SBC         #$a5
CMP         #$28
BCS         LAB_e3fa
LDA         $83,X=>$0085                    ;= ??
SEC
SBC         #$63
CMP         #$3c
BCS         LAB_e3fa
JSR         FUN_e40d                                ;undefined FUN_e40d()
LAB_e3fa:                     ;XREF[4,0]:   e3dd,e3e3,e3ec,e3f5
DEX
BMI         LAB_e400
JMP         LAB_e1f9
LAB_e400:                     ;XREF[1,0]:   e3fb
INC         $0035                            ;= ??
LDA         $0035                            ;= ??
CMP         #$3
BCC         LAB_e40c
LDA         #$0
STA         $0035                            ;= ??
LAB_e40c:                     ;XREF[1,0]:   e406
RTS
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_e40d()
;XREF[2,0]:   d782,e3f7
LDA         $0034                            ;= ??
BEQ         LAB_e429
INC         $0056                            ;= ??
LDA         #$0
STA         $0053                            ;= ??
LDA         $0050                            ;= ??
BNE         LAB_e421
LDA         $0051                            ;= ??
CMP         #$c8
BCC         LAB_e429
LAB_e421:                     ;XREF[1,0]:   e419
LDA         #$0
STA         $0050                            ;= ??
LDA         #$c8
STA         $0051                            ;= ??
LAB_e429:                     ;XREF[2,0]:   e40f,e41f
RTS
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_e42a()
;XREF[2,0]:   e3a3,e3d6
BPL         LAB_e42e
LDA         #$0
LAB_e42e:                     ;XREF[1,0]:   e42a
CMP         #$6
BCC         LAB_e434
LDA         #$6
LAB_e434:                     ;XREF[1,0]:   e430
STA         $7d,X
LDY         $80,X
CPY         #$7
BCC         LAB_e448
CMP         #$0
BNE         LAB_e442
INC         $7d,X
LAB_e442:                     ;XREF[1,0]:   e43e
CMP         #$6
BNE         LAB_e448
DEC         $7d,X
LAB_e448:                     ;XREF[2,0]:   e43a,e444
RTS
DAT_e449:                     ;XREF[3,0]:   d731,e30d,f3ea
.byte $54,$54,$54,$54,$54,$54,$54,$54,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$56,$56,$56,$56,$56,$56,$56,$56,$56,$56,$56,$57,$57,$57,$57,$57,$57,$57,$57,$57,$57,$58,$58,$58,$58,$58,$58,$59,$59,$59,$59,$59,$5A,$5A,$5A,$5A,$5A,$5B,$5B,$5B,$5C,$5C,$5C,$5C,$5D,$5D,$5D,$5E,$5E,$5E,$5F,$5F,$5F,$5F,$60,$60,$60,$61,$61,$61,$62,$62,$62,$63,$63,$63,$64,$64,$65,$65,$65,$66,$66,$66,$67,$67,$67,$68,$68,$69,$69,$69,$6A,$6A,$6A,$6B,$6B,$6C,$6C,$6C,$6D,$6D,$6E,$6E,$70,$70,$70,$71,$71,$72,$72,$73,$73,$73,$74,$74,$75,$75,$76,$76,$77,$77,$77,$78,$78,$79,$79,$7A,$7A,$7B,$7B,$7C,$7C,$7D,$7D,$7E,$7F,$7F,$80,$80,$81,$81,$82,$82,$83,$84,$84,$85,$85,$86,$86,$87,$88,$88,$89,$89,$8A,$8B,$8B,$8C,$8D,$8D,$8E,$8F,$90,$90,$91,$92,$93,$94,$94,$95,$96,$97,$98,$99,$9A,$9B,$9C,$9D,$9E,$A0,$A1,$A2,$A3,$A4,$A6,$A7,$A8,$A9,$AB,$AC,$AD,$AF,$B0,$B1,$B3,$B4,$B6,$B7,$B9,$BB,$BC,$BE,$C0,$C1,$C3,$C5,$C7,$C8,$CA,$CC,$CE,$D0,$D2,$D4,$D6,$D8,$DA,$DC,$DE,$E0,$E2,$E4,$E6,$E8,$EA,$EC,$EE,$F0
DAT_e538:                     ;XREF[1,0]:   e30d
.byte $F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0
DAT_e541:                     ;XREF[1,0]:   e30d
.byte $F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0
DAT_e549:                     ;XREF[2,0]:   e306,f3f4
.byte $01,$01,$01,$01,$01,$02,$02,$02,$02,$03,$03,$04,$04,$04,$04,$05,$05,$05,$06,$06,$06,$07,$07,$07,$08,$08,$08,$08,$08
DAT_e566:                     ;XREF[1,0]:   e306
.byte $08,$00
DAT_e568:                     ;XREF[1,0]:   e306
.byte $00
DAT_e569:                     ;XREF[2,0]:   d744,e336
.byte $0A,$0C,$0E,$10,$12,$14,$16,$18,$1A,$1C,$1E,$20,$22,$24,$26,$28,$29,$2B,$2C,$2E,$2F,$31,$32,$34,$35,$37,$38,$3A,$3B,$3D,$3E,$40,$41,$43,$44,$46,$47,$49,$4A,$4C,$4D,$4F,$50,$52,$53,$55,$56,$58,$59,$5B,$5C,$5E,$5F,$61,$62,$64,$65,$67,$68,$6A,$6B,$6D,$6E,$70,$71,$73,$74,$76,$77,$79,$7A,$7C,$7D,$7F,$80,$82,$83,$85,$86,$88,$89,$8B,$8C,$8E,$8F,$91,$92,$94,$95,$97,$98,$9A,$9B,$9D,$9E,$A0,$A1,$A3,$A4,$A6,$A7,$A9,$AA,$AC,$AD,$AF,$B0,$B2,$B3,$B5,$B6,$B8,$B9,$BB,$BC,$BE,$BF,$C1,$C2,$C4,$C5,$C7,$C8,$CA,$CB,$CD,$CE,$D0,$D1,$D3,$D4,$D6,$D7,$D9,$DA,$DC,$DD,$DF,$E0,$E2,$E3,$E5,$E6,$E8,$E9,$EB,$EC,$EE,$EF,$F1,$F2,$F4,$F5,$F7,$F8,$FA,$FB,$FD,$FE,$FF,$FF
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined LAB_PPUCTRL_e60a()
;XREF[4,0]:   c063,c930,cf52,cf5a
LDA         #$1
STA         $002a                            ;= ??
JSR         LAB_PPUCTRL_PPUMASK_f36e                ;undefined LAB_PPUCTRL_PPUMASK_f36e()
JSR         LAB_APU_MASTERCTRL_REG_f46e             ;undefined LAB_APU_MASTERCTRL_REG_f46e()
LDY         #$0
STY         $004f                            ;= ??
INY
STY         $0071                            ;= ??
LDA         #$ff
JSR         FUN_f48e                                ;undefined FUN_f48e()
JSR         LAB_JOYPAD_PORT2_f505                   ;undefined LAB_JOYPAD_PORT2_f505()
JSR         FUN_c91b                                ;undefined FUN_c91b()
LDA         $0014                            ;= ??
STA         PPU_CTRL
LDA         #$20
LDY         #$40
JSR         LAB_PPUADDR_e964                        ;undefined LAB_PPUADDR_e964()
LDY         #$0
LOOP_e634:                    ;XREF[1,0]:   e659
LDA         DAT_e86d,Y                              ;= 0Ah
BEQ         LAB_e65b
CMP         #$20
BCS         LAB_PPUDATA_e655
AND         #$f
TAX
LDA         DAT_e86d,Y                              ;= 0Ah
AND         #$10
BNE         LAB_e64b
LDA         #$2d
BNE         LOOP_PPUDATA_e64d
LAB_e64b:                     ;XREF[1,0]:   e645
LDA         #$2e
LOOP_PPUDATA_e64d:            ;XREF[2,0]:   e649,e651
STA         PPU_DATA
DEX
BPL         LOOP_PPUDATA_e64d
BMI         LAB_e658
LAB_PPUDATA_e655:             ;XREF[1,0]:   e63b
STA         PPU_DATA
LAB_e658:                     ;XREF[1,0]:   e653
INY
BNE         LOOP_e634
LAB_e65b:                     ;XREF[1,0]:   e637
JSR         FUN_c91b                                ;undefined FUN_c91b()
LDA         #$22
LDY         #$a
LDX         #$1
JSR         FUN_e812                                ;undefined FUN_e812()
LDA         #$22
LDY         #$4a
INX
JSR         FUN_e812                                ;undefined FUN_e812()
LDA         #$22
LDY         #$8a
INX
JSR         FUN_e812                                ;undefined FUN_e812()
LDA         #$24
LDY         #$60
STY         $0017                            ;= ??
JSR         LAB_PPUADDR_e964                        ;undefined LAB_PPUADDR_e964()
LDY         #$7f
LOOP_PPUDATA_e682:            ;XREF[1,0]:   e698
LDA         $0017                            ;= ??
AND         #$1
EOR         #$1
STA         $0017                            ;= ??
ASL         A
ADC         #$2d
STA         PPU_DATA
TYA
AND         #$1f
BNE         LAB_e697
INC         $0017                            ;= ??
LAB_e697:                     ;XREF[1,0]:   e693
DEY
BPL         LOOP_PPUDATA_e682
LDA         #$23
LDY         #$c0
JSR         LAB_PPUADDR_e964                        ;undefined LAB_PPUADDR_e964()
LDY         #$0
LOOP_e6a3:                    ;XREF[1,0]:   e6b1
LDA         DAT_e90e,Y
LDX         #$7
LOOP_PPUDATA_e6a8:            ;XREF[1,0]:   e6ac
STA         PPU_DATA
DEX
BPL         LOOP_PPUDATA_e6a8
INY
CPY         #$8
BCC         LOOP_e6a3
LDA         #$27
LDY         #$c0
JSR         LAB_PPUADDR_e964                        ;undefined LAB_PPUADDR_e964()
LDY         #$0
TYA
LOOP_PPUDATA_e6bd:            ;XREF[1,0]:   e6c3
STA         PPU_DATA
INY
CPY         #$40
BCC         LOOP_PPUDATA_e6bd
JSR         FUN_c91b                                ;undefined FUN_c91b()
LDA         #$3f
LDY         #$0
JSR         LAB_PPUADDR_e964                        ;undefined LAB_PPUADDR_e964()
LOOP_PPUDATA_e6cf:            ;XREF[1,0]:   e6d8
LDA         DAT_e916,Y                              ;= 0Fh
STA         PPU_DATA
INY
CPY         #$20
BCC         LOOP_PPUDATA_e6cf
LDA         #$3f
LDY         #$0
JSR         LAB_PPUADDR_e964                        ;undefined LAB_PPUADDR_e964()
TYA
JSR         LAB_PPUADDR_e964                        ;undefined LAB_PPUADDR_e964()
LDA         #$23
LDY         #$49
JSR         LAB_PPUADDR_e964                        ;undefined LAB_PPUADDR_e964()
LDY         #$d
LOOP_PPUDATA_e6ee:            ;XREF[1,0]:   e6f5
; FWD[2,0]:   e942,e943
LDA         $e936,Y=>DAT_e943                      ;= 01h
                          ;= 24h
STA         PPU_DATA
DEY
BPL         LOOP_PPUDATA_e6ee
LDA         #$22
LDY         #$eb
JSR         LAB_PPUADDR_e964                        ;undefined LAB_PPUADDR_e964()
LDY         #$3
LOOP_PPUCTRL_PPUMASK_PPUSCR...;XREF[1,0]:   e707
; FWD[2,0]:   e952,e953
LDA         $e950,Y=>DAT_e953                      ;= 18h
                          ;= 1Dh
STA         PPU_DATA
DEY
BPL         LOOP_PPUCTRL_PPUMASK_PPUSCROLL_PPUDAT...
JSR         FUN_e824                                ;undefined FUN_e824()
LDA         $0033                            ;= ??
ASL         A
ASL         A
ASL         A
ASL         A
CLC
ADC         #$7f
STA         $0200                            ;= ??
LDA         #$ff
STA         $0201                            ;= ??
LDA         #$0
STA         $0202                            ;= ??
LDA         #$40
STA         $0203                            ;= ??
JSR         FUN_c91b                                ;undefined FUN_c91b()
LDA         #$20
LDY         #$0
JSR         LAB_PPUADDR_e964                        ;undefined LAB_PPUADDR_e964()
STY         PPU_SCROLL
STY         PPU_SCROLL
LDA         #$91
STA         PPU_CTRL
LDA         #$1e
STA         PPU_MASK
LDY         #$0
STY         $0017                            ;= ??
DEY
STY         $0018                            ;= ??
LAB_PPUCTRL_PPUSCROLL_e748:   ;XREF[1,0]:   e794
JSR         FUN_c91b                                ;undefined FUN_c91b()
LDA         $0017                            ;= ??
STA         PPU_SCROLL
LDA         #$0
STA         PPU_SCROLL
TAY
LDA         #$91
STA         PPU_CTRL
LDX         #$6
LOOP_PPUCTRL_PPUSCROLL_e75d:  ;XREF[1,0]:   e761
JSR         FUN_ff08                                ;undefined FUN_ff08()
DEX
BPL         LOOP_PPUCTRL_PPUSCROLL_e75d
LDA         $0018                            ;= ??
STA         PPU_SCROLL
STA         PPU_SCROLL
LDA         $0014                            ;= ??
STA         PPU_CTRL
LDX         #$4
LOOP_PPUSCROLL_e772:          ;XREF[1,0]:   e776
JSR         FUN_ff08                                ;undefined FUN_ff08()
DEX
BPL         LOOP_PPUSCROLL_e772
LDA         #$0
STA         PPU_SCROLL
STA         PPU_SCROLL
LDA         $0017                            ;= ??
CLC
ADC         #$4
STA         $0017                            ;= ??
LDA         $0018                            ;= ??
SEC
SBC         #$4
STA         $0018                            ;= ??
LDA         $0017                            ;= ??
CMP         #$fc
BEQ         LAB_PPUCTRL_PPUSCROLL_e797
JMP         LAB_PPUCTRL_PPUSCROLL_e748
LAB_PPUCTRL_PPUSCROLL_e797:   ;XREF[1,0]:   e792
JSR         FUN_c91b                                ;undefined FUN_c91b()
LDA         $0014                            ;= ??
STA         PPU_CTRL
LDA         #$0
STA         PPU_SCROLL
STA         PPU_SCROLL
DEC         $0037                            ;= ??
BPL         LOOP_e7b4
LDA         #$3
JSR         FUN_f48e                                ;undefined FUN_f48e()
LDA         #$2
STA         $0037                            ;= ??
LOOP_e7b4:                    ;XREF[2,0]:   e7a9,e7f4
LDA         #$58
STA         $0018                            ;= ??
LDA         #$2
STA         $0019                            ;= ??
STA         $0017                            ;= ??
LOOP_e7be:                    ;XREF[3,0]:   e801,e805,e809
JSR         FUN_e96b                                ;undefined FUN_e96b()
JSR         FUN_e981                                ;undefined FUN_e981()
JSR         FUN_e981                                ;undefined FUN_e981()
JSR         FUN_c91b                                ;undefined FUN_c91b()
JSR         FUN_e824                                ;undefined FUN_e824()
JSR         LAB_PPUMASK_PPUSCROLL_c906              ;undefined LAB_PPUMASK_PPUSCROLL_c906()
JSR         LAB_JOYPAD_PORT2_f505                   ;undefined LAB_JOYPAD_PORT2_f505()
LDA         $0033                            ;= ??
ASL         A
ASL         A
ASL         A
ASL         A
CLC
ADC         #$7f
STA         $0200                            ;= ??
LDA         $0017                            ;= ??
BNE         LAB_e7f7
LDA         $006b                            ;= ??
BEQ         LAB_e7f7
LDA         $0033                            ;= ??
CLC
ADC         #$1
CMP         #$3
BCC         LAB_e7f2
LDA         #$0
LAB_e7f2:                     ;XREF[1,0]:   e7ee
STA         $0033                            ;= ??
JMP         LOOP_e7b4
LAB_e7f7:                     ;XREF[2,0]:   e7e1,e7e5
LDA         $006b                            ;= ??
STA         $0017                            ;= ??
DEC         $0018                            ;= ??
LDA         $0018                            ;= ??
CMP         #$ff
BNE         LOOP_e7be
DEC         $0019                            ;= ??
BPL         LOOP_e7be
LDA         $00b8                            ;= ??
BPL         LOOP_e7be
LDA         #$0
STA         $002a                            ;= ??
JMP         FUN_c0d5                                ;undefined FUN_c0d5()
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_e812()
;XREF[3,0]:   e664,e66c,e674
JSR         LAB_PPUADDR_e964                        ;undefined LAB_PPUADDR_e964()
LDY         #$b
LOOP_PPUDATA_e817:            ;XREF[1,0]:   e81e
; FWD[2,0]:   e94e,e94f
LDA         $e944,Y=>DAT_e94f                      ;= 14h
                          ;= 1Ch
STA         PPU_DATA
DEY
BPL         LOOP_PPUDATA_e817
STX         PPU_DATA
RTS
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_e824()
;XREF[2,0]:   e709,e7ca
LDA         #$0
STA         $0038                            ;= ??
LDA         #$22
LDY         #$ef
JSR         LAB_PPUADDR_e964                        ;undefined LAB_PPUADDR_e964()
LDY         $0033                            ;= ??
LDA         DAT_cf69,Y
CLC
ADC         #$4
TAX
LDY         #$4
LOOP_e83a:                    ;XREF[1,0]:   e851
STX         $001a                            ;= ??
LDA         $0,X
BNE         LAB_e848
LDX         $0038                            ;= ??
BNE         LAB_PPUDATA_e84a
LDA         #$2d
BNE         LAB_PPUDATA_e84a
LAB_e848:                     ;XREF[1,0]:   e83e
STA         $0038                            ;= ??
LAB_PPUDATA_e84a:             ;XREF[2,0]:   e842,e846
STA         PPU_DATA
LDX         $001a                            ;= ??
DEX
DEY
BPL         LOOP_e83a
LDA         #$0
STA         PPU_DATA
LDA         #$3f
LDY         #$8
JSR         LAB_PPUADDR_e964                        ;undefined LAB_PPUADDR_e964()
LDA         #$f
JSR         LAB_PPUDATA_d101                        ;undefined LAB_PPUDATA_d101()
LDY         $0033                            ;= ??
LDA         DAT_e954,Y                              ;= 21h    !
JSR         LAB_PPUDATA_d101                        ;undefined LAB_PPUDATA_d101()
RTS
DAT_e86d:                     ;XREF[2,0]:   e634,e640
.byte $0A,$13,$FE,$02,$A9,$11,$09,$2F,$2D,$2F,$2D,$2F,$2D,$2F,$2D,$2F,$01,$11,$05,$12,$01,$2F,$2D,$2F,$2D,$2F,$2D,$2F,$2D,$2D,$2F,$2D,$2F,$2D,$2F,$2D,$2F,$02,$12,$FE,$2D,$11,$01,$11,$02,$2F,$2D,$2F,$2D,$2F,$2D,$2F,$2F,$2D,$2F,$2D,$2F,$2D,$2F,$03,$11,$06,$11,$03,$2F,$2D,$2F,$2D,$2F,$2D,$2D,$2F,$2D,$2F,$2D,$2F,$04,$11,$06,$11,$04,$2F,$2D,$2F,$2D,$2F,$0F,$0F,$0F,$0F,$04,$13,$FB,$2D,$FA,$12,$FB,$2D,$FA,$12,$FB,$2D,$13,$FE,$08,$11,$2D,$11,$2D,$11,$2D,$11,$2D,$11,$2D,$11,$2D,$11,$0B,$13,$FD,$2D,$11,$2D,$11,$2D,$11,$03,$12,$FE,$09,$11,$FF,$2E,$BA,$2D,$14,$2D,$11,$2D,$11,$2D,$11,$0B,$11,$2D,$FF,$2E,$2D,$11,$2D,$11,$2D,$FC,$12,$FD,$2D,$13,$FE,$03,$00
DAT_e90e:                     ;XREF[1,0]:   e6a3
.byte $00,$00,$00,$00,$55,$A5,$FF,$00
DAT_e916:                     ;XREF[1,0]:   e6cf
.byte $0F,$0F,$16,$30,$0F,$0F,$27,$27,$0F,$0F,$21,$21,$0F,$0F,$30,$30,$0F,$3A,$00,$00,$0F,$00,$00,$00,$0F,$00,$00,$00,$0F,$00,$00,$00,$18,$0D,$17,$0E,$1D,$17,$12,$17,$2D,$04,$08,$09
DAT_e942:                     ;XREF[1,0]:   e6ee
.byte $01
DAT_e943:                     ;XREF[1,0]:   e6ee
.byte $24,$2D,$15,$0E,$1F,$0E,$15,$2D,$15,$15,$12
DAT_e94e:                     ;XREF[1,0]:   e817
.byte $14
DAT_e94f:                     ;XREF[1,0]:   e817
.byte $1C,$26,$19
DAT_e952:                     ;XREF[1,0]:   e700
.byte $18
DAT_e953:                     ;XREF[1,0]:   e700
.byte $1D
DAT_e954:                     ;XREF[1,0]:   e866
.byte $21,$25,$2A
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_e957()
;XREF[4,0]:   cf8c,e9cd,e9e2,e9f7
LDA         #$0
STA         $006d                            ;= ??
STA         $006e                            ;= ??
LDA         #$ff
STA         $006f                            ;= ??
STA         $0070                            ;= ??
RTS
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined LAB_PPUADDR_e964()
;XREF[59,0]:  c558,c576,c5a7,c5ab,c5b4,c5da,c5ff,c60f
;             c61f,c62f,c641,c656,c667,c685,c6ae,c753
;             c767,c77b,c90a,c97c,c997,ca47,ca60,ca96
;             cabc,cad0,cae9,cb3f,cb4d,cec4,ced0,cee2
;             cef3,d03b,d070,d081,d092,d0a8,e62f,e67d
;             e69e,e6b7,e6cc,e6de,e6e2,e6e9,e6fb,e72e
;             e812,e82c,e85c,ea2a,ea5e,ea6a,eb2e,eb44
;             f0af,f381,f393
STA         PPU_ADDR
STY         PPU_ADDR
RTS
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_e96b()
;XREF[3,0]:   c579,e20a,e7be
ASL         $002e                            ;= ??
ROL         $002f                            ;= ??
ROL         A
ROL         A
EOR         $002e                            ;= ??
ROL         A
EOR         $002e                            ;= ??
LSR         A
LSR         A
EOR         #$ff
AND         #$1
ORA         $002e                            ;= ??
STA         $002e                            ;= ??
RTS
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_e981()
;XREF[4,0]:   e23c,e295,e7c1,e7c4
ASL         $0030                            ;= ??
ROL         $0031                            ;= ??
ROL         A
ROL         A
EOR         $0030                            ;= ??
ROL         A
EOR         $0030                            ;= ??
LSR         A
LSR         A
EOR         #$ff
AND         #$1
ORA         $0030                            ;= ??
STA         $0030                            ;= ??
RTS
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_e997()
;XREF[2,0]:   ce12,d74d
LDY         #$7
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_e999()
;XREF[3,0]:   e34e,e3bd,e3c9
LDA         #$0
STA         $00a0                            ;= ??
STA         $00a2                            ;= ??
STA         $00a3                            ;= ??
LOOP_e9a1:                    ;XREF[1,0]:   e9b7
LSR         $00a1                            ;= ??
BCC         LAB_e9b2
LDA         $00a2                            ;= ??
CLC
ADC         $009f                            ;= ??
STA         $00a2                            ;= ??
LDA         $00a3                            ;= ??
ADC         $00a0                            ;= ??
STA         $00a3                            ;= ??
LAB_e9b2:                     ;XREF[1,0]:   e9a3
ASL         $009f                            ;= ??
ROL         $00a0                            ;= ??
DEY
BPL         LOOP_e9a1
RTS
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_e9ba()
;XREF[1,0]:   c15a
INC         $0034                            ;= ??
LDA         $0071                            ;= ??
BNE         LAB_e9c3
JSR         FUN_cfd2                                ;undefined FUN_cfd2()
LAB_e9c3:                     ;XREF[1,0]:   e9be
JSR         LAB_PPUMASK_c543                        ;undefined LAB_PPUMASK_c543()
LDA         #$0
STA         $004f                            ;= ??
JSR         LAB_PPUCTRL_ca38                        ;undefined LAB_PPUCTRL_ca38()
JSR         FUN_e957                                ;undefined FUN_e957()
JSR         FUN_cc75                                ;undefined FUN_cc75()
JSR         FUN_ff14                                ;undefined FUN_ff14()
JSR         FUN_c91b                                ;undefined FUN_c91b()
JSR         FUN_d11b                                ;undefined FUN_d11b()
JSR         FUN_ff14                                ;undefined FUN_ff14()
JSR         FUN_c91b                                ;undefined FUN_c91b()
JSR         FUN_e957                                ;undefined FUN_e957()
JSR         FUN_cc75                                ;undefined FUN_cc75()
JSR         FUN_ff14                                ;undefined FUN_ff14()
JSR         FUN_c91b                                ;undefined FUN_c91b()
JSR         FUN_d11b                                ;undefined FUN_d11b()
JSR         FUN_ff14                                ;undefined FUN_ff14()
JSR         FUN_c91b                                ;undefined FUN_c91b()
JSR         FUN_e957                                ;undefined FUN_e957()
JSR         FUN_cc75                                ;undefined FUN_cc75()
JSR         FUN_ff14                                ;undefined FUN_ff14()
JSR         FUN_c91b                                ;undefined FUN_c91b()
INC         $004f                            ;= ??
JSR         LAB_PPUCTRL_ca38                        ;undefined LAB_PPUCTRL_ca38()
JSR         FUN_d11b                                ;undefined FUN_d11b()
JSR         FUN_ff14                                ;undefined FUN_ff14()
DEC         $004f                            ;= ??
LDA         #$f8
STA         $008f                            ;= ??
STA         $0090                            ;= ??
STA         $0091                            ;= ??
LDY         #$0
STY         $0061                            ;= ??
STY         $0062                            ;= ??
STY         $0063                            ;= ??
INY
STY         $0053                            ;= ??
JSR         FUN_c91b                                ;undefined FUN_c91b()
LDA         #$21
LDY         #$2d
JSR         LAB_PPUADDR_e964                        ;undefined LAB_PPUADDR_e964()
TYA
JSR         LAB_PPUDATA_d0f5                        ;undefined LAB_PPUDATA_d0f5()
LDA         #$21
STA         $0022                            ;= ??
LDA         #$e
STA         $0022+1
LDY         #$3
LOOP_PPUADDR_ea3b:            ;XREF[1,0]:   ea58
LDA         $0022                            ;= ??
STA         PPU_ADDR
LDA         $0022+1
STA         PPU_ADDR
LDX         #$3
LOOP_PPUCTRL_PPUDATA_ea47:    ;XREF[1,0]:   ea4e
; FWD[2,0]:   eb5a,eb5b
LDA         $eb58,X=>DAT_eb5b                      ;= 9Dh
                          ;= 9Ch
STA         PPU_DATA
DEX
BPL         LOOP_PPUCTRL_PPUDATA_ea47
LDA         $0022+1
CLC
ADC         #$20
STA         $0022+1
DEY
BPL         LOOP_PPUADDR_ea3b
LDA         #$21
LDY         #$4c
JSR         LAB_PPUADDR_e964                        ;undefined LAB_PPUADDR_e964()
LDA         #$2d
STA         PPU_DATA
LDA         #$23
LDY         #$d3
JSR         LAB_PPUADDR_e964                        ;undefined LAB_PPUADDR_e964()
LDA         #$ff
JSR         LAB_PPUDATA_d101                        ;undefined LAB_PPUDATA_d101()
JSR         LAB_PPUMASK_PPUSCROLL_c906              ;undefined LAB_PPUMASK_PPUSCROLL_c906()
LDA         #$fd
LDY         #$0
JSR         FUN_f088                                ;undefined FUN_f088()
INY
JSR         FUN_f088                                ;undefined FUN_f088()
LDA         #$20
INY
JSR         FUN_f088                                ;undefined FUN_f088()
LDA         #$70
STA         $03a3                            ;= ??
LDA         #$78
STA         $03a7                            ;= ??
LDA         #$80
STA         $03ab                            ;= ??
LDA         #$88
STA         $03af                            ;= ??
JSR         LAB_APU_MASTERCTRL_REG_f46e             ;undefined LAB_APU_MASTERCTRL_REG_f46e()
LDA         #$0
JSR         FUN_f48e                                ;undefined FUN_f48e()
LDY         #$0
JSR         FUN_ff08                                ;undefined FUN_ff08()
JSR         FUN_ff14                                ;undefined FUN_ff14()
LDA         #$1
STA         $004f                            ;= ??
LDA         #$1e
JSR         FUN_eb5c                                ;undefined FUN_eb5c()
LDA         #$58
LDY         #$0
JSR         FUN_f088                                ;undefined FUN_f088()
LDA         #$6
JSR         FUN_f48e                                ;undefined FUN_f48e()
LDA         #$3c
JSR         FUN_eb5c                                ;undefined FUN_eb5c()
LDA         #$50
LDY         #$0
JSR         FUN_f088                                ;undefined FUN_f088()
LDA         #$22
LDY         #$2
JSR         FUN_f088                                ;undefined FUN_f088()
LDA         #$3c
JSR         FUN_eb5c                                ;undefined FUN_eb5c()
LDA         #$48
LDY         #$0
JSR         FUN_f088                                ;undefined FUN_f088()
LDA         #$3c
JSR         FUN_eb5c                                ;undefined FUN_eb5c()
LDA         #$40
LDY         #$0
JSR         FUN_f088                                ;undefined FUN_f088()
LDA         #$21
LDY         #$2
JSR         FUN_f088                                ;undefined FUN_f088()
LDA         #$a
JSR         FUN_eb5c                                ;undefined FUN_eb5c()
LDA         $0053                            ;= ??
STA         $007a                            ;= ??
JSR         FUN_c91b                                ;undefined FUN_c91b()
LDA         $0014                            ;= ??
STA         PPU_CTRL
LDA         #$21
STA         $0022                            ;= ??
LDA         #$e
STA         $0022+1
LDY         #$3
LOOP_PPUADDR_eb0c:            ;XREF[1,0]:   eb28
LDA         $0022                            ;= ??
STA         PPU_ADDR
LDA         $0022+1
STA         PPU_ADDR
LDX         #$3
LDA         #$2d
LOOP_PPUDATA_eb1a:            ;XREF[1,0]:   eb1e
STA         PPU_DATA
DEX
BPL         LOOP_PPUDATA_eb1a
LDA         $0022+1
CLC
ADC         #$20
STA         $0022+1
DEY
BPL         LOOP_PPUADDR_eb0c
LDA         #$21
LDY         #$4c
JSR         LAB_PPUADDR_e964                        ;undefined LAB_PPUADDR_e964()
LDA         #$5f
STA         PPU_DATA
LDY         #$6
LOOP_PPUDATA_eb38:            ;XREF[1,0]:   eb3e
LDA         #$2d
STA         PPU_DATA
DEY
BPL         LOOP_PPUDATA_eb38
LDA         #$23
LDY         #$d3
JSR         LAB_PPUADDR_e964                        ;undefined LAB_PPUADDR_e964()
LDA         #$55
JSR         LAB_PPUDATA_d101                        ;undefined LAB_PPUDATA_d101()
JSR         LAB_PPUMASK_PPUSCROLL_c906              ;undefined LAB_PPUMASK_PPUSCROLL_c906()
LDY         #$0
JSR         FUN_ff08                                ;undefined FUN_ff08()
JSR         FUN_ff14                                ;undefined FUN_ff14()
RTS
.byte $9E,$9D
DAT_eb5a:                     ;XREF[1,0]:   ea47
.byte $9D
DAT_eb5b:                     ;XREF[1,0]:   ea47
.byte $9C
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_eb5c()
;XREF[5,0]:   eab0,eac1,ead4,eae0,eaf3
STA         $00a4                            ;= ??
LOOP_eb5e:                    ;XREF[1,0]:   eb9c
JSR         FUN_c91b                                ;undefined FUN_c91b()
JSR         LAB_PPUCTRL_ca38                        ;undefined LAB_PPUCTRL_ca38()
JSR         LAB_PPUMASK_PPUSCROLL_c906              ;undefined LAB_PPUMASK_PPUSCROLL_c906()
LDA         #$0
JSR         FUN_f48e                                ;undefined FUN_f48e()
LDA         $006d                            ;= ??
BNE         LAB_eb7b
LDA         $0053                            ;= ??
SEC
SBC         #$2
BPL         LAB_eb88
LDA         #$0
BEQ         LAB_eb88
LAB_eb7b:                     ;XREF[1,0]:   eb6e
LDA         $0053                            ;= ??
CLC
ADC         #$3
STA         $0053                            ;= ??
CMP         #$78
BCC         LAB_eb88
LDA         #$78
LAB_eb88:                     ;XREF[3,0]:   eb75,eb79,eb84
STA         $0053                            ;= ??
LDA         $006f                            ;= ??
BMI         LAB_eb92
EOR         #$1
STA         $0047                            ;= ??
LAB_eb92:                     ;XREF[1,0]:   eb8c
LDY         #$0
JSR         FUN_ff08                                ;undefined FUN_ff08()
JSR         FUN_ff14                                ;undefined FUN_ff14()
DEC         $00a4                            ;= ??
BNE         LOOP_eb5e
RTS
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_eb9f()
;XREF[1,0]:   c13a
LDY         $002d                            ;= ??
LDA         $0071                            ;= ??
BNE         LAB_ebb3
LDA         #$0
STA         $0076                            ;= ??
LDA         DAT_f060,Y
STA         $0077                            ;= ??
LDA         DAT_f06a,Y                              ;= 04h
STA         $0078                            ;= ??
LAB_ebb3:                     ;XREF[1,0]:   eba3
LDA         DAT_ee66,Y                              ;= 7Ah    z
STA         $0022                            ;= ??
LDA         DAT_ee70,Y                              ;= EEh
STA         $0022+1
LDA         #$0
STA         $0024                            ;= ??
LDA         #$7
STA         $0024+1
LDY         #$0
STY         $0017                            ;= ??
STY         $0018                            ;= ??
STY         $001b                            ;= ??
LAB_ebcd:                     ;XREF[1,0]:   ec19
LDY         #$1
LDA         ($0022),Y                        ;= ??
SEC
SBC         $0017                            ;= ??
STA         $0019                            ;= ??
INY
LDA         ($0022),Y                        ;= ??
SBC         $0018                            ;= ??
STA         $001a                            ;= ??
BNE         LAB_ec1c
LDA         $0019                            ;= ??
CMP         #$20
BCS         LAB_ec1c
LOOP_ebe5:                    ;XREF[1,0]:   ec26
DEY
STA         ($0024),Y                        ;= ??
DEY
LDA         ($0022),Y                        ;= ??
STA         ($0024),Y                        ;= ??
BNE         LAB_ebf9
LDY         #$2
STA         ($0024),Y                        ;= ??
INY
STA         ($0024),Y                        ;= ??
JMP         LAB_ec4c
LAB_ebf9:                     ;XREF[1,0]:   ebed
LDA         #$0
STA         $0017                            ;= ??
STA         $0018                            ;= ??
LDA         #$30
STA         $001c                            ;= ??
LDA         $0022                            ;= ??
CLC
ADC         #$3
STA         $0022                            ;= ??
BCC         LOOP_ec0e
INC         $0022+1
LOOP_ec0e:                    ;XREF[2,0]:   ec0a,ec49
LDA         $0024                            ;= ??
CLC
ADC         #$2
STA         $0024                            ;= ??
BCC         LAB_ec19
INC         $0024+1
LAB_ec19:                     ;XREF[1,0]:   ec15
JMP         LAB_ebcd
LAB_ec1c:                     ;XREF[2,0]:   ebdd,ebe3
LDA         $001a                            ;= ??
BNE         LAB_ec28
LDA         $0019                            ;= ??
CMP         #$51
BCS         LAB_ec28
BCC         LOOP_ebe5
LAB_ec28:                     ;XREF[2,0]:   ec1e,ec24
DEY
LDA         $001c                            ;= ??
STA         ($0024),Y                        ;= ??
DEY
LDA         $001b                            ;= ??
AND         #$1
BNE         LAB_ec36
LDA         #$81
LAB_ec36:                     ;XREF[1,0]:   ec32
STA         ($0024),Y                        ;= ??
INC         $001b                            ;= ??
LDA         $0017                            ;= ??
CLC
ADC         $001c                            ;= ??
STA         $0017                            ;= ??
BCC         LAB_ec45
INC         $0018                            ;= ??
LAB_ec45:                     ;XREF[1,0]:   ec41
LDA         #$20
STA         $001c                            ;= ??
JMP         LOOP_ec0e
LAB_ec4c:                     ;XREF[1,0]:   ebf6
LDY         $002d                            ;= ??
LDA         DAT_ecc8,Y                              ;= DCh
STA         $0022                            ;= ??
LDA         DAT_ecd2,Y                              ;= ECh
STA         $0022+1
LDA         #$60
STA         $0024                            ;= ??
LDA         #$6
STA         $0024+1
LAB_ec60:                     ;XREF[1,0]:   ec84
LDY         #$0
LDA         ($0022),Y                        ;= ??
STA         ($0024),Y                        ;= ??
STA         $0017                            ;= ??
INY
LDA         ($0022),Y                        ;= ??
STA         ($0024),Y                        ;= ??
LDA         $0017                            ;= ??
BNE         LAB_ec87
LDA         ($0022),Y                        ;= ??
BNE         LOOP_ec76
RTS
LOOP_ec76:                    ;XREF[7,0]:   ec73,ec89,ec92,ec9d,ec9f,eca8,ecaa
LDA         $0022                            ;= ??
CLC
ADC         #$2
STA         $0022                            ;= ??
BCC         LAB_ec81
INC         $0022+1
LAB_ec81:                     ;XREF[1,0]:   ec7d
JSR         FUN_ecbc                                ;undefined FUN_ecbc()
JMP         LAB_ec60
LAB_ec87:                     ;XREF[1,0]:   ec6f
CMP         #$80
BEQ         LOOP_ec76
INY
LDA         ($0022),Y                        ;= ??
BEQ         LOOP_ec94
CMP         #$80
BNE         LOOP_ec76
LOOP_ec94:                    ;XREF[2,0]:   ec8e,ecba
LDA         $0017                            ;= ??
BMI         LAB_eca3
SEC
SBC         #$8
STA         $0017                            ;= ??
BMI         LOOP_ec76
BEQ         LOOP_ec76
BPL         LAB_ecac
LAB_eca3:                     ;XREF[1,0]:   ec96
CLC
ADC         #$8
STA         $0017                            ;= ??
BPL         LOOP_ec76
BEQ         LOOP_ec76
LAB_ecac:                     ;XREF[1,0]:   eca1
JSR         FUN_ecbc                                ;undefined FUN_ecbc()
LDY         #$0
LDA         $0017                            ;= ??
STA         ($0024),Y                        ;= ??
INY
LDA         #$1
STA         ($0024),Y                        ;= ??
BNE         LOOP_ec94
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_ecbc()
;XREF[2,0]:   ec81,ecac
LDA         $0024                            ;= ??
CLC
ADC         #$2
STA         $0024                            ;= ??
BCC         LAB_ecc7
INC         $0024+1
LAB_ecc7:                     ;XREF[1,0]:   ecc3
RTS
DAT_ecc8:                     ;XREF[1,0]:   ec4e
.byte $DC,$EA,$04,$26,$4E,$74,$9A,$CC,$FE,$30
DAT_ecd2:                     ;XREF[1,0]:   ec53
.byte $EC,$EC,$ED,$ED,$ED,$ED,$ED,$ED,$ED,$EE,$00,$36,$0E,$47,$00,$4C,$0E,$47,$80,$00,$00,$16,$00,$00,$00,$12,$12,$0C,$00,$30,$F2,$58,$00,$10,$EE,$0C,$00,$34,$10,$2A,$00,$12,$28,$08,$80,$00,$00,$0E,$00,$00,$00,$46,$27,$09,$14,$11,$00,$17,$12,$0B,$00,$20,$2C,$12,$00,$0C,$D5,$12,$00,$08,$F0,$10,$00,$14,$16,$14,$0F,$32,$80,$00,$00,$19,$00,$00,$00,$16,$F0,$0E,$00,$1A,$10,$0E,$00,$10,$2C,$06,$00,$0C,$11,$24,$18,$0A,$00,$01,$F3,$0D,$00,$14,$F0,$0D,$00,$10,$F0,$1B,$00,$14,$2E,$1B,$80,$00,$00,$10,$00,$00,$00,$38,$0E,$50,$00,$01,$DC,$02,$00,$01,$20,$0F,$00,$08,$D0,$06,$D8,$06,$00,$04,$28,$06,$16,$08,$00,$01,$F4,$06,$00,$10,$2E,$0D,$80,$00,$00,$24,$00,$00,$00,$18,$30,$08,$10,$20,$16,$12,$00,$01,$DD,$19,$00,$08,$29,$14,$00,$04,$ED,$05,$00,$18,$E0,$0C,$00,$1A,$E0,$1B,$00,$3A,$14,$09,$80,$00,$00,$10,$00,$00,$00,$12,$12,$0C,$00,$1A,$EE,$0C,$00,$0E,$D1,$0F,$00,$0E,$2F,$0F,$00,$19,$2C,$06,$00,$1A,$2C,$06,$00,$2C,$17,$0A,$00,$01,$DC,$09,$00,$08,$24,$0C,$00,$01,$F7,$0D,$00,$0A,$26,$0F,$80,$00,$00,$0A,$00,$00,$00,$18,$28,$13,$00,$01,$F2,$0E,$00,$08,$27,$0F,$00,$01,$D2,$05,$00,$19,$F0,$08,$00,$01,$26,$0B,$00,$04,$D2,$0E,$00,$0B,$EC,$20,$00,$0C,$30,$04,$00,$01,$D6,$0F,$00,$16,$2C,$06,$80,$00,$00,$14,$00,$00,$00,$10,$0E,$1C,$00,$06,$E0,$14,$D0,$04,$00,$01,$1A,$14,$26,$07,$00,$30,$2B,$16,$00,$01,$E0,$12,$00,$06,$0E,$13,$00,$1A,$1E,$14,$00,$01,$E0,$20,$00,$04,$2C,$0F,$00,$0A,$2C,$07,$80,$00,$00,$0C,$00,$00,$00,$28,$2C,$0E,$00,$03,$D3,$02,$00,$0A,$30,$0F,$00,$0E,$D8,$19,$00,$04,$1E,$21,$00,$02,$E0,$11,$00,$04,$10,$10,$00,$11,$30,$0C,$00,$02,$E0,$0C,$00,$05,$26,$16,$00,$06,$D0,$0A,$00,$01,$2E,$03,$80,$00,$00,$0D,$00,$00
DAT_ee66:                     ;XREF[1,0]:   ebb3
.byte $7A,$95,$B9,$E6,$0A,$37,$76,$A3,$F4,$33
DAT_ee70:                     ;XREF[1,0]:   ebb8
.byte $EE,$EE,$EE,$EE,$EF,$EF,$EF,$EF,$EF,$F0,$02,$06,$00,$82,$01,$00,$83,$60,$01,$83,$20,$00,$83,$20,$00,$83,$80,$04,$83,$20,$00,$83,$20,$00,$00,$10,$03,$02,$06,$00,$82,$01,$00,$0B,$60,$02,$0B,$20,$00,$0B,$20,$00,$83,$50,$05,$83,$20,$00,$83,$20,$00,$83,$B0,$01,$83,$20,$00,$83,$20,$00,$00,$12,$01,$02,$06,$00,$82,$01,$00,$83,$D0,$01,$83,$20,$00,$83,$20,$00,$83,$10,$03,$83,$20,$00,$83,$20,$00,$03,$20,$01,$03,$20,$00,$03,$20,$00,$83,$20,$02,$83,$30,$00,$83,$20,$00,$00,$28,$03,$02,$06,$00,$82,$01,$00,$83,$D0,$02,$83,$20,$00,$83,$20,$00,$83,$C0,$01,$83,$20,$00,$83,$20,$00,$83,$30,$04,$83,$20,$00,$83,$20,$00,$00,$C0,$01,$02,$06,$00,$82,$01,$00,$83,$90,$04,$83,$20,$00,$83,$20,$00,$03,$B0,$00,$03,$20,$00,$03,$20,$00,$83,$A0,$00,$83,$20,$00,$83,$20,$00,$83,$30,$01,$83,$20,$00,$83,$20,$00,$00,$F8,$01,$02,$06,$00,$82,$01,$00,$83,$60,$00,$83,$20,$00,$83,$20,$00,$83,$20,$01,$83,$20,$00,$83,$20,$00,$03,$A0,$00,$03,$20,$00,$03,$20,$00,$83,$00,$01,$83,$20,$00,$83,$20,$00,$03,$10,$02,$03,$20,$00,$03,$20,$00,$03,$40,$01,$03,$20,$00,$03,$20,$00,$00,$C8,$03,$02,$06,$00,$82,$01,$00,$03,$D0,$02,$03,$20,$00,$03,$20,$00,$83,$10,$01,$83,$20,$00,$83,$20,$00,$83,$50,$01,$83,$20,$00,$83,$20,$00,$83,$40,$01,$83,$20,$00,$83,$20,$00,$00,$C0,$05,$02,$06,$00,$82,$01,$00,$83,$60,$00,$83,$20,$00,$83,$20,$00,$83,$80,$01,$83,$20,$00,$83,$20,$00,$03,$E0,$00,$03,$20,$00,$03,$20,$00,$B3,$40,$01,$B3,$20,$00,$B3,$20,$00,$03,$80,$00,$03,$20,$00,$03,$20,$00,$83,$70,$02,$83,$20,$00,$83,$20,$00,$03,$60,$00,$03,$20,$00,$03,$20,$00,$83,$40,$01,$83,$20,$00,$83,$20,$00,$00,$38,$01,$02,$06,$00,$82,$01,$00,$03,$80,$01,$03,$20,$00,$03,$20,$00,$83,$A0,$01,$83,$20,$00,$83,$20,$00,$83,$90,$01,$83,$20,$00,$83,$20,$00,$03,$F0,$00,$03,$20,$00,$03,$20,$00,$83,$80,$04,$83,$20,$00,$83,$20,$00,$83,$E0,$00,$83,$20,$00,$83,$20,$00,$00,$18,$01,$02,$06,$00,$82,$01,$00,$83,$E0,$00,$83,$20,$00,$83,$20,$00,$83,$60,$01,$83,$20,$00,$83,$20,$00,$03,$10,$01,$03,$20,$00,$03,$20,$00,$83,$70,$04,$83,$20,$00,$83,$20,$00,$00,$70,$04
DAT_f060:                     ;XREF[1,0]:   eba9
.byte $00,$03,$00,$05,$00,$05,$00,$05,$00,$00
DAT_f06a:                     ;XREF[1,0]:   ebae
.byte $04,$04,$05,$04,$04,$04,$05,$04,$05,$05
DAT_f074:                     ;XREF[1,0]:   cd33
.byte $05,$08,$05,$00,$05,$00,$05,$00,$05,$05
DAT_f07e:                     ;XREF[1,0]:   cd38
.byte $03,$03,$04,$04,$03,$04,$04,$04,$04,$04
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_f088()
;XREF[9,0]:   ea79,ea7d,ea83,eab7,eac8,eacf,eadb,eae7
;             eaee
STA         $03a0,Y                          ;= ??
STA         $03a4,Y                          ;= ??
STA         $03a8,Y                          ;= ??
STA         $03ac,Y                          ;= ??
RTS
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_f095()
;XREF[2,0]:   c7ae,c9cb
LDA         #$20
STA         $0017                            ;= ??
LDA         #$55
STA         $0018                            ;= ??
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_f09d()
;XREF[1,0]:   d069
LDY         $002d                            ;= ??
LDA         DAT_f0d8,Y                              ;= ECh
STA         $0022                            ;= ??
LDA         DAT_f0e2,Y                              ;= F0h
STA         $0022+1
LDX         #$3
LOOP_f0ab:                    ;XREF[1,0]:   f0d1
LDA         $0017                            ;= ??
LDY         $0018                            ;= ??
JSR         LAB_PPUADDR_e964                        ;undefined LAB_PPUADDR_e964()
LDY         #$0
LOOP_PPUDATA_f0b4:            ;XREF[1,0]:   f0bc
LDA         ($0022),Y                        ;= ??
STA         PPU_DATA
INY
CPY         #$9
BCC         LOOP_PPUDATA_f0b4
LDA         $0022                            ;= ??
CLC
ADC         #$9
STA         $0022                            ;= ??
BCC         LAB_f0c9
INC         $0022+1
LAB_f0c9:                     ;XREF[1,0]:   f0c5
LDA         $0018                            ;= ??
CLC
ADC         #$20
STA         $0018                            ;= ??
DEX
BPL         LOOP_f0ab
LDA         #$0
STA         $00c9                            ;= ??
RTS
DAT_f0d8:                     ;XREF[1,0]:   f09f
.byte $EC,$10,$34,$58,$7C,$A0,$C4,$E8,$0C,$30
DAT_f0e2:                     ;XREF[1,0]:   f0a4
.byte $F0,$F1,$F1,$F1,$F1,$F1,$F1,$F1,$F2,$F2,$C6,$D9,$C3,$C2,$C3,$C3,$C3,$DA,$2D,$DC,$2D,$2D,$2D,$2D,$2D,$2D,$C5,$DD,$DE,$2D,$2D,$2D,$2D,$2D,$2D,$C6,$DF,$C5,$D7,$C3,$C3,$C3,$C3,$C3,$D8,$2D,$CC,$28,$C3,$DA,$C6,$D9,$C3,$DA,$2D,$C4,$2D,$2D,$C7,$D2,$2D,$2D,$C5,$DD,$DE,$2D,$C6,$D1,$C5,$D0,$2D,$C6,$DF,$C5,$D7,$D8,$2D,$2D,$C5,$D7,$D8,$2D,$C6,$D9,$C3,$C2,$C3,$C3,$C3,$C3,$CD,$DC,$2D,$C6,$D9,$C3,$CD,$2D,$C6,$DF,$DE,$C6,$D1,$CC,$C3,$CF,$C6,$D1,$2D,$C5,$CA,$2D,$CE,$C3,$C3,$D8,$2D,$2D,$2D,$C6,$D9,$C3,$DA,$C6,$D9,$C3,$CD,$2D,$DC,$2D,$2D,$C7,$D2,$2D,$2D,$C4,$CC,$D3,$C2,$C3,$D8,$C5,$DD,$C6,$DF,$CE,$CF,$2D,$2D,$2D,$2D,$CE,$D8,$2D,$CC,$C3,$C3,$C2,$C3,$C3,$C3,$DA,$2D,$CE,$DA,$2D,$CC,$CD,$2D,$2D,$C5,$DD,$2D,$C5,$D7,$CF,$C4,$2D,$2D,$C6,$DF,$2D,$2D,$2D,$2D,$CE,$D8,$D7,$D8,$2D,$2D,$C6,$CB,$C6,$D9,$C3,$C2,$C3,$CD,$C6,$D1,$C7,$D2,$C8,$D4,$DD,$C6,$DF,$DC,$C6,$D1,$C5,$E1,$DD,$CE,$D8,$2D,$CE,$D8,$2D,$2D,$CE,$CF,$2D,$2D,$2D,$CC,$28,$C3,$DA,$2D,$CC,$C3,$C3,$CD,$DE,$2D,$2D,$C5,$D0,$CE,$C3,$CD,$C4,$C5,$DD,$C6,$CB,$C5,$D7,$C3,$CF,$C4,$2D,$CE,$D8,$C5,$D7,$C3,$C3,$C3,$CF,$CC,$CD,$2D,$2D,$CC,$C3,$C2,$C3,$CD,$C4,$DE,$D9,$C3,$D3,$CD,$C6,$D9,$CF,$DE,$C6,$D9,$CD,$C4,$DE,$D6,$2D,$2D,$C5,$CA,$2D,$CE,$CF,$2D,$2D,$2D,$2D,$CC,$28,$C3,$DA,$C8,$D4,$D0,$2D,$2D,$C4,$DB,$D5,$C5,$E2,$DD,$C5,$D0,$2D,$CE,$CF,$DC,$2D,$CE,$E0,$D4,$E2,$DD,$2D,$2D,$CE,$C3,$C3,$D8,$2D,$CE,$CF,$C8,$D4,$DD,$CC,$C3,$C2,$C3,$C3,$CD,$C9,$DD,$CE,$CF,$2D,$CC,$CD,$CC,$CF,$CC,$CF,$C6,$D9,$CD,$DE,$C4,$C4,$2D,$CE,$C3,$D8,$2D,$DE,$D6,$CE,$CF,$2D
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_f254()
;XREF[1,0]:   d2c4
LDA         $0056                            ;= ??
LSR         A
LSR         A
LSR         A
TAY
LDA         DAT_f296,Y                              ;= AEh
STA         $0022                            ;= ??
LDA         DAT_f29e,Y                              ;= F2h
STA         $0022+1
LDX         #$8
CPY         #$8
BCS         LAB_f28e
LDA         DAT_f2a6,Y                              ;= 28h    (
STA         $0017                            ;= ??
LDY         #$0
LOOP_f271:                    ;XREF[1,0]:   f27d
LDA         ($0022),Y                        ;= ??
; FWD[2,0]:   0208,0209
STA         $200,X=>$0208                   ;= ??
; FWD[2,0]:   0308,0309
STA         $300,X=>$0308                   ;= ??
INX
INY
CPY         $0017                            ;= ??
BCC         LOOP_f271
LAB_f27f:                     ;XREF[1,0]:   f293
INC         $0056                            ;= ??
LDY         #$0
JSR         FUN_ff08                                ;undefined FUN_ff08()
LDY         #$80
JSR         FUN_ff08                                ;undefined FUN_ff08()
JMP         LAB_d3ff
LAB_f28e:                     ;XREF[1,0]:   f268
LDY         #$80
JSR         FUN_ff08                                ;undefined FUN_ff08()
JMP         LAB_f27f
DAT_f296:                     ;XREF[1,0]:   f25a
.byte $AE,$AE,$D6,$0E,$D6,$0E,$D6,$0E
DAT_f29e:                     ;XREF[1,0]:   f25f
.byte $F2,$F2,$F2,$F3,$F2,$F3,$F2,$F3
DAT_f2a6:                     ;XREF[1,0]:   f26a
.byte $28,$28,$38,$60,$38,$60,$38,$60,$C0,$A6,$03,$78,$C0,$A6,$43,$80,$C8,$A7,$03,$70,$C8,$A8,$03,$78,$C8,$A8,$43,$80,$C8,$A7,$43,$88,$D0,$A9,$03,$70,$D0,$AA,$03,$78,$D0,$AA,$43,$80,$D0,$A9,$43,$88,$B8,$AB,$03,$78,$B8,$AC,$03,$80,$C0,$AD,$03,$70,$C0,$AE,$03,$78,$C0,$AF,$03,$80,$C0,$B0,$03,$88,$C8,$B1,$03,$70,$C8,$B2,$03,$78,$C8,$B3,$03,$80,$C8,$B4,$03,$88,$D0,$B5,$03,$70,$D0,$B6,$03,$78,$D0,$B7,$03,$80,$D0,$B8,$03,$88,$B0,$B9,$03,$90,$B8,$BA,$03,$70,$B8,$BB,$03,$78,$B8,$BC,$03,$80,$B8,$BD,$03,$88,$B8,$BE,$03,$90,$C0,$BF,$03,$68,$C0,$C0,$03,$70,$C0,$C1,$03,$78,$C0,$C2,$03,$80,$C0,$C3,$03,$88,$C0,$C4,$03,$90,$C8,$C5,$03,$68,$C8,$C6,$03,$70,$C8,$C7,$03,$78,$C8,$C8,$03,$80,$C8,$C9,$03,$88,$C8,$CA,$03,$90,$D0,$CB,$03,$68,$D0,$CC,$03,$70,$D0,$CD,$03,$78,$D0,$CE,$03,$80,$D0,$CF,$03,$88,$D0,$D0,$03,$90
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined LAB_PPUCTRL_PPUMASK_f36e()
;XREF[2,0]:   cfd6,e60e
JSR         FUN_c91b                                ;undefined FUN_c91b()
LDA         #$0
STA         $0015                            ;= ??
STA         PPU_MASK
LDA         $0014                            ;= ??
STA         PPU_CTRL
LDA         #$20
LDY         #$0
JSR         LAB_PPUADDR_e964                        ;undefined LAB_PPUADDR_e964()
LDA         #$2d
LOOP_f386:                    ;XREF[1,0]:   f38a
JSR         LAB_PPUDATA_d0fb                        ;undefined LAB_PPUDATA_d0fb()
INY
BNE         LOOP_f386
JSR         FUN_c91b                                ;undefined FUN_c91b()
LDA         #$24
LDY         #$0
JSR         LAB_PPUADDR_e964                        ;undefined LAB_PPUADDR_e964()
LDA         #$2d
LOOP_f398:                    ;XREF[1,0]:   f39c
JSR         LAB_PPUDATA_d0fb                        ;undefined LAB_PPUDATA_d0fb()
INY
BNE         LOOP_f398
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_f39e()
;XREF[1,0]:   c0db
LDY         #$0
LDA         #$f0
LOOP_f3a2:                    ;XREF[1,0]:   f3a9
STA         $0200,Y                          ;= ??
STA         $0300,Y                          ;= ??
INY
BNE         LOOP_f3a2
RTS
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_f3ac()
;XREF[5,0]:   c1fc,c237,c271,cf74,d2af
LDA         #$0
STA         $0050                            ;= ??
STA         $0051                            ;= ??
STA         $0052                            ;= ??
RTS
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_f3b5()
;XREF[1,0]:   d2cb
LDA         $00b4                            ;= ??
CMP         #$f0
BCC         LAB_f3be
JMP         LAB_f469
LAB_f3be:                     ;XREF[1,0]:   f3b9
LDA         $00b6                            ;= ??
BNE         LAB_f3ce
LDA         $00b7                            ;= ??
CMP         #$c8
BCS         LAB_f3ce
LDA         $00b7                            ;= ??
ADC         #$2
STA         $00b7                            ;= ??
LAB_f3ce:                     ;XREF[2,0]:   f3c0,f3c6
LDA         $00b6                            ;= ??
STA         $0017                            ;= ??
LDA         $00b7                            ;= ??
ASL         A
ROL         $0017                            ;= ??
ASL         A
ROL         $0017                            ;= ??
STA         $0018                            ;= ??
LDA         $00b5                            ;= ??
SEC
SBC         $0018                            ;= ??
STA         $00b5                            ;= ??
LDA         $00b4                            ;= ??
SBC         $0017                            ;= ??
STA         $00b4                            ;= ??
TAX
LDA         DAT_e449,X                              ;= 54h    T
STA         $0017                            ;= ??
TXA
LSR         A
LSR         A
LSR         A
TAY
LDX         DAT_e549,Y                              ;= 01h
BEQ         LAB_f469
LDY         DAT_dd0b,X                              ;= 08h
LDA         DAT_dd17,Y                              ;= E8h
STA         $0022                            ;= ??
LDA         DAT_dd87,Y                              ;= DAh
STA         $0022+1
LDA         DAT_de21,Y                              ;= 40h    @
CPY         #$e
BCC         LAB_f422
LDA         DAT_ddf7,Y                              ;= 30h    0
CPY         #$2a
BCC         LAB_f422
LDA         #$14
CPY         #$38
BCC         LAB_f422
LDA         #$8
CPY         #$54
BCC         LAB_f422
LDA         #$4
LAB_f422:                     ;XREF[4,0]:   f40b,f412,f418,f41e
STA         $0018                            ;= ??
LDX         #$8
LDY         #$0
LOOP_f428:                    ;XREF[1,0]:   f464
LDA         ($0022),Y                        ;= ??
CLC
ADC         $0017                            ;= ??
; FWD[2,0]:   0208,020c
STA         $200,X=>$0208                   ;= ??
; FWD[2,0]:   0308,030c
STA         $300,X=>$0308                   ;= ??
CMP         #$50
BCS         LAB_f43f
LDA         #$f0
STA         $200,X=>$0208                   ;= ??
STA         $300,X=>$0308                   ;= ??
LAB_f43f:                     ;XREF[1,0]:   f435
INX
INY
LDA         ($0022),Y                        ;= ??
STA         $200,X=>$0209                   ;= ??
STA         $300,X=>$0309                   ;= ??
INX
INY
LDA         ($0022),Y                        ;= ??
STA         $200,X=>$020a                   ;= ??
STA         $300,X=>$030a                   ;= ??
INX
INY
LDA         ($0022),Y                        ;= ??
CLC
ADC         #$80
STA         $200,X=>$020b                   ;= ??
STA         $300,X=>$030b                   ;= ??
INX
INY
CPY         $0018                            ;= ??
BCC         LOOP_f428
JMP         LAB_d3ff
LAB_f469:                     ;XREF[2,0]:   f3bb,f3f7
LDX         #$8
JMP         LAB_d3ff
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined LAB_APU_MASTERCTRL_REG_f46e()
;XREF[4,0]:   c041,d0be,e611,ea9a
LDX         #$0
STX         APU_DELTA_REG:DAT_4011
STX         $00bc                            ;= ??
DEX
STX         $00b8                            ;= ??
STX         $00bd                            ;= ??
STX         $00c2                            ;= ??
LDX         #$f
STX         APU_MASTERCTRL_REG:APU_MASTERCTRL_REG
LDA         #$ff
LOOP_f483:                    ;XREF[1,0]:   f487
; FWD[2,0]:   01ce,01cf
STA         $1c0,X=>$01cf                   ;= ??
DEX
BPL         LOOP_f483
LDA         $0053                            ;= ??
STA         $00be                            ;= ??
RTS
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_f48e()
;XREF[19,0]:  c12b,c16d,c1da,c347,c9a7,c9d3,c9e4,cf08
;             cf99,cfc3,d0c3,d1d3,e61d,e7ad,ea9f,eabc
;             eb69,fc11,ff3a
TAX
BMI         LAB_APU_SND_SQUARE1_REG_APU_SND_SQUAR...
LDA         $00bd                            ;= ??
CMP         DAT_f4df,X                              ;= 32h    2
BCS         LAB_f499
RTS
LAB_f499:                     ;XREF[1,0]:   f496
LDA         DAT_f4df,X                              ;= 32h    2
STA         $00bd                            ;= ??
CMP         #$1e
BCC         LAB_f4a7
CPX         $00b8                            ;= ??
BNE         LAB_f4a7
RTS
LAB_f4a7:                     ;XREF[2,0]:   f4a0,f4a4
STX         $00b8                            ;= ??
LDA         DAT_f4f3,X
STA         $00b9                            ;= ??
LDA         DAT_f4fc,X
STA         $00b9+1
LDA         DAT_f4e9,X
STA         $00c2                            ;= ??
LDA         #$10
STA         $00bb                            ;= ??
LDA         #$1
STA         $00bc                            ;= ??
RTS
LAB_APU_SND_SQUARE1_REG_APU...;XREF[1,0]:   f48f
STX         $00b8                            ;= ??
INX
STX         $00bc                            ;= ??
STX         $00bd                            ;= ??
LDA         #$30
STA         APU_SND_SQUARE1_REG:APU_SND_SQUARE1_REG
STA         APU_SND_SQUARE2_REG:APU_SND_SQUARE2_REG
STA         APU_NOISE_REG:APU_NOISE_REG
LDA         #$0
STA         APU_SND_TRIANGLE_REG:APU_SND_TRIANGLE...
STA         APU_SND_TRIANGLE_REG:DAT_400a
STA         APU_SND_TRIANGLE_REG:DAT_400b
RTS
DAT_f4df:                     ;XREF[2,0]:   f493,f499
.byte $32,$28,$28,$28,$28,$28,$28,$2D,$28,$28
DAT_f4e9:                     ;XREF[1,0]:   f4b3
.byte $00,$FF,$FF,$FF,$02,$FF,$01,$01,$FF,$FF
DAT_f4f3:                     ;XREF[1,0]:   f4a9
.byte $00,$7F,$DB,$1E,$5A,$6C,$A4,$C0,$D1
DAT_f4fc:                     ;XREF[1,0]:   f4ae
.byte $00,$F6,$F6,$F8,$FA,$FA,$FA,$FA,$FA
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined LAB_JOYPAD_PORT2_f505()
;XREF[6,0]:   ca07,d0c6,d0cc,e620,e7d0,ff47
LDA         #$c0
STA         JOYPAD_PORT2:JOYPAD_PORT2
LDA         $00b8                            ;= ??
BEQ         LAB_f52d
LDX         $00bc                            ;= ??
BNE         LAB_f530
CMP         #$8
BNE         LAB_f520
LDA         $0032                            ;= ??
BNE         LAB_f520
LDA         #$0
STA         $00b8                            ;= ??
STA         $00c2                            ;= ??
LAB_f520:                     ;XREF[2,0]:   f514,f518
LDX         #$ff
STX         $00bd                            ;= ??
STX         $00b8                            ;= ??
LDA         $00c2                            ;= ??
BMI         LAB_f52d
INX
STX         $00c2                            ;= ??
LAB_f52d:                     ;XREF[2,0]:   f50c,f528
JMP         FUN_fae8                                ;undefined FUN_fae8()
LAB_f530:                     ;XREF[1,0]:   f510
DEC         $00bc                            ;= ??
BEQ         LOOP_f53d
JMP         FUN_fae8                                ;undefined FUN_fae8()
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_f537()
;XREF[6,0]:   f562,f56a,f59a,f5bb,f654,f67c
INC         $00b9                            ;= ??
BNE         LOOP_f53d
INC         $00b9+1
LOOP_f53d:                    ;XREF[7,0]:   f532,f539,f5cd,f5f8,f60f,f633,f64b
LDY         #$0
LDA         ($00b9),Y                        ;= ??
AND         #$c0
BEQ         LAB_f56d
SEC
SBC         #$40
LSR         A
LSR         A
LSR         A
LSR         A
TAX
LDA         ($00b9),Y                        ;= ??
AND         #$3f
ASL         A
TAY
LDA         DAT_fd4f,Y                              ;= AEh
STA         APU_SND_SQUARE1_REG:DAT_4002,X
STA         $01c2,X                          ;= ??
LDA         DAT_fd4e,Y                              ;= 06h
CMP         $01c3,X                          ;= ??
BEQ         FUN_f537
STA         APU_SND_SQUARE1_REG:DAT_4003,X
STA         $01c3,X                          ;= ??
JMP         FUN_f537
LAB_f56d:                     ;XREF[1,0]:   f543
LDA         ($00b9),Y                        ;= ??
AND         #$20
BNE         LAB_APU_SND_SQUARE1_REG_f584
LDA         ($00b9),Y                        ;= ??
STA         $00bc                            ;= ??
JSR         FUN_f57d                                ;undefined FUN_f57d()
JMP         FUN_fae8                                ;undefined FUN_fae8()
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_f57d()
;XREF[8,0]:   f577,f58f,f5d4,f5da,f5e0,f616,f620,f65b
INC         $00b9                            ;= ??
BNE         LAB_f583
INC         $00b9+1
LAB_f583:                     ;XREF[1,0]:   f57f
RTS
LAB_APU_SND_SQUARE1_REG_f584: ;XREF[1,0]:   f571
LDA         ($00b9),Y                        ;= ??
AND         #$10
BNE         LAB_f59d
LDA         ($00b9),Y                        ;= ??
AND         #$f
TAX
JSR         FUN_f57d                                ;undefined FUN_f57d()
LDA         ($00b9),Y                        ;= ??
STA         APU_SND_SQUARE1_REG:APU_SND_SQUARE1_R...
STA         $01c0,X                          ;= ??
JMP         FUN_f537
LAB_f59d:                     ;XREF[1,0]:   f588
LDA         ($00b9),Y                        ;= ??
CMP         #$3f
BNE         LAB_f5be
LDX         #$8
LOOP_f5a5:                    ;XREF[1,0]:   f5b9
LDA         #$0
; FWD[2,0]:   4006,400a
STA         $4002,X=>APU_SND_TRIANGLE_REG:DAT_400a
; FWD[2,0]:   01c6,01ca
STA         $1c2,X=>$01ca                   ;= ??
; FWD[2,0]:   4007,400b
STA         $4003,X=>APU_SND_TRIANGLE_REG:DAT_400b
LDA         #$ff
; FWD[2,0]:   01c7,01cb
STA         $1c3,X=>$01cb                   ;= ??
DEX
DEX
DEX
DEX
BPL         LOOP_f5a5
JMP         FUN_f537
LAB_f5be:                     ;XREF[1,0]:   f5a1
CMP         #$33
BNE         LAB_f5d0
INY
LDA         ($00b9),Y                        ;= ??
TAX
INY
LDA         ($00b9),Y                        ;= ??
STX         $00b9                            ;= ??
STA         $00b9+1
JMP         LOOP_f53d
LAB_f5d0:                     ;XREF[1,0]:   f5c0
CMP         #$34
BNE         LAB_f5fb
JSR         FUN_f57d                                ;undefined FUN_f57d()
LDA         ($00b9),Y                        ;= ??
TAX
JSR         FUN_f57d                                ;undefined FUN_f57d()
LDA         ($00b9),Y                        ;= ??
PHA
JSR         FUN_f57d                                ;undefined FUN_f57d()
LDY         $00bb                            ;= ??
LDA         $00b9+1
STA         $01cf,Y                          ;= ??
LDA         $00b9                            ;= ??
STA         $01ce,Y                          ;= ??
DEC         $00bb                            ;= ??
DEC         $00bb                            ;= ??
PLA
STX         $00b9                            ;= ??
STA         $00b9+1
JMP         LOOP_f53d
LAB_f5fb:                     ;XREF[1,0]:   f5d2
CMP         #$35
BNE         LAB_f612
INC         $00bb                            ;= ??
INC         $00bb                            ;= ??
LDY         $00bb                            ;= ??
LDA         $01cf,Y                          ;= ??
STA         $00b9+1
LDA         $01ce,Y                          ;= ??
STA         $00b9                            ;= ??
JMP         LOOP_f53d
LAB_f612:                     ;XREF[1,0]:   f5fd
CMP         #$36
BNE         LAB_f636
JSR         FUN_f57d                                ;undefined FUN_f57d()
LDA         ($00b9),Y                        ;= ??
LDX         $00bb                            ;= ??
STA         $01cd,X                          ;= ??
JSR         FUN_f57d                                ;undefined FUN_f57d()
LDA         $00b9                            ;= ??
STA         $01ce,X                          ;= ??
LDA         $00b9+1
STA         $01cf,X                          ;= ??
DEC         $00bb                            ;= ??
DEC         $00bb                            ;= ??
DEC         $00bb                            ;= ??
JMP         LOOP_f53d
LAB_f636:                     ;XREF[1,0]:   f614
CMP         #$37
BNE         LAB_f657
LDX         $00bb                            ;= ??
DEC         $01d0,X                          ;= ??
BEQ         LAB_f64e
LDA         $01d1,X                          ;= ??
STA         $00b9                            ;= ??
LDA         $01d2,X                          ;= ??
STA         $00b9+1
JMP         LOOP_f53d
LAB_f64e:                     ;XREF[1,0]:   f63f
INC         $00bb                            ;= ??
INC         $00bb                            ;= ??
INC         $00bb                            ;= ??
JMP         FUN_f537
LAB_f657:                     ;XREF[1,0]:   f638
AND         #$6
ASL         A
TAX
JSR         FUN_f57d                                ;undefined FUN_f57d()
LDA         ($00b9),Y                        ;= ??
BPL         LAB_f663
DEY
LAB_f663:                     ;XREF[1,0]:   f660
CLC
ADC         $01c2,X                          ;= ??
STA         APU_SND_SQUARE1_REG:DAT_4002,X
STA         $01c2,X                          ;= ??
TYA
ADC         $01c3,X                          ;= ??
CMP         $01c3,X                          ;= ??
BEQ         LAB_f67c
STA         APU_SND_SQUARE1_REG:DAT_4003,X
STA         $01c3,X                          ;= ??
LAB_f67c:                     ;XREF[1,0]:   f674
JMP         FUN_f537
.byte $20,$3F,$21,$7F,$24,$3F,$25,$7F,$28,$FF,$3F,$5E,$99,$DB,$06,$7C,$BC,$02,$5E,$99,$06,$3F,$02,$5E,$99,$DB,$06,$7C,$BC,$02,$60,$9D,$D9,$16,$7C,$BC,$02,$5D,$9B,$0E,$7C,$BC,$02,$62,$98,$06,$7C,$BC,$02,$60,$9D,$D8,$16,$3F,$02,$5D,$9B,$D8,$0E,$3F,$02,$5E,$9B,$D8,$06,$3F,$02,$60,$9D,$DE,$06,$3F,$02,$62,$A0,$DE,$06,$3F,$02,$63,$A2,$DE,$06,$3F,$02,$64,$9C,$DD,$1E,$1C,$3F,$00,$20,$3D,$21,$7F,$24,$3D,$25,$7F,$28,$FF,$34,$EC,$F6,$34,$E5,$F7,$00,$5C,$99,$D5,$10,$3F,$02,$59,$95,$D0,$0A,$7C,$BC,$02,$5C,$99,$04,$7C,$BC,$02,$61,$99,$D5,$0C,$61,$9C,$04,$3F,$02,$60,$97,$D4,$0C,$9A,$04,$3F,$02,$5E,$95,$D2,$0A,$7C,$BC,$02,$59,$95,$04,$3F,$02,$59,$95,$CD,$10,$FC,$02,$D2,$06,$7C,$BC,$06,$52,$8D,$04,$3F,$02,$55,$92,$D5,$04,$7C,$BC,$02,$59,$95,$D5,$04,$7C,$BC,$02,$5C,$99,$04,$3F,$02,$5E,$9A,$D7,$10,$3F,$02,$5A,$97,$D2,$0A,$7C,$BC,$02,$5E,$9A,$D2,$04,$3F,$02,$63,$9A,$D7,$0C,$9E,$04,$3F,$02,$61,$9B,$D7,$0C,$9E,$04,$3F,$02,$60,$9C,$DC,$0C,$97,$04,$3F,$02,$5E,$8F,$D7,$0C,$95,$04,$3F,$02,$5C,$94,$DC,$0A,$7C,$BC,$02,$54,$90,$DC,$04,$3F,$02,$57,$94,$D0,$04,$7C,$BC,$02,$5C,$97,$04,$7C,$BC,$02,$60,$9C,$04,$3F,$02,$65,$9D,$D9,$0A,$BC,$02,$9D,$04,$BC,$02,$9D,$04,$BC,$02,$99,$04,$BC,$02,$9D,$04,$3F,$02,$65,$A0,$D9,$0C,$9D,$04,$BC,$02,$63,$9B,$0C,$9D,$04,$3F,$02,$61,$9E,$DE,$0C,$99,$04,$3F,$02,$60,$9D,$D9,$0C,$97,$04,$3F,$02,$5E,$95,$DE,$0A,$7C,$BC,$02,$55,$92,$04,$3F,$02,$59,$95,$DE,$04,$7C,$BC,$02,$5E,$99,$04,$7C,$BC,$02,$61,$9E,$04,$3F,$02,$35,$63,$8E,$D7,$0C,$9E,$04,$3F,$02,$63,$8E,$D7,$0A,$7C,$BC,$02,$61,$97,$04,$3F,$02,$60,$9C,$DC,$0C,$60,$97,$DC,$04,$3F,$02,$5E,$9A,$D0,$0A,$7C,$BC,$02,$60,$9A,$04,$3F,$02,$61,$99,$D5,$10,$FC,$02,$D0,$10,$FC,$02,$D5,$12,$3F,$00,$35,$20,$3E,$21,$7F,$24,$7D,$25,$7F,$28,$FF,$3F,$34,$57,$F8,$34,$8A,$F8,$34,$C1,$F8,$34,$57,$F8,$34,$8A,$F8,$34,$EA,$F8,$34,$17,$F9,$34,$64,$F9,$34,$17,$F9,$34,$B1,$F9,$34,$57,$F8,$34,$8A,$F8,$34,$C1,$F8,$34,$57,$F8,$34,$0A,$FA,$00,$63,$A0,$D0,$0F,$3F,$02,$60,$97,$DC,$0A,$7C,$BC,$03,$61,$97,$02,$3F,$02,$60,$98,$DB,$0A,$BC,$03,$94,$02,$3F,$02,$5E,$96,$D4,$0A,$BC,$03,$98,$02,$3F,$02,$5C,$99,$D9,$0F,$3F,$02,$5B,$9B,$DB,$0F,$3F,$02,$35,$59,$9C,$DC,$0A,$7C,$BC,$03,$5B,$9E,$02,$3F,$02,$5C,$A0,$D9,$0F,$3F,$02,$5E,$9E,$DE,$0F,$3F,$02,$60,$9D,$D9,$0A,$BC,$03,$99,$02,$3F,$02,$61,$95,$DE,$0A,$BC,$03,$99,$02,$3F,$02,$59,$9E,$D2,$0A,$BC,$03,$A1,$02,$3F,$02,$35,$60,$A0,$D7,$0F,$BC,$FC,$02,$9E,$D6,$0A,$BC,$03,$9C,$02,$3F,$02,$5E,$9B,$D7,$0A,$BC,$FC,$03,$9C,$D2,$02,$BC,$FC,$02,$9E,$D7,$0A,$BC,$FC,$03,$97,$DB,$02,$BC,$02,$35,$60,$A0,$D7,$0A,$BC,$03,$97,$02,$3F,$02,$5E,$99,$D7,$0A,$BC,$03,$9B,$02,$3F,$02,$5C,$9C,$D0,$0A,$7C,$BC,$03,$5C,$9C,$02,$3F,$02,$5B,$9B,$DC,$0A,$7C,$BC,$03,$5C,$9C,$02,$3F,$02,$35,$5E,$9A,$DA,$0A,$BC,$03,$99,$02,$7C,$BC,$02,$5E,$9A,$DA,$0A,$BC,$03,$9E,$02,$3F,$02,$60,$9D,$D9,$0F,$3F,$02,$59,$94,$D9,$0A,$7C,$BC,$03,$63,$9D,$02,$3F,$02,$61,$9E,$DE,$0A,$BC,$03,$99,$02,$3F,$02,$60,$9D,$D9,$0A,$BC,$03,$97,$02,$3F,$02,$5E,$95,$DE,$0A,$BC,$03,$97,$02,$BC,$FC,$02,$5E,$99,$D2,$0F,$3F,$02,$35,$60,$9B,$D4,$0F,$3F,$02,$58,$94,$D6,$0A,$7C,$BC,$03,$59,$96,$FC,$02,$7C,$BC,$02,$5B,$98,$D8,$0A,$BC,$03,$99,$02,$3F,$02,$5E,$9B,$D4,$0A,$BC,$03,$98,$02,$3F,$02,$5C,$99,$D9,$0A,$7C,$BC,$03,$5B,$9B,$02,$3F,$02,$5C,$9C,$D4,$0A,$7C,$BC,$03,$5E,$9E,$02,$3F,$02,$60,$A0,$D9,$0F,$3F,$02,$59,$94,$D0,$0F,$3F,$02,$35,$5E,$96,$DE,$0A,$7C,$BC,$03,$9D,$94,$02,$3F,$02,$5E,$96,$D9,$0A,$7C,$BC,$03,$60,$97,$02,$3F,$02,$62,$99,$DE,$0A,$BC,$03,$9B,$02,$3F,$02,$5E,$9C,$D2,$0F,$3F,$02,$63,$9B,$D7,$0A,$7C,$BC,$03,$5B,$97,$02,$3F,$02,$5C,$99,$DE,$0A,$7C,$BC,$03,$5B,$9A,$02,$3F,$02,$5E,$9B,$E3,$0A,$3F,$03,$57,$97,$D7,$02,$3F,$02,$59,$99,$D9,$0A,$3F,$03,$5B,$9B,$DB,$02,$3F,$02,$35,$59,$9C,$DC,$0A,$7C,$BC,$03,$5B,$9E,$02,$3F,$02,$5D,$A0,$D9,$0A,$BC,$03,$A3,$02,$3F,$02,$5E,$A1,$D2,$0A,$BC,$03,$A0,$02,$3F,$02,$61,$9E,$DE,$0A,$BC,$03,$9C,$02,$3F,$02,$5B,$9E,$D7,$0A,$7C,$BC,$03,$57,$9B,$02,$3F,$02,$59,$9C,$D7,$0A,$7C,$BC,$03,$5B,$9E,$02,$3F,$02,$5C,$A0,$DC,$0F,$FC,$02,$D7,$0F,$FC,$02,$D0,$11,$3F,$35,$24,$9D,$25,$7F,$AA,$01,$AC,$01,$A9,$01,$AC,$01,$A9,$01,$AB,$27,$28,$00,$20,$B0,$24,$B0,$28,$00,$2F,$08,$2C,$3C,$2E,$0F,$05,$2C,$30,$01,$2C,$3F,$08,$2C,$3E,$08,$2C,$3D,$08,$2C,$3C,$08,$2C,$3B,$08,$2C,$3A,$08,$2C,$39,$08,$2C,$38,$08,$2C,$37,$08,$2C,$36,$08,$2C,$35,$08,$2C,$34,$08,$2C,$30,$08,$00,$24,$3F,$25,$7F,$36,$03,$36,$08,$9E,$01,$3A,$04,$01,$37,$BC,$1E,$12,$37,$36,$20,$AA,$01,$3A,$01,$01,$37,$BC,$00,$24,$3F,$25,$7F,$9E,$01,$BC,$9D,$01,$BC,$9F,$01,$BC,$A5,$01,$BC,$00,$3F,$2C,$30,$20,$3F,$70,$05,$6B,$05,$70,$05,$6B,$05,$70,$05,$6B,$05,$70,$05,$6B,$0A,$3F,$00
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_fae8()
;XREF[3,0]:   f52d,f534,f57a
LDA         $00c2                            ;= ??
BPL         LAB_faed
RTS
LAB_faed:                     ;XREF[1,0]:   faea
LDA         $0053                            ;= ??
CMP         $00be                            ;= ??
BNE         LAB_fafc
LDX         $0051                            ;= ??
CPX         $00bf                            ;= ??
BNE         LAB_fafc
JMP         LAB_fb71
LAB_fafc:                     ;XREF[2,0]:   faf1,faf7
STA         $00be                            ;= ??
STX         $00bf                            ;= ??
LDX         $0053                            ;= ??
CPX         #$b4
BCC         LAB_fb08
LDX         #$b4
LAB_fb08:                     ;XREF[1,0]:   fb04
LDA         $005a                            ;= ??
BEQ         LAB_APU_SND_SQUARE1_REG_fb11
TXA
SEC
SBC         #$a
TAX
LAB_APU_SND_SQUARE1_REG_fb11: ;XREF[1,0]:   fb0a
; FWD[2,0]:   fcd8,fce2
LDA         $fc2e,X=>DAT_fcd8                      ;= A3h
                          ;= 8Dh
SEC
; FWD[2,0]:   fcd9,fce3
SBC         $fc2f,X=>DAT_fcd9                      ;= A1h
                          ;= 8Bh
JSR         FUN_fc15                                ;undefined FUN_fc15()
LDA         #$b4
STA         APU_SND_SQUARE1_REG:APU_SND_SQUARE1_REG
LDA         #$7f
STA         APU_SND_SQUARE1_REG:DAT_4001
LDA         $fc2e,X=>DAT_fcd8                      ;= A3h
SEC
SBC         $00c0                            ;= ??
STA         APU_SND_SQUARE1_REG:DAT_4002
LDA         $100,X=>$01aa                   ;= ??
SBC         #$0
CMP         $01c3                            ;= ??
BEQ         LAB_APU_SND_TRIANGLE_REG_fb3e
STA         APU_SND_SQUARE1_REG:DAT_4003
STA         $01c3                            ;= ??
LAB_APU_SND_TRIANGLE_REG_fb3e:;XREF[1,0]:   fb36
LDA         $fc42,X=>DAT_fcec                      ;= 7Ah
SEC
SBC         $fc43,X=>DAT_fced                      ;= 78h
JSR         FUN_fc15                                ;undefined FUN_fc15()
LDA         #$ff
STA         APU_SND_TRIANGLE_REG:APU_SND_TRIANGLE...
LDA         #$0
STA         APU_DELTA_REG:DAT_4011
LDA         $fc42,X=>DAT_fcec                      ;= 7Ah
SEC
SBC         $00c0                            ;= ??
TAY
LDA         $114,X=>$01be                   ;= ??
SBC         #$0
LSR         A
PHP
CMP         $01cb                            ;= ??
BEQ         LAB_fb6b
STA         APU_SND_TRIANGLE_REG:DAT_400b
STA         $01cb                            ;= ??
LAB_fb6b:                     ;XREF[1,0]:   fb63
PLP
TYA
ROR         A
STA         APU_SND_TRIANGLE_REG:DAT_400a
LAB_fb71:                     ;XREF[1,0]:   faf9
LDA         $00c3                            ;= ??
BNE         LAB_fbef
LDA         $00c2                            ;= ??
BEQ         LAB_fb7a
RTS
LAB_fb7a:                     ;XREF[1,0]:   fb77
LDA         $008f                            ;= ??
JSR         FUN_fbe4                                ;undefined FUN_fbe4()
STA         $00c0                            ;= ??
LDA         #$0
STA         $00c1                            ;= ??
LDY         #$2
LOOP_fb87:                    ;XREF[1,0]:   fb96
; FWD[2,0]:   0090,0091
LDA         $8f,Y=>$0091                    ;= ??
JSR         FUN_fbe4                                ;undefined FUN_fbe4()
CMP         $00c0                            ;= ??
BCS         LAB_fb95
STA         $00c0                            ;= ??
STY         $00c1                            ;= ??
LAB_fb95:                     ;XREF[1,0]:   fb8f
DEY
BNE         LOOP_fb87
LDY         $00c1                            ;= ??
LDA         $8f,Y=>$0091                    ;= ??
CMP         #$f0
BCS         LAB_APU_SND_SQUARE2_REG_fba5
CMP         #$a8
BCS         LAB_APU_SND_SQUARE2_REG_fbab
LAB_APU_SND_SQUARE2_REG_fba5: ;XREF[1,0]:   fb9f
LDA         #$b0
STA         APU_SND_SQUARE2_REG:APU_SND_SQUARE2_REG
RTS
LAB_APU_SND_SQUARE2_REG_fbab: ;XREF[1,0]:   fba3
SEC
SBC         #$a8
TAX
LDA         DAT_fd06,X                              ;= B1h
STA         APU_SND_SQUARE2_REG:APU_SND_SQUARE2_REG
LDA         #$7f
STA         APU_SND_SQUARE2_REG:DAT_4005
LDA         $0050                            ;= ??
LSR         A
LDA         $0051                            ;= ??
ROR         A
CMP         #$64
BCS         LAB_fbcc
STX         $00c0                            ;= ??
LDA         #$48
SEC
SBC         $00c0                            ;= ??
TAX
LAB_fbcc:                     ;XREF[1,0]:   fbc2
TXA
CLC
ADC         #$ac
STA         APU_SND_SQUARE2_REG:DAT_4006
LDA         $01c7                            ;= ??
CMP         #$1
BNE         LAB_fbdb
RTS
LAB_fbdb:                     ;XREF[1,0]:   fbd8
LDA         #$1
STA         APU_SND_SQUARE2_REG:DAT_4007
STA         $01c7                            ;= ??
RTS
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_fbe4()
;XREF[2,0]:   fb7c,fb8a
SEC
SBC         #$cc
BCS         LAB_fbee
EOR         #$ff
CLC
ADC         #$1
LAB_fbee:                     ;XREF[1,0]:   fbe7
RTS
LAB_fbef:                     ;XREF[1,0]:   fb73
LDA         $005f                            ;= ??
BNE         LAB_APU_NOISE_REG_APU_NOISE_REG_FREQU...
RTS
LAB_APU_NOISE_REG_APU_NOISE...;XREF[1,0]:   fbf1
LDA         $01c3                            ;= ??
STA         APU_SND_SQUARE1_REG:DAT_4003
LDA         $01cb                            ;= ??
STA         APU_SND_TRIANGLE_REG:DAT_400b
LDA         #$0
STA         APU_NOISE_REG:APU_NOISE_REG
LDA         #$e
STA         APU_NOISE_REG_FREQUENCY_2:APU_NOISE_R...
LDA         #$88
STA         APU_NOISE_REG_FREQUENCY_AND_TIME_3:AP...
LDA         #$7
JSR         FUN_f48e                                ;undefined FUN_f48e()
RTS
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_fc15()
;XREF[2,0]:   fb18,fb45
STA         $00c0                            ;= ??
LDA         $0051                            ;= ??
AND         #$3
TAY
LSR         $00c0                            ;= ??
LSR         $00c0                            ;= ??
LDA         $00c0                            ;= ??
LAB_fc22:                     ;XREF[1,0]:   fc28
DEY
BMI         LAB_fc2b
CLC
ADC         $00c0                            ;= ??
JMP         LAB_fc22
LAB_fc2b:                     ;XREF[1,0]:   fc23
STA         $00c0                            ;= ??
RTS
.byte $7E,$63,$48,$2D,$12,$F8,$DF,$C6,$AD,$94,$7C,$64,$4D,$36,$1F,$08,$F2,$DC,$C7,$B2,$9D,$88,$74,$60,$4C,$38,$25,$12,$00,$ED,$DB,$C9,$B8,$A6,$95,$85,$74,$64,$53,$44,$34,$24,$15,$06,$F7,$E9,$DA,$CC,$BE,$B1,$A3,$96,$88,$7B,$6F,$62,$56,$49,$3D,$31,$26,$1A,$0F,$03,$F8,$ED,$E3,$D8,$CE,$C3,$B9,$AF,$A5,$9B,$92,$88,$7F,$76,$6D,$64,$5B,$52,$4A,$42,$39,$31,$29,$21,$19,$11,$0A,$02,$FB,$F4,$EC,$E5,$DE,$D8,$D1,$CA,$C3,$BD,$B7,$B0,$AA,$A4,$9E,$98,$92,$8C,$87,$81,$7B,$76,$71,$6B,$66,$61,$5C,$57,$52,$4D,$48,$43,$3F,$3A,$36,$31,$2D,$28,$24,$20,$1C,$18,$14,$10,$0C,$08,$04,$00,$FD,$F9,$F5,$F2,$EE,$EB,$E8,$E4,$E1,$DE,$DB,$D7,$D4,$D1,$CE,$CB,$C8,$C5,$C3,$C0,$BD,$BA,$B8,$B5,$B2,$B0,$AD,$AB,$A8,$A6
DAT_fcd8:                     ;XREF[2,0]:   fb11,fb25
.byte $A3
DAT_fcd9:                     ;XREF[1,0]:   fb15
.byte $A1,$9F,$9C,$9A,$98,$96,$93,$91,$8F
DAT_fce2:                     ;XREF[1,0]:   fb11
.byte $8D
DAT_fce3:                     ;XREF[1,0]:   fb15
.byte $8B,$89,$87,$85,$83,$81,$7F,$7E,$7C
DAT_fcec:                     ;XREF[2,0]:   fb3e,fb52
.byte $7A
DAT_fced:                     ;XREF[1,0]:   fb42
.byte $78,$76,$75,$73,$71,$70,$6E,$6D,$6B,$69,$68,$66,$65,$63,$62,$61,$5F,$FF,$8C,$5C,$40,$2C,$1D,$10
DAT_fd05:                     ;XREF[1,0]:   c05b
.byte $05
DAT_fd06:                     ;XREF[1,0]:   fbaf
.byte $B1,$B1,$B2,$B2,$B3,$B3,$B4,$B4,$B5,$B5,$B6,$B6,$B7,$B7,$B8,$B8,$B9,$B9,$BA,$BA,$BB,$BB,$BC,$BC,$BD,$BD,$BE,$BE,$BF,$BF,$BF,$BF,$BF,$BF,$BF,$BF,$BF,$BF,$BF,$BF,$BF,$BF,$BF,$BF,$BF,$BF,$BF,$BF,$BF,$BF,$BF,$BF,$BF,$BF,$BF,$BF,$BF,$BF,$BF,$BF,$BF,$BF,$BF,$BF,$BF,$BF,$BF,$BF,$BC,$B8,$B4,$B0
DAT_fd4e:                     ;XREF[1,0]:   f55c
.byte $06
DAT_fd4f:                     ;XREF[1,0]:   f553
.byte $AE,$06,$4E,$05,$F3,$05,$9E,$05,$4D,$05,$01,$04,$B9,$04,$75,$04,$35,$03,$F8,$03,$BF,$03,$89,$03,$57,$03,$27,$02,$F9,$02,$CF,$02,$A6,$02,$80,$02,$5C,$02,$3A,$02,$1A,$01,$FC,$01,$DF,$01,$C4,$01,$AB,$01,$93,$01,$7C,$01,$67,$01,$52,$01,$3F,$01,$2D,$01,$1C,$01,$0C,$00,$FD,$00,$EE,$00,$E1,$00,$D4,$00,$C8,$00,$BD,$00,$B2,$00,$A8,$00,$9F,$00,$96,$00,$8D,$00,$85,$00,$7E,$00,$76,$00,$70,$00,$69,$00,$63,$00,$5E,$00,$58,$00,$53,$00,$4F,$00,$4A,$00,$46,$00,$42,$00,$3E,$00,$24,$00,$20,$00,$00
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_fdc8()
;XREF[1,0]:   cc7f
LDA         $00c8                            ;= ??
CLC
ADC         $005f                            ;= ??
STA         $00c8                            ;= ??
CMP         #$2
BCC         LOOP_fdf8
LDA         #$0
STA         $00c8                            ;= ??
LDA         $004a                            ;= ??
CLC
ADC         #$40
JSR         FUN_fe29                                ;undefined FUN_fe29()
CLC
ADC         $00c5                            ;= ??
STA         $00c5                            ;= ??
TYA
ADC         $00c4                            ;= ??
STA         $00c4                            ;= ??
LDA         $004a                            ;= ??
JSR         FUN_fe29                                ;undefined FUN_fe29()
CLC
ADC         $00c7                            ;= ??
STA         $00c7                            ;= ??
TYA
ADC         $00c6                            ;= ??
STA         $00c6                            ;= ??
LOOP_fdf8:                    ;XREF[2,0]:   fdd1,fdfa
LDA         $0032                            ;= ??
BNE         LOOP_fdf8
INC         $00c9                            ;= ??
LDA         $00c9                            ;= ??
AND         #$6
BNE         LAB_fe08
LDA         #$f0
BNE         LAB_fe0a
LAB_fe08:                     ;XREF[1,0]:   fe02
LDA         $00c6                            ;= ??
LAB_fe0a:                     ;XREF[1,0]:   fe06
STA         $0204                            ;= ??
STA         $0304                            ;= ??
LDA         $00c4                            ;= ??
STA         $0207                            ;= ??
STA         $0307                            ;= ??
LDA         #$fc
STA         $0205                            ;= ??
STA         $0305                            ;= ??
LDA         #$0
STA         $0206                            ;= ??
STA         $0306                            ;= ??
RTS
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_fe29()
;XREF[2,0]:   fddc,fdeb
PHA
AND         #$7f
CMP         #$40
BCC         LAB_fe37
SBC         #$80
EOR         #$ff
CLC
ADC         #$1
LAB_fe37:                     ;XREF[1,0]:   fe2e
TAX
LDY         #$0
PLA
BMI         LAB_fe41
LOOP_fe3d:                    ;XREF[1,0]:   fe43
LDA         DAT_fe4d,X
RTS
LAB_fe41:                     ;XREF[1,0]:   fe3b
CMP         #$80
BEQ         LOOP_fe3d
DEY
LDA         #$0
SEC
SBC         DAT_fe4d,X
RTS
DAT_fe4d:                     ;XREF[2,0]:   fe3d,fe49
.byte $00,$06,$0D,$13,$19,$1F,$26,$2C,$32,$38,$3E,$44,$4A,$50,$56,$5C,$62,$68,$6D,$73,$79,$7E,$84,$89,$8E,$93,$98,$9D,$A2,$A7,$AC,$B1,$B5,$B9,$BE,$C2,$C6,$CA,$CE,$D1,$D5,$D8,$DC,$DF,$E2,$E5,$E7,$EA,$ED,$EF,$F1,$F3,$F5,$F7,$F8,$FA,$FB,$FC,$FD,$FE,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_ff08()
;XREF[17,0]:  ca19,ca1c,ca1f,ce5b,cf03,cf43,d0df,e75d
;             e772,eaa4,eb51,eb94,f283,f288,f290,ff09
;             ff6b
DEY
BNE         FUN_ff08
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_ff0b()
;XREF[1,0]:   d6ba
RTS
DAT_ff0c:                     ;XREF[1,0]:   ff16
.byte $00
DAT_ff0d:                     ;XREF[1,0]:   ff26
.byte $80,$80,$00
DAT_ff10:                     ;XREF[1,0]:   ff1e
.byte $04
DAT_ff11:                     ;XREF[1,0]:   ff2c
.byte $04,$05,$04
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_ff14()
;XREF[16,0]:  c1cc,ca35,ce66,cf0b,cf46,cf9c,d0e2,e9d3
;             e9dc,e9e8,e9f1,e9fd,ea0b,eaa7,eb54,eb97
LDY         $0035                            ;= ??
LDA         DAT_ff0c,Y
STA         $003a                            ;= ??
STA         $0615                            ;= ??
LDA         DAT_ff10,Y                              ;= 04h
STA         $003a+1
STA         $0616                            ;= ??
LDA         DAT_ff0d,Y                              ;= 80h
STA         $0618                            ;= ??
LDA         DAT_ff11,Y                              ;= 04h
STA         $0619                            ;= ??
LDA         $0056                            ;= ??
CMP         #$1
BNE         LAB_ff3d
LDA         #$5
JSR         FUN_f48e                                ;undefined FUN_f48e()
LAB_ff3d:                     ;XREF[1,0]:   ff36
LDA         $0071                            ;= ??
CMP         #$1
BEQ         LAB_ff4a
LDA         $0032                            ;= ??
BNE         LAB_ff4a
JSR         LAB_JOYPAD_PORT2_f505                   ;undefined LAB_JOYPAD_PORT2_f505()
LAB_ff4a:                     ;XREF[2,0]:   ff41,ff45
LDA         #$0
STA         $0017                            ;= ??
STA         $0018                            ;= ??
LDA         #$3e
SEC
SBC         $0500                            ;= ??
EOR         #$80
STA         $001a                            ;= ??
AND         #$4
STA         $0019                            ;= ??
LDA         $0015                            ;= ??
BEQ         LAB_ff6e
LOOP_PPUSTATUS_ff62:          ;XREF[1,0]:   ff67
LDA         PPUSTATUS:PPUSTATUS
AND         #$40
BEQ         LOOP_PPUSTATUS_ff62
LDY         #$16
JSR         FUN_ff08                                ;undefined FUN_ff08()
LAB_ff6e:                     ;XREF[1,0]:   ff60
LDX         #$0
LOOP_ff70:                    ;XREF[1,0]:   ff7a
JSR         RAM:FUN_0600                            ;undefined FUN_0600()
LDA         $0017                            ;= ??
NOP
NOP
NOP
CPX         #$3a
BCC         LOOP_ff70
JSR         RAM:FUN_0600                            ;undefined FUN_0600()
LOOP_ff7f:                    ;XREF[1,0]:   ff89
JSR         RAM:FUN_0600                            ;undefined FUN_0600()
LDA         $0017                            ;= ??
NOP
NOP
NOP
CPX         #$60
BCC         LOOP_ff7f
JSR         RAM:FUN_0600                            ;undefined FUN_0600()
LOOP_ff8e:                    ;XREF[1,0]:   ff98
JSR         RAM:FUN_0600                            ;undefined FUN_0600()
LDA         $0017                            ;= ??
NOP
NOP
NOP
CPX         #$80
BCC         LOOP_ff8e
RTS
.byte $A5,$17,$18,$65,$4C,$85,$17,$A5,$18,$65,$4D,$85,$18,$18
DAT_ffa9:                     ;XREF[1,0]:   c026
.byte $69
DAT_ffaa:                     ;XREF[1,0]:   c026
.byte $3E,$38,$FD,$00,$05,$9D,$00,$04,$BD,$00,$04,$A8,$29,$04,$C5,$19,$85,$19,$D0,$1D,$98,$45,$1A,$30,$14,$EA,$EA,$98,$0A,$8D,$05,$20,$A9,$00,$8D,$05,$20,$84,$1A,$EA,$EA,$84,$1A,$E8,$60,$98,$4C,$E8,$FF,$98,$C5,$1A,$B0,$05,$29,$FC,$4C,$E8,$FF,$09,$03,$EA,$0A,$8D,$05,$20,$A9,$00,$8D,$05,$20,$65,$14,$8D,$00,$20,$84,$1A
DAT_fff8:                     ;XREF[1,0]:   c046
.byte $E8
DAT_fff9:                     ;XREF[1,0]:   c046

.segment "VECTORS"
.org $FFFA
.word NMI
.word Reset
.word IRQ
; addr        c066
; RES:                          ;XREF[1,0]:   Entry Point
; addr        c000
; IRQ:                          ;XREF[1,0]:   Entry Point
; addr        c0d2

.include "consts.inc"
.include "header.inc"

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
undefined1  2Dh
DAT_cba9:                     ;XREF[1,0]:   ca88
$C1h
$D0h
$DFh
$EEh
$FDh
$0Ch
$1Bh
$2Ah    *
$39h    9
$48h    H
$57h    W
$66h    f
DAT_cbb5:                     ;XREF[1,0]:   ca8d
$CBh
$CBh
$CBh
$CBh
$CBh
$CCh
$CCh
$CCh
$CCh
$CCh
$CCh
$CCh
$61h    a
$63h    c
$68h    h
$71h    q
$77h    w
$7Fh    
$2Ch    ,
$89h
$8Fh
$92h
$2Ch    ,
$2Ch    ,
$2Ch    ,
$99h
$92h
$61h    a
$64h    d
$69h    i
$72h    r
$78h    x
$7Fh    
$84h
$8Ah
$8Fh
$92h
$94h
$2Ch    ,
$2Ch    ,
$2Ch    ,
$9Bh
$61h    a
$65h    e
$69h    i
$73h    s
$79h    y
$7Fh    
$85h
$2Ch    ,
$90h
$92h
$92h
$2Ch    ,
$2Ch    ,
$2Ch    ,
$2Ch    ,
$61h    a
$65h    e
$6Ah    j
$74h    t
$7Ah    z
$7Fh    
$86h
$2Ch    ,
$91h
$92h
$92h
$94h
$2Ch    ,
$2Ch    ,
$2Ch    ,
$62h    b
$66h    f
$6Bh    k
$77h    w
$7Bh    {
$7Fh    
$87h
$2Ch    ,
$2Ch    ,
$92h
$92h
$92h
$96h
$2Ch    ,
$2Ch    ,
$62h    b
$66h    f
$6Bh    k
$78h    x
$7Ch    |
$80h
$7Fh    
$8Bh
$2Ch    ,
$99h
$92h
$92h
$97h
$2Ch    ,
$2Ch    ,
$62h    b
$67h    g
$6Ch    l
$79h    y
$69h    i
$81h
$7Fh    
$8Ch
$2Ch    ,
$2Ch    ,
$92h
$92h
$92h
$9Ah
$2Ch    ,
$62h    b
$67h    g
$77h    w
$7Ah    z
$72h    r
$82h
$7Fh    
$8Dh
$2Ch    ,
$2Ch    ,
$99h
$92h
$92h
$92h
$96h
$62h    b
$67h    g
$6Dh    m
$75h    u
$7Dh    }
$2Ch    ,
$7Fh    
$8Fh
$8Bh
$2Ch    ,
$2Ch    ,
$92h
$92h
$92h
$97h
$62h    b
$67h    g
$6Eh    n
$7Ch    |
$7Dh    }
$84h
$88h
$8Fh
$8Ch
$2Ch    ,
$2Ch    ,
$95h
$92h
$92h
$92h
$61h    a
$63h    c
$6Fh    o
$76h    v
$7Eh    ~
$85h
$82h
$8Fh
$8Fh
$2Ch    ,
$2Ch    ,
$2Ch    ,
$9Bh
$92h
$92h
$61h    a
$63h    c
$70h    p
$69h    i
$74h    t
$83h
$2Ch    ,
$8Eh
$8Fh
$93h
$2Ch    ,
$2Ch    ,
$98h
$92h
$92h
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
STA         $500,X=>$057f                   ;= ??
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
$2Dh    -
$1Bh
$0Eh
$1Fh
$18h
$2Dh    -
$2Dh    -
$0Eh
$16h
$0Ah
DAT_cf67:                     ;XREF[1,0]:   ced5
undefined1  10h
DAT_cf68:                     ;XREF[1,0]:   ced5
undefined1  2Dh
DAT_cf69:                     ;XREF[2,0]:   d21e,e831
$00h
$05h
$0Ah
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
$27h    '
$3Ch    <
$17h
$2Dh    -
$1Dh
$12h
$1Eh
$0Ch
$1Bh
DAT_d0f3:                     ;XREF[1,0]:   d0ad
undefined1  12h
DAT_d0f4:                     ;XREF[1,0]:   d0ad
undefined1  0Ch
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
$64h    d
$0Ah
$01h
DAT_d118:                     ;XREF[2,0]:   d16c,d182
$00h
$00h
$00h
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
$01h
$01h
$02h
$03h
$05h
DAT_d8d7:                     ;XREF[1,0]:   d7e9
$00h
$01h
$02h
$04h
$07h
DAT_d8dc:                     ;XREF[1,0]:   d7fe
$D1h
$D2h
$D4h
$D3h
$D7h
$D6h
$D5h
$DBh
$D9h
$DAh
$D9h
$D8h
DAT_d8e8:                     ;XREF[3,0]:   d7e1,d82a,d877
$00h
$00h
$01h
$02h
$02h
$03h
$03h
$03h
$04h
$04h
$04h
$04h
$04h
$04h
$04h
$04h
DAT_d8f8:                     ;XREF[1,0]:   d82d
$01h
$01h
$02h
$06h
$0Ah
DAT_d8fd:                     ;XREF[1,0]:   d838
$00h
$01h
$02h
$04h
$0Ah
DAT_d902:                     ;XREF[1,0]:   d83e
$E0h
$E0h
$E8h
$E8h
$F0h
$F0h
$F8h
$F8h
$00h
$00h
$00h
$00h
$F8h
$00h
$F0h
$F0h
$F8h
$F8h
$00h
$00h
$E0h
$E0h
$E8h
$E8h
$F0h
$F0h
$F8h
$F8h
$00h
$00h
$00h
$00h
$F8h
$00h
$F0h
$F0h
$F8h
$F8h
$00h
$00h
$E0h
$E0h
$E8h
$E8h
$F0h
$F0h
$F8h
$F8h
$00h
$00h
DAT_d934:                     ;XREF[1,0]:   d84b
$EFh
$39h    9
$F0h
$F0h
$E6h
$E6h
$F1h
$F2h
$F0h
$F0h
$DCh
$DDh
$EAh
$EBh
$E0h
$ECh
$E0h
$EDh
$E0h
$EEh
$E9h
$E9h
$E4h
$E5h
$E4h
$E4h
$E9h
$E9h
$E9h
$E9h
$DCh
$DDh
$DEh
$DFh
$E0h
$E1h
$E0h
$E2h
$E0h
$E3h
$E4h
$E5h
$E4h
$E4h
$E6h
$E6h
$E7h
$E8h
$E9h
$E9h
DAT_d966:                     ;XREF[1,0]:   d855
$00h
$00h
$00h
$40h    @
$00h
$40h    @
$00h
$00h
$00h
$40h    @
$00h
$00h
$00h
$00h
$00h
$00h
$00h
$00h
$00h
$00h
$00h
$40h    @
$00h
$00h
$00h
$40h    @
$00h
$40h    @
$00h
$40h    @
$00h
$00h
$00h
$00h
$00h
$00h
$00h
$00h
$00h
$00h
$00h
$00h
$00h
$40h    @
$00h
$40h    @
$00h
$00h
$00h
$40h    @
DAT_d998:                     ;XREF[1,0]:   d85f
$FCh
$04h
$FCh
$04h
$FCh
$04h
$FCh
$04h
$FCh
$04h
$04h
$04h
$04h
$04h
$FCh
$04h
$FCh
$04h
$FCh
$04h
$FCh
$04h
$FCh
$04h
$FCh
$04h
$FCh
$04h
$FCh
$04h
$04h
$04h
$04h
$04h
$FCh
$04h
$FCh
$04h
$FCh
$04h
$FCh
$04h
$FCh
$04h
$FCh
$04h
$FCh
$04h
$FCh
$04h
DAT_d9ca:                     ;XREF[1,0]:   d834
$F6h
$0Ah
$1Eh
DAT_d9cd:                     ;XREF[1,0]:   d87a
$01h
$01h
$02h
$04h
$07h
DAT_d9d2:                     ;XREF[1,0]:   d889
$00h
$01h
$02h
$04h
$08h
DAT_d9d7:                     ;XREF[1,0]:   d88f
$00h
$00h
$F8h
$00h
$F0h
$F0h
$F8h
$00h
$E0h
$E0h
$E8h
$E8h
$F0h
$F8h
$00h
DAT_d9e6:                     ;XREF[1,0]:   d89c
$01h
$0Bh
$0Ch
$0Dh
$47h    G
$55h    U
$85h
$85h
$8Dh
$91h
$2Fh    /
$34h    4
$32h    2
$32h    2
$32h    2
DAT_d9f5:                     ;XREF[1,0]:   d8b9
$04h
$04h
$04h
$04h
$03h
$0Bh
$03h
$03h
$00h
$08h
$00h
$08h
$04h
$04h
$04h
DAT_da04:                     ;XREF[1,0]:   d8b3
$04h
$04h
$04h
$04h
$04h
$FCh
$03h
$03h
$08h
$00h
$08h
$00h
$04h
$04h
$04h
DAT_da13:                     ;XREF[2,0]:   d30a,d60b
$5Ch    \
$A4h
$E8h
$28h    (
$6Ch    l
$B4h
$FCh
$40h    @
$80h
$C4h
DAT_da1d:                     ;XREF[2,0]:   d30f,d610
$DAh
$DAh
$DAh
$DBh
$DBh
$DBh
$DBh
$DCh
$DCh
$DCh
DAT_da27:                     ;XREF[2,0]:   d314,d61f
$30h    0
$2Ch    ,
$30h    0
$2Ch    ,
$30h    0
$30h    0
$2Ch    ,
$30h    0
$2Ch    ,
$30h    0
DAT_da31:                     ;XREF[2,0]:   d319,d615
$48h    H
$44h    D
$40h    @
$44h    D
$48h    H
$48h    H
$44h    D
$40h    @
$44h    D
$48h    H
DAT_da3b:                     ;XREF[2,0]:   d31e,d61a
$3Ch    <
$38h    8
$38h    8
$38h    8
$3Ch    <
$3Ch    <
$38h    8
$38h    8
$38h    8
$3Ch    <
$00h
$01h
$01h
$01h
$01h
$01h
$01h
$01h
$01h
$01h
$01h
$02h
$03h
$03h
$03h
$03h
$03h
$03h
$03h
$03h
$03h
$03h
DAT_da5b:                     ;XREF[1,0]:   d301
undefined1  04h
$00h
$1Fh
$40h    @
$E8h
$00h
$1Dh
$40h    @
$F8h
$00h
$1Ch
$40h    @
$00h
$08h
$23h    #
$40h    @
$F0h
$08h
$22h    "
$40h    @
$F8h
$08h
$21h    !
$40h    @
$00h
$10h
$28h    (
$40h    @
$F8h
$10h
$27h    '
$40h    @
$00h
$10h
$26h    &
$40h    @
$08h
$18h
$2Dh    -
$40h    @
$F8h
$18h
$2Ch    ,
$40h    @
$00h
$18h
$2Bh    +
$40h    @
$08h
$08h
$20h
$40h    @
$08h
$10h
$25h    %
$40h    @
$10h
$18h
$2Ah    *
$40h    @
$10h
$08h
$24h    $
$40h    @
$E8h
$10h
$29h    )
$40h    @
$F0h
$18h
$2Eh    .
$40h    @
$F0h
$00h
$00h
$40h    @
$EEh
$00h
$0Ah
$40h    @
$06h
$08h
$11h
$40h    @
$F6h
$08h
$10h
$40h    @
$FEh
$08h
$0Fh
$40h    @
$06h
$10h
$16h
$40h    @
$F6h
$10h
$15h
$40h    @
$FEh
$10h
$14h
$40h    @
$06h
$18h
$1Ah
$40h    @
$F6h
$18h
$19h
$40h    @
$FEh
$18h
$18h
$40h    @
$06h
$08h
$0Eh
$40h    @
$0Eh
$10h
$13h
$40h    @
$0Eh
$18h
$07h
$40h    @
$0Eh
$08h
$12h
$40h    @
$EEh
$10h
$17h
$40h    @
$EEh
$18h
$1Bh
$40h    @
$EEh
$00h
$00h
$00h
$F0h
$00h
$00h
$40h    @
$08h
$08h
$02h
$00h
$F0h
$08h
$03h
$00h
$F8h
$08h
$03h
$40h    @
$00h
$08h
$02h
$40h    @
$08h
$10h
$05h
$00h
$F4h
$10h
$06h
$00h
$FCh
$10h
$05h
$40h    @
$04h
$18h
$08h
$00h
$F4h
$18h
$09h
$00h
$FCh
$18h
$08h
$40h    @
$04h
$10h
$04h
$00h
$ECh
$18h
$07h
$00h
$ECh
$10h
$04h
$40h    @
$0Ch
$18h
$07h
$40h    @
$0Ch
$00h
$0Ah
$00h
$F2h
$00h
$00h
$00h
$0Ah
$08h
$0Fh
$00h
$F2h
$08h
$10h
$00h
$FAh
$08h
$11h
$00h
$02h
$10h
$14h
$00h
$F2h
$10h
$15h
$00h
$FAh
$10h
$16h
$00h
$02h
$18h
$18h
$00h
$F2h
$18h
$19h
$00h
$FAh
$18h
$1Ah
$00h
$02h
$08h
$0Eh
$00h
$EAh
$10h
$13h
$00h
$EAh
$18h
$07h
$00h
$EAh
$08h
$12h
$00h
$0Ah
$10h
$17h
$00h
$0Ah
$18h
$1Bh
$00h
$0Ah
$00h
$1Ch
$00h
$F8h
$00h
$1Dh
$00h
$00h
$00h
$1Fh
$00h
$10h
$08h
$21h    !
$00h
$F8h
$08h
$22h    "
$00h
$00h
$08h
$23h    #
$00h
$08h
$10h
$26h    &
$00h
$F0h
$10h
$27h    '
$00h
$F8h
$10h
$28h    (
$00h
$00h
$18h
$2Bh    +
$00h
$F0h
$18h
$2Ch    ,
$00h
$F8h
$18h
$2Dh    -
$00h
$00h
$08h
$20h
$00h
$F0h
$10h
$25h    %
$00h
$E8h
$18h
$2Ah    *
$00h
$E8h
$08h
$24h    $
$00h
$10h
$10h
$29h    )
$00h
$08h
$18h
$2Eh    .
$00h
$08h
$00h
$3Bh    ;
$40h    @
$E8h
$00h
$1Dh
$40h    @
$F8h
$00h
$1Eh
$40h    @
$00h
$08h
$23h    #
$40h    @
$F0h
$08h
$22h    "
$40h    @
$F8h
$08h
$3Ah    :
$40h    @
$00h
$10h
$3Eh    >
$40h    @
$F8h
$10h
$27h    '
$40h    @
$00h
$10h
$26h    &
$40h    @
$08h
$18h
$2Dh    -
$40h    @
$F8h
$18h
$2Ch    ,
$40h    @
$00h
$18h
$2Bh    +
$40h    @
$08h
$08h
$20h
$40h    @
$08h
$10h
$3Dh    =
$40h    @
$10h
$18h
$2Ah    *
$40h    @
$10h
$08h
$3Ch    <
$40h    @
$E8h
$10h
$3Fh    ?
$40h    @
$F0h
$18h
$2Eh    .
$40h    @
$F0h
$00h
$00h
$40h    @
$EEh
$00h
$0Ah
$40h    @
$06h
$08h
$11h
$40h    @
$F6h
$08h
$10h
$40h    @
$FEh
$08h
$33h    3
$40h    @
$06h
$10h
$37h    7
$40h    @
$F6h
$10h
$15h
$40h    @
$FEh
$10h
$14h
$40h    @
$06h
$18h
$1Ah
$40h    @
$F6h
$18h
$19h
$40h    @
$FEh
$18h
$18h
$40h    @
$06h
$08h
$0Eh
$40h    @
$0Eh
$10h
$36h    6
$40h    @
$0Eh
$18h
$07h
$40h    @
$0Eh
$08h
$35h    5
$40h    @
$EEh
$10h
$38h    8
$40h    @
$EEh
$18h
$1Bh
$40h    @
$EEh
$00h
$00h
$00h
$F0h
$00h
$00h
$40h    @
$08h
$08h
$30h    0
$00h
$F0h
$08h
$03h
$00h
$F8h
$08h
$03h
$40h    @
$00h
$08h
$30h    0
$40h    @
$08h
$10h
$05h
$00h
$F4h
$10h
$06h
$00h
$FCh
$10h
$05h
$40h    @
$04h
$18h
$08h
$00h
$F4h
$18h
$09h
$00h
$FCh
$18h
$08h
$40h    @
$04h
$10h
$31h    1
$00h
$ECh
$18h
$07h
$00h
$ECh
$10h
$31h    1
$40h    @
$0Ch
$18h
$07h
$40h    @
$0Ch
$00h
$0Ah
$00h
$F2h
$00h
$00h
$00h
$0Ah
$08h
$33h    3
$00h
$F2h
$08h
$10h
$00h
$FAh
$08h
$11h
$00h
$02h
$10h
$14h
$00h
$F2h
$10h
$15h
$00h
$FAh
$10h
$37h    7
$00h
$02h
$18h
$18h
$00h
$F2h
$18h
$19h
$00h
$FAh
$18h
$1Ah
$00h
$02h
$08h
$0Eh
$00h
$EAh
$10h
$36h    6
$00h
$EAh
$18h
$07h
$00h
$EAh
$08h
$35h    5
$00h
$0Ah
$10h
$38h    8
$00h
$0Ah
$18h
$1Bh
$00h
$0Ah
$00h
$1Eh
$00h
$F8h
$00h
$1Dh
$00h
$00h
$00h
$3Bh    ;
$00h
$10h
$08h
$3Ah    :
$00h
$F8h
$08h
$22h    "
$00h
$00h
$08h
$23h    #
$00h
$08h
$10h
$26h    &
$00h
$F0h
$10h
$27h    '
$00h
$F8h
$10h
$3Eh    >
$00h
$00h
$18h
$2Bh    +
$00h
$F0h
$18h
$2Ch    ,
$00h
$F8h
$18h
$2Dh    -
$00h
$00h
$08h
$20h
$00h
$F0h
$10h
$3Dh    =
$00h
$E8h
$18h
$2Ah    *
$00h
$E8h
$08h
$3Ch    <
$00h
$10h
$10h
$3Fh    ?
$00h
$08h
$18h
$2Eh    .
$00h
DAT_dd0b:                     ;XREF[2,0]:   d430,f3f9
$08h
$62h    b
$54h    T
$46h    F
$38h    8
$2Ah    *
$1Ch
$0Eh
$00h
DAT_dd14:                     ;XREF[1,0]:   d439
$00h
$5Ch    \
$A4h
DAT_dd17:                     ;XREF[1,0]:   f3fc
$E8h
$28h    (
$6Ch    l
$00h
$00h
$B4h
$FCh
$40h    @
$80h
$C4h
$00h
$00h
$3Ah    :
$6Ah    j
$96h
$C2h
$EEh
$00h
$00h
$1Eh
$4Eh    N
$7Ah    z
$A6h
$D2h
$00h
$02h
$22h    "
$3Ah    :
$52h    R
$6Ah    j
$82h
$9Ah
$02h
$22h    "
$3Ah    :
$52h    R
$6Ah    j
$82h
$9Ah
$BAh
$CEh
$E2h
$F6h
$0Ah
$1Eh
$32h    2
$BAh
$CEh
$E2h
$F6h
$0Ah
$1Eh
$32h    2
$46h    F
$52h    R
$5Ah    Z
$62h    b
$6Ah    j
$72h    r
$7Ah    z
$46h    F
$52h    R
$5Ah    Z
$62h    b
$6Ah    j
$72h    r
$7Ah    z
$86h
$8Eh
$96h
$9Eh
$A6h
$AEh
$B6h
$86h
$8Eh
$96h
$9Eh
$A6h
$AEh
$B6h
$BEh
$C2h
$C6h
$CAh
$CEh
$D2h
$D6h
$BEh
$C2h
$C6h
$CAh
$CEh
$D2h
$D6h
$DAh
$DAh
$DAh
$DAh
$DAh
$DAh
$DAh
$DAh
$DAh
$DAh
$DAh
$DAh
$DAh
$DAh
DAT_dd84:                     ;XREF[1,0]:   d43e
$00h
$DAh
$DAh
DAT_dd87:                     ;XREF[1,0]:   f401
$DAh
$DBh
$DBh
$00h
$00h
$DBh
$DBh
$DCh
$DCh
$DCh
$00h
$00h
$DEh
$DEh
$DEh
$DEh
$DEh
$00h
$00h
$DFh
$DFh
$DFh
$DFh
$DFh
$00h
$E0h
$E0h
$E0h
$E0h
$E0h
$E0h
$E0h
$E0h
$E0h
$E0h
$E0h
$E0h
$E0h
$E0h
$E0h
$E0h
$E0h
$E0h
$E1h
$E1h
$E1h
$E0h
$E0h
$E0h
$E0h
$E1h
$E1h
$E1h
$E1h
$E1h
$E1h
$E1h
$E1h
$E1h
$E1h
$E1h
$E1h
$E1h
$E1h
$E1h
$E1h
$E1h
$E1h
$E1h
$E1h
$E1h
$E1h
$E1h
$E1h
$E1h
$E1h
$E1h
$E1h
$E1h
$E1h
$E1h
$E1h
$E1h
$E1h
$E1h
$E1h
$E1h
$E1h
$E1h
$E1h
$E1h
$E1h
$E1h
$E1h
$E1h
$E1h
$E1h
$E1h
$E1h
$E1h
$E1h
$E1h
$E1h
$E1h
$E1h
$E1h
$E1h
$E1h
$E1h
DAT_ddf4:                     ;XREF[1,0]:   d44d
$00h
$30h    0
$2Ch    ,
DAT_ddf7:                     ;XREF[1,0]:   f40d
$30h    0
$2Ch    ,
$30h    0
$00h
$00h
$30h    0
$2Ch    ,
$30h    0
$2Ch    ,
$30h    0
$00h
$00h
$30h    0
$2Ch    ,
$2Ch    ,
$2Ch    ,
$30h    0
$00h
$00h
$30h    0
$2Ch    ,
$2Ch    ,
$2Ch    ,
$30h    0
$00h
$20h
$18h
$18h
$18h
$18h
$18h
$20h
$20h
$18h
$18h
$18h
$18h
$18h
$20h
DAT_de1e:                     ;XREF[1,0]:   d443
$00h
$48h    H
$44h    D
DAT_de21:                     ;XREF[1,0]:   f406
$40h    @
$44h    D
$48h    H
$00h
$00h
$48h    H
$44h    D
$40h    @
$44h    D
$48h    H
$00h
DAT_de2c:                     ;XREF[1,0]:   d448
$00h
$3Ch    <
$38h    8
$38h    8
$38h    8
$3Ch    <
$00h
$00h
$3Ch    <
$38h    8
$38h    8
$38h    8
$3Ch    <
$00h
$08h
$58h    X
$40h    @
$F0h
$08h
$57h    W
$40h    @
$F8h
$08h
$56h    V
$40h    @
$00h
$10h
$5Dh    ]
$40h    @
$ECh
$10h
$5Ch    \
$40h    @
$F4h
$10h
$5Bh    [
$40h    @
$FCh
$10h
$5Ah    Z
$40h    @
$04h
$10h
$59h    Y
$40h    @
$0Ch
$18h
$61h    a
$40h    @
$F4h
$18h
$60h    `
$40h    @
$FCh
$18h
$5Fh    _
$40h    @
$04h
$18h
$5Eh    ^
$40h    @
$0Ch
$08h
$4Ah    J
$40h    @
$F1h
$08h
$49h    I
$40h    @
$F9h
$08h
$48h    H
$40h    @
$01h
$10h
$4Eh    N
$40h    @
$F1h
$10h
$4Dh    M
$40h    @
$F9h
$10h
$4Ch    L
$40h    @
$01h
$10h
$4Bh    K
$40h    @
$09h
$18h
$52h    R
$40h    @
$F1h
$18h
$51h    Q
$40h    @
$F9h
$18h
$50h    P
$40h    @
$01h
$18h
$4Fh    O
$40h    @
$09h
$08h
$40h    @
$00h
$F4h
$08h
$41h    A
$00h
$FCh
$08h
$40h    @
$40h    @
$04h
$10h
$42h    B
$00h
$F0h
$10h
$43h    C
$00h
$F8h
$10h
$43h    C
$40h    @
$00h
$10h
$42h    B
$40h    @
$08h
$18h
$44h    D
$00h
$F0h
$18h
$45h    E
$00h
$F8h
$18h
$45h    E
$40h    @
$00h
$18h
$44h    D
$40h    @
$08h
$08h
$48h    H
$00h
$F7h
$08h
$49h    I
$00h
$FFh
$08h
$4Ah    J
$00h
$07h
$10h
$4Bh    K
$00h
$EFh
$10h
$4Ch    L
$00h
$F7h
$10h
$4Dh    M
$00h
$FFh
$10h
$4Eh    N
$00h
$07h
$18h
$4Fh    O
$00h
$EFh
$18h
$50h    P
$00h
$F7h
$18h
$51h    Q
$00h
$FFh
$18h
$52h    R
$00h
$07h
$08h
$56h    V
$00h
$F8h
$08h
$57h    W
$00h
$00h
$08h
$58h    X
$00h
$08h
$10h
$59h    Y
$00h
$ECh
$10h
$5Ah    Z
$00h
$F4h
$10h
$5Bh    [
$00h
$FCh
$10h
$5Ch    \
$00h
$04h
$10h
$5Dh    ]
$00h
$0Ch
$18h
$5Eh    ^
$00h
$ECh
$18h
$5Fh    _
$00h
$F4h
$18h
$60h    `
$00h
$FCh
$18h
$61h    a
$00h
$04h
$08h
$58h    X
$40h    @
$F0h
$08h
$57h    W
$40h    @
$F8h
$08h
$56h    V
$40h    @
$00h
$10h
$5Dh    ]
$40h    @
$ECh
$10h
$5Ch    \
$40h    @
$F4h
$10h
$5Bh    [
$40h    @
$FCh
$10h
$5Ah    Z
$40h    @
$04h
$10h
$59h    Y
$40h    @
$0Ch
$18h
$64h    d
$40h    @
$F4h
$18h
$63h    c
$40h    @
$FCh
$18h
$5Fh    _
$40h    @
$04h
$18h
$62h    b
$40h    @
$0Ch
$08h
$4Ah    J
$40h    @
$F1h
$08h
$49h    I
$40h    @
$F9h
$08h
$48h    H
$40h    @
$01h
$10h
$4Eh    N
$40h    @
$F1h
$10h
$4Dh    M
$40h    @
$F9h
$10h
$4Ch    L
$40h    @
$01h
$10h
$4Bh    K
$40h    @
$09h
$18h
$54h    T
$40h    @
$F1h
$18h
$51h    Q
$40h    @
$F9h
$18h
$50h    P
$40h    @
$01h
$18h
$53h    S
$40h    @
$09h
$08h
$40h    @
$00h
$F4h
$08h
$41h    A
$00h
$FCh
$08h
$40h    @
$40h    @
$04h
$10h
$42h    B
$00h
$F0h
$10h
$43h    C
$00h
$F8h
$10h
$43h    C
$40h    @
$00h
$10h
$42h    B
$40h    @
$08h
$18h
$44h    D
$00h
$F0h
$18h
$45h    E
$00h
$F8h
$18h
$45h    E
$40h    @
$00h
$18h
$44h    D
$40h    @
$08h
$08h
$48h    H
$00h
$F7h
$08h
$49h    I
$00h
$FFh
$08h
$4Ah    J
$00h
$07h
$10h
$4Bh    K
$00h
$EFh
$10h
$4Ch    L
$00h
$F7h
$10h
$4Dh    M
$00h
$FFh
$10h
$4Eh    N
$00h
$07h
$18h
$53h    S
$00h
$EFh
$18h
$50h    P
$00h
$F7h
$18h
$51h    Q
$00h
$FFh
$18h
$54h    T
$00h
$07h
$08h
$56h    V
$00h
$F8h
$08h
$57h    W
$00h
$00h
$08h
$58h    X
$00h
$08h
$10h
$59h    Y
$00h
$ECh
$10h
$5Ah    Z
$00h
$F4h
$10h
$5Bh    [
$00h
$FCh
$10h
$5Ch    \
$00h
$04h
$10h
$5Dh    ]
$00h
$0Ch
$18h
$62h    b
$00h
$ECh
$18h
$5Fh    _
$00h
$F4h
$18h
$63h    c
$00h
$FCh
$18h
$64h    d
$00h
$04h
$10h
$78h    x
$40h    @
$F0h
$10h
$77h    w
$40h    @
$F8h
$10h
$76h    v
$40h    @
$00h
$10h
$75h    u
$40h    @
$08h
$18h
$7Ch    |
$40h    @
$F0h
$18h
$7Bh    {
$40h    @
$F8h
$18h
$7Ah    z
$40h    @
$00h
$18h
$79h    y
$40h    @
$08h
$10h
$71h    q
$40h    @
$F2h
$10h
$70h    p
$40h    @
$FAh
$10h
$6Fh    o
$40h    @
$02h
$18h
$74h    t
$40h    @
$F6h
$18h
$73h    s
$40h    @
$FEh
$18h
$72h    r
$40h    @
$06h
$10h
$6Bh    k
$40h    @
$F4h
$10h
$6Ah    j
$40h    @
$FCh
$10h
$69h    i
$40h    @
$04h
$18h
$6Eh    n
$40h    @
$F4h
$18h
$6Dh    m
$40h    @
$FCh
$18h
$6Ch    l
$40h    @
$04h
$10h
$65h    e
$00h
$F4h
$10h
$66h    f
$00h
$FCh
$10h
$65h    e
$40h    @
$04h
$18h
$67h    g
$00h
$F4h
$18h
$68h    h
$00h
$FCh
$18h
$67h    g
$40h    @
$04h
$10h
$69h    i
$00h
$F4h
$10h
$6Ah    j
$00h
$FCh
$10h
$6Bh    k
$00h
$04h
$18h
$6Ch    l
$00h
$F4h
$18h
$6Dh    m
$00h
$FCh
$18h
$6Eh    n
$00h
$04h
$10h
$6Fh    o
$00h
$F6h
$10h
$70h    p
$00h
$FDh
$10h
$71h    q
$00h
$06h
$18h
$72h    r
$00h
$F2h
$18h
$73h    s
$00h
$FAh
$18h
$74h    t
$00h
$02h
$10h
$75h    u
$00h
$F0h
$10h
$76h    v
$00h
$F8h
$10h
$77h    w
$00h
$00h
$10h
$78h    x
$00h
$08h
$18h
$79h    y
$00h
$F0h
$18h
$7Ah    z
$00h
$F8h
$18h
$7Bh    {
$00h
$00h
$18h
$7Ch    |
$00h
$08h
$10h
$8Ch
$40h    @
$FCh
$10h
$8Bh
$40h    @
$04h
$18h
$90h
$40h    @
$F4h
$18h
$8Fh
$40h    @
$FCh
$18h
$8Eh
$40h    @
$04h
$10h
$87h
$40h    @
$F4h
$10h
$86h
$40h    @
$FCh
$18h
$8Ah
$40h    @
$F4h
$18h
$89h
$40h    @
$FCh
$18h
$88h
$40h    @
$04h
$10h
$81h
$40h    @
$F8h
$10h
$80h
$40h    @
$00h
$18h
$84h
$40h    @
$F4h
$18h
$83h
$40h    @
$FCh
$18h
$82h
$40h    @
$04h
$10h
$7Dh    }
$00h
$F8h
$10h
$7Dh    }
$40h    @
$00h
$18h
$7Eh    ~
$00h
$F4h
$18h
$7Fh    
$00h
$FCh
$18h
$7Eh    ~
$40h    @
$04h
$10h
$80h
$00h
$F8h
$10h
$81h
$00h
$00h
$18h
$82h
$00h
$F4h
$18h
$83h
$00h
$FCh
$18h
$84h
$00h
$04h
$10h
$86h
$00h
$FCh
$10h
$87h
$00h
$04h
$18h
$88h
$00h
$F4h
$18h
$89h
$00h
$FCh
$18h
$8Ah
$00h
$04h
$10h
$8Bh
$00h
$F4h
$10h
$8Ch
$00h
$FCh
$18h
$8Eh
$00h
$F4h
$18h
$8Fh
$00h
$FCh
$18h
$90h
$00h
$04h
$18h
$99h
$40h    @
$F4h
$18h
$98h
$40h    @
$FCh
$18h
$97h
$40h    @
$04h
$18h
$96h
$40h    @
$F7h
$18h
$95h
$40h    @
$FFh
$18h
$94h
$40h    @
$F8h
$18h
$93h
$40h    @
$00h
$18h
$92h
$00h
$F8h
$18h
$92h
$40h    @
$00h
$18h
$93h
$00h
$F8h
$18h
$94h
$00h
$00h
$18h
$95h
$00h
$F9h
$18h
$96h
$00h
$01h
$18h
$97h
$00h
$F4h
$18h
$98h
$00h
$FCh
$18h
$99h
$00h
$04h
$18h
$A0h
$40h    @
$F8h
$18h
$9Fh
$40h    @
$00h
$18h
$9Eh
$40h    @
$F8h
$18h
$9Dh
$40h    @
$00h
$18h
$9Ch
$40h    @
$F8h
$18h
$9Bh
$40h    @
$00h
$18h
$9Ah
$00h
$F8h
$18h
$9Ah
$40h    @
$00h
$18h
$9Bh
$00h
$F8h
$18h
$9Ch
$00h
$00h
$18h
$9Dh
$00h
$F8h
$18h
$9Eh
$00h
$00h
$18h
$9Fh
$00h
$F8h
$18h
$A0h
$00h
$00h
$18h
$A4h
$40h    @
$FCh
$18h
$A3h
$40h    @
$FCh
$18h
$A2h
$40h    @
$FCh
$18h
$A1h
$00h
$FCh
$18h
$A2h
$00h
$FCh
$18h
$A3h
$00h
$FCh
$18h
$A4h
$00h
$FCh
$18h
$A5h
$00h
$FCh
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
$54h    T
$54h    T
$54h    T
$54h    T
$54h    T
$54h    T
$54h    T
$54h    T
$55h    U
$55h    U
$55h    U
$55h    U
$55h    U
$55h    U
$55h    U
$55h    U
$55h    U
$55h    U
$55h    U
$56h    V
$56h    V
$56h    V
$56h    V
$56h    V
$56h    V
$56h    V
$56h    V
$56h    V
$56h    V
$56h    V
$57h    W
$57h    W
$57h    W
$57h    W
$57h    W
$57h    W
$57h    W
$57h    W
$57h    W
$57h    W
$58h    X
$58h    X
$58h    X
$58h    X
$58h    X
$58h    X
$59h    Y
$59h    Y
$59h    Y
$59h    Y
$59h    Y
$5Ah    Z
$5Ah    Z
$5Ah    Z
$5Ah    Z
$5Ah    Z
$5Bh    [
$5Bh    [
$5Bh    [
$5Ch    \
$5Ch    \
$5Ch    \
$5Ch    \
$5Dh    ]
$5Dh    ]
$5Dh    ]
$5Eh    ^
$5Eh    ^
$5Eh    ^
$5Fh    _
$5Fh    _
$5Fh    _
$5Fh    _
$60h    `
$60h    `
$60h    `
$61h    a
$61h    a
$61h    a
$62h    b
$62h    b
$62h    b
$63h    c
$63h    c
$63h    c
$64h    d
$64h    d
$65h    e
$65h    e
$65h    e
$66h    f
$66h    f
$66h    f
$67h    g
$67h    g
$67h    g
$68h    h
$68h    h
$69h    i
$69h    i
$69h    i
$6Ah    j
$6Ah    j
$6Ah    j
$6Bh    k
$6Bh    k
$6Ch    l
$6Ch    l
$6Ch    l
$6Dh    m
$6Dh    m
$6Eh    n
$6Eh    n
$70h    p
$70h    p
$70h    p
$71h    q
$71h    q
$72h    r
$72h    r
$73h    s
$73h    s
$73h    s
$74h    t
$74h    t
$75h    u
$75h    u
$76h    v
$76h    v
$77h    w
$77h    w
$77h    w
$78h    x
$78h    x
$79h    y
$79h    y
$7Ah    z
$7Ah    z
$7Bh    {
$7Bh    {
$7Ch    |
$7Ch    |
$7Dh    }
$7Dh    }
$7Eh    ~
$7Fh    
$7Fh    
$80h
$80h
$81h
$81h
$82h
$82h
$83h
$84h
$84h
$85h
$85h
$86h
$86h
$87h
$88h
$88h
$89h
$89h
$8Ah
$8Bh
$8Bh
$8Ch
$8Dh
$8Dh
$8Eh
$8Fh
$90h
$90h
$91h
$92h
$93h
$94h
$94h
$95h
$96h
$97h
$98h
$99h
$9Ah
$9Bh
$9Ch
$9Dh
$9Eh
$A0h
$A1h
$A2h
$A3h
$A4h
$A6h
$A7h
$A8h
$A9h
$ABh
$ACh
$ADh
$AFh
$B0h
$B1h
$B3h
$B4h
$B6h
$B7h
$B9h
$BBh
$BCh
$BEh
$C0h
$C1h
$C3h
$C5h
$C7h
$C8h
$CAh
$CCh
$CEh
$D0h
$D2h
$D4h
$D6h
$D8h
$DAh
$DCh
$DEh
$E0h
$E2h
$E4h
$E6h
$E8h
$EAh
$ECh
$EEh
$F0h
DAT_e538:                     ;XREF[1,0]:   e30d
undefined1  F0h
$F0h
$F0h
$F0h
$F0h
$F0h
$F0h
$F0h
$F0h
DAT_e541:                     ;XREF[1,0]:   e30d
undefined1  F0h
$F0h
$F0h
$F0h
$F0h
$F0h
$F0h
$F0h
DAT_e549:                     ;XREF[2,0]:   e306,f3f4
$01h
$01h
$01h
$01h
$01h
$02h
$02h
$02h
$02h
$03h
$03h
$04h
$04h
$04h
$04h
$05h
$05h
$05h
$06h
$06h
$06h
$07h
$07h
$07h
$08h
$08h
$08h
$08h
$08h
DAT_e566:                     ;XREF[1,0]:   e306
undefined1  08h
$00h
DAT_e568:                     ;XREF[1,0]:   e306
undefined1  00h
DAT_e569:                     ;XREF[2,0]:   d744,e336
$0Ah
$0Ch
$0Eh
$10h
$12h
$14h
$16h
$18h
$1Ah
$1Ch
$1Eh
$20h
$22h    "
$24h    $
$26h    &
$28h    (
$29h    )
$2Bh    +
$2Ch    ,
$2Eh    .
$2Fh    /
$31h    1
$32h    2
$34h    4
$35h    5
$37h    7
$38h    8
$3Ah    :
$3Bh    ;
$3Dh    =
$3Eh    >
$40h    @
$41h    A
$43h    C
$44h    D
$46h    F
$47h    G
$49h    I
$4Ah    J
$4Ch    L
$4Dh    M
$4Fh    O
$50h    P
$52h    R
$53h    S
$55h    U
$56h    V
$58h    X
$59h    Y
$5Bh    [
$5Ch    \
$5Eh    ^
$5Fh    _
$61h    a
$62h    b
$64h    d
$65h    e
$67h    g
$68h    h
$6Ah    j
$6Bh    k
$6Dh    m
$6Eh    n
$70h    p
$71h    q
$73h    s
$74h    t
$76h    v
$77h    w
$79h    y
$7Ah    z
$7Ch    |
$7Dh    }
$7Fh    
$80h
$82h
$83h
$85h
$86h
$88h
$89h
$8Bh
$8Ch
$8Eh
$8Fh
$91h
$92h
$94h
$95h
$97h
$98h
$9Ah
$9Bh
$9Dh
$9Eh
$A0h
$A1h
$A3h
$A4h
$A6h
$A7h
$A9h
$AAh
$ACh
$ADh
$AFh
$B0h
$B2h
$B3h
$B5h
$B6h
$B8h
$B9h
$BBh
$BCh
$BEh
$BFh
$C1h
$C2h
$C4h
$C5h
$C7h
$C8h
$CAh
$CBh
$CDh
$CEh
$D0h
$D1h
$D3h
$D4h
$D6h
$D7h
$D9h
$DAh
$DCh
$DDh
$DFh
$E0h
$E2h
$E3h
$E5h
$E6h
$E8h
$E9h
$EBh
$ECh
$EEh
$EFh
$F1h
$F2h
$F4h
$F5h
$F7h
$F8h
$FAh
$FBh
$FDh
$FEh
$FFh
$FFh
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
undefined1  0Ah
$13h
$FEh
$02h
$A9h
$11h
$09h
$2Fh    /
$2Dh    -
$2Fh    /
$2Dh    -
$2Fh    /
$2Dh    -
$2Fh    /
$2Dh    -
$2Fh    /
$01h
$11h
$05h
$12h
$01h
$2Fh    /
$2Dh    -
$2Fh    /
$2Dh    -
$2Fh    /
$2Dh    -
$2Fh    /
$2Dh    -
$2Dh    -
$2Fh    /
$2Dh    -
$2Fh    /
$2Dh    -
$2Fh    /
$2Dh    -
$2Fh    /
$02h
$12h
$FEh
$2Dh    -
$11h
$01h
$11h
$02h
$2Fh    /
$2Dh    -
$2Fh    /
$2Dh    -
$2Fh    /
$2Dh    -
$2Fh    /
$2Fh    /
$2Dh    -
$2Fh    /
$2Dh    -
$2Fh    /
$2Dh    -
$2Fh    /
$03h
$11h
$06h
$11h
$03h
$2Fh    /
$2Dh    -
$2Fh    /
$2Dh    -
$2Fh    /
$2Dh    -
$2Dh    -
$2Fh    /
$2Dh    -
$2Fh    /
$2Dh    -
$2Fh    /
$04h
$11h
$06h
$11h
$04h
$2Fh    /
$2Dh    -
$2Fh    /
$2Dh    -
$2Fh    /
$0Fh
$0Fh
$0Fh
$0Fh
$04h
$13h
$FBh
$2Dh    -
$FAh
$12h
$FBh
$2Dh    -
$FAh
$12h
$FBh
$2Dh    -
$13h
$FEh
$08h
$11h
$2Dh    -
$11h
$2Dh    -
$11h
$2Dh    -
$11h
$2Dh    -
$11h
$2Dh    -
$11h
$2Dh    -
$11h
$0Bh
$13h
$FDh
$2Dh    -
$11h
$2Dh    -
$11h
$2Dh    -
$11h
$03h
$12h
$FEh
$09h
$11h
$FFh
$2Eh    .
$BAh
$2Dh    -
$14h
$2Dh    -
$11h
$2Dh    -
$11h
$2Dh    -
$11h
$0Bh
$11h
$2Dh    -
$FFh
$2Eh    .
$2Dh    -
$11h
$2Dh    -
$11h
$2Dh    -
$FCh
$12h
$FDh
$2Dh    -
$13h
$FEh
$03h
$00h
DAT_e90e:                     ;XREF[1,0]:   e6a3
undefined1  00h
$00h
$00h
$00h
$55h    U
$A5h
$FFh
$00h
DAT_e916:                     ;XREF[1,0]:   e6cf
undefined1  0Fh
$0Fh
$16h
$30h    0
$0Fh
$0Fh
$27h    '
$27h    '
$0Fh
$0Fh
$21h    !
$21h    !
$0Fh
$0Fh
$30h    0
$30h    0
$0Fh
$3Ah    :
$00h
$00h
$0Fh
$00h
$00h
$00h
$0Fh
$00h
$00h
$00h
$0Fh
$00h
$00h
$00h
$18h
$0Dh
$17h
$0Eh
$1Dh
$17h
$12h
$17h
$2Dh    -
$04h
$08h
$09h
DAT_e942:                     ;XREF[1,0]:   e6ee
undefined1  01h
DAT_e943:                     ;XREF[1,0]:   e6ee
undefined1  24h
$2Dh    -
$15h
$0Eh
$1Fh
$0Eh
$15h
$2Dh    -
$15h
$15h
$12h
DAT_e94e:                     ;XREF[1,0]:   e817
undefined1  14h
DAT_e94f:                     ;XREF[1,0]:   e817
undefined1  1Ch
$26h    &
$19h
DAT_e952:                     ;XREF[1,0]:   e700
undefined1  18h
DAT_e953:                     ;XREF[1,0]:   e700
undefined1  1Dh
DAT_e954:                     ;XREF[1,0]:   e866
$21h    !
$25h    %
$2Ah    *
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
$9Eh
$9Dh
DAT_eb5a:                     ;XREF[1,0]:   ea47
undefined1  9Dh
DAT_eb5b:                     ;XREF[1,0]:   ea47
undefined1  9Ch
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
$DCh
$EAh
$04h
$26h    &
$4Eh    N
$74h    t
$9Ah
$CCh
$FEh
$30h    0
DAT_ecd2:                     ;XREF[1,0]:   ec53
$ECh
$ECh
$EDh
$EDh
$EDh
$EDh
$EDh
$EDh
$EDh
$EEh
$00h
$36h    6
$0Eh
$47h    G
$00h
$4Ch    L
$0Eh
$47h    G
$80h
$00h
$00h
$16h
$00h
$00h
$00h
$12h
$12h
$0Ch
$00h
$30h    0
$F2h
$58h    X
$00h
$10h
$EEh
$0Ch
$00h
$34h    4
$10h
$2Ah    *
$00h
$12h
$28h    (
$08h
$80h
$00h
$00h
$0Eh
$00h
$00h
$00h
$46h    F
$27h    '
$09h
$14h
$11h
$00h
$17h
$12h
$0Bh
$00h
$20h
$2Ch    ,
$12h
$00h
$0Ch
$D5h
$12h
$00h
$08h
$F0h
$10h
$00h
$14h
$16h
$14h
$0Fh
$32h    2
$80h
$00h
$00h
$19h
$00h
$00h
$00h
$16h
$F0h
$0Eh
$00h
$1Ah
$10h
$0Eh
$00h
$10h
$2Ch    ,
$06h
$00h
$0Ch
$11h
$24h    $
$18h
$0Ah
$00h
$01h
$F3h
$0Dh
$00h
$14h
$F0h
$0Dh
$00h
$10h
$F0h
$1Bh
$00h
$14h
$2Eh    .
$1Bh
$80h
$00h
$00h
$10h
$00h
$00h
$00h
$38h    8
$0Eh
$50h    P
$00h
$01h
$DCh
$02h
$00h
$01h
$20h
$0Fh
$00h
$08h
$D0h
$06h
$D8h
$06h
$00h
$04h
$28h    (
$06h
$16h
$08h
$00h
$01h
$F4h
$06h
$00h
$10h
$2Eh    .
$0Dh
$80h
$00h
$00h
$24h    $
$00h
$00h
$00h
$18h
$30h    0
$08h
$10h
$20h
$16h
$12h
$00h
$01h
$DDh
$19h
$00h
$08h
$29h    )
$14h
$00h
$04h
$EDh
$05h
$00h
$18h
$E0h
$0Ch
$00h
$1Ah
$E0h
$1Bh
$00h
$3Ah    :
$14h
$09h
$80h
$00h
$00h
$10h
$00h
$00h
$00h
$12h
$12h
$0Ch
$00h
$1Ah
$EEh
$0Ch
$00h
$0Eh
$D1h
$0Fh
$00h
$0Eh
$2Fh    /
$0Fh
$00h
$19h
$2Ch    ,
$06h
$00h
$1Ah
$2Ch    ,
$06h
$00h
$2Ch    ,
$17h
$0Ah
$00h
$01h
$DCh
$09h
$00h
$08h
$24h    $
$0Ch
$00h
$01h
$F7h
$0Dh
$00h
$0Ah
$26h    &
$0Fh
$80h
$00h
$00h
$0Ah
$00h
$00h
$00h
$18h
$28h    (
$13h
$00h
$01h
$F2h
$0Eh
$00h
$08h
$27h    '
$0Fh
$00h
$01h
$D2h
$05h
$00h
$19h
$F0h
$08h
$00h
$01h
$26h    &
$0Bh
$00h
$04h
$D2h
$0Eh
$00h
$0Bh
$ECh
$20h
$00h
$0Ch
$30h    0
$04h
$00h
$01h
$D6h
$0Fh
$00h
$16h
$2Ch    ,
$06h
$80h
$00h
$00h
$14h
$00h
$00h
$00h
$10h
$0Eh
$1Ch
$00h
$06h
$E0h
$14h
$D0h
$04h
$00h
$01h
$1Ah
$14h
$26h    &
$07h
$00h
$30h    0
$2Bh    +
$16h
$00h
$01h
$E0h
$12h
$00h
$06h
$0Eh
$13h
$00h
$1Ah
$1Eh
$14h
$00h
$01h
$E0h
$20h
$00h
$04h
$2Ch    ,
$0Fh
$00h
$0Ah
$2Ch    ,
$07h
$80h
$00h
$00h
$0Ch
$00h
$00h
$00h
$28h    (
$2Ch    ,
$0Eh
$00h
$03h
$D3h
$02h
$00h
$0Ah
$30h    0
$0Fh
$00h
$0Eh
$D8h
$19h
$00h
$04h
$1Eh
$21h    !
$00h
$02h
$E0h
$11h
$00h
$04h
$10h
$10h
$00h
$11h
$30h    0
$0Ch
$00h
$02h
$E0h
$0Ch
$00h
$05h
$26h    &
$16h
$00h
$06h
$D0h
$0Ah
$00h
$01h
$2Eh    .
$03h
$80h
$00h
$00h
$0Dh
$00h
$00h
DAT_ee66:                     ;XREF[1,0]:   ebb3
$7Ah    z
$95h
$B9h
$E6h
$0Ah
$37h    7
$76h    v
$A3h
$F4h
$33h    3
DAT_ee70:                     ;XREF[1,0]:   ebb8
$EEh
$EEh
$EEh
$EEh
$EFh
$EFh
$EFh
$EFh
$EFh
$F0h
$02h
$06h
$00h
$82h
$01h
$00h
$83h
$60h    `
$01h
$83h
$20h
$00h
$83h
$20h
$00h
$83h
$80h
$04h
$83h
$20h
$00h
$83h
$20h
$00h
$00h
$10h
$03h
$02h
$06h
$00h
$82h
$01h
$00h
$0Bh
$60h    `
$02h
$0Bh
$20h
$00h
$0Bh
$20h
$00h
$83h
$50h    P
$05h
$83h
$20h
$00h
$83h
$20h
$00h
$83h
$B0h
$01h
$83h
$20h
$00h
$83h
$20h
$00h
$00h
$12h
$01h
$02h
$06h
$00h
$82h
$01h
$00h
$83h
$D0h
$01h
$83h
$20h
$00h
$83h
$20h
$00h
$83h
$10h
$03h
$83h
$20h
$00h
$83h
$20h
$00h
$03h
$20h
$01h
$03h
$20h
$00h
$03h
$20h
$00h
$83h
$20h
$02h
$83h
$30h    0
$00h
$83h
$20h
$00h
$00h
$28h    (
$03h
$02h
$06h
$00h
$82h
$01h
$00h
$83h
$D0h
$02h
$83h
$20h
$00h
$83h
$20h
$00h
$83h
$C0h
$01h
$83h
$20h
$00h
$83h
$20h
$00h
$83h
$30h    0
$04h
$83h
$20h
$00h
$83h
$20h
$00h
$00h
$C0h
$01h
$02h
$06h
$00h
$82h
$01h
$00h
$83h
$90h
$04h
$83h
$20h
$00h
$83h
$20h
$00h
$03h
$B0h
$00h
$03h
$20h
$00h
$03h
$20h
$00h
$83h
$A0h
$00h
$83h
$20h
$00h
$83h
$20h
$00h
$83h
$30h    0
$01h
$83h
$20h
$00h
$83h
$20h
$00h
$00h
$F8h
$01h
$02h
$06h
$00h
$82h
$01h
$00h
$83h
$60h    `
$00h
$83h
$20h
$00h
$83h
$20h
$00h
$83h
$20h
$01h
$83h
$20h
$00h
$83h
$20h
$00h
$03h
$A0h
$00h
$03h
$20h
$00h
$03h
$20h
$00h
$83h
$00h
$01h
$83h
$20h
$00h
$83h
$20h
$00h
$03h
$10h
$02h
$03h
$20h
$00h
$03h
$20h
$00h
$03h
$40h    @
$01h
$03h
$20h
$00h
$03h
$20h
$00h
$00h
$C8h
$03h
$02h
$06h
$00h
$82h
$01h
$00h
$03h
$D0h
$02h
$03h
$20h
$00h
$03h
$20h
$00h
$83h
$10h
$01h
$83h
$20h
$00h
$83h
$20h
$00h
$83h
$50h    P
$01h
$83h
$20h
$00h
$83h
$20h
$00h
$83h
$40h    @
$01h
$83h
$20h
$00h
$83h
$20h
$00h
$00h
$C0h
$05h
$02h
$06h
$00h
$82h
$01h
$00h
$83h
$60h    `
$00h
$83h
$20h
$00h
$83h
$20h
$00h
$83h
$80h
$01h
$83h
$20h
$00h
$83h
$20h
$00h
$03h
$E0h
$00h
$03h
$20h
$00h
$03h
$20h
$00h
$B3h
$40h    @
$01h
$B3h
$20h
$00h
$B3h
$20h
$00h
$03h
$80h
$00h
$03h
$20h
$00h
$03h
$20h
$00h
$83h
$70h    p
$02h
$83h
$20h
$00h
$83h
$20h
$00h
$03h
$60h    `
$00h
$03h
$20h
$00h
$03h
$20h
$00h
$83h
$40h    @
$01h
$83h
$20h
$00h
$83h
$20h
$00h
$00h
$38h    8
$01h
$02h
$06h
$00h
$82h
$01h
$00h
$03h
$80h
$01h
$03h
$20h
$00h
$03h
$20h
$00h
$83h
$A0h
$01h
$83h
$20h
$00h
$83h
$20h
$00h
$83h
$90h
$01h
$83h
$20h
$00h
$83h
$20h
$00h
$03h
$F0h
$00h
$03h
$20h
$00h
$03h
$20h
$00h
$83h
$80h
$04h
$83h
$20h
$00h
$83h
$20h
$00h
$83h
$E0h
$00h
$83h
$20h
$00h
$83h
$20h
$00h
$00h
$18h
$01h
$02h
$06h
$00h
$82h
$01h
$00h
$83h
$E0h
$00h
$83h
$20h
$00h
$83h
$20h
$00h
$83h
$60h    `
$01h
$83h
$20h
$00h
$83h
$20h
$00h
$03h
$10h
$01h
$03h
$20h
$00h
$03h
$20h
$00h
$83h
$70h    p
$04h
$83h
$20h
$00h
$83h
$20h
$00h
$00h
$70h    p
$04h
DAT_f060:                     ;XREF[1,0]:   eba9
$00h
$03h
$00h
$05h
$00h
$05h
$00h
$05h
$00h
$00h
DAT_f06a:                     ;XREF[1,0]:   ebae
$04h
$04h
$05h
$04h
$04h
$04h
$05h
$04h
$05h
$05h
DAT_f074:                     ;XREF[1,0]:   cd33
$05h
$08h
$05h
$00h
$05h
$00h
$05h
$00h
$05h
$05h
DAT_f07e:                     ;XREF[1,0]:   cd38
$03h
$03h
$04h
$04h
$03h
$04h
$04h
$04h
$04h
$04h
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
$ECh
$10h
$34h    4
$58h    X
$7Ch    |
$A0h
$C4h
$E8h
$0Ch
$30h    0
DAT_f0e2:                     ;XREF[1,0]:   f0a4
$F0h
$F1h
$F1h
$F1h
$F1h
$F1h
$F1h
$F1h
$F2h
$F2h
$C6h
$D9h
$C3h
$C2h
$C3h
$C3h
$C3h
$DAh
$2Dh    -
$DCh
$2Dh    -
$2Dh    -
$2Dh    -
$2Dh    -
$2Dh    -
$2Dh    -
$C5h
$DDh
$DEh
$2Dh    -
$2Dh    -
$2Dh    -
$2Dh    -
$2Dh    -
$2Dh    -
$C6h
$DFh
$C5h
$D7h
$C3h
$C3h
$C3h
$C3h
$C3h
$D8h
$2Dh    -
$CCh
$28h    (
$C3h
$DAh
$C6h
$D9h
$C3h
$DAh
$2Dh    -
$C4h
$2Dh    -
$2Dh    -
$C7h
$D2h
$2Dh    -
$2Dh    -
$C5h
$DDh
$DEh
$2Dh    -
$C6h
$D1h
$C5h
$D0h
$2Dh    -
$C6h
$DFh
$C5h
$D7h
$D8h
$2Dh    -
$2Dh    -
$C5h
$D7h
$D8h
$2Dh    -
$C6h
$D9h
$C3h
$C2h
$C3h
$C3h
$C3h
$C3h
$CDh
$DCh
$2Dh    -
$C6h
$D9h
$C3h
$CDh
$2Dh    -
$C6h
$DFh
$DEh
$C6h
$D1h
$CCh
$C3h
$CFh
$C6h
$D1h
$2Dh    -
$C5h
$CAh
$2Dh    -
$CEh
$C3h
$C3h
$D8h
$2Dh    -
$2Dh    -
$2Dh    -
$C6h
$D9h
$C3h
$DAh
$C6h
$D9h
$C3h
$CDh
$2Dh    -
$DCh
$2Dh    -
$2Dh    -
$C7h
$D2h
$2Dh    -
$2Dh    -
$C4h
$CCh
$D3h
$C2h
$C3h
$D8h
$C5h
$DDh
$C6h
$DFh
$CEh
$CFh
$2Dh    -
$2Dh    -
$2Dh    -
$2Dh    -
$CEh
$D8h
$2Dh    -
$CCh
$C3h
$C3h
$C2h
$C3h
$C3h
$C3h
$DAh
$2Dh    -
$CEh
$DAh
$2Dh    -
$CCh
$CDh
$2Dh    -
$2Dh    -
$C5h
$DDh
$2Dh    -
$C5h
$D7h
$CFh
$C4h
$2Dh    -
$2Dh    -
$C6h
$DFh
$2Dh    -
$2Dh    -
$2Dh    -
$2Dh    -
$CEh
$D8h
$D7h
$D8h
$2Dh    -
$2Dh    -
$C6h
$CBh
$C6h
$D9h
$C3h
$C2h
$C3h
$CDh
$C6h
$D1h
$C7h
$D2h
$C8h
$D4h
$DDh
$C6h
$DFh
$DCh
$C6h
$D1h
$C5h
$E1h
$DDh
$CEh
$D8h
$2Dh    -
$CEh
$D8h
$2Dh    -
$2Dh    -
$CEh
$CFh
$2Dh    -
$2Dh    -
$2Dh    -
$CCh
$28h    (
$C3h
$DAh
$2Dh    -
$CCh
$C3h
$C3h
$CDh
$DEh
$2Dh    -
$2Dh    -
$C5h
$D0h
$CEh
$C3h
$CDh
$C4h
$C5h
$DDh
$C6h
$CBh
$C5h
$D7h
$C3h
$CFh
$C4h
$2Dh    -
$CEh
$D8h
$C5h
$D7h
$C3h
$C3h
$C3h
$CFh
$CCh
$CDh
$2Dh    -
$2Dh    -
$CCh
$C3h
$C2h
$C3h
$CDh
$C4h
$DEh
$D9h
$C3h
$D3h
$CDh
$C6h
$D9h
$CFh
$DEh
$C6h
$D9h
$CDh
$C4h
$DEh
$D6h
$2Dh    -
$2Dh    -
$C5h
$CAh
$2Dh    -
$CEh
$CFh
$2Dh    -
$2Dh    -
$2Dh    -
$2Dh    -
$CCh
$28h    (
$C3h
$DAh
$C8h
$D4h
$D0h
$2Dh    -
$2Dh    -
$C4h
$DBh
$D5h
$C5h
$E2h
$DDh
$C5h
$D0h
$2Dh    -
$CEh
$CFh
$DCh
$2Dh    -
$CEh
$E0h
$D4h
$E2h
$DDh
$2Dh    -
$2Dh    -
$CEh
$C3h
$C3h
$D8h
$2Dh    -
$CEh
$CFh
$C8h
$D4h
$DDh
$CCh
$C3h
$C2h
$C3h
$C3h
$CDh
$C9h
$DDh
$CEh
$CFh
$2Dh    -
$CCh
$CDh
$CCh
$CFh
$CCh
$CFh
$C6h
$D9h
$CDh
$DEh
$C4h
$C4h
$2Dh    -
$CEh
$C3h
$D8h
$2Dh    -
$DEh
$D6h
$CEh
$CFh
$2Dh    -
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
$AEh
$AEh
$D6h
$0Eh
$D6h
$0Eh
$D6h
$0Eh
DAT_f29e:                     ;XREF[1,0]:   f25f
$F2h
$F2h
$F2h
$F3h
$F2h
$F3h
$F2h
$F3h
DAT_f2a6:                     ;XREF[1,0]:   f26a
$28h    (
$28h    (
$38h    8
$60h    `
$38h    8
$60h    `
$38h    8
$60h    `
$C0h
$A6h
$03h
$78h    x
$C0h
$A6h
$43h    C
$80h
$C8h
$A7h
$03h
$70h    p
$C8h
$A8h
$03h
$78h    x
$C8h
$A8h
$43h    C
$80h
$C8h
$A7h
$43h    C
$88h
$D0h
$A9h
$03h
$70h    p
$D0h
$AAh
$03h
$78h    x
$D0h
$AAh
$43h    C
$80h
$D0h
$A9h
$43h    C
$88h
$B8h
$ABh
$03h
$78h    x
$B8h
$ACh
$03h
$80h
$C0h
$ADh
$03h
$70h    p
$C0h
$AEh
$03h
$78h    x
$C0h
$AFh
$03h
$80h
$C0h
$B0h
$03h
$88h
$C8h
$B1h
$03h
$70h    p
$C8h
$B2h
$03h
$78h    x
$C8h
$B3h
$03h
$80h
$C8h
$B4h
$03h
$88h
$D0h
$B5h
$03h
$70h    p
$D0h
$B6h
$03h
$78h    x
$D0h
$B7h
$03h
$80h
$D0h
$B8h
$03h
$88h
$B0h
$B9h
$03h
$90h
$B8h
$BAh
$03h
$70h    p
$B8h
$BBh
$03h
$78h    x
$B8h
$BCh
$03h
$80h
$B8h
$BDh
$03h
$88h
$B8h
$BEh
$03h
$90h
$C0h
$BFh
$03h
$68h    h
$C0h
$C0h
$03h
$70h    p
$C0h
$C1h
$03h
$78h    x
$C0h
$C2h
$03h
$80h
$C0h
$C3h
$03h
$88h
$C0h
$C4h
$03h
$90h
$C8h
$C5h
$03h
$68h    h
$C8h
$C6h
$03h
$70h    p
$C8h
$C7h
$03h
$78h    x
$C8h
$C8h
$03h
$80h
$C8h
$C9h
$03h
$88h
$C8h
$CAh
$03h
$90h
$D0h
$CBh
$03h
$68h    h
$D0h
$CCh
$03h
$70h    p
$D0h
$CDh
$03h
$78h    x
$D0h
$CEh
$03h
$80h
$D0h
$CFh
$03h
$88h
$D0h
$D0h
$03h
$90h
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
$32h    2
$28h    (
$28h    (
$28h    (
$28h    (
$28h    (
$28h    (
$2Dh    -
$28h    (
$28h    (
DAT_f4e9:                     ;XREF[1,0]:   f4b3
$00h
$FFh
$FFh
$FFh
$02h
$FFh
$01h
$01h
$FFh
$FFh
DAT_f4f3:                     ;XREF[1,0]:   f4a9
$00h
$7Fh    
$DBh
$1Eh
$5Ah    Z
$6Ch    l
$A4h
$C0h
$D1h
DAT_f4fc:                     ;XREF[1,0]:   f4ae
$00h
$F6h
$F6h
$F8h
$FAh
$FAh
$FAh
$FAh
$FAh
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
$20h
$3Fh    ?
$21h    !
$7Fh    
$24h    $
$3Fh    ?
$25h    %
$7Fh    
$28h    (
$FFh
$3Fh    ?
$5Eh    ^
$99h
$DBh
$06h
$7Ch    |
$BCh
$02h
$5Eh    ^
$99h
$06h
$3Fh    ?
$02h
$5Eh    ^
$99h
$DBh
$06h
$7Ch    |
$BCh
$02h
$60h    `
$9Dh
$D9h
$16h
$7Ch    |
$BCh
$02h
$5Dh    ]
$9Bh
$0Eh
$7Ch    |
$BCh
$02h
$62h    b
$98h
$06h
$7Ch    |
$BCh
$02h
$60h    `
$9Dh
$D8h
$16h
$3Fh    ?
$02h
$5Dh    ]
$9Bh
$D8h
$0Eh
$3Fh    ?
$02h
$5Eh    ^
$9Bh
$D8h
$06h
$3Fh    ?
$02h
$60h    `
$9Dh
$DEh
$06h
$3Fh    ?
$02h
$62h    b
$A0h
$DEh
$06h
$3Fh    ?
$02h
$63h    c
$A2h
$DEh
$06h
$3Fh    ?
$02h
$64h    d
$9Ch
$DDh
$1Eh
$1Ch
$3Fh    ?
$00h
$20h
$3Dh    =
$21h    !
$7Fh    
$24h    $
$3Dh    =
$25h    %
$7Fh    
$28h    (
$FFh
$34h    4
$ECh
$F6h
$34h    4
$E5h
$F7h
$00h
$5Ch    \
$99h
$D5h
$10h
$3Fh    ?
$02h
$59h    Y
$95h
$D0h
$0Ah
$7Ch    |
$BCh
$02h
$5Ch    \
$99h
$04h
$7Ch    |
$BCh
$02h
$61h    a
$99h
$D5h
$0Ch
$61h    a
$9Ch
$04h
$3Fh    ?
$02h
$60h    `
$97h
$D4h
$0Ch
$9Ah
$04h
$3Fh    ?
$02h
$5Eh    ^
$95h
$D2h
$0Ah
$7Ch    |
$BCh
$02h
$59h    Y
$95h
$04h
$3Fh    ?
$02h
$59h    Y
$95h
$CDh
$10h
$FCh
$02h
$D2h
$06h
$7Ch    |
$BCh
$06h
$52h    R
$8Dh
$04h
$3Fh    ?
$02h
$55h    U
$92h
$D5h
$04h
$7Ch    |
$BCh
$02h
$59h    Y
$95h
$D5h
$04h
$7Ch    |
$BCh
$02h
$5Ch    \
$99h
$04h
$3Fh    ?
$02h
$5Eh    ^
$9Ah
$D7h
$10h
$3Fh    ?
$02h
$5Ah    Z
$97h
$D2h
$0Ah
$7Ch    |
$BCh
$02h
$5Eh    ^
$9Ah
$D2h
$04h
$3Fh    ?
$02h
$63h    c
$9Ah
$D7h
$0Ch
$9Eh
$04h
$3Fh    ?
$02h
$61h    a
$9Bh
$D7h
$0Ch
$9Eh
$04h
$3Fh    ?
$02h
$60h    `
$9Ch
$DCh
$0Ch
$97h
$04h
$3Fh    ?
$02h
$5Eh    ^
$8Fh
$D7h
$0Ch
$95h
$04h
$3Fh    ?
$02h
$5Ch    \
$94h
$DCh
$0Ah
$7Ch    |
$BCh
$02h
$54h    T
$90h
$DCh
$04h
$3Fh    ?
$02h
$57h    W
$94h
$D0h
$04h
$7Ch    |
$BCh
$02h
$5Ch    \
$97h
$04h
$7Ch    |
$BCh
$02h
$60h    `
$9Ch
$04h
$3Fh    ?
$02h
$65h    e
$9Dh
$D9h
$0Ah
$BCh
$02h
$9Dh
$04h
$BCh
$02h
$9Dh
$04h
$BCh
$02h
$99h
$04h
$BCh
$02h
$9Dh
$04h
$3Fh    ?
$02h
$65h    e
$A0h
$D9h
$0Ch
$9Dh
$04h
$BCh
$02h
$63h    c
$9Bh
$0Ch
$9Dh
$04h
$3Fh    ?
$02h
$61h    a
$9Eh
$DEh
$0Ch
$99h
$04h
$3Fh    ?
$02h
$60h    `
$9Dh
$D9h
$0Ch
$97h
$04h
$3Fh    ?
$02h
$5Eh    ^
$95h
$DEh
$0Ah
$7Ch    |
$BCh
$02h
$55h    U
$92h
$04h
$3Fh    ?
$02h
$59h    Y
$95h
$DEh
$04h
$7Ch    |
$BCh
$02h
$5Eh    ^
$99h
$04h
$7Ch    |
$BCh
$02h
$61h    a
$9Eh
$04h
$3Fh    ?
$02h
$35h    5
$63h    c
$8Eh
$D7h
$0Ch
$9Eh
$04h
$3Fh    ?
$02h
$63h    c
$8Eh
$D7h
$0Ah
$7Ch    |
$BCh
$02h
$61h    a
$97h
$04h
$3Fh    ?
$02h
$60h    `
$9Ch
$DCh
$0Ch
$60h    `
$97h
$DCh
$04h
$3Fh    ?
$02h
$5Eh    ^
$9Ah
$D0h
$0Ah
$7Ch    |
$BCh
$02h
$60h    `
$9Ah
$04h
$3Fh    ?
$02h
$61h    a
$99h
$D5h
$10h
$FCh
$02h
$D0h
$10h
$FCh
$02h
$D5h
$12h
$3Fh    ?
$00h
$35h    5
$20h
$3Eh    >
$21h    !
$7Fh    
$24h    $
$7Dh    }
$25h    %
$7Fh    
$28h    (
$FFh
$3Fh    ?
$34h    4
$57h    W
$F8h
$34h    4
$8Ah
$F8h
$34h    4
$C1h
$F8h
$34h    4
$57h    W
$F8h
$34h    4
$8Ah
$F8h
$34h    4
$EAh
$F8h
$34h    4
$17h
$F9h
$34h    4
$64h    d
$F9h
$34h    4
$17h
$F9h
$34h    4
$B1h
$F9h
$34h    4
$57h    W
$F8h
$34h    4
$8Ah
$F8h
$34h    4
$C1h
$F8h
$34h    4
$57h    W
$F8h
$34h    4
$0Ah
$FAh
$00h
$63h    c
$A0h
$D0h
$0Fh
$3Fh    ?
$02h
$60h    `
$97h
$DCh
$0Ah
$7Ch    |
$BCh
$03h
$61h    a
$97h
$02h
$3Fh    ?
$02h
$60h    `
$98h
$DBh
$0Ah
$BCh
$03h
$94h
$02h
$3Fh    ?
$02h
$5Eh    ^
$96h
$D4h
$0Ah
$BCh
$03h
$98h
$02h
$3Fh    ?
$02h
$5Ch    \
$99h
$D9h
$0Fh
$3Fh    ?
$02h
$5Bh    [
$9Bh
$DBh
$0Fh
$3Fh    ?
$02h
$35h    5
$59h    Y
$9Ch
$DCh
$0Ah
$7Ch    |
$BCh
$03h
$5Bh    [
$9Eh
$02h
$3Fh    ?
$02h
$5Ch    \
$A0h
$D9h
$0Fh
$3Fh    ?
$02h
$5Eh    ^
$9Eh
$DEh
$0Fh
$3Fh    ?
$02h
$60h    `
$9Dh
$D9h
$0Ah
$BCh
$03h
$99h
$02h
$3Fh    ?
$02h
$61h    a
$95h
$DEh
$0Ah
$BCh
$03h
$99h
$02h
$3Fh    ?
$02h
$59h    Y
$9Eh
$D2h
$0Ah
$BCh
$03h
$A1h
$02h
$3Fh    ?
$02h
$35h    5
$60h    `
$A0h
$D7h
$0Fh
$BCh
$FCh
$02h
$9Eh
$D6h
$0Ah
$BCh
$03h
$9Ch
$02h
$3Fh    ?
$02h
$5Eh    ^
$9Bh
$D7h
$0Ah
$BCh
$FCh
$03h
$9Ch
$D2h
$02h
$BCh
$FCh
$02h
$9Eh
$D7h
$0Ah
$BCh
$FCh
$03h
$97h
$DBh
$02h
$BCh
$02h
$35h    5
$60h    `
$A0h
$D7h
$0Ah
$BCh
$03h
$97h
$02h
$3Fh    ?
$02h
$5Eh    ^
$99h
$D7h
$0Ah
$BCh
$03h
$9Bh
$02h
$3Fh    ?
$02h
$5Ch    \
$9Ch
$D0h
$0Ah
$7Ch    |
$BCh
$03h
$5Ch    \
$9Ch
$02h
$3Fh    ?
$02h
$5Bh    [
$9Bh
$DCh
$0Ah
$7Ch    |
$BCh
$03h
$5Ch    \
$9Ch
$02h
$3Fh    ?
$02h
$35h    5
$5Eh    ^
$9Ah
$DAh
$0Ah
$BCh
$03h
$99h
$02h
$7Ch    |
$BCh
$02h
$5Eh    ^
$9Ah
$DAh
$0Ah
$BCh
$03h
$9Eh
$02h
$3Fh    ?
$02h
$60h    `
$9Dh
$D9h
$0Fh
$3Fh    ?
$02h
$59h    Y
$94h
$D9h
$0Ah
$7Ch    |
$BCh
$03h
$63h    c
$9Dh
$02h
$3Fh    ?
$02h
$61h    a
$9Eh
$DEh
$0Ah
$BCh
$03h
$99h
$02h
$3Fh    ?
$02h
$60h    `
$9Dh
$D9h
$0Ah
$BCh
$03h
$97h
$02h
$3Fh    ?
$02h
$5Eh    ^
$95h
$DEh
$0Ah
$BCh
$03h
$97h
$02h
$BCh
$FCh
$02h
$5Eh    ^
$99h
$D2h
$0Fh
$3Fh    ?
$02h
$35h    5
$60h    `
$9Bh
$D4h
$0Fh
$3Fh    ?
$02h
$58h    X
$94h
$D6h
$0Ah
$7Ch    |
$BCh
$03h
$59h    Y
$96h
$FCh
$02h
$7Ch    |
$BCh
$02h
$5Bh    [
$98h
$D8h
$0Ah
$BCh
$03h
$99h
$02h
$3Fh    ?
$02h
$5Eh    ^
$9Bh
$D4h
$0Ah
$BCh
$03h
$98h
$02h
$3Fh    ?
$02h
$5Ch    \
$99h
$D9h
$0Ah
$7Ch    |
$BCh
$03h
$5Bh    [
$9Bh
$02h
$3Fh    ?
$02h
$5Ch    \
$9Ch
$D4h
$0Ah
$7Ch    |
$BCh
$03h
$5Eh    ^
$9Eh
$02h
$3Fh    ?
$02h
$60h    `
$A0h
$D9h
$0Fh
$3Fh    ?
$02h
$59h    Y
$94h
$D0h
$0Fh
$3Fh    ?
$02h
$35h    5
$5Eh    ^
$96h
$DEh
$0Ah
$7Ch    |
$BCh
$03h
$9Dh
$94h
$02h
$3Fh    ?
$02h
$5Eh    ^
$96h
$D9h
$0Ah
$7Ch    |
$BCh
$03h
$60h    `
$97h
$02h
$3Fh    ?
$02h
$62h    b
$99h
$DEh
$0Ah
$BCh
$03h
$9Bh
$02h
$3Fh    ?
$02h
$5Eh    ^
$9Ch
$D2h
$0Fh
$3Fh    ?
$02h
$63h    c
$9Bh
$D7h
$0Ah
$7Ch    |
$BCh
$03h
$5Bh    [
$97h
$02h
$3Fh    ?
$02h
$5Ch    \
$99h
$DEh
$0Ah
$7Ch    |
$BCh
$03h
$5Bh    [
$9Ah
$02h
$3Fh    ?
$02h
$5Eh    ^
$9Bh
$E3h
$0Ah
$3Fh    ?
$03h
$57h    W
$97h
$D7h
$02h
$3Fh    ?
$02h
$59h    Y
$99h
$D9h
$0Ah
$3Fh    ?
$03h
$5Bh    [
$9Bh
$DBh
$02h
$3Fh    ?
$02h
$35h    5
$59h    Y
$9Ch
$DCh
$0Ah
$7Ch    |
$BCh
$03h
$5Bh    [
$9Eh
$02h
$3Fh    ?
$02h
$5Dh    ]
$A0h
$D9h
$0Ah
$BCh
$03h
$A3h
$02h
$3Fh    ?
$02h
$5Eh    ^
$A1h
$D2h
$0Ah
$BCh
$03h
$A0h
$02h
$3Fh    ?
$02h
$61h    a
$9Eh
$DEh
$0Ah
$BCh
$03h
$9Ch
$02h
$3Fh    ?
$02h
$5Bh    [
$9Eh
$D7h
$0Ah
$7Ch    |
$BCh
$03h
$57h    W
$9Bh
$02h
$3Fh    ?
$02h
$59h    Y
$9Ch
$D7h
$0Ah
$7Ch    |
$BCh
$03h
$5Bh    [
$9Eh
$02h
$3Fh    ?
$02h
$5Ch    \
$A0h
$DCh
$0Fh
$FCh
$02h
$D7h
$0Fh
$FCh
$02h
$D0h
$11h
$3Fh    ?
$35h    5
$24h    $
$9Dh
$25h    %
$7Fh    
$AAh
$01h
$ACh
$01h
$A9h
$01h
$ACh
$01h
$A9h
$01h
$ABh
$27h    '
$28h    (
$00h
$20h
$B0h
$24h    $
$B0h
$28h    (
$00h
$2Fh    /
$08h
$2Ch    ,
$3Ch    <
$2Eh    .
$0Fh
$05h
$2Ch    ,
$30h    0
$01h
$2Ch    ,
$3Fh    ?
$08h
$2Ch    ,
$3Eh    >
$08h
$2Ch    ,
$3Dh    =
$08h
$2Ch    ,
$3Ch    <
$08h
$2Ch    ,
$3Bh    ;
$08h
$2Ch    ,
$3Ah    :
$08h
$2Ch    ,
$39h    9
$08h
$2Ch    ,
$38h    8
$08h
$2Ch    ,
$37h    7
$08h
$2Ch    ,
$36h    6
$08h
$2Ch    ,
$35h    5
$08h
$2Ch    ,
$34h    4
$08h
$2Ch    ,
$30h    0
$08h
$00h
$24h    $
$3Fh    ?
$25h    %
$7Fh    
$36h    6
$03h
$36h    6
$08h
$9Eh
$01h
$3Ah    :
$04h
$01h
$37h    7
$BCh
$1Eh
$12h
$37h    7
$36h    6
$20h
$AAh
$01h
$3Ah    :
$01h
$01h
$37h    7
$BCh
$00h
$24h    $
$3Fh    ?
$25h    %
$7Fh    
$9Eh
$01h
$BCh
$9Dh
$01h
$BCh
$9Fh
$01h
$BCh
$A5h
$01h
$BCh
$00h
$3Fh    ?
$2Ch    ,
$30h    0
$20h
$3Fh    ?
$70h    p
$05h
$6Bh    k
$05h
$70h    p
$05h
$6Bh    k
$05h
$70h    p
$05h
$6Bh    k
$05h
$70h    p
$05h
$6Bh    k
$0Ah
$3Fh    ?
$00h
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
$7Eh    ~
$63h    c
$48h    H
$2Dh    -
$12h
$F8h
$DFh
$C6h
$ADh
$94h
$7Ch    |
$64h    d
$4Dh    M
$36h    6
$1Fh
$08h
$F2h
$DCh
$C7h
$B2h
$9Dh
$88h
$74h    t
$60h    `
$4Ch    L
$38h    8
$25h    %
$12h
$00h
$EDh
$DBh
$C9h
$B8h
$A6h
$95h
$85h
$74h    t
$64h    d
$53h    S
$44h    D
$34h    4
$24h    $
$15h
$06h
$F7h
$E9h
$DAh
$CCh
$BEh
$B1h
$A3h
$96h
$88h
$7Bh    {
$6Fh    o
$62h    b
$56h    V
$49h    I
$3Dh    =
$31h    1
$26h    &
$1Ah
$0Fh
$03h
$F8h
$EDh
$E3h
$D8h
$CEh
$C3h
$B9h
$AFh
$A5h
$9Bh
$92h
$88h
$7Fh    
$76h    v
$6Dh    m
$64h    d
$5Bh    [
$52h    R
$4Ah    J
$42h    B
$39h    9
$31h    1
$29h    )
$21h    !
$19h
$11h
$0Ah
$02h
$FBh
$F4h
$ECh
$E5h
$DEh
$D8h
$D1h
$CAh
$C3h
$BDh
$B7h
$B0h
$AAh
$A4h
$9Eh
$98h
$92h
$8Ch
$87h
$81h
$7Bh    {
$76h    v
$71h    q
$6Bh    k
$66h    f
$61h    a
$5Ch    \
$57h    W
$52h    R
$4Dh    M
$48h    H
$43h    C
$3Fh    ?
$3Ah    :
$36h    6
$31h    1
$2Dh    -
$28h    (
$24h    $
$20h
$1Ch
$18h
$14h
$10h
$0Ch
$08h
$04h
$00h
$FDh
$F9h
$F5h
$F2h
$EEh
$EBh
$E8h
$E4h
$E1h
$DEh
$DBh
$D7h
$D4h
$D1h
$CEh
$CBh
$C8h
$C5h
$C3h
$C0h
$BDh
$BAh
$B8h
$B5h
$B2h
$B0h
$ADh
$ABh
$A8h
$A6h
DAT_fcd8:                     ;XREF[2,0]:   fb11,fb25
undefined1  A3h
DAT_fcd9:                     ;XREF[1,0]:   fb15
undefined1  A1h
$9Fh
$9Ch
$9Ah
$98h
$96h
$93h
$91h
$8Fh
DAT_fce2:                     ;XREF[1,0]:   fb11
undefined1  8Dh
DAT_fce3:                     ;XREF[1,0]:   fb15
undefined1  8Bh
$89h
$87h
$85h
$83h
$81h
$7Fh    
$7Eh    ~
$7Ch    |
DAT_fcec:                     ;XREF[2,0]:   fb3e,fb52
undefined1  7Ah
DAT_fced:                     ;XREF[1,0]:   fb42
undefined1  78h
$76h    v
$75h    u
$73h    s
$71h    q
$70h    p
$6Eh    n
$6Dh    m
$6Bh    k
$69h    i
$68h    h
$66h    f
$65h    e
$63h    c
$62h    b
$61h    a
$5Fh    _
$FFh
$8Ch
$5Ch    \
$40h    @
$2Ch    ,
$1Dh
$10h
DAT_fd05:                     ;XREF[1,0]:   c05b
undefined1  05h
DAT_fd06:                     ;XREF[1,0]:   fbaf
$B1h
$B1h
$B2h
$B2h
$B3h
$B3h
$B4h
$B4h
$B5h
$B5h
$B6h
$B6h
$B7h
$B7h
$B8h
$B8h
$B9h
$B9h
$BAh
$BAh
$BBh
$BBh
$BCh
$BCh
$BDh
$BDh
$BEh
$BEh
$BFh
$BFh
$BFh
$BFh
$BFh
$BFh
$BFh
$BFh
$BFh
$BFh
$BFh
$BFh
$BFh
$BFh
$BFh
$BFh
$BFh
$BFh
$BFh
$BFh
$BFh
$BFh
$BFh
$BFh
$BFh
$BFh
$BFh
$BFh
$BFh
$BFh
$BFh
$BFh
$BFh
$BFh
$BFh
$BFh
$BFh
$BFh
$BFh
$BFh
$BCh
$B8h
$B4h
$B0h
DAT_fd4e:                     ;XREF[1,0]:   f55c
$06h
DAT_fd4f:                     ;XREF[1,0]:   f553
$AEh
$06h
$4Eh    N
$05h
$F3h
$05h
$9Eh
$05h
$4Dh    M
$05h
$01h
$04h
$B9h
$04h
$75h    u
$04h
$35h    5
$03h
$F8h
$03h
$BFh
$03h
$89h
$03h
$57h    W
$03h
$27h    '
$02h
$F9h
$02h
$CFh
$02h
$A6h
$02h
$80h
$02h
$5Ch    \
$02h
$3Ah    :
$02h
$1Ah
$01h
$FCh
$01h
$DFh
$01h
$C4h
$01h
$ABh
$01h
$93h
$01h
$7Ch    |
$01h
$67h    g
$01h
$52h    R
$01h
$3Fh    ?
$01h
$2Dh    -
$01h
$1Ch
$01h
$0Ch
$00h
$FDh
$00h
$EEh
$00h
$E1h
$00h
$D4h
$00h
$C8h
$00h
$BDh
$00h
$B2h
$00h
$A8h
$00h
$9Fh
$00h
$96h
$00h
$8Dh
$00h
$85h
$00h
$7Eh    ~
$00h
$76h    v
$00h
$70h    p
$00h
$69h    i
$00h
$63h    c
$00h
$5Eh    ^
$00h
$58h    X
$00h
$53h    S
$00h
$4Fh    O
$00h
$4Ah    J
$00h
$46h    F
$00h
$42h    B
$00h
$3Eh    >
$00h
$24h    $
$00h
$20h
$00h
$00h
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
$00h
$06h
$0Dh
$13h
$19h
$1Fh
$26h    &
$2Ch    ,
$32h    2
$38h    8
$3Eh    >
$44h    D
$4Ah    J
$50h    P
$56h    V
$5Ch    \
$62h    b
$68h    h
$6Dh    m
$73h    s
$79h    y
$7Eh    ~
$84h
$89h
$8Eh
$93h
$98h
$9Dh
$A2h
$A7h
$ACh
$B1h
$B5h
$B9h
$BEh
$C2h
$C6h
$CAh
$CEh
$D1h
$D5h
$D8h
$DCh
$DFh
$E2h
$E5h
$E7h
$EAh
$EDh
$EFh
$F1h
$F3h
$F5h
$F7h
$F8h
$FAh
$FBh
$FCh
$FDh
$FEh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
$FFh
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
$00h
DAT_ff0d:                     ;XREF[1,0]:   ff26
$80h
$80h
$00h
DAT_ff10:                     ;XREF[1,0]:   ff1e
$04h
DAT_ff11:                     ;XREF[1,0]:   ff2c
$04h
$05h
$04h
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
$A5h
$17h
$18h
$65h    e
$4Ch    L
$85h
$17h
$A5h
$18h
$65h    e
$4Dh    M
$85h
$18h
$18h
DAT_ffa9:                     ;XREF[1,0]:   c026
undefined1  69h
DAT_ffaa:                     ;XREF[1,0]:   c026
undefined1  3Eh
$38h    8
$FDh
$00h
$05h
$9Dh
$00h
$04h
$BDh
$00h
$04h
$A8h
$29h    )
$04h
$C5h
$19h
$85h
$19h
$D0h
$1Dh
$98h
$45h    E
$1Ah
$30h    0
$14h
$EAh
$EAh
$98h
$0Ah
$8Dh
$05h
$20h
$A9h
$00h
$8Dh
$05h
$20h
$84h
$1Ah
$EAh
$EAh
$84h
$1Ah
$E8h
$60h    `
$98h
$4Ch    L
$E8h
$FFh
$98h
$C5h
$1Ah
$B0h
$05h
$29h    )
$FCh
$4Ch    L
$E8h
$FFh
$09h
$03h
$EAh
$0Ah
$8Dh
$05h
$20h
$A9h
$00h
$8Dh
$05h
$20h
$65h    e
$14h
$8Dh
$00h
$20h
$84h
$1Ah
DAT_fff8:                     ;XREF[1,0]:   c046
undefined1  E8h
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

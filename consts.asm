;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Constants for PPU registers mapped from addresses $2000 to $2007
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PPU_CTRL    = $2000
PPU_MASK    = $2001
PPU_STATUS  = $2002
OAM_ADDR    = $2003
OAM_DATA    = $2004
PPU_SCROLL  = $2005
PPU_ADDR    = $2006
PPU_DATA    = $2007
PPU_OAM_DMA = $4014

APU_DELTA_REG = $4011
APU_MASTER_CTRL = $4015
APU_SND_SQUARE1 = $4000
APU_SND_SQUARE1_1 = $4001
APU_SND_SQUARE1_2 = $4002
APU_SND_SQUARE1_3 = $4003
APU_SND_SQUARE2 = $4004
APU_SND_SQUARE2_5 = $4005
APU_SND_SQUARE2_6 = $4006
APU_SND_SQUARE2_7 = $4007
APU_SND_NOISE = $400C
APU_SND_NOISE_FREQUENCY_2        = $400E
APU_SND_NOISE_FREQUENCY_AND_TIME_3 = $400F
APU_SND_TRIANGLE = $4008
APU_SND_TRIANGLE_A = $400A
APU_SND_TRIANGLE_B = $400B

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Controller ports and buttons
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
JOYPAD_PORT1 = $4016
JOYPAD_PORT2 = $4017

BUTTON_A      = $80          ; 10000000
BUTTON_B      = $40          ; 01000000
BUTTON_SELECT = $20          ; 00100000
BUTTON_START  = $10          ; 00010000
BUTTON_UP     = $08          ; 00001000
BUTTON_DOWN   = $04          ; 00000100
BUTTON_LEFT   = $02          ; 00000010
BUTTON_RIGHT  = $01          ; 00000001

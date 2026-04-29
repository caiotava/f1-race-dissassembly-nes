all: f1-race.nes

%.o: %.asm
	ca65 -g -o $@ $^

%.nes: %.o
	ld65 -C nes.cfg --dbgfile $*.dbg --mapfile $*.map -o $@ $^

clean:
	rm -f *.o *.nes *.map *.sym *.dbg

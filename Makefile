disk: disk.img boot kernel
	dd if=boot of=$< bs=512 count=1 conv=notrunc
	dd if=kernel of=$< bs=512 seek=1 conv=notrunc

disk.img:
	dd if=/dev/zero of=$@ bs=1M count=1

boot: boot.asm
	nasm -f bin -o $@ $<

protected.o: protected.l interrupts.l calls.l sin.sh
	cat protected.l | ./sin.sh > protected_tmp.l
	cat calls.l >> protected_tmp.l
	cat interrupts.l >> protected_tmp.l
	./ltc protected_tmp.l
	mv protected_tmp.s protected.asm
	rm -f protected_tmp.err
	nasm -f elf -o $@ protected.asm

start.o: start.asm
	nasm -f elf -o $@ $<

kernel: start.o protected.o
	ld -melf_i386 --oformat=binary -Tlinker.ld -o $@ $^

clean:
	rm -f disk.img boot protected.o start.o kernel protected_tmp.l protected.asm calls calls.l interrupts interrupts.l

run: bochs.txt disk.img
	bochs -qf $<

ltc: ltc.cpp
	g++ -std=c++11 -o $@ $<

interrupts: interrupts.cpp
	g++ -std=c++11 -o $@ $<

interrupts.l: interrupts
	./$< > $@

calls: calls.cpp
	g++ -std=c++11 -o $@ $<

calls.l: calls
	./$< > $@

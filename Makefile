disk: disk.img boot kernel
	dd if=boot of=$< bs=512 count=1 conv=notrunc
	dd if=kernel of=$< bs=512 seek=1 conv=notrunc

disk.img:
	dd if=/dev/zero of=$@ bs=1M count=1

boot: boot.asm
	nasm -f bin -o $@ $<

kernel.o: kernel.l sin.sh ltc
	cat kernel.l | ./sin.sh > kernel_tmp.l
	./ltc kernel_tmp.l
	mv kernel_tmp.s kernel.asm
	rm -f kernel_tmp.err
	nasm -f elf -o $@ kernel.asm

start.o: start.asm
	nasm -f elf -o $@ $<

kernel: start.o kernel.o
	ld -melf_i386 --oformat=binary -Tlinker.ld -o $@ $^

clean:
	rm -f disk.img boot *.o kernel kernel_tmp.l kernel.asm

run: bochs.txt disk.img
	bochs -qf $<

ltc: ltc.cpp
	g++ -std=c++11 -o $@ $<

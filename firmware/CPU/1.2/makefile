OBJS=   p.init.o p.comm.o p.serial.o p.ldsd.o p.boot.o p.testram.o \
	p.testothr.o p.disk.o p.floppy.o p.tape.o p.dummy.o p.ram.o

all:	CPU-2.2

clean:
	rm -f CPU-2.2 ${OBJS}
	
CPU-2.2:  ${OBJS}
	ld ${OBJS} -o CPU-2.2
	strip -h CPU-2.2


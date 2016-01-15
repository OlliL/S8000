OBJS=   p.init.o p.comm.o p.serial.o p.ldsd.o p.boot.o p.testram.o \
	p.testothr.o p.disk.o p.floppy.o p.tape.o p.dummy.o p.ram.o

all:	CPU-1.2

clean:
	rm -f CPU-1.2 ${OBJS}
	
CPU-1.2:  ${OBJS}
	ld ${OBJS} -o CPU-1.2
	strip -h CPU-1.2


CC?=cc
OPT?=-O2
CFLAGS?=-Wall -std=c99 -g -ggdb
HIREDIS_OBJ=alloc.o async.o dict.o hiredis.o net.o read.o sds.o sockcompat.o

all: sigsegv

sigsegv: $(HIREDIS_OBJ) sigsegv.o
	$(CC) $(CFLAGS) -o $@ $^

%.o:
	$(CC) $(OPT) $(CFLAGS) -c $<

alloc.o: hiredis/alloc.c hiredis/fmacros.h hiredis/alloc.h
async.o: hiredis/async.c hiredis/fmacros.h hiredis/alloc.h \
 hiredis/async.h hiredis/hiredis.h hiredis/read.h hiredis/sds.h \
 hiredis/net.h hiredis/dict.c hiredis/dict.h hiredis/win32.h \
 hiredis/async_private.h
dict.o: hiredis/dict.c hiredis/fmacros.h hiredis/alloc.h hiredis/dict.h
hiredis.o: hiredis/hiredis.c hiredis/fmacros.h hiredis/hiredis.h \
 hiredis/read.h hiredis/sds.h hiredis/alloc.h hiredis/net.h \
 hiredis/async.h hiredis/win32.h
net.o: hiredis/net.c hiredis/fmacros.h hiredis/net.h hiredis/hiredis.h \
 hiredis/read.h hiredis/sds.h hiredis/alloc.h hiredis/sockcompat.h \
 hiredis/win32.h
read.o: hiredis/read.c hiredis/fmacros.h hiredis/read.h hiredis/sds.h \
 hiredis/win32.h
sds.o: hiredis/sds.c hiredis/sds.h hiredis/sdsalloc.h
sockcompat.o: hiredis/sockcompat.c hiredis/sockcompat.h
sigsegv.o: sigsegv.c

debug:
	OPT=-O0 $(MAKE)

clean:
	rm -f *.o sigsegv

.PHONY: all sigsegv

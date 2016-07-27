#include "common.h"

extern int errno;

#define demux(a) { \
    if(a >= (uint)(-4096)){ \
        errno = -(int)a; \
        a = (uint)-1; \
    } \
    return (int)a; \
}

int syscall0(uint a){
    asm volatile("int $0x80"
        : "=a"(a)
        : "a"(a)
        : "memory");

    demux(a)
}

int syscall1(uint a, uint b){
    asm volatile("int $0x80"
        : "=a"(a)
        : "a"(a), "b"(b)
        : "memory");

    demux(a)
}

int syscall2(uint a, uint b, uint c){
    asm volatile("int $0x80"
        : "=a"(a)
        : "a"(a), "b"(b), "c"(c)
        : "memory");

    demux(a)
}

int syscall3(uint a, uint b, uint c, uint d){
    asm volatile("int $0x80"
        : "=a"(a)
        : "a"(a), "b"(b), "c"(c), "d"(d)
        : "memory");

    demux(a)
}

int syscall4(uint a, uint b, uint c, uint d, uint e){
    asm volatile("int $0x80"
        : "=a"(a)
        : "a"(a), "b"(b), "c"(c), "d"(d), "S"(e)
        : "memory");

    demux(a)
}

int syscall5(uint a, uint b, uint c, uint d, uint e, uint f){
    asm volatile("int $0x80"
        : "=a"(a)
        : "a"(a), "b"(b), "c"(c), "d"(d), "S"(e), "D"(f)
        : "memory");

    demux(a)
}

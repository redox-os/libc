#include "common.h"

extern int errno;

#define demux(a) { \
    if(a >= (uint64_t)(-4096)){ \
        errno = -(int)a; \
        a = (uint64_t)-1; \
    } \
    return (int64_t)a; \
}

int64_t syscall0(uint64_t a){
    asm volatile("int $0x80"
        : "=a"(a)
        : "a"(a)
        : "memory");

    demux(a)
}

int64_t syscall1(uint64_t a, uint64_t b){
    asm volatile("int $0x80"
        : "=a"(a)
        : "a"(a), "b"(b)
        : "memory");

    demux(a)
}

int64_t syscall2(uint64_t a, uint64_t b, uint64_t c){
    asm volatile("int $0x80"
        : "=a"(a)
        : "a"(a), "b"(b), "c"(c)
        : "memory");

    demux(a)
}

int64_t syscall3(uint64_t a, uint64_t b, uint64_t c, uint64_t d){
    asm volatile("int $0x80"
        : "=a"(a)
        : "a"(a), "b"(b), "c"(c), "d"(d)
        : "memory");

    demux(a)
}

int64_t syscall4(uint64_t a, uint64_t b, uint64_t c, uint64_t d, uint64_t e){
    asm volatile("int $0x80"
        : "=a"(a)
        : "a"(a), "b"(b), "c"(c), "d"(d), "S"(e)
        : "memory");

    demux(a)
}

int64_t syscall5(uint64_t a, uint64_t b, uint64_t c, uint64_t d, uint64_t e, uint64_t f){
    asm volatile("int $0x80"
        : "=a"(a)
        : "a"(a), "b"(b), "c"(c), "d"(d), "S"(e), "D"(f)
        : "memory");

    demux(a)
}

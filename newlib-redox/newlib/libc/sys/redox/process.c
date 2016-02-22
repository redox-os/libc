#include "common.h"

int clone() {
    return syscall1(SYS_CLONE, CLONE_VM | CLONE_FS | CLONE_FILES);
}

void _exit(int code){
    syscall1(SYS_EXIT, (uint)code);
}

int _execve(const char *name, const char **argv, const char **env) {
    return syscall3(SYS_EXECVE, (uint)name, (uint)argv, (uint)env);
}

int fork() {
    return syscall1(SYS_CLONE, 0);
}

char * getcwd(char * buf, size_t size) {
    char * cwd = NULL;

    int file = open("", O_RDONLY);
    if(file >= 0){
        if(!buf){
            if(size == 0){
                size = 4096;
            }
            buf = (char *)calloc(size, 1);

            if(fpath(file, buf, size) >= 0){
                cwd = buf;
            }else{
                free(buf);
            }
        }else{
            memset(buf, 0, size);
            if(fpath(file, buf, size) >= 0){
                cwd = buf;
            }
        }
        close(file);
    }

    return cwd;
}


pid_t getpid() {
    return syscall0(SYS_GETPID);
}

void * sbrk(ptrdiff_t increment){
    char * curr_brk = (char *)syscall1(SYS_BRK, 0);
    char * new_brk = (char *)syscall1(SYS_BRK, (uint)(curr_brk + increment));
    if (new_brk != curr_brk + increment){
        return (void *) -1;
    }
    return curr_brk;
}

int sched_yield() {
    return syscall0(SYS_YIELD);
}

pid_t vfork() {
    return syscall1(SYS_CLONE, CLONE_VM | CLONE_VFORK);
}

pid_t wait(int * status) {
    return waitpid(-1, status, 0);
}

pid_t waitpid(pid_t pid, int * status, int options) {
    return syscall3(SYS_WAITPID, (uint)pid, (uint)status, (uint)options);
}

#include "common.h"

int chdir(const char *path){
    return (int)syscall(SYS_CHDIR, (uint)path, 0, 0);
}

int clone() {
    return (int)syscall(SYS_CLONE, CLONE_VM | CLONE_FS | CLONE_FILES, 0, 0);
}

void _exit(int code){
    syscall(SYS_EXIT, (uint)code, 0, 0);
}

int _execve(const char *name, const char **argv, const char **env) {
    return (int)syscall(SYS_EXECVE, (uint)name, (uint)argv, (uint)env);
}

int fork() {
    return (int)syscall(SYS_CLONE, 0, 0, 0);
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
    return (int)syscall(SYS_GETPID, 0, 0, 0);
}

void * sbrk(ptrdiff_t increment){
    char * curr_brk = (char *)syscall(SYS_BRK, 0, 0, 0);
    char * new_brk = (char *)syscall(SYS_BRK, (uint)(curr_brk + increment), 0, 0);
    if (new_brk != curr_brk + increment){
        return (void *) -1;
    }
    return curr_brk;
}

int sched_yield() {
    return (int)syscall(SYS_YIELD, 0, 0, 0);
}

pid_t wait(int * status) {
    return waitpid(-1, status, 0);
}

pid_t waitpid(pid_t pid, int * status, int options) {
    return (pid_t)syscall(SYS_WAITPID, (uint)pid, (uint)status, (uint)options);
}

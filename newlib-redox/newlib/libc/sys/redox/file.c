#include "common.h"

int chdir(const char *path){
    return syscall1(SYS_CHDIR, (uint)path);
}

int close(int file){
    return syscall1(SYS_CLOSE, (uint)file);
}

int dup(int file){
    return syscall1(SYS_DUP, (uint)file);
}

int fpath(int file, char * buf, int len) {
    return syscall2(SYS_FPATH, (uint)buf, (uint)len);
}

int fsync(int file) {
    return syscall1(SYS_FSYNC, (uint)file);
}

int ftruncate(int file, off_t len){
    return syscall2(SYS_FTRUNCATE, (uint)file, (uint)len);
}

int lseek(int file, int ptr, int dir) {
    return syscall3(SYS_LSEEK, (uint)file, (uint)ptr, (uint)dir);
}

int link(const char *old, const char *new) {
    return syscall2(SYS_LINK, (uint)old, (uint)new);
}

int mkdir(const char * path, mode_t mode) {
    return syscall2(SYS_MKDIR, (uint)path, (uint)mode);
}

int open(const char *file, int flags, ...) {
    return syscall3(SYS_OPEN, (uint)file, (uint)flags, 0);
}

int pipe(int pipefd[2]) {
    return syscall2(SYS_PIPE2, (uint)pipefd, 0);
}

int pipe2(int pipefd[2], int flags) {
    return syscall2(SYS_PIPE2, (uint)pipefd, (uint)flags);
}

int read(int file, char *ptr, int len) {
    return syscall3(SYS_READ, (uint)file, (uint)ptr, (uint)len);
}

int rmdir(const char * path){
    return syscall1(SYS_RMDIR, (uint)path);
}

int unlink(const char *name) {
    return syscall1(SYS_UNLINK, (uint)name);
}

int write(int file, const char *ptr, int len) {
    return syscall3(SYS_WRITE, (uint)file, (uint)ptr, (uint)len);
}

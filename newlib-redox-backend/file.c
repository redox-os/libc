#include "common.h"

int chdir(const char *path){
    return syscall2(SYS_CHDIR, (uint)path, (uint)strlen(path));
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

int fstat(int file, struct stat *st) {
    return syscall2(SYS_FSTAT, (uint)file, (uint)st);
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

int mkdir(const char * path, mode_t mode) {
    return syscall3(SYS_MKDIR, (uint)path, (uint)strlen(path), (uint)mode);
}

int open(const char *path, int flags, ...) {
    return syscall3(SYS_OPEN, (uint)path, (uint)strlen(path), (uint)flags);
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
    return syscall2(SYS_RMDIR, (uint)path, (uint)strlen(path));
}

int stat(const char *__restrict path, struct stat *__restrict sbuf) {
    return syscall3(SYS_STAT, (uint)path, (uint)strlen(path), (uint)sbuf);
}

int unlink(const char *path) {
    return syscall2(SYS_UNLINK, (uint)path, (uint)strlen(path));
}

int write(int file, const char *ptr, int len) {
    return syscall3(SYS_WRITE, (uint)file, (uint)ptr, (uint)len);
}

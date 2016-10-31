#include "common.h"

int chdir(const char *path){
    return syscall2(SYS_CHDIR, (uint64_t)path, (uint64_t)strlen(path));
}

int close(int file){
    return syscall1(SYS_CLOSE, (uint64_t)file);
}

int dup(int file){
    return syscall1(SYS_DUP, (uint64_t)file);
}

int fpath(int file, char * buf, int len) {
    return syscall2(SYS_FPATH, (uint64_t)buf, (uint64_t)len);
}

int fstat(int file, struct stat *st) {
    return syscall3(SYS_FSTAT, (uint64_t)file, (uint64_t)st, sizeof(stat));
}

int fsync(int file) {
    return syscall1(SYS_FSYNC, (uint64_t)file);
}

int ftruncate(int file, off_t len){
    return syscall2(SYS_FTRUNCATE, (uint64_t)file, (uint64_t)len);
}

int lseek(int file, int ptr, int dir) {
    return syscall3(SYS_LSEEK, (uint64_t)file, (uint64_t)ptr, (uint64_t)dir);
}

int mkdir(const char * path, mode_t mode) {
    return syscall3(SYS_MKDIR, (uint64_t)path, (uint64_t)strlen(path), (uint64_t)mode);
}

int open(const char *path, int flags, ...) {
    return syscall3(SYS_OPEN, (uint64_t)path, (uint64_t)strlen(path), (uint64_t)flags);
}

int pipe(int pipefd[2]) {
    return syscall2(SYS_PIPE2, (uint64_t)pipefd, 0);
}

int pipe2(int pipefd[2], int flags) {
    return syscall2(SYS_PIPE2, (uint64_t)pipefd, (uint64_t)flags);
}

int read(int file, char *ptr, int len) {
    return syscall3(SYS_READ, (uint64_t)file, (uint64_t)ptr, (uint64_t)len);
}

int rmdir(const char * path){
    return syscall2(SYS_RMDIR, (uint64_t)path, (uint64_t)strlen(path));
}

int stat(const char *__restrict path, struct stat *__restrict sbuf) {
    int fd = open(path, 0);
    if(fd < 0){
        return fd;
    }
    int ret = fstat(fd, sbuf);
    int err = errno;
    close(fd);
    errno = err;
    return ret;
}

int unlink(const char *path) {
    return syscall2(SYS_UNLINK, (uint64_t)path, (uint64_t)strlen(path));
}

int write(int file, const char *ptr, int len) {
    return syscall3(SYS_WRITE, (uint64_t)file, (uint64_t)ptr, (uint64_t)len);
}

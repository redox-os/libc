#include "common.h"

#include <stdio.h>

#define UNIMPL(error) { \
    errno = error; \
    fprintf(stderr, "unimplemented: %s: %s\n", __func__, strerror(error)); \
    return -1; \
}

int access(const char * path, int amode){
    //All permissions granted, if file exists
    struct stat sbuf;
    return stat(path, &sbuf);
}

int chmod(const char * path, mode_t mode) {
    UNIMPL(EACCES);
}

int dup2(int oldfd, int newfd) {
    UNIMPL(EBADF);
}

int fcntl(int file, int cmd, ...){
    UNIMPL(EACCES);
}

struct hostent * gethostbyname(const char * name) {
    return (struct hostent *) NULL;
}

int getdtablesize() {
    return 65536;
}

struct group * getgrnam(const char * name){
    return (struct group *) NULL;
}

struct group * getgrgid(gid_t gid){
    return (struct group *) NULL;
}

struct passwd * getpwnam(const char * name){
    return (struct passwd *) NULL;
}

struct passwd * getpwuid(uid_t uid){
    return (struct passwd *) NULL;
}

gid_t getegid() {
    return 0;
}

uid_t geteuid() {
    return 0;
}

gid_t getgid() {
    return 0;
}

uid_t getuid() {
    return 0;
}

int ioctl(int file, int request, ...) {
    UNIMPL(EINVAL);
}

int kill(int pid, int sig) {
    UNIMPL(EINVAL);
}

int setgid(gid_t gid) {
    UNIMPL(EINVAL);
}

int setuid(uid_t uid) {
    UNIMPL(EINVAL);
}

long sysconf(int name) {
    UNIMPL(EINVAL);
}

clock_t times(struct tms * buf) {
    UNIMPL(EINVAL);
}

mode_t umask(mode_t mask) {
    //All permissions granted
    return 0777;
}

int utime(const char * filename, const struct utimbuf * times) {
    UNIMPL(EACCES);
}

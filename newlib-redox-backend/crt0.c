extern char ** environ;
extern void exit(int code);
extern int main(int argc, char ** argv, char ** envp);

void _start() {
    exit(main(0, 0, 0));
}

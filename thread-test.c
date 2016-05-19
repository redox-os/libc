int regular_data = 1;
int regular_bss = 0;

__thread int test_tl_data = 1;
__thread int test_tl_bss = 0;

int main(int argc, char ** argv){
    printf("REG DATA: %d, REG BSS: %d\n", regular_data, regular_bss);
    printf("TLS DATA: %d, TLS BSS: %d\n", test_tl_data, test_tl_bss);
    return 0;
}

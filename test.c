//license by MIT
//https://github.com/no-passwd/lxc-toolkit
#define _GNU_SOURCE
#include <unistd.h>
#include <stdio.h>
#include <sys/syscall.h>

int main() {
    long nprocs = sysconf(_SC_NPROCESSORS_ONLN);
    if (nprocs >= 0) {
        printf("从系统调用中获取到的CPU核心数: %ld 个\n", nprocs);
    } 
    return 0;
}

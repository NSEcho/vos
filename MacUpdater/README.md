# CVE-2023-41902

MacUpdater before 3.1.2 and 2.3.8 had misconfigured XPC PrivilegedHelper which can be exploited using race condition 
for `xpc_connection_get_pid` function

[walkthrough link](https://www.ns-echo.com/posts/cve_2023_41902.html)
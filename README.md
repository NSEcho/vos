# vos
macOS software vulnerabilities I have discovered along with the vulnerable software and exploit/PoC.

* [Perimeter81](./Perimeter81) - CVE-2023-33298 - Local Privilege Escalation abusing XPC with the Command Injection
* [NoMachine](./NoMachine) - CVE-2023-39107 - Arbitrary File Overwrite to overwrite root-owned files
* [ShadowsocksX-NG](./ShadowsocksX-NG) - CVE-2023-27574 - Code injection abusing `com.apple.security.get-task-allow`.
* [Tunnelblick](./Tunnelblick) - Arbitrary File Overwrite to overwrite root-owned files
* [Tunnelblick](./Tunnelblick) - "Assisted" LPE abusing .ovpn files
* [UninstallPKG](./UninstallPKG) - Arbitrary File Delete (affects also root-owned files)
* [MacUpdater](./MacUpdater) - CVE-2023-41902 - Local Privilege Escalation abusing `xpc_connection_get_pid`
* COORDINATION PROCESS - Race condition to LPE in VPN solution
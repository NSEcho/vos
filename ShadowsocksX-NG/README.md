# CVE-2023-27574

ShadowsocksX-NG before version v1.10.1 had `com.apple.security.get-task-allow` entitlement set which allows other processes 
to inject into the application and execute code. Full walkthrough is at my [blog](https://www.ns-echo.com/posts/cve_2023_27574.html).
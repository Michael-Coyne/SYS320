New-SSHSession -ComputerName 192.168.8.151 -Port 22
Invoke-SSHCommand -SessionId 0 -Command "cat /etc/os-release"
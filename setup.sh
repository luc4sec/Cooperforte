#!/bin/bash
if [ "$1" == "" ] || [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
        echo ""
        echo ""
        echo "+============================================+"
        echo "| Automatizador de configuração ubuntu 20.04 |"
        echo "+============================================+"
        echo "|    Modo de uso:~$ sudo chmod +x setup.sh   |"
        echo "|                ~$ sudo ./setup.sh install  |"
        echo "+============================================+"
        echo ""
elif [ "$1" == "install" ]; then
        if [ `whoami` == 'root' ]; then
                echo "Instalando aplicativos..."
		apt -y install realmd sssd sssd-tools libnss-sss libpam-sss adcli samba-common-bin oddjob oddjob-mkhomedir packagekit & > log.log
                echo "Digite o usuário de rede: "
                read user
                realm join --user $user cooperforte.coop
        else
                echo "É necessário logar com root (sudo ./setup install)"
        fi
fi

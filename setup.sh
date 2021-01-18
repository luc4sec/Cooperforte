#!/bin/bash
#Vesion 1.2
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
		echo "---Atualizando pacotes---"
		sudo apt update 1>> registro.log; sudo apt list --upgradable 1>> registro.log; sudo apt upgrade -y 1>> registro.log; sudo apt autoremove -y 1>> registro.log
        echo "---Instalando aplicativos...---"
		apt -y install realmd sssd sssd-tools libnss-sss libpam-sss adcli samba-common-bin oddjob oddjob-mkhomedir packagekit 1>> /registro.log
                echo "Digite o usuário de rede: "
                read user
                realm join --user $user cooperforte.coop
        echo "---Editando arquivo sssd.conf---"
		mv /etc/sssd/sssd.conf /etc/sssd/sssd.conf.old
		cp sssd.conf /etc/sssd/

		echo "---Editando common-session---"
		mv /etc/pam.d/common-session /etc/pam.d/common-session.old
		mv common-session /etc/pam.d/

		echo "---Reiniciando sssd---"
		systemctl restart sssd

		echo "---Adicionando usuário como root---"
		mv /etc/sudoers /etc/sudoers.old
		mv sudoers /etc/

		echo "---Testando usuário de rede---"
		#id lucas.nascimento > teste.txt
		#if 
		
        else
                echo "É necessário logar com root (sudo ./setup install)"
        fi
fi

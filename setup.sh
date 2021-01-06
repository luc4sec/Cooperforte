#!/bin/bash
#Vesion 0.1
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
		echo "Atualizando pacotes"
		sudo apt update; sudo apt list --upgradable; sudo apt upgrade -y; sudo apt autoremove -y
                echo "Instalando aplicativos..."
		apt -y install realmd sssd sssd-tools libnss-sss libpam-sss adcli samba-common-bin oddjob oddjob-mkhomedir packagekit
                echo "Digite o usuário de rede: "
                read user
                realm join --user $user cooperforte.coop
		mv /etc/sssd/sssd.conf /etc/sssd/sssd.conf.old
		echo "
[sssd]
domains = cooperforte.coop
config_file_version = 2
services = nss, pam

[domain/cooperforte.coop]
ad_domain = cooperforte.coop
krb5_realm = COOPERFORTE.COOP
realmd_tags = manages-system joined-with-adcli
cache_credentials = True
id_provider = ad
krb5_store_password_if_offline = True
default_shell = /bin/bash
ldap_id_mapping = true
use_fully_qualified_names = false
fallback_homedir = /home/%u
access_provider = ad
ad_gpo_access_control = permissive" > /etc/sssd/sssd.conf

		
        else
                echo "É necessário logar com root (sudo ./setup install)"
        fi
fi

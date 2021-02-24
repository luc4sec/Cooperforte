#!/bin/bash
#
# __________________________________________________________________________
#
# auto-config.sh - Automatizador de Configuração de rede padrão Cooperforte
# 
# ---------------------------------------------------------------------------
# Como Usar? 
#	1. chmod +x auto-config.sh
#	2. ./auto-config.sh
#
# Exemplos:
#	$ sudo ./auto-config.sh --help
# 	# ./auto-config.sh --help
#	# ./auto-config.sh --install-all
# ---------------------------------------------------------------------------
#
# Histório:
#  v1.0 10/02/2021, Lucas Nascimento:
#	- Versão inicial funcional
#  v1.2 23/02/2021, Lucas Nascimento
#	- Correção de bugs em configCommon, Correção de bugs em configRealm
#
# ---------------------------------------------------------------------------
#
# O que fazer:
#	- Validar configurações
#	- Barra de carregamento
#
# ---------------------------------------------------------------------------- 
# ___________________________________________________________________________
#


function help () {
	echo "


	-h, --help			Manual de ajuda
	-u, --update		        Atualizar lista de pacotes
	-U, --upgrade 		        Atualizar aplicativos
	-uU, 				Atualizar pacortes e aplicativos
	-C, 				Configurar todos os aplicativos
	--install-all, 		        Instalar e configurar tudo
	"
	exit 1

}

function update () {
	echo "* Atualizando pacotes *"
	apt update
	apt list --upgradable
	exit 2
}

function upgrade () {
	echo "* Atualizando sistema *"
	apt upgrade -y
	exit 3
}

function install () {
	apt -y install realmd sssd sssd-tools libnss-sss libpam-sss adcli samba-common-bin oddjob oddjob-mkhomedir packagekit openssh-server
	exit 4
}

function configRealm () {
	echo "Digite o usuário de rede: "
	read user
    	realm join -U $user cooperforte.coop -v
    	exit 5
}

function configSSSD () {
	echo "---Editando arquivo sssd.conf---"
	cp /etc/sssd/sssd.conf /etc/sssd/sssd.conf.old
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
use_fully_qualified_names = False
fallback_homedir = /home/%u
access_provider = ad
ad_gpo_access_control = permissive
" > /etc/sssd/sssd.conf
	exit 6
}

function configCommon () {
	echo "---Editando common-session---"
	cp /etc/pam.d/common-session /etc/pam.d/common-session.old
	echo "session optional   pam_mkhomedir.so skel = /etc/skel/ mask=0077 " >> /etc/pam.d/common-session
	systemctl restart sssd
	exit 7
}

function configSudoers () {
	echo "---Adicionando usuário como root---"
	cp /etc/sudoers /etc/sudoers.old
	echo "%desenlinux ALL=(ALL) ALL" >> /etc/sudoers
	echo "%Grupo\ Sutec ALL=(ALL) ALL" >> /etc/sudors
	exit 8
}

function forticlient(){
	echo "---Instlado Forticlient---"
	wget -O - https://repo.fortinet.com/repo/6.4/ubuntu/DEB-GPG-KEY | sudo apt-key add -
	echo "deb https://repo.fortinet.com/repo/6.4/ubuntu/ bionic multiverse"	>> /etc/apt/sources.list
	update;
	exit 9

}

if [ "$1" != "" ]; then
	if [ `whoami` == 'root' ]; then
		for arg in "$@"; do
		  	shift
		 	case "$arg" in
				"") help;;
		    		"-h") help ;;
		    		"--help") help;;
				"-u") update;;
				"-U") upgrade;;
				"-uU") update && upgrade;;
				"-I") install; forticlient;;
				"-C") configRealm; configSSSD; configCommon; configSudoers;;
				"--install-all") update; install; configRealm; configSSSD; configCommon; configSudoers; forticlient;;
		    	*)  echo "* Comando inexistente *" && help;;
			exit 10
				
		  	esac
		done
	else
            echo "É necessário logar com root (sudo ./setup install)"
	    exit 0
    fi
else
	help
fi

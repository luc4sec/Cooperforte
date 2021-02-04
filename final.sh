#!/bin/bash
#Versão 0.2

function help () {
	echo "


	-h, --help			Manual de ajuda
	-u, --update		Atualizar lista de pacotes
	-U, --upgrade 		Atualizar aplicativos
	-uU, 				Atualizar pacortes e aplicativos
	"

}

function update () {
	echo "* Atualizando pacotes *"
	apt update
	apt list --upgradable
}

function upgrade () {
	echo "* Atualizando sistema *"
	apt upgrade -y
}

function install () {
	apt -y install realmd sssd sssd-tools libnss-sss libpam-sss adcli samba-common-bin oddjob oddjob-mkhomedir packagekit openssh-server 1>> /registro.log
}

function configRealm () {
	echo "Digite o usuário de rede: "
	read user
    realm join --user $user cooperforte.coop
}

function configSSSD () {
	echo "---Editando arquivo sssd.conf---"
	cp /etc/sssd/sssd.conf /etc/sssd/sssd.conf.old
	touch sssd.conf
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
" > sssd.conf
}

function configCommon () {
	echo "---Editando common-session---"
	cp /etc/pam.d/common-session /etc/pam.d/common-session.old
	echo "session optional   pam_mkhomedir.so skel = /etc/skel/ mask=0077 " >> /etc/pam.d/common-session
	systemctl restart sssd
}

function configSudoers () {
	echo "---Adicionando usuário como root---"
	cp /etc/sudoers /etc/sudoers.old
	echo "%desenlinux ALL=(ALL) ALL" >> /etc/sudoers
}
if [ "$1" != "" ]; then
	if [ `whoami` == 'root' ]; then
		for arg in "$@"; do
		  	shift
		 	case "$arg" in
		    	"-h") help ;;
		    	"--help") help;;
				"-u") update;;
				"-U") upgrade;;
				"-uU") update && upgrade;;
				"-I") install;;
				"-C") configRealm; configSSSD; configCommon; configSudoers;;
				"--install-all") update; install; configRealm; configSSSD; configCommon; configSudoers;;
		    	*)  echo "* Comando inexistente *" && help;;
				"") help;;
		  	esac
		done
	else
            echo "É necessário logar com root (sudo ./setup install)"
    fi
else
	help
fi






## O que fazer? ##
# Criar função de validação
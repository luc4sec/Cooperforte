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
	apt -y install realmd sssd sssd-tools libnss-sss libpam-sss adcli samba-common-bin oddjob oddjob-mkhomedir packagekit 1>> /registro.log
}

function configRealm () {
	echo "Digite o usuário de rede: "
	read user
    realm join --user $user cooperforte.coop
}

function configSSSD () {
	echo "---Editando arquivo sssd.conf---"
	mv /etc/sssd/sssd.conf /etc/sssd/sssd.conf.old
	cp sssd.conf /etc/sssd/
}

function configCommon () {
	echo "---Editando common-session---"
	mv /etc/pam.d/common-session /etc/pam.d/common-session.old
	echo "session optional   pam_mkhomedir.so skel = /etc/skel/ mask=0077 " >> /etc/pam.d/common-session
}

function configSudoers () {
	echo "---Adicionando usuário como root---"
	mv /etc/sudoers /etc/sudoers.old
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
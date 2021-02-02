#!/bin/bash
#Vesion 1.2
if [ "$1" == "" ] || [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
        echo ""
        echo "
Seja bem vindo ao script de primeiras configurações do S.O. Ubuntu

			Escolha uma opção abaixo para começar!
       			1 - Configurações iniciais do Sistema Operacional;
       			2 - Verificar repositório do sistema;
       			3 - Mostrar atualizações do sistema;
       			4 - Instalar atualizações do sistema;
       			5 - Limpar o sistema;
       			6 - Remover pacotes não necessários;
       			0 - Sair do sistema.
      "
# Abaixo, foi uma forma que encontrei de modular, precisamos melhorar essa parte.
# A primeira opção é o programa completo, ele que é o carinha que vai fazer todas as configurações iniciais, os demais casos são para manutenção futura.
elif [ "$#" == "install" ]; then
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
		echo "session optional   pam_mkhomedir.so skel = /etc/skel/ mask=0077 " >> /etc/pam.d/common-session

		echo "---Adicionando usuário como root---"
		mv /etc/sudoers /etc/sudoers.old
		echo "%desenlinux ALL=(ALL) ALL" >> /etc/sudoers

		#echo "---Testando usuário de rede---"
		id lucas.nascimento > teste.txt
		
		
        else
                echo "É necessário logar com root (sudo ./setup install)"
        fi
fi
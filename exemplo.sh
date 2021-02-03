#/bin/bash

NOME=$1
PATRIMONIO=$2
IP=$3
QTD_PARAM=$#
OPCAO=$4
SENHA=$(cat senha.txt)

function instalar() {
  echo "Nome:  $NOME  -  Patrimonio $PATRIMONIOi - SENHA=$SENHA"
  configurarIp
  configurarDns

}

function print_usage() {
   echo "Utilize o comando da seguinte forma: meuexemplo.sh <NOME> <PATRIMONIO> <IP> <instalar/verificar>"
}

function configurarIp() {
  echo "Configurando o IP $IP"
  if [ "$?" == "0" ] ; then
     echo "IP Configurado com sucesso"
  else
     echo "Erro ao configurar IP"
  fi
}

function configurarDns() {
  echo "Configurando o DNS na máquina"
}


function verificar() {
  echo "Verificando"
}

function main() {

  if [ "$NOME" == "-h" ] || [ "$QTD_PARAM" != "4" ] ; then
     print_usage
     exit 1
  else
     case "$OPCAO" in
             "instalar") instalar ;;
             "verificar") verificar ;;
     esac
  fi

}



main
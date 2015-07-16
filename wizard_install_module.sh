#!/bin/bash

####################################################################
# CEREBRUM Comércio e Desenvolvimento de Sistemas de Informática Ltda ME - CNPJ 07.361.259/0001-07
####################################################################

####################################################################
# base files inclusion
####################################################################

function usage()
{
  cat <<EOF

Acesse o diretório do Magento e execute o seguinte comando no terminal


bash < <(wget -q --no-check-certificate -O - https://raw.github.com/colinmollenhour/modman/master/modman-installer)

or

bash < <(curl -s -L https://raw.github.com/colinmollenhour/modman/master/modman-installer)

source ~/.profile





./wizard_install_module.sh

# FAQ

1. 

bash: ./wizard_install_module.sh: Permissão negada

chmod +x ./wizard_install_module.sh

EOF
exit 0
}

set_colors(){
	red='\E[31m'
	green='\E[32m'
	yellow='\E[33m'
	cyan='\E[36m'

	color_end='\E[0m'
	bold='\033[1m'
	bold_end='\033[0m'
}

log(){
	eval echo -e '"$1"' $log_output
}

functionBefore() {

	DATA_HORA_INICIAL=$(date '+%d/%m/%Y %H:%M:%S')

}

functionAfter() {

	DATA_HORA_FINAL=$(date '+%d/%m/%Y %H:%M:%S')

	log "${green} DATA_HORA_INICIAL: $DATA_HORA_INICIAL ${color_end}\n"
	log "${green} DATA_HORA_FINAL: $DATA_HORA_FINAL ${color_end}\n"

}

wizard_install_module(){

    # ##
    # functionBefore
    # ##
	functionBefore

	#

	file='index.php'
    if [ -f "$file" ];then # True if file exists and is a regular file. 
		log "${green} (Arquivo encontrado) ${color_end}\n"
    else
		log "${red} (Não foi encontrado o arquivo index.php do Magento) ${color_end}\n"
		exit;
    fi

	#

	#php -i | grep -i '/php.ini'
	REQUIREMENTS=''

	#

	class_exists=`php -i | grep -i 'mbstring'`

	if [ -z "$class_exists" ] ; then # -z string - True if the length of string is zero.
		log "${red} (A extensão do PHP mbstring deve ser instalado para que o módulo funcione corretamente. Entre em contato com sua empresa de hospedagem informando o erro e solicite a ativação da extensão) ${color_end}\n"
		REQUIREMENTS='false'
	else
		log "${green} (PHP mbstring encontrado) ${color_end}\n"
	fi

	#

	class_exists=`php -i | grep -i 'soap'`

	if [ -z "$class_exists" ] ; then # -z string - True if the length of string is zero.
		log "${red} (A extensão do PHP Soap deve ser instalado para que o módulo funcione corretamente. Entre em contato com sua empresa de hospedagem informando o erro e solicite a ativação da extensão) ${color_end}\n"
		REQUIREMENTS='false'
	else
		log "${green} (PHP Soap encontrado) ${color_end}\n"
	fi

	#

	zendGuardLoader=`php -i | grep -i 'Zend Guard Loader'`

	if [ -z "$zendGuardLoader" ]
	then
		log "${red} (Zend Guard Loader não encontrado) ${color_end}\n"
		REQUIREMENTS='false'
	else
		log "${green} (Zend Guard Loader encontrado) ${color_end}\n"
	fi

	#

	phpversion=`php -v`
	phpversion=${phpversion:0:7} # Extract a Substring from a Variable
	phpversion=${phpversion:4:3}
	phpversion_rpl=${phpversion//./} # Replace ponto por nada
	echo $phpversion_rpl

	if [ -z "$phpversion" ]
	then
		log "${red} ($phpversion) ${color_end}\n"
		REQUIREMENTS='false'
	else
		log "${green} (PHP $phpversion) ${color_end}\n"
	fi

	#

	#echo $REQUIREMENTS
	chrlen=${#REQUIREMENTS} ## string lenght
	#echo $chrlen

	if [ $chrlen -gt 0 ]; then
		log "${red} (Houve as seguintes fahas acima.) ${color_end}\n"
	else
		log "${green} (Módulo sendo mesclado ao projeto) ${color_end}\n"

		wget https://github.com/cerebrumgit/php$phpversion_rpl-magento1-cerebrum_telencephalon/archive/master.zip
		unzip master.zip
		cp -Rv php$phpversion_rpl-magento1-cerebrum_telencephalon-master/* .
		rm -fr master.zip php$phpversion_rpl-magento1-cerebrum_telencephalon-master

	fi

	log "${green} (Fim) ${color_end}\n"

    # ##
    # functionAfter
    # ##
	functionAfter

}

user_interface() {

echo -n -e "${cyan}"
echo "-------------------------------------------------------------------------"
echo -n ""
echo ""
echo "Assistente de instalação de módulo, disponibilizado por CEREBRUM"
echo ""
echo "-------------------------------------------------------------------------"
echo -n -e "${color_end}"
echo

}


set_colors

####################################################################
# load app
####################################################################

user_interface
wizard_install_module

exit 0

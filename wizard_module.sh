#!/bin/bash

####################################################################
# Copyright © 2015 Cerebrum. All rights reserved.
# http://www.cerebrum.com.br/
####################################################################

####################################################################
# base functions
####################################################################

function usage()
{
  cat <<EOF

1. 

Foi criado o seguinte programa em Shell Script

https://github.com/cerebrumgit/cerebrum/blob/master/wizard_module.sh

Para usar o mesmo

Antes acesse o Magento e mantenha o Compiler e Cache desativado

Acesse o diretório do Magento e execute o seguinte comando no terminal

	wget https://raw.githubusercontent.com/cerebrumgit/cerebrum/master/wizard_module.sh
	chmod +x ./wizard_module.sh
	./wizard_module.sh 5.3

O programa deve executar os seguintes processos:

1. Checagem do recurso de servidor: mbstring, soap, Zend Guard Loader
2. Possibilidade de backup do banco de dados e arquivos do projeto
3. Criação de projeto "ambiente de teste"
4. Mesclagem do módulo ao projeto "Podendo ser usado para instalação/atualização"

2. 

./wizard_module.sh

bash: ./wizard_module.sh: Permissão negada

chmod +x ./wizard_module.sh

./wizard_module.sh

3. 

sudo ln -s ~/Dropbox/Private/shell_script/bash/web/wizard_module.sh ~/dados/public_html/magento-1.9.2.0-dev02/magento

./wizard_module.sh


EOF
exit 0
}

set_colors(){
	# Reset
	color_end='\e[0m'       # Text Reset

	# Regular Colors
	black='\e[0;30m'        # Black
	red='\e[0;31m'          # Red
	green='\e[0;32m'        # Green
	yellow='\e[0;33m'       # Yellow
	blue='\e[0;34m'         # Blue
	purple='\e[0;35m'       # Purple
	cyan='\e[0;36m'         # Cyan
	white='\e[0;37m'        # White

	# Background
	On_Black='\e[40m'       # Black
	On_Red='\e[41m'         # Red
	On_Green='\e[42m'       # Green
	On_Yellow='\e[43m'      # Yellow
	On_Blue='\e[44m'        # Blue
	On_Purple='\e[45m'      # Purple
	On_Cyan='\e[46m'        # Cyan
	On_White='\e[47m'       # White
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

user_interface() {

echo -n -e "${On_Cyan}"
echo "-------------------------------------------------------------------------"
echo -n ""
echo ""
echo "Assistente de instalação/atualização do módulo Cerebrum_Telencephalon"
echo ""
echo "-------------------------------------------------------------------------"
echo -n -e "${color_end}"
echo

}

# xml_value path/to/file node_key
function xml_value(){
    grep "<$2>.*<.$2>" $1 | sed -e "s/<\!\[CDATA\[//" | sed -e "s/\]\]>//" | sed -e "s/^.*<$2/<$2/" | cut -f2 -d">"| cut -f1 -d"<"
}


wizard_module(){

	#echo -e "Arguments: (${0}) - (${1}) - (${2}) - (${3}) - (${4}) - (${5})"

    # ##
    # functionBefore
    # ##
	functionBefore

	#

	file='index.php'
    if [ -f "$file" ];then # True if file exists and is a regular file. 
		log "${green} (Arquivo index.php encontrado) ${color_end}\n"
    else
		log "${red} (Não foi encontrado o arquivo index.php do Magento) ${color_end}\n"
		exit;
    fi

	#

	#php -i | grep -i '/php.ini'

	#

	class_exists=`php -i | grep -i 'mbstring'`

	if [ -z "$class_exists" ] ; then # -z string - True if the length of string is zero.
		log "${red} (A extensão do PHP mbstring deve ser instalado para que o módulo funcione corretamente. Entre em contato com sua empresa de hospedagem informando o erro e solicite a ativação da extensão) ${color_end}\n"
	else
		log "${green} (PHP mbstring encontrado) ${color_end}\n"
	fi

	#

	class_exists=`php -i | grep -i 'soap'`

	if [ -z "$class_exists" ] ; then # -z string - True if the length of string is zero.
		log "${red} (A extensão do PHP Soap deve ser instalado para que o módulo funcione corretamente. Entre em contato com sua empresa de hospedagem informando o erro e solicite a ativação da extensão) ${color_end}\n"
	else
		log "${green} (PHP Soap encontrado) ${color_end}\n"
	fi

	#

	zendGuardLoader=`php -i | grep -i 'Zend Guard Loader'`

	if [ -z "$zendGuardLoader" ]
	then
		log "${red} (Zend Guard Loader não encontrado) ${color_end}\n"
	else
		log "${green} (Zend Guard Loader encontrado) ${color_end}\n"
	fi

	#

	phpversion=`php -v`
	phpversion=${phpversion:0:7} # Extract a Substring from a Variable
	phpversion=${phpversion:4:3}
	if [ "$1" ] ; then
		phpversion=${1}
	fi
	phpversion_rpl=${phpversion//./} # Replace ponto por nada

	if [ -z "$phpversion" ]
	then
		log "${red} ($phpversion) ${color_end}\n"
	else
		log "${green} (PHP $phpversion) ${color_end}\n"
	fi

	#

	directory_up="$(cd ../; pwd)" # FIX: tar: .: arquivo alterado enquanto estava sendo lido
	NOW=$(date +%Y.%m.%d_%H.%M.%S)
	file_sql="$directory_up/magento-$NOW.sql.gz"
	file_tgz="$directory_up/magento-$NOW.tgz"

	log "${blue} (Processo para backup do banco de dados em $file_sql) ${color_end}\n"

	dbhost=$(xml_value app/etc/local.xml host)
	dbname=$(xml_value app/etc/local.xml dbname)
	dbuser=$(xml_value app/etc/local.xml username)
	dbpass=$(xml_value app/etc/local.xml password)

	log "${yellow} (dbhost: $dbhost) ${color_end}\n"
	log "${yellow} (dbname: $dbname) ${color_end}\n"
	log "${yellow} (dbuser: $dbuser) ${color_end}\n"
	log "${yellow} (dbpass: $dbpass) ${color_end}\n"

	read -e -p "Deseja efetuar o backup do banco de dados [S/N]: " -i "S" accept

	#log "${red} (Informe ${white}S${color_end}${red} para criar o projeto ambiente_01) ${color_end}\n"
	#read accept

	if [ "$accept" == "S" ]
	then

		mysqldump -h $dbhost -u $dbuser -p$dbpass $dbname | gzip > $file_sql

	fi

	#

	log "${blue} (Processo para backup dos arquivos em $file_tgz) ${color_end}\n"

	read -e -p "Deseja efetuar o backup dos arquivos [S/N]: " -i "S" accept

	if [ "$accept" == "S" ]
	then

		tar -cpzf $file_tgz . --exclude=var --exclude=media

	fi

	#

	read -e -p "Deseja criar o ambiente de teste [S/N]: " -i "" accept

	if [ "$accept" == "S" ]
	then

		mkdir `pwd`/ambiente_01

		cp -Rap app downloader errors includes js lib media pkginfo shell skin var cron.php cron.sh favicon.ico get.php index.php mage .htaccess `pwd`/ambiente_01

		cd `pwd`/ambiente_01

		log "${red} (Avisos) ${color_end}\n"
		log "${yellow} (Foi criado o seguinte diretório `pwd`) ${color_end}\n"
		log "${yellow} (1. Efetue a criação do banco de teste) ${color_end}\n"
		log "${yellow} (2. Importe os dados para o banco de teste) ${color_end}\n"
		log "${yellow} (mysql -h 'dbhost' -u 'dbuser' -p'dbpass' 'dbname' < 'file.sql') ${color_end}\n"
		log "${yellow} (Acesse o phpmyadmin e execute a instrução SQL e altere os value para a nova URL do projeto) ${color_end}\n"
		log "${yellow} (SELECT * FROM core_config_data WHERE path like '%base_url%') ${color_end}\n"
		log "${yellow} (Acesse o projeto, estando funcional execute esse programa agora sem criar o ambiente de teste, onde deve ser feito a mesclagem do módulo para o dirétorio) ${color_end}\n"

		exit

	fi

	#

	log "${red} (Avisos) ${color_end}\n"
	log "${yellow} (Será feito o download e mesclagem do módulo em `pwd`) ${color_end}\n"
	log "${yellow} (Certifique se de ter desativado o Compiler e Cache) ${color_end}\n"

	#

	read -e -p "Deseja prosseguir [S/N]: " -i "" accept

	if [ "$accept" == "S" ]
	then
		log "${green} (Executando) ${color_end}\n"

		chrlen=${#accept} ## string lenght
		#echo $chrlen

		log "${green} (Módulo sendo mesclado ao projeto) ${color_end}\n"

		wget https://github.com/cerebrumgit/php$phpversion_rpl-magento1-cerebrum_telencephalon/archive/master.zip
		unzip master.zip
		cp -Rv php$phpversion_rpl-magento1-cerebrum_telencephalon-master/* .
		rm -fr master.zip php$phpversion_rpl-magento1-cerebrum_telencephalon-master

	else
		log "${red} (Processo abortado) ${color_end}\n"
	fi

	#

	log "${On_Yellow} (Fim) ${color_end}\n"

	#

    # ##
    # functionAfter
    # ##
	functionAfter

}

####################################################################
# load app
####################################################################

set_colors
user_interface
wizard_module ${1} ${2}

exit 0

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

Foi criado o seguinte programa em Shell Script, testado no Ubuntu 15.04

https://github.com/cerebrumgit/cerebrum/blob/master/magento2_install.sh

Antes de executar o script certifique se conferir as variaveis

Para executar o mesmo informe os seguintes comandos no terminal

	wget --no-check-certificate https://raw.githubusercontent.com/cerebrumgit/cerebrum/master/magento2_install.sh
	chmod +x ./magento2_install.sh
	nano magento2_install.sh
	./magento2_install.sh

2. 

./magento2_install.sh

bash: ./magento2_install.sh: Permissão negada

chmod +x ./magento2_install.sh

./magento2_install.sh

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
echo "Assistente de instalação do Magento 2"
echo ""
echo "-------------------------------------------------------------------------"
echo -n -e "${color_end}"
echo

}

magento2_install() {

	#echo -e "Arguments: (${0}) - (${1}) - (${2}) - (${3}) - (${4}) - (${5})"

    # ##
    # functionBefore
    # ##
	functionBefore

	# 

	log "${cyan} (Setando variaveis) ${color_end}\n"

	versao_magento='100.0.0'
	variacao_projeto='dev08'
	nome_projeto="magento2-$versao_magento-$variacao_projeto"
	dbhost='127.0.0.1'
	dbname="$nome_projeto"
	dbname=${dbname//./} # Replace ponto por nada
	dbname=${dbname//-/} # Replace traço por nada
	dbuser='root'
	dbpass='???'
	url_projeto="http://127.0.0.1/public_html/$nome_projeto/magento2/"
	adminfname='Marcio'
	adminlname='Amorim'
	adminemail='suporte@cerebrum.com.br'
	adminuser='admin'
	adminpass='123456a'
	directory_base="/var/www/html/public_html/$nome_projeto"

	# 

	log "${cyan} (Acessa diretório) ${color_end}\n"

	mkdir $directory_base
	cd $directory_base
	ls -all
	pwd

	log "${cyan} (git clone) ${color_end}\n"

	git clone https://github.com/magento/magento2.git
	cd magento2
	ls -all
	pwd

	log "${cyan} (Set file system ownership and permissions) ${color_end}\n"

	sudo chown -R :www-data .

	sudo find . -type d -exec chmod 770 {} \; && sudo find . -type f -exec chmod 660 {} \; && sudo chmod u+x bin/magento

	ls -all
	pwd

	log "${cyan} (Comandos Composer) ${color_end}\n"

	composer --version && sudo composer self-update

	#composer clear-cache && composer update

	log "${cyan} (Executando Composer para instalar dependências) ${color_end}\n"

	composer install

	log "${cyan} (Efetuando backup do arquivo composer.json e editando) ${color_end}\n"

	# http://devdocs.magento.com/guides/v1.0/install-gde/install/sample-data.html#instgde-install-sample-enable-before

	cp composer.json composer.json.bak

	sed -i "s/\"minimum\-stability\"\:\ \"alpha\"/\"minimum\-stability\"\:\ \"beta\"/g" composer.json

	log "${cyan} (Adicionando referência do repositorio do Magento ao composer.json) ${color_end}\n"

	composer config repositories.magento composer http://packages.magento.com

	log "${cyan} (Adicionando suporte a módulo sample data) ${color_end}\n"

	composer require magento/module-sample-data:$versao_magento

	log "${cyan} Criando o banco de dados (${dbname}) ${color_end}\n"

	mysqladmin -u root -p DROP "${dbname}";
	mysqladmin -u root -p CREATE "${dbname}";

	log "${cyan} (Instalando o software Magento a partir da linha de comando) ${color_end}\n"

	php bin/magento setup:install --base-url=$url_projeto \
	--backend-frontname=admin \
	--db-host=$dbhost --db-name=$dbname --db-user=$dbuser --db-password=$dbpass \
	--admin-firstname=$adminfname --admin-lastname=$adminlname --admin-email=$adminemail \
	--admin-user=$adminuser --admin-password=$adminpass --language=pt_BR \
	--currency=BRL --timezone=America/Sao_Paulo \
	--use-sample-data \
	--use-rewrites=1 \
	--sales-order-increment-prefix="ORD$" --session-save=db \
	--cleanup-database

	php index.php

	log "${cyan} (Update Magento configuration) ${color_end}\n"

    mysql -h $dbhost -u $dbuser -p $dbpass $dbname -e "INSERT INTO \`$dbname\`.\`core_config_data\` (\`path\`, \`value\`) VALUES ('dev/template/minify_html', 1), ('dev/js/enable_js_bundling', 1), ('dev/js/merge_files', 1), ('dev/js/minify_files', 1), ('dev/css/merge_css_files', 1), ('dev/css/minify_files', 1), ('web/seo/use_rewrites', 1), ('web/url/redirect_to_base', 1), ('admin/security/use_form_key', 1) ON DUPLICATE KEY UPDATE \`value\` = VALUES(\`value\`);"

	log "${cyan} (Executando Composer para atualizar dependências) ${color_end}\n"

	composer clear-cache && composer update

	log "${cyan} (.htaccess -> enable developer mode) ${color_end}\n"

	cp .htaccess .htaccess.bak

	STRING_DE='#   SetEnv MAGE_MODE developer'
	STRING_PARA='SetEnv MAGE_MODE developer'

	sed -i "s/$STRING_DE/$STRING_PARA/g" .htaccess;

	log "${cyan} (Adicionando suporte a módulos de terceiros) ${color_end}\n"

	php index.php

	composer require magento/sample-bundle-all:*
	#composer require ebizmarts/magento2-mandrill:*
	#composer require ebizmarts/magento2-magemonkey:*
	#composer require ebizmarts/magento2-abandonedcart:*
	#composer require ebizmarts/magento2-autoresponder:*
	#composer require sweettooth/magento2-module-webhook:*
	#composer require cerebrumgit/magento2-bundle-php56:*
	#composer require narayanvarma/magento2-google-tagmanager:*
	#composer require muriloamaral/magento2module:dev-master
	#composer require dmamontov/benchmark-tools ~1.0.2

	log "${cyan} (Para registrar o módulo no Magento2 deve executar o comando a seguir) ${color_end}\n"

	ARRAY_0=("cache:disable" "cache:clean" "cache:flush" "cache:status" "indexer:reindex" "indexer:status" "info:backups:list" "maintenance:status" "module:status" "setup:db-data:upgrade" "setup:db-schema:upgrade" "setup:db:status" "setup:upgrade")
	COUNT=0;

	while [ $COUNT != ${#ARRAY_0[@]} ]
	do

		log "${cyan} (php bin/magento ${ARRAY_0[$COUNT]}) ${color_end}\n"

		php bin/magento ${ARRAY_0[$COUNT]}
		let "COUNT = COUNT +1"

	done 

	#log "${cyan} (Para registrar o módulo no Magento2 deve executar o comando a seguir) ${color_end}\n"

	#sudo chmod 777 -R . && php bin/magento cache:disable && php bin/magento cache:clean && php bin/magento cache:flush && php bin/magento cache:status && php bin/magento maintenance:status && php bin/magento module:status && php bin/magento setup:db:status && php bin/magento setup:upgrade && sudo chmod 777 -R .

	#log "${cyan} (Para atualizar seu repositório local para obter o código mais recente) ${color_end}\n"

	# git reset --hard HEAD && git pull origin develop && sudo composer self-update && composer clear-cache && composer update && php bin/magento cache:disable && php bin/magento cache:clean && php bin/magento cache:flush && php bin/magento cache:status && php bin/magento maintenance:status && php bin/magento module:status && php bin/magento setup:db:status && php bin/magento setup:upgrade && sudo chmod 777 -R .

	#echo 'Remove static and generated files'

	#rm -R -f ./var/* ./pub/static/*

	#log "${cyan} (Clone the sample data repository) ${color_end}\n"

	#cd /var/www/html/public_html

	#git clone -b master https://github.com/magento/magento2-sample-data.git

	#cd magento2-sample-data

	#sudo chown -R :www-data .

	#sudo find . -type d -exec chmod 770 {} \; && sudo find . -type f -exec chmod 660 {} \;

	#php -f ./dev/tools/build-sample-data.php -- --ce-source="/var/www/html/public_html/$nome_projeto"

	#php bin/magento setup:upgrade


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
magento2_install ${1} ${2}

exit 0

![valid XHTML][checkmark]
[checkmark]: http://www.cerebrum.com.br/loja/skin/frontend/base/default/images/logo.png "CEREBRUM"
[requirements]: https://cerebrum.loggly.com/search
[uninstall-mods]: http://devdocs.magento.com/guides/v1.0/install-gde/install/install-cli-uninstall-mods.html
[limites-de-dimensoes-e-de-peso]: http://www.jamef.com.br/para-voce/precisa-de-ajuda/limites-de-dimensoes-e-de-peso
[mao-propria-mp]: http://www.jamef.com.br/para-voce/jamef-de-a-a-z/mao-propria-mp
[aviso-de-recebimento-ar]: http://www.jamef.com.br/para-voce/jamef-de-a-a-z/aviso-de-recebimento-ar
[valor-declarado]: http://www.jamef.com.br/para-voce/jamef-de-a-a-z/valor-declarado
[falecomosjamef]: http://www.jamef.com.br/servicos/falecomosjamef/default.cfm
[encomendas-prazo]: http://www.jamef.com.br/encomendas/prazo/

# wizard_module.sh

## Sinopse

Instalador do módulo Cerebrum_Telencephalon para Magento 1

## Motivação

Disponibilizar ao mercado automação para instalação do nosso módulo

## Característica técnica

Revisado em 01/12/2015 13:53:31

## Como usar

Foi criado o seguinte programa em Shell Script

	https://github.com/cerebrumgit/cerebrum/blob/master/wizard_module.sh

Para usar o mesmo

Antes acesse o Magento e mantenha o Compiler e Cache desativado

Acesse o diretório do Magento e execute o seguinte comando no terminal

	wget --no-check-certificate https://raw.githubusercontent.com/cerebrumgit/cerebrum/master/wizard_module.sh
	chmod +x ./wizard_module.sh
	./wizard_module.sh 5.3

O programa deve executar os seguintes processos:

1. Checagem do recurso de servidor: mbstring, soap, Zend Guard Loader
2. Possibilidade de backup do banco de dados e arquivos do projeto
3. Criação de projeto "ambiente de teste"
4. Mesclagem do módulo ao projeto "Podendo ser usado para instalação/atualização"

--

# magento2_install.sh

## Sinopse

Instalador do Magento 2

## Motivação

Disponibilizar ao mercado instalador para Magento 2

## Característica técnica

Revisado em 01/12/2015 13:53:31

## Como usar

Foi criado o seguinte programa em Shell Script, testado no Ubuntu 15.04

h	ttps://github.com/cerebrumgit/cerebrum/blob/master/magento2_install.sh

Antes de executar o script certifique se conferir as variaveis

Para executar o mesmo informe os seguintes comandos no terminal

	wget --no-check-certificate https://raw.githubusercontent.com/cerebrumgit/cerebrum/master/magento2_install.sh
	chmod +x ./magento2_install.sh
	nano magento2_install.sh
	./magento2_install.sh

## Contribuintes

Equipe Cerebrum

## License

[Comercial License] (LICENSE.txt)

## Badges

[![Join the chat at https://gitter.im/cerebrumgit](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/cerebrumgit/)

:cat2:

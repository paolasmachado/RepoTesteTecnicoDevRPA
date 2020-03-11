*** Settings ***
Documentation   Teste técnico Desenvolvedor RPA
Resource    ../resources/ResourceClashroyale.robot
#Task Teardown   Encerrar execução


*** Tasks ***
Cenário 01: Realizar login no aplicativo da Unicred com um usuário que já tem saldo.
     Adquirir IP Externo do computador
     Acessar o website clashroyale
     Clicar no botão login
     Inserir usuário paolasmachado@gmail.com e senha 12345678
     Clicar em login
     Ir até o menu minha conta
     Criar uma nova chave keyClashRoyaleAPI descrição
     Salvar a token criado
     Consulta clan

*** Settings ***
Documentation   Teste técnico Desenvolvedor RPA
Resource    ../resources/ResourceClashroyale.robot
Task Teardown   Encerrar execução


*** Tasks ***
Teste técnico para posição de Desenvolvedor RPA: Prime Control
#PARTE EXTRA: Obter o endereço IP externo de maneira dinâmica ao invés de deixá-lo fixo no seu código.
     Adquirir IP Externo do computador
#PARTE 1: Utilizando o Robot Framework + Selenium Library.
     Acessar o website clashroyale
     Clicar no botão login
     Inserir usuário paolasmachado@gmail.com e senha 12345678
     Clicar em login
     Ir até o menu minha conta
     Criar uma nova chave keyClashRoyaleAPI descrição
     Salvar a token criado
#PARTE 2: Utilizando o Python
      #Através da API do Clash Royale, obtenha as informações do clã de nome "The resistance", cuja tag começa com #9V2Y e que esteja localizado no Brasil
     Consultar Clan
     # Utilizando a resposta da chamada do passo 1, realizar uma nova chamada para recuperar a lista de membros do clã
     Consultar membros do Clan
     #Escrever num arquivo .csv as seguintes informações de cada membro: - nome(name), - level(expLevel), - troféus(trophies), - papel(role)
     Salvar informações dos membros do clan no arquivo csv

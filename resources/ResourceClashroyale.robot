*** Settings ***
Library         SeleniumLibrary
Library         ../libraries/clashroyale.py
Library         String
# Library         RequestsLibrary
# Library         Collections
# Library         OperatingSystem

*** Variable ***
${HOST_CLASHROYALE}   https://developer.clashroyale.com/
${HOST_MEUIP}   https://www.meuip.com.br/
${NAVEGADOR}      chrome

##ELEMENTOS WEBDRIVER
${LINK_LOGIN}   xpath=//div[@class='login-menu']/a[2]
${CAMPO_USUARIO}   id=email
${CAMPO_SENHA}   id=password
${BOTAO_LOGIN}   xpath=//button[@type='submit']
${MENU_USUARIO}   xpath=//span[@class='dropdown-toggle__text']
${SUBMENU_MINHACONTA}   xpath=//ul[@class='dropdown-menu']/li
${LINK_CRIARNOVACHAVE}    Create New Key
${CAMPO_CHAVE}   id=name
${CAMPO_DESCRICAOCHAVE}   id=description
${CAMPO_IPCHAVE}    id=range-0
${BOTAO_CRIARCHAVE}   xpath=//button[contains(.,'Create Key')]
${MENSAGEM_CONFIRMACAOCHAVECRIADA}    Key created successfully.
${PRIMEIRACHAVE}    xpath=//ul[@class='api-keys']/li[1]
${BOTAO_EXCLUIRCHAVE}   xpath=//button[@type='submit']
${MENSAGEM_CONFIRMACAOCHAVEEXCLUIDA}    Key deleted successfully.
${CAMPO_TOKENGERADO}    xpath=//form[@class='api-key__details']/div[1]
${TEXTO_IPEXTERNO}    //h3[contains(.,'Meu ip é ')]

*** Keywords ***
Acessar o website clashroyale
    Open Browser    ${HOST_CLASHROYALE}   ${NAVEGADOR}
    Maximize Browser Window

Clicar no botão login
    Click Element    ${LINK_LOGIN}

Inserir usuário ${USUARIO} e senha ${SENHA}
    Input Text       ${CAMPO_USUARIO}    ${USUARIO}
    Input Password   ${CAMPO_SENHA}   ${SENHA}

Clicar em login
    Click Button    ${BOTAO_LOGIN}

Ir até o menu minha conta
    Sleep    3s
    Click Element    ${MENU_USUARIO}
    Click Element    ${SUBMENU_MINHACONTA}

Criar uma nova chave ${NOMECHAVE} ${DESCRICAOCHAVE}
    Click Link    ${LINK_CRIARNOVACHAVE}
    Input Text    ${CAMPO_CHAVE}    ${NOMECHAVE}
    Input Text    ${CAMPO_DESCRICAOCHAVE}  ${DESCRICAOCHAVE}
    #IP EXTRAÍDO DA KEYWORD Pegar IP Externo do computador
    Input Text    ${CAMPO_IPCHAVE}    ${MEUIP}
    Click Element    ${BOTAO_CRIARCHAVE}
    Sleep    3s
    Page Should Contain    ${MENSAGEM_CONFIRMACAOCHAVECRIADA}

Salvar a token criado
    Click Element    ${PRIMEIRACHAVE}
    Sleep    3s
    ${TOKEN}   Get Text    ${CAMPO_TOKENGERADO}
    Set Test Variable    ${TOKEN}

Adquirir IP Externo do computador
    Open Browser    ${HOST_MEUIP}   ${NAVEGADOR}
    Maximize Browser Window
    #ARMANEZA O IP NA VARIÁVEL MEUIP COM TEXTO
    ${MEUIP}    Get Text    ${TEXTO_IPEXTERNO}
    #RETIRA DA STRING A INFORMAÇÃO "Meu ip é"
    ${MEUIP}    Get Substring   ${MEUIP}    9    24
    #ARMAZENA NA VARIÁVEL PARA SER UTILIZADO QUANDO CRIAR A CHAVE
    Set Test Variable         ${MEUIP}
    Close Browser

Excluir chave criada
    Click Element    ${BOTAO_EXCLUIRCHAVE}
    Sleep    3s
    Page Should Contain    ${MENSAGEM_CONFIRMACAOCHAVEEXCLUIDA}

Consulta clan
    Get Clan    ${TOKEN}

#EXCLUI A CHAVE CRIADA E FECHA O BROWSER DA EXECUÇÃO
Encerrar execução
    Excluir chave criada
    Close Browser

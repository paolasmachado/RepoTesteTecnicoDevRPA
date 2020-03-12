*** Settings ***
Library         SeleniumLibrary
Library         ../libraries/clashroyale.py
Library         String
Library         Collections
Library         OperatingSystem
Library         RequestsLibrary

*** Variable ***
${HOST_CLASHROYALE}   https://developer.clashroyale.com/
${HOST_MEUIP}   https://www.meuip.com.br/
${NAVEGADOR}      chrome

##ELEMENTOS WEBDRIVER
${COOKIE_ALERT}  xpath=/html/body/div[1]/div/a											  
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
    ${TEM_COOKIE_ALERT}   Run Keyword And Return Status  Page Should Contain Element    ${COOKIE_ALERT}
    Run Keyword If    ${TEM_COOKIE_ALERT}    Click Element    ${COOKIE_ALERT}																									   
Clicar no botão login
    Click Element    ${LINK_LOGIN}

Inserir usuário ${USUARIO} e senha ${SENHA}
    Input Text       ${CAMPO_USUARIO}    ${USUARIO}
    Input Password   ${CAMPO_SENHA}   ${SENHA}

Clicar em login
	Wait Until Element Is Visible   ${BOTAO_LOGIN}											  
    Click Button    ${BOTAO_LOGIN}

Ir até o menu minha conta
    Wait Until Element Is Visible    ${MENU_USUARIO}
    Click Element    ${MENU_USUARIO}
    Click Element    ${SUBMENU_MINHACONTA}

Criar uma nova chave ${NOMECHAVE} ${DESCRICAOCHAVE}
    Click Link    ${LINK_CRIARNOVACHAVE}
	Wait Until Element Is Visible    ${CAMPO_CHAVE}
    Wait Until Element Is Visible    ${BOTAO_CRIARCHAVE}											   
    Input Text    ${CAMPO_CHAVE}    ${NOMECHAVE}
    Input Text    ${CAMPO_DESCRICAOCHAVE}  ${DESCRICAOCHAVE}
    ##IP EXTRAÍDO DA KEYWORD Adquirir IP Externo do computador
    Input Text    ${CAMPO_IPCHAVE}    ${MEUIP}
    Click Element    ${BOTAO_CRIARCHAVE}
    Wait Until Page Contains    ${MENSAGEM_CONFIRMACAOCHAVECRIADA}

Salvar a chave criada
    Wait Until Element Is Visible    ${PRIMEIRACHAVE}
    Click Element    ${PRIMEIRACHAVE}
    Wait Until Element Is Visible    ${CAMPO_TOKENGERADO}
    ${TOKEN}   Get Text    ${CAMPO_TOKENGERADO}
    ${TOKEN}   Get Substring   ${TOKEN}    6
    Set Task Variable    ${TOKEN}

Adquirir IP Externo do computador
    Open Browser    ${HOST_MEUIP}   headless${NAVEGADOR}
	Maximize Browser Window													
    #ARMANEZA O IP NA VARIÁVEL MEUIP COM TEXTO
    ${MEUIP}    Get Text    ${TEXTO_IPEXTERNO}
    #RETIRA DA STRING A INFORMAÇÃO "Meu ip é"
    ${MEUIP}    Get Substring   ${MEUIP}    9    24
    #ARMAZENA NA VARIÁVEL PARA SER UTILIZADO QUANDO CRIAR A CHAVE
    Set Task Variable         ${MEUIP}
    Close Browser

Excluir chave criada
    Wait Until Element Is Visible    ${BOTAO_EXCLUIRCHAVE}
    Scroll Element Into View    ${BOTAO_EXCLUIRCHAVE}
    Click Element    ${BOTAO_EXCLUIRCHAVE}																		 
    Wait Until Page Contains    ${MENSAGEM_CONFIRMACAOCHAVEEXCLUIDA}

Consultar Clan
    ${RESPONSE}   Get Clan    ${TOKEN}										
    ${DADOSCLAN_TAG}   Get From Dictionary     ${RESPONSE.json()["items"][7]}    tag
    Log    Tag: ${DADOSCLAN_TAG}
    Set Task Variable    ${DADOSCLAN_TAG}
    ${DADOSCLAN_NAME}   Get From Dictionary     ${RESPONSE.json()["items"][7]}   name
    Log    Nome: ${DADOSCLAN_NAME}
    ${DADOSCLAN_MEMBROS}   Get From Dictionary     ${RESPONSE.json()["items"][7]}   members
    Log    Quantidade de membro do clan: ${DADOSCLAN_MEMBROS}
    Set Task Variable    ${DADOSCLAN_MEMBROS}
    ${DADOSCLAN_PAIS}   Get From Dictionary     ${RESPONSE.json()["items"][7]["location"]}   name
    Log    País: ${DADOSCLAN_PAIS}

Consultar membros do Clan
    ${DADOSCLAN_TAG}    Get Substring   ${DADOSCLAN_TAG}    1
    ${DADOSCLAN_TAG}    Set Variable    %23${DADOSCLAN_TAG}
    ${RESPONSE}   Get list of clan members    ${TOKEN}      ${DADOSCLAN_TAG}
    Set Task Variable   ${LISTAMEMBROSCLAN}   ${RESPONSE}

Salvar informações dos membros do clan no arquivo csv
    #REMOVE O ARQUIVO EXISTENTE ANTES DE CRIAR OUTRO
    Remove File    listamembrosclan.csv
    Create File    listamembrosclan.csv
    FOR    ${COUNT}    IN RANGE    0    ${DADOSCLAN_MEMBROS}
           ${NOME}   Get From Dictionary     ${LISTAMEMBROSCLAN.json()["items"][${COUNT}]}    name
           ${LEVEL}   Get From Dictionary     ${LISTAMEMBROSCLAN.json()["items"][${COUNT}]}    expLevel
           ${TROFEUS}   Get From Dictionary     ${LISTAMEMBROSCLAN.json()["items"][${COUNT}]}    trophies
           ${PAPEL}   Get From Dictionary     ${LISTAMEMBROSCLAN.json()["items"][${COUNT}]}    role
           ${LINHACSV}   Set Variable    ${NOME};${LEVEL};${TROFEUS};${PAPEL};\n
           Append To File    listamembrosclan.csv    ${LINHACSV}
    END

#EXCLUI A CHAVE CRIADA E FECHA O BROWSER DA EXECUÇÃO
Encerrar execução
    Excluir chave criada
    Close Browser

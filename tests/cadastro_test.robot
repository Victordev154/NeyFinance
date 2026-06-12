*** Settings ***
Library    SeleniumLibrary

Suite Setup       Dado que o usuário acessa a tela de cadastro
Suite Teardown    E fecha o navegador

*** Variables ***
${URL}              http://127.0.0.1:5500/register.html
${BROWSER}          chrome

${INPUT_NOME}       id=f-nome
${INPUT_EMAIL}      id=f-email
${INPUT_SENHA}      id=f-senha
${INPUT_CONFIRMA}   id=f-confirma
${BOTAO_CADASTRAR}  css=button[type=submit]
${ERRO_EMAIL}       id=err-email
${ERRO_SENHA}       id=err-senha

*** Test Cases ***
CT01 - Deve realizar cadastro com dados válidos
    Dado que o usuário informa o nome       Luiz Filipe
    E informa o email                       luizfilipe2@email.com
    E informa a senha                       12345678
    E confirma a senha                      12345678
    Quando solicitar o cadastro
    Então o sistema deve redirecionar para login

CT02 - Deve validar email sem arroba
    Dado que o usuário informa o nome       Luiz Filipe
    E informa o email                       luizfilipeemail.com
    E informa a senha                       12345678
    E confirma a senha                      12345678
    Quando solicitar o cadastro
    Então o sistema deve apresentar erro no email    Informe um e-mail válido.

CT03 - Deve validar email vazio
    Dado que o usuário informa o nome       Luiz Filipe
    E informa o email                       ${EMPTY}
    E informa a senha                       12345678
    E confirma a senha                      12345678
    Quando solicitar o cadastro
    Então o sistema deve apresentar erro no email    Informe um e-mail válido.

CT04 - Deve validar senha curta
    Dado que o usuário informa o nome       Luiz Filipe
    E informa o email                       luizfilipe@email.com
    E informa a senha                       123
    E confirma a senha                      123
    Quando solicitar o cadastro
    Então o sistema deve apresentar erro na senha    Mínimo de 8 caracteres.

CT05 - Deve validar senha vazia
    Dado que o usuário informa o nome       Luiz Filipe
    E informa o email                       luizfilipe@email.com
    E informa a senha                       ${EMPTY}
    E confirma a senha                      ${EMPTY}
    Quando solicitar o cadastro
    Então o sistema deve apresentar erro na senha    Mínimo de 8 caracteres.

*** Keywords ***
Dado que o usuário acessa a tela de cadastro
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window

Dado que o usuário informa o nome
    [Arguments]    ${nome}=${EMPTY}
    Input Text    ${INPUT_NOME}    ${nome}

E informa o email
    [Arguments]    ${email}=${EMPTY}
    Input Text    ${INPUT_EMAIL}    ${email}

E informa a senha
    [Arguments]    ${senha}=${EMPTY}
    Input Password    ${INPUT_SENHA}    ${senha}

E confirma a senha
    [Arguments]    ${confirma}=${EMPTY}
    Input Password    ${INPUT_CONFIRMA}    ${confirma}

Quando solicitar o cadastro
    Click Button    ${BOTAO_CADASTRAR}

Então o sistema deve redirecionar para login
    Wait Until Location Contains    login.html    timeout=5s

Então o sistema deve apresentar erro no email
    [Arguments]    ${mensagem}
    Wait Until Element Is Visible    ${ERRO_EMAIL}    timeout=5s
    Element Text Should Be    ${ERRO_EMAIL}    ${mensagem}

Então o sistema deve apresentar erro na senha
    [Arguments]    ${mensagem}
    Wait Until Element Is Visible    ${ERRO_SENHA}    timeout=5s
    Element Text Should Be    ${ERRO_SENHA}    ${mensagem}

E fecha o navegador
    Close Browser

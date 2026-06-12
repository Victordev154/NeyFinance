*** Settings ***
Library    SeleniumLibrary

Suite Setup       Dado que o usuário acessa a tela de login
Suite Teardown    E fecha o navegador

*** Variables ***
${URL}          http://127.0.0.1:5500/login.html
${BROWSER}      chrome

${INPUT_EMAIL}  id=f-email
${INPUT_SENHA}  id=f-senha
${BOTAO_LOGIN}  css=button[type=submit]
${MENSAGEM}     id=alert-msg

*** Test Cases ***
CT01 - Deve realizar login com credenciais válidas
    Dado que o usuário informa o email    luizfilipe@email.com
    E informa a senha    123456
    Quando solicitar o login
    Então o sistema deve apresentar a mensagem    Login realizado! Redirecionando…

CT02 - Deve validar email vazio
    Dado que o usuário informa o email    ${EMPTY}
    E informa a senha    123456
    Quando solicitar o login
    Então o sistema deve apresentar a mensagem    Preencha e-mail e senha.

CT03 - Deve validar senha vazia
    Dado que o usuário informa o email    luizfilipe@email.com
    E informa a senha    ${EMPTY}
    Quando solicitar o login
    Então o sistema deve apresentar a mensagem    Preencha e-mail e senha.

CT04 - Deve validar credenciais inválidas
    Dado que o usuário informa o email    luizfilipe@email.com
    E informa a senha    senhaerrada
    Quando solicitar o login
    Então o sistema deve apresentar a mensagem    E-mail ou senha inválidos.

*** Keywords ***
Dado que o usuário acessa a tela de login
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window

Dado que o usuário informa o email
    [Arguments]    ${email}=${EMPTY}
    Input Text    ${INPUT_EMAIL}    ${email}

E informa a senha
    [Arguments]    ${senha}=${EMPTY}
    Input Password    ${INPUT_SENHA}    ${senha}

Quando solicitar o login
    Click Button    ${BOTAO_LOGIN}

Então o sistema deve apresentar a mensagem
    [Arguments]    ${mensagem}
    Wait Until Element Is Visible    ${MENSAGEM}    timeout=5s
    Element Text Should Be    ${MENSAGEM}    ${mensagem}

E fecha o navegador
    Close Browser

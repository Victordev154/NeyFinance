*** Settings ***
Library    SeleniumLibrary

Suite Setup       Abrir Navegador
Suite Teardown    Fechar Navegador

*** Variables ***
${URL}          http://127.0.0.1:5500/NeyFinanceUsu/login.html
${BROWSER}      chrome

${EMAIL}        id=f-email
${SENHA}        id=f-senha
${BTN_LOGIN}    id=btn-login
${BTN_SAIR}     xpath=//button[contains(.,'Sair')]

*** Test Cases ***

CT01 - Regra 1 - Email cadastrado e senha correta
    Go To    ${URL}

    Input Text        ${EMAIL}    joao@teste.com
    Input Password    ${SENHA}    123456
    Click Button      ${BTN_LOGIN}

    Wait Until Element Is Visible    ${BTN_SAIR}    10s

    Click Element     ${BTN_SAIR}

CT02 - Regra 2 - Email cadastrado e senha incorreta
    Go To    ${URL}

    Input Text        ${EMAIL}    joao@teste.com
    Input Password    ${SENHA}    senhaerrada
    Click Button      ${BTN_LOGIN}

    Sleep    2s

CT03 - Regra 3 - Email inexistente e senha correta
    Go To    ${URL}

    Input Text        ${EMAIL}    inexistente@teste.com
    Input Password    ${SENHA}    123456
    Click Button      ${BTN_LOGIN}

    Sleep    2s

CT04 - Regra 4 - Email inexistente e senha incorreta
    Go To    ${URL}

    Input Text        ${EMAIL}    inexistente@teste.com
    Input Password    ${SENHA}    senhaerrada
    Click Button      ${BTN_LOGIN}

    Sleep    2s

*** Keywords ***

Abrir Navegador
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window

Fechar Navegador
    Close Browser
    
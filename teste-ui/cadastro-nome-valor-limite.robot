*** Settings ***
Library    SeleniumLibrary

Suite Setup       Abrir Tela De Cadastro
Suite Teardown    Fechar Navegador

*** Variables ***
${URL}          http://127.0.0.1:5500/NeyFinanceUsu/register.html
${BROWSER}      chrome

*** Test Cases ***

CT01 - Nome com 2 caracteres
    Preencher Cadastro    Jo    jo@email.com    123456    123456
    Clicar Em Criar Conta

CT02 - Nome com 3 caracteres
    Preencher Cadastro    Ana    ana@email.com    123456    123456
    Clicar Em Criar Conta

CT03 - Nome com 4 caracteres
    Preencher Cadastro    João    joao@email.com    123456    123456
    Clicar Em Criar Conta

CT04 - Nome com 101 caracteres
    ${nome_longo}=    Set Variable    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA

    Preencher Cadastro
    ...    ${nome_longo}
    ...    teste@email.com
    ...    123456
    ...    123456

    Clicar Em Criar Conta

*** Keywords ***

Abrir Tela De Cadastro
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window

Preencher Cadastro
    [Arguments]    ${nome}    ${email}    ${senha}    ${confirmar}

    Input Text        id=f-nome        ${nome}
    Input Text        id=f-email       ${email}
    Input Password    id=f-senha       ${senha}
    Input Password    id=f-confirma    ${confirmar}

Clicar Em Criar Conta
    Click Button    id=btn-reg

Fechar Navegador
    Close Browser
*** Settings ***
Library    SeleniumLibrary

Suite Setup       Abrir Tela De Cadastro
Suite Teardown    Fechar Navegador

*** Variables ***
${URL}        http://127.0.0.1:5500/NeyFinanceUsu/register.html
${BROWSER}    chrome

*** Test Cases ***

CT01 - Senha com 5 caracteres
    Preencher Cadastro
    ...    João Silva
    ...    joao@email.com
    ...    12345
    ...    12345

    Clicar Em Criar Conta

CT02 - Senha com 6 caracteres
    Preencher Cadastro
    ...    João Silva
    ...    joao@email.com
    ...    123456
    ...    123456

    Clicar Em Criar Conta

CT03 - Senha com 21 caracteres
    ${senha_longa}=    Set Variable    123456789012345678901

    Preencher Cadastro
    ...    João Silva
    ...    joao@email.com
    ...    ${senha_longa}
    ...    ${senha_longa}

    Clicar Em Criar Conta

*** Keywords ***

Abrir Tela De Cadastro
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Wait Until Element Is Visible    id=f-nome    10s

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
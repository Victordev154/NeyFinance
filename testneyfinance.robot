*** Settings ***

Library     RequestsLibrary
Library     Collections
Library     String

Suite Setup     Criar Sessao Da API
Suite Teardown  Delete All Sessions

*** Variables ***
${BASE_URL}         http://localhost:8080
${LOGIN}            joao@teste.com
${SENHA}            123456
${TOKEN}            ${EMPTY}
${LANCAMENTO_ID}    ${EMPTY}

*** Test Cases ***

TC-01 Login deve retornar token JWT
    [Documentation]    Autentica o usuário e armazena o token para os próximos testes
    [Tags]    autenticacao    smoke

    ${body}=    Create Dictionary
    ...    login=${LOGIN}
    ...    senha=${SENHA}

    ${response}=    POST On Session
    ...    neyfinance
    ...    /usuarios/login
    ...    json=${body}

    # Verificações
    Should Be Equal As Integers    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()}    token

    # Armazena o token para uso nos próximos casos de teste
    ${token_obtido}=    Get From Dictionary    ${response.json()}    token
    Set Suite Variable    ${TOKEN}    ${token_obtido}

    Log    Token obtido: ${TOKEN}

TC-02 Cadastrar lancamento de receita deve retornar 200
    [Documentation]    Cria um lançamento de receita e valida a resposta
    [Tags]    lancamento    crud

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${TOKEN}
    ...    Content-Type=application/json

    ${body}=    Create Dictionary
    ...    usuarioId=${1}
    ...    descricao=Salário Junho
    ...    valor=${5000.00}
    ...    tipo=RECEITA
    ...    categoria=SALARIO
    ...    data=2025-06-01

    ${response}=    POST On Session
    ...    neyfinance
    ...    /lancamentos
    ...    json=${body}
    ...    headers=${headers}

    Should Be Equal As Integers    ${response.status_code}    200
    ${body_resp}=    Set Variable    ${response.json()}

    Dictionary Should Contain Key    ${body_resp}    id
    Should Be Equal As Strings    ${body_resp}[descricao]     Salário Junho
    Should Be Equal As Strings    ${body_resp}[tipoLancamento]    RECEITA
    Should Be Equal As Numbers    ${body_resp}[valor]         5000.0

    # Salva o ID para usar no TC-04 (exclusão)
    Set Suite Variable    ${LANCAMENTO_ID}    ${body_resp}[id]

    Log    Lançamento criado com ID: ${LANCAMENTO_ID}

TC-03 Listar lancamentos do usuario deve retornar lista nao vazia
    [Documentation]    Lista os lançamentos do usuário 1 e valida que há itens
    [Tags]    lancamento    listagem

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${TOKEN}

    ${response}=    GET On Session
    ...    neyfinance
    ...    /lancamentos/usuario/1
    ...    headers=${headers}

    Should Be Equal As Integers    ${response.status_code}    200

    ${lista}=    Set Variable    ${response.json()}
    Should Not Be Empty    ${lista}

    # Verifica que o lançamento criado no TC-02 está na lista
    ${primeiro}=    Get From List    ${lista}    0
    Dictionary Should Contain Key    ${primeiro}    id
    Dictionary Should Contain Key    ${primeiro}    descricao
    Dictionary Should Contain Key    ${primeiro}    valor

    Log    Total de lançamentos encontrados: ${lista.__len__()}

TC-04 Excluir lancamento deve retornar 204
    [Documentation]    Exclui o lançamento criado no TC-02 e valida o retorno 204
    [Tags]    lancamento    crud    exclusao

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${TOKEN}

    ${response}=    DELETE On Session
    ...    neyfinance
    ...    /lancamentos/${LANCAMENTO_ID}
    ...    headers=${headers}

    Should Be Equal As Integers    ${response.status_code}    204

    Log    Lançamento ${LANCAMENTO_ID} excluído com sucesso

TC-05 Requisicao sem token deve retornar 403
    [Documentation]    Tenta acessar endpoint protegido sem autenticação
    [Tags]    seguranca    negativo

    ${response}=    POST On Session
    ...    neyfinance
    ...    /lancamentos
    ...    json=${{{"usuarioId": 1, "descricao": "Teste", "valor": 100, "tipo": "DESPESA", "categoria": "OUTROS", "data": "2025-06-01"}}}
    ...    expected_status=403

    Should Be Equal As Integers    ${response.status_code}    403
    Log    Segurança validada — acesso negado sem token

*** Keywords ***
Criar Sessao Da API
    [Documentation]    Cria a sessão HTTP reutilizada em todos os testes
    Create Session    neyfinance    ${BASE_URL}    verify=False
pm.test("Status code é 200", function () {
    pm.response.to.have.status(200);
});

pm.test("Resposta contém token", function () {
    var jsonData = pm.response.json();
    pm.expect(jsonData.token).to.exist;
});

pm.test("Tempo de resposta menor que 2000ms", function () {
    pm.expect(pm.response.responseTime).to.be.below(2000);
});
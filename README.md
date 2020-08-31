# [Lua] libTest 

## Funções 

* createTests(name, testArrays) - Essa função cria uma array de testes a serem executados em uma determinada ordem.
    - Esta função ainda possui os metodos:
        - runAll() - Que executa todos os Testes de uma vez.
        - runTest(test) - executa apenas uma dos testes, sendo este argumento uma string com o nome do index ou um numero.
        - debug.printNames() - printa na tela o nome de todos os testes.

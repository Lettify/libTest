require('libTest')()

createTests('Primeiro Teste', {
    describe('teste do Sum!', function()
        local a = 5
        local b = 10

        expected('sum test', sum, a, b).toBe(15)
    end),

    describe('teste do mut', function()
        local a = 5
        local b = 2

        expected('mut test', mut, a, b).toReturn(11)
    end),

    describe('teste do return', function()
        expected('concat test', function(a, b)
            return a..b
        end, 'a', 'b').toReturnType('string')
    end)

}):runAllTests()






function sum(a,b)
    return a + b
end

function mut(a,b)
    return a * b
end

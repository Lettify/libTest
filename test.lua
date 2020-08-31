createTests('tests', {
    sum = describe('sum', function()
        local a = 1
        local b = 1

        local sum = a + b
        print(expected('sum', sum).toBe(2))
    end)
}):run()


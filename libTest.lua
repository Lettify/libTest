function createTests(name, array)
    return {
        __name = name,
        __array = array,
        runAll = function(self) for i, v in pairs(self.__array) do v:run() end end,
        runTest = function(self, i) if self.__array[i] ~= nil then self.__array[i]:run() end end,
    }
end

function describe(name, func)
    return {
        __name = name,
        __func = func,
        run = function(self) return self.__func() end,
        getFunc = function(self) return self.__func end,
        getName = function(self) return self.__name end,
    } 
end

function expected(name, f)
    local f = type(f) == 'function' and f() or f
    return {
        toBe = function(n)
            assert(f == n, '[expected().toBe] - Test has failed!')
            return true
        end,
    }
end


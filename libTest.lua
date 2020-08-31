function describe(name, func)
    return {
        __name = name,
        __func = func,
        run = function(self) return self.__func() end,
        getFunc = function(self) return self.__func end,
        getName = function(self) return self.__name end,
    } 
end

function createTests(name, array)
    return {
        __name = name,
        __array = array,
        run = function(self)
            for i, v in pairs(self.__array) do v:run() end
        end,
    }
end


function sendDebug(name, message, i)
    return {
        failed = function(name, i) print(debug.getinfo(i).short_src .. ':'..debug.getinfo(i).currentline .. ' ['..name..'] - Test has Failed!') end,
        sucess = function(name, i) print(debug.getinfo(i).short_src .. ':'..debug.getinfo(i).currentline .. ' ['..name..'] - Test has Succeed!') end,
    }
end

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

function expected(name,func)
    local f = type(func) == 'function' and func() or func
    return {
        toBe = function(n)
            if f == n then 
                sendDebug().sucess(name, 3)
            else 
                sendDebug().failed(name, 3)
            end 
        end,
    }
end


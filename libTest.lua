function sendDebug(name, message, i)
    return {
        failed = function(name, i) print(debug.getinfo(i).short_src .. ':'..debug.getinfo(i).currentline .. ' ['..name..'] - Test has Failed!') end,
        sucess = function(name, i) print(debug.getinfo(i).short_src .. ':'..debug.getinfo(i).currentline .. ' ['..name..'] - Test has Succeed!') end,
        result = function(condition, name, i) if condition == true then sendDebug().sucess(name, i) else sendDebug().failed(name, i) end end,
    }
end

function functionHasReturn(func)
   local d = string.dump(func)
   assert(d:sub(1,5) == "\27LuaQ") 
   d = d:match"^.-\30%z\128%z"
   for pos = #d % 4 + 1, #d, 4 do
      local b1, b2, b3, b4 = d:byte(pos, pos+3)
      local dword = b1 + 256 * (b2 + 256 * (b3 + 256 * b4))
      local OpCode, BC = dword % 64, math.floor(dword/16384)
      local B, C = math.floor(BC/512), BC % 512
      if OpCode == 30 and C == 0 and B ~= 1 then return true end
   end
   return false
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

function expected(name, func, ...)
    local f = type(func) == 'function' and func(...) or func
    return {
        toBe = function(n) sendDebug().result(f == n, name, 3) end,
        toReturn = function(n) sendDebug().result(f == n, name, 3) end,
    }
end

function sum(a,b) 
    return a + b
end

print(expected('sum', sum, 1, 3).toReturn(3))

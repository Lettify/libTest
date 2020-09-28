local Cache = {} 
local callMeta = { __call = function(self, ...) return self:isValidInterface(...) end }

function interfaceExists(name)
    if Cache[name] == nil then return false end 
    return true 
end

function createInterface(name, interfaceTable)
    Cache[name] = setmetatable({
        __name = name,
        __type = 'interfaceObject',
        interface = interfaceTable,
        validate = function(self, validateTable)
            print(validateTable)
        end,
    }, callMeta)
end

function returnInterface(name)
    if Cache[name] ~= nil and Cache[name].__type == 'interfaceObject' then
        return Cache[name]
    end 
    return false
end

function Interface(name, interfaceTable)
    if interfaceExists(name) == false then createInterface(name, interfaceTable)
    else returnInterface(name):validate(interfaceTable) end
end

Interface('test', { name = 'string', event = 'event' })
Interface('test', {name = 'dev', event = 'oi'})

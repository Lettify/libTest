-- function name(arg) *1 -> name {} -> f({}) --

local GlobalInterfaces = {}
local interfaceCallMeta = { __call = function(self, ...) return self:validateInterface(self,...) end } 

function interfaceExists(name)
    return GlobalInterfaces[name] ~= nil or false
end

function isInterfaceObject(interface)
    return interface.__type == 'interfaceObject' or false
end

function getInterfaceObject(name)
    if interfaceExists(name) == true then
        return GlobalInterfaces[name] 
    end
    return false
end

function isValidInterface(interfaceTable)
    local errors = {}
    for field, v in pairs(interfaceTable) do 
        if type(field) ~= 'string' or type(v) ~= 'string' then 
            table.insert(errors, field)
        end
    end
    return #errors == 0 or false
end

function Interface(interfaceTable)
    assert(type(interfaceTable) == 'table', '[Interface] - Expected a \'table\' on #1 argument and got '..type(interfaceTable))
    assert(interfaceTable.__name__ ~= nil, '[Interface] - Expected a field \'__name__\' and got none')
    if interfaceExists(interfaceTable.__name__) == false then 
        assert(isValidInterface(interfaceTable) == true, '[Interface] - Invalid interface construction, please make sure that every field has a \'string\' value.')
        GlobalInterfaces[interfaceTable.__name__] = {
            __name = interfaceTable.__name__,
            __type = 'interfaceObject',
            interface = interfaceTable,
            validateInterface = function(self, validateTable)
                assert(type(validateTable) == 'table', '[validateInterface] - Expected a \'table\' on #1 argument and got a '..type(validateTable))
                if self:hasSameMethods(validateTable) == true then 
                    return self:hasSameTypes(validateTable) == true or self:getDiffTypes(validateTable)
                else self:getMissingFields(validateTable) end
            end,
            hasSameMethods = function(self, validateTable)
                if self.interface['__name__'] ~= nil then self.interface['__name__'] = nil end
                for field, v in pairs(self.interface) do 
                    if validateTable[field] == nil then
                        return false 
                    end 
                end
                return true
            end,
            hasSameTypes = function(self, validateTable)
                for field, v in pairs(self.interface) do 
                    if type(validateTable[field]) ~= v then
                        return false
                    end
                end
                return true
            end,
            getDiffMethods = function(self, validateTable)
                for field, v in pairs(self.interface) do 
                    if validateTable[field] == nil then 
                        print('[Interface] - Missing Field: '..field)
                    end
                end
            end,
            getDiffTypes = function(self, validateTable) 
                for field, v in pairs(self.interface) do 
                    if type(validateTable[field]) ~= v then 
                        print('[getDiffTypes] - Field: '..field..' expected \''..v..'\' and got ' ..type(validateTable[field]))
                    end
                end
            end,
            getMissingFields = function(self, validateTable)
                for field, v in pairs(self.interface) do 
                    if validateTable[field] == nil then 
                        print('[getMissingFields] - Missing field: '..field)
                    end
                end
            end,
        } 
    else return getInterfaceObject(interfaceTable.__name__):validateInterface(interfaceTable) end
end

Interface {
    __name__ = 'test',
    name = 'string',
}

function getInterface(name, validateInterface)
    if interfaceExists(name) == true then 
        return getInterfaceObject(name):validateInterface(validateInterface)
    end
end

print(getInterface('test', {name = 23}))

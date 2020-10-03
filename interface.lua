-- function name(arg) *1 -> name {} -> f({}) --

local GlobalInterfaces = {}
local interfaceCallMeta = { __call = function(self, ...) return self:validateInterface(self,...) end }
local validTypes = {
    luaTypes = {'string', 'number', 'boolean', 'table'},
    customTypes = {
        ['interfaceObject'] = function (interface)
            if (type(interface) == 'table') then
                return (interface.__type == 'interfaceObject' and interface.__name and GlobalInterfaces[tostring(interface.__name)]) or false
            end
            return false
        end
    }
}

function isLuaType(typeValue)
    for _, v in ipairs(validTypes.luaTypes) do
        if (typeValue == v) then
            return true
        end
    end
    return false
end

function getTypeNameByTypeValue(typeValue)
    for typeName, tV in pairs(validTypes) do
        if (isLuaType(typeValue)) then
            return typeName
        else
            if (typeName == 'customTypes') then
                for typeName2, _ in pairs(tV) do
                    if (typeValue == typeName2) then
                        return typeName
                    end
                end
            end
        end
    end
    return false
end

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

function Interface(name, interfaceTable)
    assert(type(name) == 'string', '[createInterface] - Expected a \'string\' on #1 argument and got '..type(name))
    assert(type(interfaceTable) == 'table', '[createInterface] - Expected a \'table\' on #2 argument and got '..type(interfaceTable))
    if interfaceExists(name) == false then 
        assert(isValidInterface(interfaceTable) == true, '[Interface] - Invalid interface construction, please make sure that every field has a \'string\' value.')
        GlobalInterfaces[name] = {
            __name = name,
            __type = 'interfaceObject',
            interface = interfaceTable,
            validateInterface = function(self, validateTable)
                assert(type(validateTable) == 'table', '[validateInterface] - Expected a \'table\' on #1 argument and got a '..type(validateTable))
                if self:hasSameMethods(validateTable) == true then 
                    return self:hasSameTypes(validateTable) == true or self:getDiffTypes(validateTable)
                else self:getMissingFields(validateTable) end
            end,
            hasSameMethods = function(self, validateTable)
                for field, v in pairs(self.interface) do 
                    if validateTable[field] == nil then
                        return false 
                    end 
                end
                return true
            end,
            hasSameTypes = function(self, validateTable)
                for field, v in pairs(self.interface) do
                    if (getTypeNameByTypeValue(v) == 'luaTypes' and type(validateTable[field]) ~= v) then
                        return false
                    elseif (getTypeNameByTypeValue(v) == 'customTypes' and validTypes.customTypes[v](validateTable[field]) == false) then
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
                    if (getTypeNameByTypeValue(v) == 'luaTypes' and type(validateTable[field]) ~= v) then 
                        print('[getDiffTypes] - Field: ('..field..') expected \''..v..'\' and got ' ..type(validateTable[field]))
                    elseif (getTypeNameByTypeValue(v) == 'customTypes' and validTypes.customTypes[v](validateTable[field]) == false) then
                        print('[getDiffTypes] - Field: ('..field..') expected \''..v..'\'')
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
    else return getInterfaceObject(name):validateInterface(interfaceTable) end
end

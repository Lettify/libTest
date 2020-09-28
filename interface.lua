local callMeta = { __call = function(self, ...) return self.validate(self, ...) end }

function Interface(interface, name)
    return setmetatable({
        __name = name or 'default',
        __type = 'interfaceObject',
        interface = interface,
        validate = function(self, validadeInterface)
            assert(type(validadeInterface) == 'table', '[Interface - '..self.__name..'] - Expected a \'table\' on #1 argument and got '..type(validadeInterface)) 
            if hasSameFields(self.interface, validadeInterface) == true then 
                for i, v in pairs(self.interface) do 
                    if type(validadeInterface[i]) == v then 
                        print(getFieldType(self.interface, validadeInterface))
                    else
                        print('Não sao do mesmo tipo')
                    end
                end
            else 
                print(unpack(getDiffFields(self.interface, validadeInterface)))
            end
        end,
    }, callMeta)
end

function getFieldType(t, validateField)
    for i, v in pairs(t) do 
        if type(validateField[i]) ~= v then 
            return i
        end
    end
    return true
end

function hasSameFields(t, validateTable)
    for i, v in pairs(t) do 
        if validateTable[i] == nil then return false end
    end
    return true
end

function getDiffFields(t, validateTable)
    local index = {}
    for i, v in pairs(t) do 
        if validateTable[i] == nil then table.insert(index, tostring(i)) end
    end
    return #index >= 1 and index or false
end


local teste = Interface({
    name = 'string',
    age = 'number',
})

print(teste({name = 'oi', age = 23}))


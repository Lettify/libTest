local callMeta = { __call = function(self, ...) return self:validate(...) end }

function isValidInterface(interface)
    local errors = {}
    for field, v in pairs(interface) do 
        if type(field) ~= 'string' or type(v) ~= 'string' then table.insert(errors, field) end
    end
    return #errors >= 1 and errors or true  
end

function Interface(interface, name)
    assert(isValidInterface(interface) == true, '[Interface] - Invalid interface construction, please make sure that every field has a \'string\' value.')
    return setmetatable({
        __name = name or 'default',
        __type = 'interfaceObject',
        interface = interface,
        validate = function(self, validateInterface)
            assert(type(validateInterface) == 'table', '[Interface - '..self.__name..'] - Expected a \'table\' on #1 argument and got '..type(validadeInterface)) 
            if self:hasSameFields(validateInterface) == true then 
                local returnValue = 0
                for field, v in pairs(validateInterface) do 
                    if self:getFieldType(field, validateInterface) == false then
                        print('Name: '..self.__name..' (f)_getDiffFields ['..field..'] - Expected \''..self.interface[field]..'\' and got '..type(validateInterface[field]))
                        returnValue = returnValue + 1
                    end
                end
                return returnValue == 0 and true or false
            else return false, self:getDiffFields(validateInterface) end
        end,
        hasSameFields = function(self, validateInterface)
            for field, v in pairs(self.interface) do 
                if validateInterface[field] == nil then return false end 
            end
            return true
        end,
        getDiffFields = function(self, validateInterface) 
            local index = {}
            for field, _ in pairs(self.interface) do 
                if validateInterface[field] == nil then table.insert(index, tostring(field)) end 
            end
            return index
        end,
        hasSameType = function(self, validateInterface) 
            for field, t in pairs(self.interface) do 
                if type(validateInterface[i]) ~= t then return false end
            end
            return true
        end,
        getFieldType = function(self, field, validateInterface)
            if type(validateInterface[field]) ~= self.interface[field] then return false end  
        end,
    }, callMeta)
end


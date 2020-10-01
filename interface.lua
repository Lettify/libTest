-- function name(arg) *1 -> name {} -> f({}) --

local GlobalInterfaces = {}
local interfaceCallMeta = { __call = function(self, ...) return self:validateInterface(self,...) end }
local validTypes = {'string', 'number', 'boolean', 'table'}

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

function isStringEqToValidType(str) -- String equivalente à um dos tipos válidos da tabela global?
	for _, valTypes in ipairs(validTypes) do
		if (str == valTypes) then
			return true
		end
	end
	return false
end

function areValidTypesSpecified(interfaceTable)
	local fieldsNotValid = {}
	for field, valType in pairs(interfaceTable) do
		if not (isStringEqToValidType(valType)) then
			table.insert(fieldsNotValid, {fieldName = field, fieldValType = valType})
		end
	end
	if (#fieldsNotValid > 0) then
        return false, fieldsNotValid
    else
        return true
    end
end

function Interface(name, interfaceTable)
    assert(type(name) == 'string', '[createInterface] - Expected a \'string\' on #1 argument and got '..type(name))
    assert(type(interfaceTable) == 'table', '[createInterface] - Expected a \'table\' on #2 argument and got '..type(interfaceTable))
    if interfaceExists(name) == false then 
        assert(isValidInterface(interfaceTable) == true, '[Interface] - Invalid interface construction, please make sure that every field has a \'string\' value.')
		local fieldValid, infoTable = areValidTypesSpecified(interfaceTable)
		if not (fieldValid) then
			for _, tInfo in ipairs(infoTable) do
				print("Field ["..tInfo.fieldName.."] declarou '"..tInfo.fieldValType.."' como valor esperado, mas é INVÁLIDO!")
			end
            error("Não foi possível prosseguir com a criação da Interface "..name..". Veja o motivo acima.")
		end
        GlobalInterfaces[name] = {
            __name = name,
            __type = 'interfaceObject',
            interface = interfaceTable,
            validateInterface = function(self, validateTable)
                assert(type(validateTable) == 'table', '[validateInterface] - Expected a \'table\' on #1 argument and got a '..type(validateTable))
                if self:hasSameMethods(validateTable) == true then 
                    if self:hasSameTypes(validateTable) == true then
                        return true
                    else self:getDiffTypes(validateTable) end
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
                        print('[getDiffTypes] - Field: ('..field..') expected \''..v..'\' and got \'' ..type(validateTable[field])..'\'')
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

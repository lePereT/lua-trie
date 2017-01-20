local methods = {}

local function mknode() 
    return {
        children = {},
        value = nil
    }
end

function methods:set(keyiter, value)
    local cur_node = self.root
    for x in keyiter do
        local child = cur_node.children[x]
        if child == nil then
            child = mknode()
            cur_node.children[x] = child
        end
        cur_node = child
    end
    cur_node.value = value
end

function methods:get(keyiter)
    local cur_node = self.root
    for x in keyiter do
        local child = cur_node.children[x]
        if child == nil then
            return nil
        end
        cur_node = child
    end
    return cur_node.value
end

function methods:longest_prefix(keyiter)
    local cur_node = self.root
    local prefix = {}
    local value = nil

    local stack = {}
    for x in keyiter do
        if cur_node.value ~= nil then
            value = cur_node.value
            for _, v in ipairs(stack) do
                table.insert(prefix, v)
            end
            stack = {}
        end

        local child = cur_node.children[x]
        if cur_node.children[x] == nil then
            break
        end

        table.insert(stack, x)
        cur_node = cur_node.children[x]
    end
    if cur_node.value ~= nil then
        value = cur_node.value
        for _, v in ipairs(stack) do
            table.insert(prefix, v)
        end
    end
    return prefix, value
end

local function new()
    return setmetatable({
        root = mknode()
    },
    {
        __index = methods
    })
end

return setmetatable({}, {
  __call = new
})

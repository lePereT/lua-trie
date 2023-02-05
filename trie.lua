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

function methods:match(keyiter)
    local cur_node_list = {self.root}
    local next_node_list = {}
    local ret_vals = {}
    for elem in keyiter do
        for _, cur_node in ipairs(cur_node_list) do
            -- first check for fully wild
            local fully_wild = cur_node.children[self.full_wild]
            if fully_wild then
                if fully_wild.value then table.insert( ret_vals, fully_wild.value ) end
            end
            -- second check for partially wild
            local partially_wild = cur_node.children[self.part_wild]
            if partially_wild then
                table.insert( next_node_list, partially_wild )
            end
            -- third check for actual
            local actual_match = cur_node.children[elem]
            if actual_match then
                table.insert( next_node_list, actual_match )
            end
        end
        if #next_node_list > 0 then
            cur_node_list = next_node_list
            next_node_list = {}
        else
            cur_node_list = {}
            break
        end
    end
    for _, i in ipairs(cur_node_list) do
        if i.value then table.insert( ret_vals, i.value ) end
    end
    for _, i in ipairs(ret_vals) do print("ret val is "..i) end
    print("here, return list is size "..#ret_vals)
    return ret_vals
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

local function new(partial, full)
    return setmetatable({
        root = mknode(),
        part_wild = partial,
        full_wild = full
    },
    {
        __index = methods
    })
end

return {
    new = new
}

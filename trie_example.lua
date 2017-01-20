#!/usr/bin/env lua

if not arg[1] then
    print (("Usage: %s <word>"):format(arg[0]))
    return
end

local trie = require "trie"

local function iterstr(str)
    return str:gmatch"."
end

local keys = {
    "abc",
    "def",
    "dfdsfdsfsdaf2dwdf",
    "qwerty",
    "12345",
    "123"
}

local t = trie()
for i, v in ipairs(keys) do
    t:set(iterstr(v), i)
end

print(("Exact match: %s"):format(t:get(iterstr(arg[1])) or "none"))
local pfx, val = t:longest_prefix(iterstr(arg[1]))
print(("Longest prefix: %s => %s"):format(table.concat(pfx, ""), val or "none"))

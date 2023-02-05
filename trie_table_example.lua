#!/usr/bin/env lua

if not arg[1] then
    print (("Usage: %s <period separated table>"):format(arg[0]))
    return
end

local trie = require "trie"

-- split("a,b,c", ",") => {"a", "b", "c"}
local function split(s, sep)
    local fields = {}
    local sep = sep or "."
    local pattern = string.format("([^%s]+)", sep)
    string.gsub(s, pattern, function(c) fields[#fields + 1] = c end)
    return fields
end

local function list_iter (t)
    local i = 0
    local n = #t
    return function ()
            i = i + 1
            if i <= n then return t[i] end
        end
end

local keys = {
    {"foo", "bar", "fizz", "buzz", "plop"},
    {"foo", "bar", "fizz", "buzz"},
    {"foo", "bar", "fizz"},
    {"foo", "bar", ">"},
    {"foo", "?", "donkey"},
    {"foo", "bar", "fizz"},
    {"foo", "bar"},
    {"foo", "bat"},
    {"foo"},
    {">"}
}

local t = trie.new("?", ">")
for i, v in ipairs(keys) do
    t:set(list_iter(v), i)
end

local arg = split(arg[1])

local results = t:match(list_iter(arg))
print(results)
for k, v in ipairs(results) do
    print(k,v)
end
local pfx, val = t:longest_prefix(list_iter(split(arg[1])))
print(("Longest prefix: %s => %s"):format(table.concat(pfx, "."), val or "none"))

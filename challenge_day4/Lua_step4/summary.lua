-- Create a Metatable
SummaryMetaTable = {
    __add = function (left, right)
        local newSummary = {super=0, good=0, middle=0, low=0}
        for k, v in pairs(left) do
            newSummary[k] = v + right[k]
        end
        return newSummary
    end
}

-- Read JSON data from file
local jsonFile = io.open("/Users/voldemarq/late-group/challenge_day4/fulldata/data1.json", "r")
local jsonContent = jsonFile:read("*all")
jsonFile:close()

-- Basic JSON parsing (you might want to use a proper JSON library in production)
local people = {}
for name, tech, soft, bus, creative, academic in jsonContent:gmatch('"name": "([^"]+)".-"Technical Skills": (%d+).-"Soft Skills": (%d+).-"Business Skills": (%d+).-"Creative Skills": (%d+).-"Academic Skills": (%d+)') do
    local summary = {super=0, good=0, middle=0, low=0}
    setmetatable(summary, SummaryMetaTable)

    for _, skill in ipairs({tech, soft, bus, creative, academic}) do
        local skillLevel = tonumber(skill) or 0
        if skillLevel >= 90 then
            summary.super = summary.super + 1
        elseif skillLevel >= 80 then
            summary.good = summary.good + 1
        elseif skillLevel >= 70 then
            summary.middle = summary.middle + 1
        else
            summary.low = summary.low + 1
        end
    end

    local finalSummary
    if summary.super > 0 then
        finalSummary = "super"
    elseif summary.good >= 2 then
        finalSummary = "good"
    elseif summary.middle >= 3 then
        finalSummary = "middle"
    else
        finalSummary = "low"
    end

    -- Convert skill values to strings for output
    table.insert(people, {
        name,
        tostring(tech or ""),
        tostring(soft or ""),
        tostring(bus or ""),
        tostring(creative or ""),
        tostring(academic or ""),
        finalSummary
    })
end

-- Write data to `data5.txt`
local out = io.open("/Users/voldemarq/late-group/challenge_day4/testdata/data5.txt", "w")
out:write("Name,Technical Skills,Soft Skills,Business Skills,Creative Skills,Academic Skills,Summary\n")
for _, entry in ipairs(people) do
    out:write(table.concat(entry, ',') .. "\n")
end
out:close()

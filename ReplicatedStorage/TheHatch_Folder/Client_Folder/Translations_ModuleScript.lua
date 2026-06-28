-- Roblox: ReplicatedStorage._TheHatch.Client.Translations
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__LocalPlayer__1 = game:GetService("Players").LocalPlayer;
local v1 = {};
local l__upper__2 = string.upper;
local l__LocaleId__3 = l__LocalPlayer__1.LocaleId;
local v2 = string.find(l__LocaleId__3, "-");
if v2 then
    l__LocaleId__3 = string.sub(l__LocaleId__3, 1, v2 - 1);
end;
local u3 = l__upper__2(l__LocaleId__3);
local l__RawTranslations__4 = require(script:WaitForChild("RawTranslations"));
local u4 = {};
for _, v5 in pairs(l__RawTranslations__4) do
    if v5.Key then
        u4[v5.Key] = v5;
    end;
end;
for _, v6 in pairs(l__RawTranslations__4) do
    for v7, v8 in pairs(v6) do
        if string.find(v8, "{b}") then
            v6[v7] = v8:gsub("{b}", "<font transparency=\"0\">"):gsub("{/b}", "</font>");
        end;
    end;
    function replaceFontTags(_) end;
end;
function v1.translateUI(p9) --[[ Line: 57 ]]
    -- upvalues: u4 (copy), u3 (copy)
    for v10, v11 in pairs(p9) do
        local v12 = u4[v10];
        v11.Text = v12 and (v12[u3] or v12.EN or "") or "";
    end;
end;
return v1;
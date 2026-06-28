-- Roblox: Workspace.SilverAce293026.ACS_Client.ACS_Framework.Control
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local u1 = {};
game:GetService("RunService");
local l__LocalPlayer__1 = game:GetService("Players").LocalPlayer;
local u2 = {
    "Walk",
    "Sprint",
    "Crouch",
    "Stand",
    "Prone",
    "Slide",
    "LeanLeft",
    "LeanRight",
    "Jump",
    "Swim",
    "Sit",
    "Fall",
    "NVG",
    "NVGAnim"
};
local u3 = {
    "Equip",
    "ADS",
    "Fire",
    "Reload",
    "Pump",
    "Inspect",
    "AltAim",
    "CycleFireMode",
    "CycleLaser",
    "CycleFlashlight",
    "NVGLaser",
    "GrenadeCook",
    "GrenadeThrow"
};
local u4 = {
    "ActionBlocker",
    "FireRateBlocker",
    "FireAfterADS",
    "ADSBlocker"
};
u1.Debug = false;
local u9 = (function() --[[ Name: setupQueue, Line 19 ]]
    -- upvalues: u2 (copy), u3 (copy), u4 (copy)
    local v5 = {};
    for _, v6 in ipairs(u2) do
        v5[v6] = v5[v6] or {
            InProgress = false,
            QueueTs = nil,
            Start = nil,
            End = nil
        };
    end;
    for _, v7 in ipairs(u3) do
        v5[v7] = {
            InProgress = false,
            QueueTs = nil,
            Start = nil,
            End = nil
        };
    end;
    for _, v8 in ipairs(u4) do
        v5[v8] = {
            InProgress = false,
            QueueTs = nil,
            Start = nil,
            End = nil
        };
    end;
    return v5;
end)();
function u1.setToggle(p10, p11) --[[ Line: 56 ]]
    -- upvalues: u9 (copy)
    local v12 = u9[p10];
    if v12.Start == nil then
    else
        if v12.IsTogglable then
            v12.Toggle = p11;
        end;
    end;
end;
local function u14(...) --[[ Line: 64 ]]
    -- upvalues: u9 (copy)
    for _, v13 in ipairs({ ... }) do
        if u9[v13].InProgress then
            return true;
        end;
    end;
    return false;
end;
local function u21(p15) --[[ Line: 75 ]]
    -- upvalues: u9 (copy), u14 (copy), l__LocalPlayer__1 (copy)
    local v16 = false;
    local v17 = {};
    if not u9[p15] then
        error("Action named " .. p15 .. " not found! | Control Module");
    end;
    if u14("ActionBlocker") or u9[p15].InProgress and (not u9[p15].IsTogglable and p15 ~= "Fire") then
        return {
            canPerform = false,
            cancel = {}
        };
    end;
    if p15 == "Sprint" then
        local v18 = u14("Walk") and not u14("Fire", "Swim", "Sit");
        v16 = v18 and true or v18;
        v17 = {
            "LeanLeft",
            "LeanRight",
            "Crouch",
            "ADS"
        };
    elseif p15 == "Crouch" then
        v16 = not u14("Sit");
        v17 = { "Sprint" };
    elseif p15 == "Stand" then
        v16 = not u14("Sit");
    elseif p15 == "Slide" then
        v16 = true;
        v17 = { "Sprint" };
    elseif p15 == "LeanLeft" or p15 == "LeanRight" then
        v16 = not u14("Slide", "Swim");
        local l__PlayerGui__2 = l__LocalPlayer__1.PlayerGui;
        local v19 = { l__PlayerGui__2.GameUI.LoadoutUI };
        if l__PlayerGui__2.LoadingGui.Enabled and (l__PlayerGui__2.LoadingGui.Frame.ModesFrame.Visible or l__PlayerGui__2.LoadingGui.Frame.Menu.Visible) then
            v16 = false;
        end;
        for _, v20 in v19 do
            if v20.Enabled then
                v16 = false;
                break;
            end;
        end;
        v17 = { "Sprint" };
    elseif p15 == "Jump" then
        v16 = not u14("Crouch");
        v17 = { "Crouch" };
    elseif p15 == "NVG" then
        v16 = not u14("NVGAnim", "Reload", "Equip");
        v17 = { "ADS" };
    elseif p15 == "Equip" or (p15 == "AltAim" or p15 == "CycleFireMode") then
        v16 = not u14("Equip", "Reload", "Fire", "Sit");
    elseif p15 == "ADS" then
        v16 = not u14("Equip", "Inspect", "Sprint", "ADSBlocker");
        v17 = { "Sprint" };
    elseif p15 == "Fire" then
        v16 = not u14("Equip", "Sprint", "Reload", "Pump", "Inspect", "GrenadeCook", "GrenadeThrow");
        v17 = { "Sprint" };
    elseif p15 == "FireRelease" then
        v16 = u14("GrenadeCook");
        v17 = { "Fire" };
    elseif p15 == "Reload" then
        v16 = not u14("NVGAnim", "Equip", "Fire", "Inspect");
    elseif p15 == "Pump" then
        v16 = not u14("Equip", "Fire", "Reload");
    elseif p15 == "Inspect" then
        v16 = not u14("Equip", "Fire", "ADS", "Reload");
    elseif p15 == "CycleLaser" or p15 == "CycleFlashlight" then
        v16 = not u14("Equip", "Reload");
    elseif p15 == "ADSBlocker" then
        v16 = true;
        v17 = { "ADS" };
    elseif p15 == "GrenadeCook" then
        v16 = not u14("GrenadeCook", "GrenadeThrow");
        v17 = { "Fire" };
    elseif p15 == "GrenadeThrow" then
        v16 = not u14("GrenadeThrow");
        v17 = { "GrenadeCook", "Fire" };
    end;
    return {
        canPerform = v16,
        cancel = v17
    };
end;
function u1.exists(p22) --[[ Line: 161 ]]
    -- upvalues: u9 (copy)
    return u9[p22] ~= nil;
end;
function u1.configureAction(p23, p24, p25, p26) --[[ Line: 165 ]]
    -- upvalues: u9 (copy)
    local v27 = u9[p23];
    if v27 then
        v27.Start = p24;
        v27.End = p25;
        if p26 then
            v27.IsTogglable = true;
            v27.Toggle = false;
        end;
    else
        warn(p23 .. " not found | ControlModule");
    end;
end;
function u1.reset() --[[ Line: 181 ]]
    -- upvalues: u9 (copy), u3 (copy), u4 (copy)
    for _, v28 in ipairs(u3) do
        local v29 = u9[v28];
        v29.InProgress = false;
        v29.QueueTs = nil;
    end;
    for _, v30 in ipairs(u4) do
        local v31 = u9[v30];
        v31.InProgress = false;
        v31.QueueTs = nil;
    end;
end;
function u1.setInProgress(p32, p33) --[[ Line: 195 ]]
    -- upvalues: u9 (copy)
    local v34 = u9[p32];
    v34.InProgress = p33;
    v34.IsStopping = false;
    if p33 then
        v34.QueueTs = nil;
    end;
end;
function u1.isInProgress(...) --[[ Line: 204 ]]
    -- upvalues: u14 (copy)
    return u14(...);
end;
function u1.stop(p35, p36) --[[ Line: 208 ]]
    -- upvalues: u9 (copy), u1 (copy)
    local v37 = u9[p35];
    v37.QueueTs = p36;
    if v37.InProgress and (v37.End ~= nil and not v37.IsStopping) then
        v37.IsStopping = true;
        local v38 = "Stopping " .. p35;
        if u1.Debug then
            print("Control | " .. v38);
        end;
        if v37.IsTogglable then
            v37.Toggle = false;
        end;
        v37.End(false);
    end;
end;
function u1.queue(p39) --[[ Line: 221 ]]
    -- upvalues: u9 (copy), u1 (copy)
    if p39 == "GrenadeCook" then
    else
        u9[p39].QueueTs = true;
        local v40 = "Queued " .. p39 .. ", QueueTs: " .. tostring(u9[p39].QueueTs);
        if u1.Debug then
            print("Control | " .. v40);
        end;
    end;
end;
function u1.dequeue(p41) --[[ Line: 227 ]]
    -- upvalues: u9 (copy), u1 (copy)
    u9[p41].QueueTs = nil;
    local v42 = "Dequeued " .. p41;
    if u1.Debug then
        print("Control | " .. v42);
    end;
end;
function u1.performOrQueue(p43) --[[ Line: 232 ]]
    -- upvalues: u9 (copy), u1 (copy)
    if p43 == "Reload" and u9[p43].InProgress then
    else
        if not u1.performIfPossible(p43).canPerform then
            u1.queue(p43);
        end;
    end;
end;
function u1.performIfPossible(p44) --[[ Line: 240 ]]
    -- upvalues: u21 (copy), u9 (copy), u1 (copy)
    local v45 = u21(p44);
    if v45.cancel then
        for _, u46 in ipairs(v45.cancel) do
            u9[u46].QueueTs = nil;
            coroutine.wrap(function() --[[ Line: 245 ]]
                -- upvalues: u1 (ref), u46 (copy)
                u1.stop(u46);
            end)();
        end;
    end;
    if not v45.canPerform then
        if not v45.canPerform and p44 == "GrenadeCook" then
            u9[p44].QueueTs = nil;
        end;
        return v45;
    end;
    u9[p44].QueueTs = nil;
    local v47 = u9[p44];
    if v47.Start == nil then
        return v45;
    end;
    local v48;
    if v47.IsTogglable then
        v47.Toggle = not v47.Toggle;
        v48 = v47.Toggle;
    else
        v48 = true;
    end;
    v47.Start(v48);
    return v45;
end;
function u1.resolveQueue() --[[ Line: 257 ]]
    -- upvalues: u9 (copy), u1 (copy), u2 (copy), u3 (copy), u4 (copy)
    for _, u49 in ipairs(u2) do
        coroutine.wrap(function() --[[ Line: 265 ]]
            -- upvalues: u49 (copy), u9 (ref), u1 (ref)
            local v50 = u49;
            if u9[v50].QueueTs and not u9[v50].IsStopping then
                local v51 = "Dequeueing " .. v50;
                if u1.Debug then
                    print("Control | " .. v51);
                end;
                u1.performIfPossible(v50);
            end;
        end)();
    end;
    for _, u52 in ipairs(u3) do
        coroutine.wrap(function() --[[ Line: 268 ]]
            -- upvalues: u52 (copy), u9 (ref), u1 (ref)
            local v53 = u52;
            if u9[v53].QueueTs and not u9[v53].IsStopping then
                local v54 = "Dequeueing " .. v53;
                if u1.Debug then
                    print("Control | " .. v54);
                end;
                u1.performIfPossible(v53);
            end;
        end)();
    end;
    for _, u55 in ipairs(u4) do
        coroutine.wrap(function() --[[ Line: 271 ]]
            -- upvalues: u55 (copy), u9 (ref), u1 (ref)
            local v56 = u55;
            if u9[v56].QueueTs and not u9[v56].IsStopping then
                local v57 = "Dequeueing " .. v56;
                if u1.Debug then
                    print("Control | " .. v57);
                end;
                u1.performIfPossible(v56);
            end;
        end)();
    end;
end;
return u1;
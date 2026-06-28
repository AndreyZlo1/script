-- Roblox: Players.SilverAce293026.PlayerScripts.MinigameClient.Common.ClientTouchable
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__RunService__1 = game:GetService("RunService");
local l__Players__2 = game:GetService("Players");
local u1 = {};
u1.__index = u1;
function u1.new(u2, u3, u4, u5) --[[ Line: 9 ]]
    -- upvalues: u1 (copy), l__RunService__1 (copy), l__Players__2 (copy)
    local v6 = setmetatable({}, u1);
    local u7 = 0;
    local u8 = false;
    v6.runConnection = l__RunService__1.RenderStepped:Connect(function(p9) --[[ Line: 14 ]]
        -- upvalues: u7 (ref), l__Players__2 (ref), u2 (copy), u3 (copy), u8 (ref), u5 (copy), u4 (copy)
        u7 = u7 + p9;
        if u7 < 0.1 then
        else
            u7 = 0;
            local l__Character__3 = l__Players__2.LocalPlayer.Character;
            if l__Character__3 then
                local l__PrimaryPart__4 = l__Character__3.PrimaryPart;
                if l__PrimaryPart__4 then
                    if u3 < (l__PrimaryPart__4.Position - u2).Magnitude then
                        if not u8 then
                            return;
                        end;
                        u5();
                    else
                        if u8 then
                            return;
                        end;
                        u4();
                    end;
                    u8 = not u8;
                end;
            end;
        end;
    end);
    return v6;
end;
function u1.Dispose(p10) --[[ Line: 42 ]]
    p10.runConnection:Disconnect();
    p10.runConnection = nil;
end;
return u1;
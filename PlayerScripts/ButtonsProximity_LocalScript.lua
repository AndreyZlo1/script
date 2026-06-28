-- Roblox: Players.SilverAce293026.PlayerScripts.ButtonsProximity
-- Class: LocalScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__MarketplaceService__1 = game:GetService("MarketplaceService");
local l__ReplicatedStorage__2 = game:GetService("ReplicatedStorage");
local l__Players__3 = game:GetService("Players");
local l__Modules__4 = l__ReplicatedStorage__2:WaitForChild("Modules");
local l__GuiModule__5 = require(l__Modules__4:WaitForChild("GuiModule"));
local l__LocalPlayer__6 = l__Players__3.LocalPlayer;
local l__CollectCashEvent__7 = l__ReplicatedStorage__2:WaitForChild("CollectCashEvent");
local l__RequestPurchaseEvent__8 = l__ReplicatedStorage__2:WaitForChild("RequestPurchaseEvent");
local l__ProgressTutorial__9 = l__ReplicatedStorage__2:WaitForChild("BindableEvents"):WaitForChild("ProgressTutorial");
local l__Money__10 = l__LocalPlayer__6:WaitForChild("leaderstats"):WaitForChild("Money");
local l__ShopGui__11 = l__LocalPlayer__6:WaitForChild("PlayerGui"):WaitForChild("ShopGui");
local l__AddMoneyFrame__12 = l__ShopGui__11:WaitForChild("AddMoneyFrame");
local l__Button__13 = l__AddMoneyFrame__12:WaitForChild("ButtonFrame"):WaitForChild("Button");
local l__ProductId__14 = l__Button__13:WaitForChild("ProductId");
local l__ShopModule__15 = require(l__ShopGui__11:WaitForChild("ShopModule"));
local u1 = { l__ShopGui__11:WaitForChild("PrestigeConfirmFrame"), l__ShopGui__11:WaitForChild("PrestigeMenu"), l__ShopGui__11:WaitForChild("PrestigeRewardsMenu") };
local l__CollectCashFrame__16 = l__ShopGui__11:WaitForChild("CollectCashFrame");
local l__GroundVehiclesFrame__17 = l__ShopGui__11:WaitForChild("GroundVehiclesFrame");
local l__HelicoptersFrame__18 = l__ShopGui__11:WaitForChild("HelicoptersFrame");
local l__PrestigeFrame__19 = l__ShopGui__11:WaitForChild("PrestigeFrame");
local l__LoadoutFrame__20 = l__ShopGui__11:WaitForChild("LoadoutFrame");
local l__ReplicatedConfig__21 = require(l__ReplicatedStorage__2:WaitForChild("ReplicatedConfig"));
local u2;
if l__ReplicatedConfig__21.Mode == "Tycoon" then
    u2 = l__LocalPlayer__6:WaitForChild("AssociatedTycoon", (1 / 0));
else
    u2 = nil;
end;
local u3 = false;
local u4 = false;
local u5 = false;
local u6 = false;
local function u8(p7) --[[ Line: 81 ]]
    -- upvalues: l__ReplicatedConfig__21 (copy), u2 (ref)
    if l__ReplicatedConfig__21.Mode == "Tycoon" then
        local l__Parent__22 = p7.Parent;
        repeat
            l__Parent__22 = l__Parent__22.Parent;
        until l__Parent__22 == workspace or l__Parent__22.Name and l__Parent__22.Name == u2.Value;
        if l__Parent__22 ~= workspace then
            return true;
        end;
    end;
end;
local function u13(p9) --[[ Line: 125 ]]
    -- upvalues: u8 (copy), l__ProgressTutorial__9 (copy)
    local v10;
    if p9.Name == "ButtonPart" and p9.Parent:GetAttribute("Cost") then
        v10 = u8(p9);
    else
        v10 = nil;
    end;
    if v10 and p9.Parent.Name == "Extractor1" then
        l__ProgressTutorial__9:Fire("buildExtractor");
    else
        local v11;
        if p9.Name == "CashCollectButton" and p9.Parent.Name == "CashGiver" then
            v11 = u8(p9);
        else
            v11 = nil;
        end;
        if v11 then
            l__ProgressTutorial__9:Fire("collectCash");
        else
            local v12;
            if p9.Name == "ButtonPart" and p9.Parent:GetAttribute("Cost") then
                v12 = u8(p9);
            else
                v12 = nil;
            end;
            if v12 and p9.Parent.Name == "GFFoyerLocker" then
                l__ProgressTutorial__9:Fire("firstLocker");
            end;
        end;
    end;
end;
local function u22(p14) --[[ Line: 135 ]]
    -- upvalues: u6 (ref), l__MarketplaceService__1 (copy), l__LocalPlayer__6 (copy), l__Money__10 (copy), u5 (ref), l__RequestPurchaseEvent__8 (copy), u3 (ref), l__ProductId__14 (copy), l__Button__13 (copy), l__AddMoneyFrame__12 (copy), l__GuiModule__5 (copy)
    local l__Parent__23 = p14.Parent;
    local v15 = l__Parent__23:GetAttribute("Cost");
    local v16 = l__Parent__23:GetAttribute("Stun");
    local v17 = l__Parent__23:GetAttribute("PassId");
    if v16 or v15 == nil then
    elseif v17 then
        if u6 then
        else
            u6 = true;
            l__MarketplaceService__1:PromptGamePassPurchase(l__LocalPlayer__6, v17);
            spawn(function() --[[ Line: 148 ]]
                -- upvalues: u6 (ref)
                task.wait(5);
                u6 = false;
            end);
        end;
    elseif v15 <= l__Money__10.Value then
        if u5 then
        else
            u5 = true;
            l__RequestPurchaseEvent__8:FireServer(p14);
            spawn(function() --[[ Line: 157 ]]
                -- upvalues: u5 (ref)
                task.wait(1);
                u5 = false;
            end);
        end;
    elseif u3 then
    else
        local v18 = v15 - l__Money__10.Value;
        if v18 <= 25000 then
            l__ProductId__14.Value = 1156077820;
            l__Button__13.Text = "+25,000$";
        elseif v18 <= 100000 then
            l__ProductId__14.Value = 1156077821;
            l__Button__13.Text = "+100,000$";
        elseif v18 <= 500000 then
            l__ProductId__14.Value = 1653332182;
        elseif v18 <= 1000000 then
            l__ProductId__14.Value = 1156078137;
            l__Button__13.Text = "+1,000,000$";
        else
            l__ProductId__14.Value = 1653331413;
            l__Button__13.Text = "+5,000,000$";
        end;
        local u19 = l__AddMoneyFrame__12;
        local v20 = 0.75;
        if u19 and u19.Visible ~= true then
            if u3 then
                return;
            end;
            u3 = true;
            u19.Visible = true;
            l__GuiModule__5.setModal(u19, v20 or 0.8);
            local u21 = true;
            spawn(function() --[[ Line: 71 ]]
                -- upvalues: u3 (ref), u21 (copy), u19 (copy)
                task.wait(0.35);
                u3 = false;
                if not u21 then
                    u19.Visible = false;
                end;
            end);
        end;
    end;
end;
local function u26() --[[ Line: 189 ]]
    -- upvalues: l__ShopGui__11 (copy), l__CollectCashFrame__16 (copy), u3 (ref), l__GuiModule__5 (copy), u4 (ref), l__CollectCashEvent__7 (copy)
    if not l__ShopGui__11:GetAttribute("IsHidden") then
        local u23 = l__CollectCashFrame__16;
        local v24 = 0.69;
        if u23 and (u23.Visible ~= true and not u3) then
            u3 = true;
            u23.Visible = true;
            l__GuiModule__5.setModal(u23, v24 or 0.8);
            local u25 = true;
            spawn(function() --[[ Line: 71 ]]
                -- upvalues: u3 (ref), u25 (copy), u23 (copy)
                task.wait(0.35);
                u3 = false;
                if not u25 then
                    u23.Visible = false;
                end;
            end);
        end;
    end;
    if not u4 then
        u4 = true;
        l__CollectCashEvent__7:FireServer();
        l__GuiModule__5.Sounds.collectCash();
        spawn(function() --[[ Line: 199 ]]
            -- upvalues: u4 (ref)
            task.wait(3);
            u4 = false;
        end);
    end;
end;
local function v78() --[[ Line: 214 ]]
    -- upvalues: l__LocalPlayer__6 (copy), u1 (copy), u13 (copy), u8 (copy), u22 (copy), u26 (copy), l__PrestigeFrame__19 (copy), u3 (ref), l__GuiModule__5 (copy), l__GroundVehiclesFrame__17 (copy), l__HelicoptersFrame__18 (copy), l__LoadoutFrame__20 (copy), l__AddMoneyFrame__12 (copy), l__CollectCashFrame__16 (copy), l__ShopModule__15 (copy)
    local l__Character__24 = l__LocalPlayer__6.Character;
    if not l__Character__24 then
        return;
    end;
    local v27 = l__Character__24:FindFirstChild("HumanoidRootPart");
    if not v27 then
        return;
    end;
    local v28 = CFrame.new(Vector3.new(v27.Position.X, v27.Position.Y - 2, v27.Position.Z), Vector3.new(0, 0, 0));
    local v29 = workspace:GetPartBoundsInBox(v28, Vector3.new(1, 4, 12));
    local v30 = false;
    for _, v31 in u1 do
        if v31.Visible then
            v30 = true;
            break;
        end;
    end;
    local v32 = false;
    local v33 = false;
    local v34 = false;
    local v35 = false;
    local v36 = false;
    local v37 = false;
    local v38 = false;
    local v39 = false;
    for _, v40 in ipairs(v29) do
        u13(v40);
        local v41;
        if v40.Name == "ButtonPart" and v40.Parent:GetAttribute("Cost") then
            v41 = u8(v40);
        else
            v41 = nil;
        end;
        if v41 then
            u22(v40);
            v32 = true;
        else
            local v42;
            if v40.Name == "CashCollectButton" and v40.Parent.Name == "CashGiver" then
                v42 = u8(v40);
            else
                v42 = nil;
            end;
            if v42 then
                u26();
                v33 = true;
            else
                local v43;
                if v40.Name == "PrestigeButton" and v40.Parent.Name == "PrestigePanel" then
                    v43 = u8(v40);
                else
                    v43 = nil;
                end;
                if v43 then
                    v39 = true;
                    if not v30 then
                        v34 = true;
                        local u44 = l__PrestigeFrame__19;
                        local v45 = nil;
                        if u44 and u44.Visible ~= true then
                            if not u3 then
                                u3 = true;
                                u44.Visible = true;
                                l__GuiModule__5.setModal(u44, v45 or 0.8);
                                local u46 = true;
                                spawn(function() --[[ Line: 71 ]]
                                    -- upvalues: u3 (ref), u46 (copy), u44 (copy)
                                    task.wait(0.35);
                                    u3 = false;
                                    if not u46 then
                                        u44.Visible = false;
                                    end;
                                end);
                            end;
                        end;
                    end;
                else
                    local v47;
                    if v40.Name == "GarageFloor" then
                        v47 = u8(v40);
                    else
                        v47 = nil;
                    end;
                    if v47 then
                        v35 = true;
                        local u48 = l__GroundVehiclesFrame__17;
                        local v49 = nil;
                        if u48 and u48.Visible ~= true then
                            if not u3 then
                                u3 = true;
                                u48.Visible = true;
                                l__GuiModule__5.setModal(u48, v49 or 0.8);
                                local u50 = true;
                                spawn(function() --[[ Line: 71 ]]
                                    -- upvalues: u3 (ref), u50 (copy), u48 (copy)
                                    task.wait(0.35);
                                    u3 = false;
                                    if not u50 then
                                        u48.Visible = false;
                                    end;
                                end);
                            end;
                        end;
                    else
                        local v51;
                        if v40.Name == "HeliPadFloor" then
                            local l__Character__25 = l__LocalPlayer__6.Character;
                            if l__Character__25 then
                                local l__Humanoid__26 = l__Character__25:WaitForChild("Humanoid", 5);
                                if l__Humanoid__26 then
                                    v51 = u8(v40);
                                    if v51 then
                                        v51 = not l__Humanoid__26.SeatPart;
                                    end;
                                else
                                    v51 = nil;
                                end;
                            else
                                v51 = nil;
                            end;
                        else
                            v51 = nil;
                        end;
                        if v51 then
                            v36 = true;
                            local u52 = l__HelicoptersFrame__18;
                            local v53 = nil;
                            if u52 and u52.Visible ~= true then
                                if not u3 then
                                    u3 = true;
                                    u52.Visible = true;
                                    l__GuiModule__5.setModal(u52, v53 or 0.8);
                                    local u54 = true;
                                    spawn(function() --[[ Line: 71 ]]
                                        -- upvalues: u3 (ref), u54 (copy), u52 (copy)
                                        task.wait(0.35);
                                        u3 = false;
                                        if not u54 then
                                            u52.Visible = false;
                                        end;
                                    end);
                                end;
                            end;
                        else
                            local v55;
                            if v40.Name == "ArmoryFloor" then
                                v55 = u8(v40);
                            else
                                v55 = nil;
                            end;
                            if v55 then
                                local u56 = l__LoadoutFrame__20;
                                local v57 = nil;
                                if u56 and (u56.Visible ~= true and not u3) then
                                    u3 = true;
                                    u56.Visible = true;
                                    l__GuiModule__5.setModal(u56, v57 or 0.8);
                                    local u58 = true;
                                    spawn(function() --[[ Line: 71 ]]
                                        -- upvalues: u3 (ref), u58 (copy), u56 (copy)
                                        task.wait(0.35);
                                        u3 = false;
                                        if not u58 then
                                            u56.Visible = false;
                                        end;
                                    end);
                                end;
                                v37 = true;
                            else
                                local v59;
                                if v40.Name == "TouchPart" and v40.Parent.Parent == workspace.Hardpoints then
                                    v59 = v40.Parent.Name;
                                else
                                    v59 = nil;
                                end;
                                if v59 then
                                    l__LocalPlayer__6:SetAttribute("CurrentHardpoint", v59);
                                    v38 = true;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;
    if not v32 then
        local u60 = l__AddMoneyFrame__12;
        local v61 = nil;
        if u60 and (u60.Visible ~= false and not u3) then
            u3 = true;
            l__GuiModule__5.setModal(u60, v61 or 1.2);
            local u62 = false;
            spawn(function() --[[ Line: 71 ]]
                -- upvalues: u3 (ref), u62 (copy), u60 (copy)
                task.wait(0.35);
                u3 = false;
                if not u62 then
                    u60.Visible = false;
                end;
            end);
        end;
    end;
    if not v33 then
        local u63 = l__CollectCashFrame__16;
        local v64 = nil;
        if u63 and (u63.Visible ~= false and not u3) then
            u3 = true;
            l__GuiModule__5.setModal(u63, v64 or 1.2);
            local u65 = false;
            spawn(function() --[[ Line: 71 ]]
                -- upvalues: u3 (ref), u65 (copy), u63 (copy)
                task.wait(0.35);
                u3 = false;
                if not u65 then
                    u63.Visible = false;
                end;
            end);
        end;
    end;
    if not v34 then
        local u66 = l__PrestigeFrame__19;
        local v67 = nil;
        if u66 and (u66.Visible ~= false and not u3) then
            u3 = true;
            l__GuiModule__5.setModal(u66, v67 or 1.2);
            local u68 = false;
            spawn(function() --[[ Line: 71 ]]
                -- upvalues: u3 (ref), u68 (copy), u66 (copy)
                task.wait(0.35);
                u3 = false;
                if not u68 then
                    u66.Visible = false;
                end;
            end);
        end;
        if v30 and not v39 then
            l__ShopModule__15.resetPrestigeMenuState();
            print("reset");
        end;
    end;
    if not v35 then
        local u69 = l__GroundVehiclesFrame__17;
        local v70 = nil;
        if u69 and (u69.Visible ~= false and not u3) then
            u3 = true;
            l__GuiModule__5.setModal(u69, v70 or 1.2);
            local u71 = false;
            spawn(function() --[[ Line: 71 ]]
                -- upvalues: u3 (ref), u71 (copy), u69 (copy)
                task.wait(0.35);
                u3 = false;
                if not u71 then
                    u69.Visible = false;
                end;
            end);
        end;
    end;
    if not v36 then
        local u72 = l__HelicoptersFrame__18;
        local v73 = nil;
        if u72 and (u72.Visible ~= false and not u3) then
            u3 = true;
            l__GuiModule__5.setModal(u72, v73 or 1.2);
            local u74 = false;
            spawn(function() --[[ Line: 71 ]]
                -- upvalues: u3 (ref), u74 (copy), u72 (copy)
                task.wait(0.35);
                u3 = false;
                if not u74 then
                    u72.Visible = false;
                end;
            end);
        end;
    end;
    if not v37 then
        local u75 = l__LoadoutFrame__20;
        local v76 = nil;
        if u75 and (u75.Visible ~= false and not u3) then
            u3 = true;
            l__GuiModule__5.setModal(u75, v76 or 1.2);
            local u77 = false;
            spawn(function() --[[ Line: 71 ]]
                -- upvalues: u3 (ref), u77 (copy), u75 (copy)
                task.wait(0.35);
                u3 = false;
                if not u77 then
                    u75.Visible = false;
                end;
            end);
        end;
    end;
    if not v38 then
        l__LocalPlayer__6:SetAttribute("CurrentHardpoint", "");
    end;
end;
while true do
    task.wait(0.2);
    pcall(v78);
end;
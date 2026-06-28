-- Roblox: Players.SilverAce293026.PlayerScripts.ChessHandler
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local u1 = {};
local l__RunService__1 = game:GetService("RunService");
local l__UserInputService__2 = game:GetService("UserInputService");
local l__ReplicatedStorage__3 = game:GetService("ReplicatedStorage");
local l__Modules__4 = l__ReplicatedStorage__3:WaitForChild("Modules");
local l__Chess__5 = require(l__Modules__4:WaitForChild("Chess"));
local l__Pieces__6 = l__Modules__4:WaitForChild("Pieces");
local l__Board__7 = require(l__ReplicatedStorage__3.Modules.Chess:WaitForChild("Board"));
local u2 = {
    Move = script:WaitForChild("MoveHighlight"),
    Takeover = script:WaitForChild("TakeoverHighlight")
};
local l__ChessNetwork__8 = l__ReplicatedStorage__3:WaitForChild("ChessNetwork");
local u3 = {
    RequestMove = l__ChessNetwork__8:WaitForChild("Move"),
    ReplicateMove = l__ChessNetwork__8:WaitForChild("ReplicateMove")
};
local l__CheckHighlight__9 = script:WaitForChild("CheckHighlight");
u1.Games = {};
local u4 = {};
function u1.RegisterNewGame(p5, p6, p7, p8) --[[ Line: 28 ]]
    -- upvalues: l__Board__7 (copy), u1 (copy), u4 (copy)
    local v9 = l__Board__7.fromNotationArray(p7);
    v9.BoardModel = p6;
    v9.WhiteTurn = true;
    v9.HighFidelity = p8 ~= nil;
    v9.GUID = p5;
    Instance.new("Model", p6).Name = "ClientPieces";
    u1.Games[p6] = v9;
    u1.CleanRenderPieces(p6);
    if p8 then
        for _, v10 in workspace:GetChildren() do
            if v10.Name:sub(1, 6) == "Tycoon" then
                for _, v11 in v10:GetDescendants() do
                    if v11:IsA("Highlight") then
                        v11:Destroy();
                    end;
                end;
            end;
        end;
        v9.OurColour = p8;
        u4[p6] = {};
        u1.SetupConnections(p6);
    end;
end;
function u1.CleanRenderPieces(p12) --[[ Line: 59 ]]
    -- upvalues: u1 (copy), l__Pieces__6 (copy)
    if u1.Games[p12] then
        local v13 = p12:FindFirstChild("ClientPieces");
        if v13 then
            local v14 = u1.Games[p12];
            local v15 = v14.HighFidelity and "H" or "L";
            for v16 = 1, 8 do
                for v17 = 1, 8 do
                    local v18 = v14.Pieces[v16][v17];
                    if v18 then
                        local v19 = string.char(v17 + 96);
                        local v20 = l__Pieces__6:WaitForChild(v15 .. v18.Name):Clone();
                        v20.Parent = v13;
                        v20.Size = v20.Size * 0.07;
                        v20.Position = v14.BoardModel:WaitForChild(v19 .. v16).Central.WorldCFrame.Position + Vector3.new(0, v20.Size.Y / 2, 0);
                        if not v18.White then
                            v20.CFrame = v20.CFrame * CFrame.Angles(0, 2.923426497090502, 0);
                            v20.Color = Color3.fromRGB(115, 115, 115);
                        end;
                        v18.Model = v20;
                    end;
                end;
            end;
        else
            warn("Tried to render pieces for a chess board without a ClientPieces container");
        end;
    else
        warn("Tried to render pieces for a chess game that we haven\'t registered");
    end;
end;
function u1.SetupConnections(u21) --[[ Line: 96 ]]
    -- upvalues: u1 (copy), u4 (copy), l__Chess__5 (copy), u2 (copy), l__ChessNetwork__8 (copy), u3 (copy), l__UserInputService__2 (copy), l__RunService__1 (copy)
    if u1.Games[u21] then
        if u21:FindFirstChild("ClientPieces") then
            local u22 = u1.Games[u21];
            local u23 = u4[u21];
            if u23 then
                local u24 = {
                    Type = "Idle",
                    Data = nil
                };
                local u25 = {};
                local function u31() --[[ Line: 125 ]]
                    -- upvalues: u24 (ref), l__Chess__5 (ref), u21 (copy), u22 (copy), u2 (ref), u25 (ref)
                    if u24.Type == "Move" then
                        if u24.Data then
                            for _, v26 in u24.Data.Options do
                                local v27 = l__Chess__5.Util.VectorToTile(v26);
                                local v28 = u21[v27];
                                local v29 = (u22:GetPieceAtNotation(v27) ~= nil and u2.Takeover or u2.Move):Clone();
                                local v30 = v28:FindFirstChildOfClass("Highlight");
                                if v30 then
                                    v30:Destroy();
                                end;
                                v29.Parent = v28;
                                table.insert(u25, v29);
                            end;
                        end;
                    end;
                end;
                local u32 = u24;
                local u33 = u25;
                local v34 = {};
                local function u40(p35, p36) --[[ Line: 150 ]]
                    -- upvalues: u22 (copy)
                    if not u22.CheckState then
                        return p36;
                    end;
                    if u22.CheckState == "Checkmate" then
                        return nil;
                    end;
                    print(u22.CheckState);
                    local v37 = {};
                    if p35.Name == "King" then
                        for _, v38 in u22.CheckState.FleeMoves do
                            table.insert(v37, v38);
                        end;
                    end;
                    for _, v39 in u22.CheckState.DefenceMoves do
                        if v39.Piece == p35 then
                            table.insert(v37, v39.To);
                        end;
                    end;
                    return v37;
                end;
                for _, u41 in u21:GetChildren() do
                    if u41:IsA("Part") and u41.Name ~= "Base" then
                        table.insert(v34, u41);
                        u23[u41.Name] = function() --[[ Line: 182 ]]
                            -- upvalues: u32 (ref), u22 (copy), u41 (copy), u40 (copy), l__ChessNetwork__8 (ref), u31 (copy), l__Chess__5 (ref), u33 (ref), u3 (ref)
                            if u32.Type == "Idle" then
                                local v42 = u22:GetPieceAtNotation(u41.Name);
                                if v42 then
                                    local v43 = u22:GetValidOptions(v42);
                                    if v43 then
                                        local v44 = u40(v42, v43);
                                        if v44 then
                                            u32.Type = "Move";
                                            u32.Data = {
                                                Piece = v42,
                                                Options = v44
                                            };
                                            u31();
                                            return;
                                        else
                                            l__ChessNetwork__8.Stop:FireServer(u22.GUID, u22.OurColour);
                                            return;
                                        end;
                                    else
                                        return;
                                    end;
                                else
                                    return;
                                end;
                            end;
                            if u32.Type ~= "Move" then
                                return;
                            end;
                            local v45 = l__Chess__5.Util.TileToVector(u41.Name);
                            local v46 = false;
                            for _, v47 in u32.Data.Options do
                                if v47 == v45 then
                                    v46 = true;
                                    break;
                                end;
                            end;
                            if v46 then
                                u3.RequestMove:InvokeServer(u22.GUID, u32.Data.Piece.Position, u41.Name);
                                for _, v48 in u33 do
                                    v48:Destroy();
                                end;
                                u33 = {};
                                u32 = {
                                    Type = "Idle",
                                    Data = nil
                                };
                            else
                                local v49 = u22:GetPieceAtNotation(u41.Name);
                                if v49 then
                                    local v50 = u22:GetValidOptions(v49);
                                    if v50 then
                                        local v51 = u40(v49, v50);
                                        if v51 then
                                            for _, v52 in u33 do
                                                v52:Destroy();
                                            end;
                                            u33 = {};
                                            u32.Type = "Move";
                                            u32.Data = {
                                                Piece = v49,
                                                Options = v51
                                            };
                                            u31();
                                        else
                                            l__ChessNetwork__8.Stop:FireServer(u22.GUID, u22.OurColour);
                                        end;
                                    else
                                        for _, v53 in u33 do
                                            v53:Destroy();
                                        end;
                                        u33 = {};
                                        u32 = {
                                            Type = "Idle",
                                            Data = nil
                                        };
                                    end;
                                else
                                    for _, v54 in u33 do
                                        v54:Destroy();
                                    end;
                                    u33 = {};
                                    u32 = {
                                        Type = "Idle",
                                        Data = nil
                                    };
                                end;
                            end;
                        end;
                    end;
                end;
                local u55 = RaycastParams.new();
                u55.FilterType = Enum.RaycastFilterType.Include;
                u55.FilterDescendantsInstances = v34;
                local u56 = nil;
                for _, v66 in { l__UserInputService__2.InputEnded:Connect(function(p57, _) --[[ Line: 272 ]]
                        -- upvalues: u56 (ref), u33 (ref), u32 (ref), u23 (copy), u55 (copy)
                        if p57.UserInputType == Enum.UserInputType.MouseButton1 or p57.KeyCode == Enum.KeyCode.ButtonA then
                            if u56 then
                                u23[u56.Name]();
                            else
                                for _, v58 in u33 do
                                    v58:Destroy();
                                end;
                                u33 = {};
                                u32 = {
                                    Type = "Idle",
                                    Data = nil
                                };
                            end;
                        else
                            if p57.UserInputType == Enum.UserInputType.Touch then
                                local l__CurrentCamera__10 = workspace.CurrentCamera;
                                local l__Position__11 = p57.Position;
                                local v59 = l__CurrentCamera__10:ScreenPointToRay(l__Position__11.X, l__Position__11.Y);
                                local v60 = workspace:Raycast(v59.Origin, v59.Direction * 64, u55);
                                if not v60 then
                                    u56 = nil;
                                    return;
                                end;
                                u56 = v60.Instance;
                                if not u56 then
                                    for _, v61 in u33 do
                                        v61:Destroy();
                                    end;
                                    u33 = {};
                                    u32 = {
                                        Type = "Idle",
                                        Data = nil
                                    };
                                    return;
                                end;
                                u23[u56.Name]();
                            end;
                        end;
                    end), l__RunService__1.RenderStepped:Connect(function() --[[ Line: 301 ]]
                        -- upvalues: l__UserInputService__2 (ref), u55 (copy), u56 (ref)
                        local l__CurrentCamera__12 = workspace.CurrentCamera;
                        local v62 = l__UserInputService__2:GetMouseLocation();
                        local v63 = l__CurrentCamera__12:ViewportPointToRay(v62.X, v62.Y);
                        local v64 = workspace:Raycast(v63.Origin, v63.Direction * 64, u55);
                        if v64 then
                            local l__Instance__13 = v64.Instance;
                            if u56 == l__Instance__13 then
                            else
                                u56 = l__Instance__13;
                            end;
                        else
                            u56 = nil;
                        end;
                    end), (l__RunService__1.RenderStepped:Connect(function() --[[ Line: 316 ]]
                        -- upvalues: u21 (copy), u22 (copy)
                        local v65 = (u21:GetPivot() * CFrame.new(u22.OurColour == "White" and 1.8 or -1.8, 0, 0)).Position + Vector3.new(0, 2.3, 0);
                        workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable;
                        workspace.CurrentCamera.CameraSubject = nil;
                        workspace.CurrentCamera.CFrame = CFrame.new(v65, u21:GetPivot().Position);
                    end)) } do
                    table.insert(u4[u21], v66);
                end;
            else
                warn("Tried to setup connections for a chess board without a GameConnections entry");
            end;
        else
            warn("Tried to setup connections for a chess board without a ClientPieces container");
        end;
    else
        warn("Tried to setup connections for a chess game that we haven\'t registered");
    end;
end;
function u1.ReplicateMove(p67, p68, p69) --[[ Line: 329 ]]
    -- upvalues: u1 (copy), l__CheckHighlight__9 (copy), l__ChessNetwork__8 (copy)
    local v70 = nil;
    for _, v71 in u1.Games do
        if v71.GUID == p67 then
            v70 = v71;
            break;
        end;
    end;
    if v70 then
        local v72 = v70:GetPieceAtNotation(p68);
        v72.Unmoved = false;
        local v73 = v70:GetPieceAtNotation(p69);
        if v73 then
            v73.Model:Destroy();
        end;
        v70:MovePieceToNotation(v72, p69);
        v72.Position = p69;
        local l__Model__14 = v72.Model;
        l__Model__14.Position = v70.BoardModel[p69].Central.WorldCFrame.Position + Vector3.new(0, l__Model__14.Size.Y / 2, 0);
        v70.WhiteTurn = not v70.WhiteTurn;
        if v70.OurColour then
            v70.CheckState = v70:GetCheckStatus(v70.OurColour == "White");
            if v70.CheckState and v70.CheckState ~= "Checkmate" then
                for v74 = 1, 8 do
                    for v75 = 1, 8 do
                        local v76 = v70.Pieces[v74][v75];
                        if v76 and v76.Name == "King" and (v76.White and v70.OurColour == "White" or not v76.White and v70.OurColour == "Black") then
                            l__CheckHighlight__9.Parent = v76.Model;
                        end;
                    end;
                end;
            elseif v70.CheckState and v70.CheckState == "Checkmate" then
                l__ChessNetwork__8.Stop:FireServer(v70.GUID, v70.OurColour);
            else
                l__CheckHighlight__9.Parent = script;
            end;
        end;
    else
        warn("Cannot replicate a move for a game that isn\'t registered");
    end;
end;
function u1.OnStop(p77, p78) --[[ Line: 379 ]]
    -- upvalues: u1 (copy), u4 (copy), u2 (copy)
    for v79, v80 in u1.Games do
        if v80.GUID == p77 then
            if v80.OurColour then
                for _, u81 in u4[v80.BoardModel] do
                    pcall(function() --[[ Line: 384 ]]
                        -- upvalues: u81 (copy)
                        u81:Disconnect();
                    end);
                end;
                u4[v80.BoardModel] = {};
                for _, v82 in v80.BoardModel:GetDescendants() do
                    if v82:IsA("Highlight") then
                        if v82.Name == u2.Move.Name or v82.Name == u2.Takeover.Name then
                            v82:Destroy();
                        else
                            v82.Parent = script;
                        end;
                    end;
                end;
                task.wait();
                workspace.CurrentCamera.CameraType = Enum.CameraType.Custom;
                workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character.Humanoid;
                if p78 then
                    game.Players.LocalPlayer.PlayerGui.ChessGui.Label.Text = p78 == "White" and "Black wins!" or "White wins!";
                    game.Players.LocalPlayer.PlayerGui.ChessGui.Enabled = true;
                    task.wait(2.5);
                    game.Players.LocalPlayer.PlayerGui.ChessGui.Enabled = false;
                end;
            end;
            v80.BoardModel.ClientPieces:Destroy();
            u1.Games[v79] = nil;
            return;
        end;
    end;
end;
return u1;
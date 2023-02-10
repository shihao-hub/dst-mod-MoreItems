--[[
Copyright (C) 2019, 2020 Zarklord

This file is part of Gem Core.

The source code of this program is shared under the RECEX
SHARED SOURCE LICENSE (version 1.0).
The source code is shared for referrence and academic purposes
with the hope that people can read and learn from it. This is not
Free and Open Source software, and code is not redistributable
without permission of the author. Read the RECEX SHARED
SOURCE LICENSE for details
The source codes does not come with any warranty including
the implied warranty of merchandise.
You should have received a copy of the RECEX SHARED SOURCE
LICENSE in the form of a LICENSE file in the root of the source
directory. If not, please refer to
<https://raw.githubusercontent.com/Recex/Licenses/master/SharedSourceLicense/LICENSE.txt>
]]
local DEBUGWORLDSEED = false

STRINGS.UI.CUSTOMIZATIONSCREEN.WORLDSEED = STRINGS.UI.CUSTOMIZATIONSCREEN.WORLDSEED or "Leave blank for a random seed."
STRINGS.UI.CUSTOMIZATIONSCREEN.ICON_TITLES.WORLDSEED = STRINGS.UI.CUSTOMIZATIONSCREEN.ICON_TITLES.WORLDSEED or "World Seed"

GEMENV.AddCustomizeItem(LEVELCATEGORY.WORLDGEN, "misc", "worldseed", {desc = {}, order = -10, value = "", widget_type = "textentry", image = "world_seed.tex", atlas = "images/world_seed.xml", options_remap = {img = "blank_world.tex"}})

if IsTheFrontEnd then
    local args = {...}
    local functionname = args[1]
    local MakeGemFunction = gemrun("gemfunctionmanager")
    MakeGemFunction(functionname, nil, true)

    local FrontendHelper = gemrun("tools/frontendhelper", GEMENV.modname)

    local function LoadWorldSeedAndVersion(worldsettingstab)
        local self = worldsettingstab

        if self:IsLevelEnabled() and not self:IsNewShard() then
            local session_id = ShardSaveGameIndex:GetSlotSession(self.slot, SERVER_LEVEL_SHARDS[self.location_index])
            local meta
            local prefab
            if session_id ~= nil then
                local function onreadworldfile(success, str)
                    if success and str ~= nil and #str > 0 then
                        local success, savedata = RunInSandbox(str)
                        if success and savedata ~= nil and GetTableSize(savedata) > 0 then
                            meta = savedata.meta
                            prefab = savedata.map.prefab
                        end
                    end
                end
                if ShardSaveGameIndex:IsSlotMultiLevel(self.slot) or not ShardSaveGameIndex:GetSlotServerData(self.slot).use_legacy_session_path then
                    local shard = SERVER_LEVEL_SHARDS[self.location_index]
                    local file = TheNet:GetWorldSessionFileInClusterSlot(self.slot,  shard, session_id)
                    if file ~= nil then
                        TheSim:GetPersistentStringInClusterSlot(self.slot, shard, file, onreadworldfile)
                    end
                else
                    local file = TheNet:GetWorldSessionFile(session_id)
                    if file ~= nil then
                        TheSim:GetPersistentString(file, onreadworldfile)
                    end
                end
            end

            local options = ShardSaveGameIndex:GetSlotGenOptions(self.slot, SERVER_LEVEL_SHARDS[self.location_index])
            local overrides = options and options.overrides
            local worldseed
            if overrides and overrides.worldseed and (tonumber(overrides.worldseed) or hash(overrides.worldseed)) == (meta and meta.seed or nil) then
                worldseed = overrides.worldseed
            else
                worldseed = meta and meta.seed or "WORLD SEED NOT FOUND"
            end

            local FIRST_VALID_BUILD_VERSION = 435008 --this is the first build that has the fixed worldgen so its not completly random.
            if meta and (tonumber(meta.build_version) or 0) < FIRST_VALID_BUILD_VERSION and tonumber(meta.build_version) ~= -1 then
                print((prefab or "unknown").." world's build version is: "..meta.build_version.." needs to be greater than "..FIRST_VALID_BUILD_VERSION)
                print("worldseed is: "..worldseed)
                worldseed = "WORLD VERSION IS TOO OLD"
            end

            self.worldgen_widget:SetTweak("worldseed", worldseed)
            self.worldgen_widget:Refresh(true)
        end
    end

    local WorldSettingsTab = require("widgets/redux/worldsettings/worldsettingstab")

    local CheckWorldSeed = false
    FrontendHelper.ReplaceFunction(WorldSettingsTab, "SetDataForSlot", function(_SetDataForSlot, self, slot, ...)
        CheckWorldSeed = true
        return _SetDataForSlot(self, slot, ...)
    end)

    FrontendHelper.ReplaceFunction(WorldSettingsTab, "Refresh", function(_Refresh, self, ...)
        if CheckWorldSeed then
            CheckWorldSeed = false
            LoadWorldSeedAndVersion(self)
        end
        return _Refresh(self, ...)
    end)
    return
elseif rawget(_G, "WORLDGEN_MAIN") == 1 then
    local WORLDSEED
    local function hash(str)
        local _hash = 0;
        for c in str:lower():gmatch(".") do
            _hash = (c:byte() + bit.lshift(_hash, 6) + bit.lshift(_hash, 16) - _hash)
        end
        return _hash
    end

    assert(GEN_PARAMETERS ~= nil, "Parameters were not provided to worldgen!")
    local world_gen_data = json.decode(GEN_PARAMETERS)
    assert(world_gen_data.level_data ~= nil, "Must provide complete level data to worldgen.")
    WORLDSEED = world_gen_data.level_data.overrides.worldseed

    WORLDSEED = (WORLDSEED ~= nil and WORLDSEED ~= "") and (tonumber(WORLDSEED) or hash(WORLDSEED)) or nil

    SEED = SetWorldGenSeed(WORLDSEED or SEED)

    --ensure seed is the proper value still after all mods have loaded.
    function GEMENV.WorldSeedPostLoad()
        SEED = WORLDSEED or SEED
        if DEBUGWORLDSEED then
            local worldgen_log = assert(io.open(GEMENV.MODROOT.."worldgen_log_"..world_gen_data.level_data.location..".txt", "w"))
            AddPrintLogger(function(str)
                worldgen_log:write(str.."\n")
            end)
            local random_log = assert(io.open(GEMENV.MODROOT.."random_log_"..world_gen_data.level_data.location..".txt", "w"))
            local randcount = 0
            local _random = math.random
            random_log:write("SEED = "..SEED.."\n")
            function math.random(...)
                local args = {...}
                local m, n = "0F", "1F"
                if #args == 2 then
                    m, n = args[1], args[2]
                elseif #args == 1 then
                    m, n = 1, args[1]
                end
                local rand = _random(...)
                randcount = randcount + 1
                random_log:write("math.random: "..tostring(m)..", "..tostring(n).." returned value "..tostring(rand).." callcount = "..randcount.."\n")
                random_log:write(debugstack().."\n")
                return rand
            end
        end
    end
    return
end

local function ReportRegenReady(shard_id)
    TheWorld:PushEvent("shard_reportregenready", tonumber(shard_id))
end
AddShardRPCHandler("GemCore", "ReportRegenReady", ReportRegenReady)
local function ResetServer(shard_id, data)
    TheWorld:PushEvent("shard_resetserver", {srpc_sender = tonumber(shard_id), preserve_seed = data.preserve_seed})
end
AddShardRPCHandler("GemCore", "ResetServer", ResetServer)
gemrun("shardcomponent", "shard_regenerate")
local function ClientRequestResetServer(player, preserve_seed)
    if player.Network:IsServerAdmin() then
        if TheWorld then
            TheWorld:PushEvent("shard_resetserver", {preserve_seed = preserve_seed})
        else
            self:ActualSendWorldResetRequestToServer()
        end
    end
end
AddModRPCHandler("GemCore", "ClientRequestResetServer", ClientRequestResetServer)

NetworkProxy.ActualSendWorldResetRequestToServer = NetworkProxy.SendWorldResetRequestToServer
function NetworkProxy:SendWorldResetRequestToServer(...)
    --clear world seed, callback will call ActualSendWorldResetRequestToServer(...)
    if TheNet:GetIsClient() and TheNet:GetIsServerAdmin() then
        SendModRPCToServer(GetModRPC("GemCore", "ClientRequestResetServer"), false)
    elseif TheNet:GetIsServer() and TheWorld then
        TheWorld:PushEvent("shard_resetserver", {preserve_seed = false})
    else
        self:ActualSendWorldResetRequestToServer(...)
    end
end
function NetworkProxy:SendIdenticalWorldResetRequestToServer(...)
    --set world seed, callback will call ActualSendWorldResetRequestToServer(...)
    if TheNet:GetIsClient() and TheNet:GetIsServerAdmin() then
        SendModRPCToServer(GetModRPC("GemCore", "ClientRequestResetServer"), true)
    elseif TheNet:GetIsServer() and TheWorld then
        TheWorld:PushEvent("shard_resetserver", {preserve_seed = true})
    else
        self:ActualSendWorldResetRequestToServer(...)
    end
end

local worldseed
local preserveworldseed
local _SetServerShardData = ShardIndex.SetServerShardData
function ShardIndex:SetServerShardData(customoptions, serverdata, callback, ...)
    if customoptions and customoptions.preserveworldseed then
        preserveworldseed = true
        worldseed = customoptions.overrides and customoptions.overrides.worldseed or nil
        customoptions.preserveworldseed = nil
    end

    return _SetServerShardData(self, customoptions, serverdata, callback, ...)
end

local _Save = ShardIndex.Save
function ShardIndex:Save(callback, ...)
    local options = self:GetGenOptions()
    if options then
        if preserveworldseed then
            options.overrides.worldseed = worldseed
            preserveworldseed = nil
            worldseed = nil
        end
    end
    return _Save(self, callback, ...)
end

GEMENV.AddGamePostInit(function()
    STRINGS.UI.BUILTINCOMMANDS.REGENERATEIDENTICAL = STRINGS.UI.BUILTINCOMMANDS.REGENERATEIDENTICAL or {
        PRETTYNAME = "Regen Same World",
        DESC = "Destroy this world and restart with the same world!",
        VOTETITLEFMT = "Should we regenerate the same world?",
        VOTENAMEFMT = "vote to regenerate the same world world",
        VOTEPASSEDFMT = "Regenerating the same world in 5 seconds...",
    }
    local UserCommands = require("usercommands")
    local VoteUtil = require("voteutil")
    GEMENV.AddUserCommand("regenerateidentical", {
        prettyname = nil, --default to STRINGS.UI.BUILTINCOMMANDS.REGENERATEIDENTICAL.PRETTYNAME
        desc = nil, --default to STRINGS.UI.BUILTINCOMMANDS.REGENERATEIDENTICAL.DESC
        permission = COMMAND_PERMISSION.ADMIN,
        confirm = true,
        slash = true,
        usermenu = false,
        servermenu = true,
        params = {},
        vote = true,
        votetimeout = 30,
        voteminstartage = 20,
        voteminpasscount = 3,
        votecountvisible = true,
        voteallownotvoted = true,
        voteoptions = nil, --default to { "Yes", "No" }
        votetitlefmt = nil, --default to STRINGS.UI.BUILTINCOMMANDS.REGENERATEIDENTICAL.VOTETITLEFMT
        votenamefmt = nil, --default to STRINGS.UI.BUILTINCOMMANDS.REGENERATEIDENTICAL.VOTENAMEFMT
        votepassedfmt = nil, --default to STRINGS.UI.BUILTINCOMMANDS.REGENERATEIDENTICAL.VOTEPASSEDFMT
        votecanstartfn = VoteUtil.DefaultCanStartVote,
        voteresultfn = VoteUtil.YesNoMajorityVote,
        serverfn = function(params, caller)
            --NOTE: must support nil caller for voting
            if caller ~= nil then
                --Wasn't a vote so we should send out an announcement manually
                --NOTE: the vote regenerateidentical announcement is customized and still
                --      makes sense even when it wasn't a vote, (run by admin)
                local command = UserCommands.GetCommandFromName("regenerateidentical")
                TheNet:AnnounceVoteResult(command.hash, nil, true)
            end
            TheWorld:DoTaskInTime(5, function(world)
                if world.ismastersim then
                    TheNet:SendIdenticalWorldResetRequestToServer()
                end
            end)
        end,
    })
end)
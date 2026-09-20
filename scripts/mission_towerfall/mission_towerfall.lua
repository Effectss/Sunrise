-- Homecoming (mission_towerfall) campaign controller.
-- All referenced content is resolved from the SDK generated from the installed game.
local mission = require("missions.mission_towerfall_80b500bc")

local S, C, L, V = mission.Squad, mission.Scene, mission.Slot, mission.TriggerVolume

local function place(ctx, squads)
    for i = 1, #squads do ctx:squad(squads[i]):place{} end
end

local function play(ctx, id)
    ctx:scene(id):activate{spawn = false}
end

local function entered(event, volume)
    return volume ~= nil
        and event.volume_registry_key == volume.registry_key
        and event.volume_slot_type == volume.slot_type
        and event.volume_slot_index == volume.slot_index
end

local opening = {S.SQ_BAZAAR_START, S.SQ_BAZAAR_TEASE_A, S.SQ_BAZAAR_TEASE_B,
    S.SQ_BAZAAR_A_A, S.SQ_BAZAAR_A_B, S.SQ_BAZAAR_A_C, S.SQ_FLAME,
    S.SQ_IKORA_80B5011F}
local bazaar_finale = {S.SQ_BAZAAR_FINALE, S.SQUAD_CABAL_BLASTED_1,
    S.SQUAD_CABAL_BLASTED_2, S.SQUAD_CABAL_BLASTED_3, S.SQUAD_CABAL_BLASTED_4}
local hangar_overlook = {S.SQ_MILITARY_HALLWAY_DESTRUCTION, S.SQ_HANGAR_OVERLOOK_A_A,
    S.SQ_HANGAR_OVERLOOK_A_A_CENT, S.SQ_HANGAR_OVERLOOK_A_B, S.SQ_HANGAR_OVERLOOK_A_C,
    S.SQ_HANGAR_OVERLOOK_B_A, S.SQ_HANGAR_OVERLOOK_B_B, S.SQ_HANGAR_OVERLOOK_B_C,
    S.SQ_HANGAR_OVERLOOK_SNIPER}
local hangar = {S.SQ_HANGAR_A_A, S.SQ_HANGAR_A_A_FLANK, S.SQ_HANGAR_A_B,
    S.SQ_HANGAR_A_B_SNIPER, S.SQ_FRIENDLIES_EARLY, S.SQ_FRIENDLIES_EARLY_UPPER,
    S.SQ_HANGAR_FODDER_A, S.SQ_HANGAR_FODDER_B, S.SQ_HANGAR_FODDER_C,
    S.SQ_RED_GUARD_FAKE_FIGHT_A, S.SQ_RED_GUARD_FAKE_FIGHT_B,
    S.SQ_RED_GUARD_FAKE_FIGHT_C}
local plaza_opening = {S.SQ_ZAVALA, S.SQUAD_KILL_CABAL_1, S.SQUAD_KILL_CABAL_2,
    S.SQUAD_KILL_CABAL_3, S.SQUAD_KILL_CABAL_4, S.SQUAD_CABAL_DROPOFF_1,
    S.SQ_PLAZA_REINFORCE_START_A, S.SQ_PLAZA_REINFORCE_START_B}
local plaza_reinforcements = {S.SQUAD_KILL_CABAL_5, S.SQUAD_KILL_CABAL_6,
    S.SQUAD_KILL_CABAL_7, S.SQUAD_KILL_CABAL_8, S.SQ_PLAZA_REINFORCE_A_A,
    S.SQ_PLAZA_REINFORCE_A_A_EXTRA, S.SQ_PLAZA_REINFORCE_A_B,
    S.SQ_PLAZA_REINFORCE_A_C, S.SQ_PLAZA_REINFORCE_A_D,
    S.SQ_PLAZA_REINFORCE_A_D_EXTRA, S.SQ_PLAZA_REINFORCE_B_A,
    S.SQ_PLAZA_REINFORCE_B_A_EXTRA, S.SQ_PLAZA_REINFORCE_B_B,
    S.SQ_PLAZA_REINFORCE_B_B_EXTRA, S.SQ_PLAZA_INTERIM_A_A, S.SQ_PLAZA_INTERIM_A_B}
local damaged_tower = {S.SQ_PODS, S.SQ_DAMAGED, S.SQ_DAMAGED_HALL_FRONT,
    S.SQ_DAMAGED_HALL_REAR, S.SQ_DAMAGED_HALL_REAR_ANCHOR, S.SQ_DAMAGED_HALL_MELEE,
    S.SQ_DAMAGED_HALL_REAR_STAIR, S.SQ_DAMAGED_HALL_REAR_STAIR_ANCHOR}
local deck = {S.SQ_DECK_FRONT_A_A, S.SQ_DECK_FRONT_A_B, S.SQ_DECK_FRONT_A_C,
    S.SQ_DECK_FRONT_B_A, S.SQ_DECK_FRONT_B_B, S.SQ_DECK_FRONT_B_C,
    S.SQ_DECK_FRONT_C_A, S.SQ_DECK_HARDPOINT_L, S.SQ_DECK_HARDPOINT_L2,
    S.SQ_DECK_HARDPOINT_L_LOWER, S.SQ_DECK_HARDPOINT_R, S.SQ_DECK_ULTRA,
    S.SQ_DECK_MINIBOSS}
local ship = {S.SQ_SHIP_DOOR_MELEE, S.SQ_SHIP_DOOR_MELEE_B, S.SQ_SHIP_DOOR_MELEE_C,
    S.SQ_SHIP_DOOR_MELEE_D, S.SQ_SHIP_DOOR_MELEE_E, S.SQ_SHIP_ENTRY_A_A,
    S.SQ_SHIP_ENTRY_A_B, S.SQ_SHIP_ENTRY_A_B_O, S.SQ_SHIP_ENTRY_A_C,
    S.SQ_SHIELD_SNIPES, S.SQ_SHIELD_FRONT, S.SQ_SHIELD_MID, S.SQ_SHIELD_REAR,
    S.SQ_SHIELD_MELEE, S.SQ_SHIELD_GEN_A, S.SQ_SHIELD_GEN_B, S.SQ_SHIELD_GEN_C}

local function advance(ctx, state, next_stage, squads, authored_scene)
    if state.phase >= next_stage then return end
    ctx:set_phase(next_stage)
    if squads ~= nil then place(ctx, squads) end
    if authored_scene ~= nil then play(ctx, authored_scene) end
end

return {
    on_start = function(ctx, state)
        advance(ctx, state, 1, opening, C.SCENE_IKORA_BOULEVARD)
        play(ctx, C.SC_PYRO_INTRO)
    end,
    on_load = function(_ctx, _state) end,
    on_event_player_trigger = function(ctx, state, event)
        if entered(event, V.PT_BAZAAR_FARTHER) then
            advance(ctx, state, 2, bazaar_finale)
        elseif entered(event, V.PT_GOTO_MILITARY) then
            advance(ctx, state, 3, hangar_overlook, C.SC_MILITARY_HALLWAY_DESTRUCTION)
        elseif entered(event, V.PT_HANGAR_EARLY) or entered(event, V.PT_HANGAR_COMBAT) then
            advance(ctx, state, 4, hangar)
        elseif entered(event, V.PT_GOTO_PLAZA) or entered(event, V.PT_PLAZA_SPAWN_INIT) then
            advance(ctx, state, 5, plaza_opening, C.SC_ZAVALA)
        elseif entered(event, V.PT_PLAZA_ZAVALA_MEET) or entered(event, V.PT_DEFEND) then
            advance(ctx, state, 6, plaza_reinforcements, C.SC_ZAVALA_COMBAT)
        elseif entered(event, V.PT_CABAL_CRAWLER1) or entered(event, V.PT_DAMAGED) then
            advance(ctx, state, 7, damaged_tower)
        elseif entered(event, V.PT_DECK_START) then
            advance(ctx, state, 8, deck)
        elseif entered(event, V.PT_AIRLOCK) or entered(event, V.PT_MATRIX_DOOR) then
            advance(ctx, state, 9, ship)
        elseif entered(event, V.PT_ENGINE_ROOM_GHAUL) then
            advance(ctx, state, 10, {S.SQ_GHAUL}, C.SC_GHAUL_E3)
        elseif entered(event, V.PT_GOTO_END) or entered(event, V.PT_GOTO_END_B) then
            advance(ctx, state, 11, {S.SQ_ESCAPE_A, S.SQ_ESCAPE_B})
        end
    end,
    on_event_scene_finished = function(ctx, state, event)
        if state.phase >= 10 and event.slot ~= nil and event.slot.id == L.SC_GHAUL_E3 then
            ctx:set_phase(12)
            ctx:complete_mission{}
        end
    end,
}

# Authored mission controllers

Controllers in this directory are copied beside the built DLL and override the generated no-op
controller for the matching activity stem. At runtime they live under `Sunrise/scripts` beside the
DLL. They reference only SDK data extracted at runtime.

`mission_towerfall/mission_towerfall.lua` targets Homecoming activity `0x62D85FB3` and scenario
`0x80B500BC`. It advances through the Bazaar, Hangar, Plaza, damaged Tower, Cabal deck, ship and
Ghaul route using retail trigger volumes and authored enemy squads.

Enable `server.activation.mission_scripting`, launch `mission_towerfall`, and inspect the mission
script log channel for compile, attach or native request failures.

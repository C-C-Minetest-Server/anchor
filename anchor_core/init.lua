anchor = {}

-- The version ID indicating API features.
-- Increase this number on every changes that touched
-- the behaviour of the APIs.
-- Mods can then check the compactibility by comparing
-- this value to the target version.
-- Ideally, all changes should be backward-compactible, so
-- mods should only check for a lower limit of this variable.
anchor.version = 1

function anchor.log(lvl,msg)
	core.log(lvl,"[anchor] " .. msg)
end

local MP = core.get_modpath("anchor_core")

local function load(n)
	return dofile(MP .. DIR_DELIM .. "src" .. DIR_DELIM .. n .. ".lua")
end

load("storage")
load("playerstorage")

anchor.gui = {}
for _,k in ipairs({"setup","modify","list"}) do
	anchor.gui[k] = load("gui_" .. k)
end

load("chatcommand")
load("register")



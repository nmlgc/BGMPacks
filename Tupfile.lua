OGGENC_Q = 5

---@param pack string
---@return string
function VariantFLAC(pack)
	return string.format("%s (FLAC)", pack)
end

---@param pack string
---@return string
function VariantLossy(pack)
	return pack
end

---@class Game
---@field id string
---@field title string
local Game = {}

Game.__index = Game

---@param fn string
---@return string
function Game:fn(fn)
	return string.format("%s/%s", self.id, fn)
end

---@param variant string
---@param basename string
---@return string
function Game:variant_fn(variant, basename)
	return self:fn(string.format("%s/%s", variant, basename))
end

---@param variant string
function Game:lossy(variant)
	local variant_flac = VariantFLAC(variant)
	local variant_lossy = VariantLossy(variant)
	local f_flac = self:variant_fn(variant_flac, "*.flac")
	local f_lossy = tup.foreach_rule(
		f_flac,
		string.format('oggenc -q%d "%%f" -o "%%o"', OGGENC_Q),
		self:variant_fn(variant_lossy, "%B.ogg")
	)
end

---@param id string
---@return Game
function Game:new(id)
	local ret = setmetatable({ id = id }, self)
	return ret
end

-- SH01 秋霜玉 / Shuusou Gyoku
-- ---------------------------

local sh01 = Game:new("sh01")
SH01_ST = { "Original soundtrack", "Arranged soundtrack" }
SH01_REC = { "Romantique Tp recordings", "Sound Canvas VA" }

for _, rec in pairs(SH01_REC) do
	local variant_ost = string.format("%s (%s)", SH01_ST[1], rec)
	local variant_ast = string.format("%s (%s)", SH01_ST[2], rec)

	-- Original soundtrack
	sh01:lossy(variant_ost)

	-- Arranged soundtrack
	sh01:lossy(variant_ast)
end
-- ---------------------------

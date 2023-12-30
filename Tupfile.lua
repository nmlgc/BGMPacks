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

---@param fn string
---@return string
function Game:readme_section_fn(fn)
	return string.format("%s/README %s.md", self.id, fn)
end

--Symlinks `src` into `dst_variant`, using the same basename.
---@param src string
---@param dst_variant string
function Game:link(src, dst_variant)
	local dst = self:variant_fn(dst_variant, src:gsub(".+/", ""))
	local cmd
	if tup.getconfig("TUP_PLATFORM") == "win32" then
		local src_win = src:gsub("/", "\\"):gmatch("%w+\\(.+)")()
		local dst_win = dst:gsub("/", "\\")
		cmd = string.format('cmd /c mklink "%s" "..\\%s"', dst_win, src_win)
	else
		cmd = 'ln -s "%f" "%o"'
	end
	return tup.rule(src, cmd, dst)
end

---Generates a README file for the given variant.
---@param variant string
---@param sections string[]
function Game:readme(variant, sections)
	local variant_title = variant
	if tup.getconfig("TUP_PLATFORM") == "win32" then
		variant_title = variant:gsub("%)", "^)")
	end
	local cmd = string.format('echo # %s – %s', self.title, variant_title)
	for _, section in pairs(sections) do
		cmd = (cmd .. string.format('&& cat "%s"', section))
	end
	cmd = (cmd .. string.format(
		" | sed -f README.sed -e s/\\{oggenc_q\\}/%d/", OGGENC_Q
	))
	return tup.rule(
		sections,
		string.format('(%s)>"%%o"', cmd),
		self:variant_fn(variant, "README.md")
	)
end

---@param variant string
---@param readme_sections string[]
function Game:lossy(variant, readme_sections)
	local variant_flac = VariantFLAC(variant)
	local variant_lossy = VariantLossy(variant)
	local f_flac = self:variant_fn(variant_flac, "*.flac")
	local f_lossy = tup.foreach_rule(
		f_flac,
		string.format('oggenc -q%d "%%f" -o "%%o"', OGGENC_Q),
		self:variant_fn(variant_lossy, "%B.ogg")
	)
	f_flac += self:readme(variant_flac, readme_sections)
	readme_sections += { "README Lossy.md" }
	f_lossy += self:readme(variant_lossy, readme_sections)
end

---@param id string
---@param title string
---@return Game
function Game:new(id, title)
	local ret = setmetatable({
		id = id, title = (id:upper() .. " " .. title),
	}, self)
	return ret
end

-- SH01 秋霜玉 / Shuusou Gyoku
-- ---------------------------

local sh01 = Game:new("sh01", "秋霜玉 / Shuusou Gyoku")
SH01_ST = { "Original soundtrack", "Arranged soundtrack" }
SH01_REC = { "Romantique Tp recordings", "Sound Canvas VA" }

for _, rec in pairs(SH01_REC) do
	local variant_ost = string.format("%s (%s)", SH01_ST[1], rec)
	local variant_ast = string.format("%s (%s)", SH01_ST[2], rec)
	local variant_ost_flac = VariantFLAC(variant_ost)
	local variant_ast_flac = VariantFLAC(variant_ast)
	local section_ost = sh01:readme_section_fn(SH01_ST[1])
	local section_ast = sh01:readme_section_fn(SH01_ST[2])

	-- Original soundtrack
	local sections = { section_ost }
	sh01:lossy(variant_ost, sections)

	-- Arranged soundtrack
	for _, basename in pairs({ "20.flac", "20.loop.flac" }) do
		local src = sh01:variant_fn(variant_ost_flac, basename)
		sh01:link(src, variant_ast_flac)
	end
	local sections = { section_ast }
	sh01:lossy(variant_ast, sections)
end
-- ---------------------------

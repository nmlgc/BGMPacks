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
---@field placefiles string[]
local Game = {}

Game.__index = Game

---@param fn string
---@return string
function Game:fn(fn)
	return string.format("%s/%s", self.id, fn)
end

---@param fn string
---@return string
function Game:build_fn(fn)
	return self:fn("_build/" .. fn)
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

---Runs a sed patch on a MIDI file.
---@param src string
---@param dst string
---@param patch_fns string[]
function Game:midi_patch(src, dst, patch_fns)
	local cmd = "midicomp -i \"%f\" | "
	for _, patch_fn in pairs(patch_fns) do
		cmd = (cmd .. string.format("sed -rf '%s' | ", patch_fn))
	end
	cmd = (cmd .. "midicomp -ic \"%o\"")
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
---@param order_inputs string[]
function Game:pack(variant, order_inputs)
	local cmd = string.format(
		'7z a -xr!.gitignore "%%o" "./%s/%s"', self.id, variant
	)
	for _, fn in pairs(self.placefiles) do
		cmd = (cmd .. string.format(' "./%s"', fn))
	end
	inputs += order_inputs
	inputs += self.placefiles
	local zip_fn = string.format("release/%s %s.zip", self.id, variant)
	tup.rule(inputs, cmd, zip_fn)
end

---@param variant string
---@param readme_sections string[]
---@param extra_files_to_link string[]
---@param flac_order_inputs string[]
function Game:lossy_and_pack(
	variant, readme_sections, extra_files_to_link, flac_order_inputs
)
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

	for _, input in pairs(extra_files_to_link) do
		f_flac += input
		f_lossy += self:link(input, variant_lossy)
	end

	f_flac += flac_order_inputs
	f_lossy += flac_order_inputs
	self:pack(variant_flac, f_flac)
	self:pack(variant_lossy, f_lossy)
end

---@param id string
---@param title string
---@param place_strings string[]
---@return Game
function Game:new(id, title, place_strings)
	local ret = setmetatable({
		id = id, title = (id:upper() .. " " .. title), placefiles = {}
	}, self)
	for _, str in pairs(place_strings) do
		ret.placefiles += tup.rule({}, 'type NUL >"%o"', ret:build_fn(str))
	end
	return ret
end

-- SH01 秋霜玉 / Shuusou Gyoku
-- ---------------------------

local sh01 = Game:new("sh01", "秋霜玉 / Shuusou Gyoku", {
	"Place the soundtrack folder (not its contents) into Shuusou Gyoku's bgm folder",
	"Lege den Soundtrack-Ordner (not its contents) in den bgm-Ordner von Shuusou Gyoku",

	-- Commissioned from https://twitter.com/Wafflesespeon24
	"「秋霜玉のbgmのフォルダ」では中に置きます「音楽のフォルダ」",

	-- Based on https://twitter.com/verinnah/status/1740070244306043292
	"Coloca la carpeta de la banda sonora (no su contenido) en la carpeta bgm de Shuusou Gyoku",
})
SH01_ST = { "Original soundtrack", "Arranged soundtrack" }
SH01_REC = { "(Romantique Tp recordings)", "(Sound Canvas VA)", "(Sound Canvas VA) (no echo)" }

---@param echo boolean
---@return string[]
function sh01:sections_midi(echo)
	local ret = { self:readme_section_fn("MIDI") }
	if echo then
		ret += self:readme_section_fn("MIDI echo")
	end
	ret += self:readme_section_fn("MIDI footer")
	return ret
end

local variant_mid = string.format("%s (MIDIs only)", SH01_ST[2])
local variant_mid_ne = string.format("%s (no echo)", variant_mid)
local build_path = sh01:build_fn("")
local arranged_mids_in_ne_pack = {}
local arranged_mids_in_e_pack = {}
for i = 1, 19 do
	local lzh_basename = string.format("ssg_%02u.lzh", i)
	local cmd = string.format(
		"curl -o %%o https://www16.big.or.jp/~zun/data/smf/arc/%s", lzh_basename
	)
	local lzh = tup.rule({}, cmd, sh01:build_fn(lzh_basename))

	local mid_fn_in_lzh = string.format("ssg_%02u.mid", i)
	local mid_fn_original = (build_path .. mid_fn_in_lzh)
	cmd = string.format('7z e -o"%s" %%f %s', build_path, mid_fn_in_lzh)
	tup.rule(lzh, cmd, mid_fn_original)

	local mid_fn_ne_g = sh01:fn(string.format("%s/%02u.mid", variant_mid_ne, i))
	local mid_fn_e_g = sh01:fn(string.format("%s/%%b", variant_mid))
	arranged_mids_in_ne_pack += sh01:midi_patch(
		mid_fn_original,
		mid_fn_ne_g,
		{ "sh01/MIDI general fixes.sed", "sh01/MIDI in-game fixes.sed" }
	)
	arranged_mids_in_e_pack += sh01:midi_patch(
		mid_fn_ne_g, mid_fn_e_g, { "sh01/MIDI echo.sed" }
	)
	local mid_fn_ne_rec = sh01:midi_patch(
		mid_fn_original,
		sh01:build_fn("ast_rec/ne/%b"),
		{ "sh01/MIDI general fixes.sed", "sh01/MIDI recording fixes.sed" }
	)
	sh01:midi_patch(
		mid_fn_ne_rec, sh01:build_fn("ast_rec/e/%b"), { "sh01/MIDI echo.sed" }
	)
end
local sections_midi_ne = { sh01:readme_section_fn(variant_mid) }
local sections_midi_e = { table.unpack(sections_midi_ne) }
sections_midi_ne += sh01:sections_midi(false)
sections_midi_e += sh01:sections_midi(true)
local inputs = sh01:readme(variant_mid_ne, sections_midi_ne)
inputs += arranged_mids_in_ne_pack
sh01:pack(variant_mid_ne, inputs)

inputs = sh01:readme(variant_mid, sections_midi_e)
inputs += arranged_mids_in_e_pack
sh01:pack(variant_mid, inputs)

--- Link missing echo files from the no-echo recordings
---@param st string
local function link_missing(st)
	local variant_ne = VariantFLAC(st .. " " .. SH01_REC[3])
	local variant_e = VariantFLAC(st .. " " .. SH01_REC[2])
	local ne = {}
	for _, v in pairs(tup.glob(sh01:variant_fn(variant_ne, "*.flac"))) do
		ne[tup.file(v)] = true
	end
	for _, v in pairs(tup.glob(sh01:variant_fn(variant_e, "*.flac"))) do
		ne[tup.file(v)] = nil
	end
	for basename, _ in pairs(ne) do
		sh01:link(sh01:variant_fn(variant_ne, basename), variant_e)
	end
end
link_missing(SH01_ST[1])
link_missing(SH01_ST[2])

for rec_i, rec in pairs(SH01_REC) do
	local variant_ost = string.format("%s %s", SH01_ST[1], rec)
	local variant_ast = string.format("%s %s", SH01_ST[2], rec)
	local variant_ost_flac = VariantFLAC(variant_ost)
	local variant_ast_flac = VariantFLAC(variant_ast)
	local section_ost = sh01:readme_section_fn(SH01_ST[1])
	local section_ast = sh01:readme_section_fn(SH01_ST[2])

	local sections_rec = {}
	if rec_i >= 2 then
		sections_rec += { "README Sound Canvas VA.md" }
		sections_rec += {
			sh01:readme_section_fn("Sound Canvas VA echo header")
		}
		sections_rec += { sh01:readme_section_fn(rec) }
		sections_rec += { sh01:readme_section_fn("Sound Canvas VA version") }
		sections_rec += { "README Sound Canvas VA process.md" }
	else
		sections_rec += { sh01:readme_section_fn(rec) }
	end

	-- Original soundtrack
	local sections = { section_ost }
	sections += sections_rec
	sh01:lossy_and_pack(variant_ost, sections, {}, {})

	-- Arranged soundtrack
	local flac_extras = {}
	local arranged_mids = (
		((rec_i == 3) and arranged_mids_in_e_pack) or arranged_mids_in_ne_pack
	)
	for _, mid in pairs(arranged_mids) do
		flac_extras += sh01:link(mid, variant_ast_flac)
	end
	local order_inputs = {}
	for _, basename in pairs({ "20.flac", "20.loop.flac" }) do
		local src = sh01:variant_fn(variant_ost_flac, basename)
		order_inputs += sh01:link(src, variant_ast_flac)
	end
	local sections = { section_ast }
	sections += sections_rec
	if rec_i == 1 then
		sections += { sh01:readme_section_fn(variant_ast) }
	else
		local fn = string.format("%s (Sound Canvas VA)", SH01_ST[2])
		table.insert(sections, 6, sh01:readme_section_fn(fn))
	end
	sections += sh01:sections_midi(false)
	sh01:lossy_and_pack(variant_ast, sections, flac_extras, order_inputs)
end
-- ---------------------------

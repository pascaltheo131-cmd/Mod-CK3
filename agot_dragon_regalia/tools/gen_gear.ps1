$ErrorActionPreference = 'Stop'
$M = 'C:\Users\pasca\Documents\Paradox Interactive\Crusader Kings III\mod\Mod-CK3\agot_dragon_regalia'
$enc = New-Object System.Text.UTF8Encoding $true
function Out-ModFile($rel, $text) {
	$p = Join-Path $M $rel
	New-Item -ItemType Directory -Force (Split-Path $p) | Out-Null
	[IO.File]::WriteAllText($p, ($text -replace "`r?`n", "`r`n"), $enc)
}

Add-Type -TypeDefinition @"
using System; using System.IO;
public static class DrDds {
  public static void Write(string path, int[] rgb) {
    int w = 16, h = 4;
    using (var bw = new BinaryWriter(File.Create(path))) {
      bw.Write(new byte[]{0x44,0x44,0x53,0x20});
      bw.Write(124); bw.Write(0x100F); bw.Write(h); bw.Write(w); bw.Write(w*4); bw.Write(0); bw.Write(0);
      for (int i=0;i<11;i++) bw.Write(0);
      bw.Write(32); bw.Write(0x41); bw.Write(0); bw.Write(32);
      bw.Write(0x00FF0000); bw.Write(0x0000FF00); bw.Write(0x000000FF); unchecked { bw.Write((int)0xFF000000); }
      bw.Write(0x1000); bw.Write(0); bw.Write(0); bw.Write(0); bw.Write(0);
      for (int y=0;y<h;y++) for (int x=0;x<w;x++) {
        int blk = x/4, sub = x%4;
        double f = sub==2 ? 0.82 : (sub==3 ? 1.15 : 1.0);
        for (int c=2;c>=0;c--) { int v=(int)Math.Round(rgb[blk*3+c]*f); if (v>255) v=255; bw.Write((byte)v); }
        bw.Write((byte)255);
      }
    }
  }
}
"@

# --- Patterns (r, g, b) par style : texture + layout (tous verifies dans le jeu / AGOT)
$stylePatterns = [ordered]@{
	war       = @(@('leather_plain_04','western_silk_brocade_01_layout'), @('leather_plain_04','plain_fabric_layout'), @('leather_plain_01','small_trim_layout'))
	travel    = @(@('leather_plain_01','western_silk_brocade_01_layout'), @('western_wool_plain_01','plain_fabric_layout'), @('leather_plain_01','small_trim_layout'))
	parade    = @(@('western_silk_brocade_01','western_silk_brocade_01_layout'), @('velvet_01','plain_fabric_layout'), @('western_silk_trim_01','small_trim_layout'))
	valyrian  = @(@('valyrian_silk_01','valyrian_silk_01_layout'), @('agot_leather_damask_01','agot_armor_layout_01'), @('leather_plain_04','small_trim_layout'))
	champion  = @(@('western_silk_brocade_01','western_silk_brocade_01_layout'), @('velvet_01','plain_fabric_layout'), @('western_silk_trim_01','small_trim_layout'))
	conqueror = @(@('agot_leather_damask_01','western_silk_brocade_01_layout'), @('leather_plain_04','plain_fabric_layout'), @('leather_plain_04','small_trim_layout'))
}
$metalTex = [ordered]@{ gold = 'western_gold_plain_01'; silver = 'all_silver_plain_rough_01'; black = 'cast_iron_01' }
$metalRgb = @{ gold = @(200,160,70); silver = @(190,190,196); black = @(48,46,50); champion = @(232,192,84) }

# --- Couleurs (principal r, secondaire g, garniture b)
$colorSets = [ordered]@{
	style_war      = @(55,42,35, 40,32,28, 82,70,60)
	style_travel   = @(150,110,70, 175,140,100, 110,80,50)
	style_parade   = @(125,20,35, 62,16,26, 192,152,62)
	style_valyrian = @(26,22,24, 140,20,22, 34,28,28)
	targaryen = @(26,22,24, 150,20,20, 26,22,24)
	velaryon  = @(70,150,140, 192,196,202, 40,92,92)
	lannister = @(150,20,30, 202,160,60, 110,15,20)
	stark     = @(110,112,116, 226,226,226, 70,72,76)
	baratheon = @(30,28,28, 205,165,50, 30,28,28)
	arryn     = @(120,170,215, 232,232,236, 70,110,160)
	tully     = @(40,70,150, 160,30,30, 40,70,150)
	tyrell    = @(50,110,50, 210,170,60, 40,80,40)
	martell   = @(220,110,30, 170,30,25, 230,150,50)
	greyjoy   = @(25,25,28, 195,160,60, 25,25,28)
	hightower = @(120,120,126, 230,230,230, 220,120,40)
	neutral   = @(100,85,70, 130,115,95, 80,65,55)
}
$houses = @('targaryen','velaryon','lannister','stark','baratheon','arryn','tully','tyrell','martell','greyjoy','hightower','neutral')
$baseStyles = @('war','travel','parade','valyrian')

$texDir = Join-Path $M 'gfx\portraits\accessory_variations\textures'
New-Item -ItemType Directory -Force $texDir | Out-Null
function New-Palette($name, $c3, $metal) { [DrDds]::Write((Join-Path $texDir "agot_dr_gear_$name.dds"), [int[]]($c3 + $metal)) }
foreach ($cs in $colorSets.Keys) { foreach ($mt in $metalTex.Keys) { New-Palette "${cs}_$mt" $colorSets[$cs] $metalRgb[$mt] } }
New-Palette 'champion' @(90,150,210, 235,235,240, 205,165,60) $metalRgb.champion
New-Palette 'conqueror' @(20,18,20, 130,15,20, 52,50,56) $metalRgb.black

# --- Liste des combinaisons
$combos = New-Object System.Collections.ArrayList
foreach ($s in $baseStyles) { foreach ($mt in $metalTex.Keys) { foreach ($c in @('style') + $houses) {
	$pal = if ($c -eq 'style') { "style_${s}_$mt" } else { "${c}_$mt" }
	[void]$combos.Add([pscustomobject]@{ id = "${s}_${mt}_$c"; style = $s; metal = $mt; colors = $c; pal = $pal })
} } }
[void]$combos.Add([pscustomobject]@{ id = 'champion'; style = 'champion'; metal = 'gold'; colors = $null; pal = 'champion' })
[void]$combos.Add([pscustomobject]@{ id = 'conqueror'; style = 'conqueror'; metal = 'black'; colors = $null; pal = 'conqueror' })

$hdr = "# AGOT - Dragon Regalia : Equipement (selles). FICHIER GENERE (scratchpad gen_gear.ps1) - ne pas editer a la main.`n"

# --- Variations
$sb = New-Object Text.StringBuilder
[void]$sb.Append($hdr + "# Memes masques que dragon_saddle_01 d'AGOT : r = assise, g = sangles/panneaux, b = garnitures, a = pieces metalliques.`n# Une seule ligne de palette (repetee 4x) => couleur deterministe.`n`n")
foreach ($k in $combos) {
	$p = $stylePatterns[$k.style]
	[void]$sb.Append(@"
variation = {
	name = "agot_dr_gear_$($k.id)"
	pattern = {
		weight = 1
		r = { textures = "$($p[0][0])"	layout = "$($p[0][1])" }
		g = { textures = "$($p[1][0])"	layout = "$($p[1][1])" }
		b = { textures = "$($p[2][0])"	layout = "$($p[2][1])" }
		a = { textures = "$($metalTex[$k.metal])"	layout = "plain_fabric_layout" }
	}
	color_palette = { weight = 1	texture = "gfx/portraits/accessory_variations/textures/agot_dr_gear_$($k.pal).dds" }
}

"@)
}
Out-ModFile 'gfx\portraits\accessory_variations\agot_dr_gear_saddle_variations.txt' $sb.ToString()

# --- Entites (meme maillage saddle_mesh d'AGOT, autre variation)
$states = @'
	state = {	name = "dragon_static"						animation = "dragon_idle_1" 					looping = no animation_speed = 1.0 animation_blend_time = 0.3 }
	state = {	name = "dragon_idle_loop"					animation = "dragon_idle_1" 					looping = no animation_speed = 1.0 animation_blend_time = 0.3 }
	state = {	name = "dragon_idle_entry"					animation = "dragon_idle_flair_lookingleft" 	looping = no animation_speed = 1.0 animation_blend_time = 0.3 }
	state = {	name = "dragon_idle"						animation = "dragon_idle_1" 					looping = no animation_speed = 1.0 animation_blend_time = 0.3 }
	state = {	name = "dragon_flying"						animation = "dragon_flying_1" 					looping = no animation_speed = 1.0 animation_blend_time = 0.3 }
	state = {	name = "dragon_flying_2"					animation = "dragon_flying_2" 					looping = no animation_speed = 1.0 animation_blend_time = 0.3 }
	state = {	name = "dragon_flying_fire"					animation = "dragon_flying_1_fire" 				looping = no animation_speed = 1.0 animation_blend_time = 0.3 }
	state = {	name = "dragon_flying_2_fire"				animation = "dragon_flying_2_fire" 				looping = no animation_speed = 1.0 animation_blend_time = 0.3 }
	state = {	name = "dragon_roar"						animation = "dragon_roar_1" 					looping = no animation_speed = 1.0 animation_blend_time = 0.3 }
	state = {	name = "dragon_hover"						animation = "dragon_hover_1" 					looping = no animation_speed = 1.0 animation_blend_time = 0.3 }
	state = {	name = "dragon_roar_fire"					animation = "dragon_roar_1_fire" 				looping = no animation_speed = 1.0 animation_blend_time = 0.3 }
	state = {	name = "dragon_hover_fire"					animation = "dragon_hover_1_fire" 				looping = no animation_speed = 1.0 animation_blend_time = 0.3 }
	state = {	name = "dragon_baby_idle"					animation = "dragon_baby_idle_1" 				looping = no animation_speed = 1.0 animation_blend_time = 0.3 }
	state = {	name = "dragon_baby_idle_2"					animation = "dragon_baby_idle_2" 				looping = no animation_speed = 1.0 animation_blend_time = 0.3 }
	state = {	name = "dragon_baby_idle_burp"				animation = "dragon_baby_idle_burp" 			looping = no animation_speed = 1.0 animation_blend_time = 0.3 }
	state = {	name = "dragon_baby_fire"					animation = "dragon_baby_idle_burp" 			looping = no animation_speed = 1.0 animation_blend_time = 0.3 }
	state = {	name = "dragon_baby_fire_idle"				animation = "dragon_baby_idle_1" 				looping = no animation_speed = 1.0 animation_blend_time = 0.3 }
'@
$sb = New-Object Text.StringBuilder
[void]$sb.Append($hdr + "# Copie fidele de saddle_entity (AGOT, saddle.asset) ; seule la variation change.`n# PHASE 2 (Blender) : un caparacon brode du vrai blason (coat_of_arms) et des ornements de cornes demandent de NOUVEAUX maillages ;`n# ils viendront ici sous forme de nouvelles entites (ex. agot_dr_gear_caparison_entity, agot_dr_gear_horn_ornament_entity).`n`n")
foreach ($k in $combos) {
	[void]$sb.Append(@"
entity = {
	name = "agot_dr_gear_$($k.id)_entity"
	pdxmesh = "saddle_mesh"
	game_data = {
		portrait_entity_user_data = {
			color_mask_remap_interval = {
				interval = {0.0 1.0}
			}
			portrait_accessory = {
				pattern_mask = "gfx/models/portraits/agot_creatures/dragon/saddle/saddle_masks.dds"
				variation = "agot_dr_gear_$($k.id)"
			}
		}
	}
	attribute = { name = "bs_dragon_large"						blend_shape = "saddle_dragon_large" }
	attribute = { name = "dragon_infant_proportions" 			additive_animation = "dragon_infant_proportions" default = 0.5 }
	attribute = { name = "dragon_large_proportions" 			additive_animation = "dragon_large_proportions" default = 0.5 }
	get_state_from_parent = yes
$states}

"@)
}
Out-ModFile 'gfx\models\portraits\agot_creatures\dragon\agot_dr_gear_saddles.asset' $sb.ToString()

# --- Accessoires
$sb = New-Object Text.StringBuilder
[void]$sb.Append($hdr + "`n")
foreach ($k in $combos) { [void]$sb.Append("agot_dr_gear_acc_$($k.id) = {`n`tentity = {`tnode = `"dragon_origin`"`tentity = `"agot_dr_gear_$($k.id)_entity`" }`n}`n`n") }
Out-ModFile 'gfx\portraits\accessories\agot_dr_gear_saddles.txt' $sb.ToString()

# --- Gene
$sb = New-Object Text.StringBuilder
[void]$sb.Append($hdr + "# Nouveau gene accessoire (special) : AGOT n'est pas modifie. Le gene gene_dragon_saddle d'AGOT est mis a no_saddle`n# par notre portrait modifier quand une parure est choisie.`nspecial_genes = {`n`taccessory_genes = {`n`t`tagot_dr_gear_saddle = {`n")
[void]$sb.Append("`t`t`tagot_dr_gear_none = {`n`t`t`t`tindex = 0`n`t`t`t`tmale = { 1 = empty }`n`t`t`t`tfemale = male`n`t`t`t`tboy = male`n`t`t`t`tgirl = female`n`t`t`t}`n")
$i = 1
foreach ($k in $combos) {
	[void]$sb.Append("`t`t`tagot_dr_gear_$($k.id) = {`n`t`t`t`tindex = $i`n`t`t`t`tmale = { 1 = agot_dr_gear_acc_$($k.id) }`n`t`t`t`tfemale = male`n`t`t`t`tboy = male`n`t`t`t`tgirl = female`n`t`t`t}`n")
	$i++
}
[void]$sb.Append("`t`t}`n`t}`n}`n")
Out-ModFile 'common\genes\agot_dr_gear_genes.txt' $sb.ToString()

# --- Portrait modifiers
$sb = New-Object Text.StringBuilder
[void]$sb.Append($hdr + @"
# Priorite 12 > dragonrider d'AGOT (11) : applique APRES et ecrase la selle d'AGOT.
# Portee = le personnage porte (le cavalier, tag dragonrider) ; la parure est lue sur var:current_dragon.
# Tout modificateur dont le tag correspond a un poids >= 1 : l'entree agot_dr_gear_default (poids 100 si aucune parure)
# garantit qu'on ne choisit pas une parure au hasard. selection_behavior = max : le premier poids >= 100 l'emporte.
agot_dr_gear_saddle_group = {
	usage = game
	selection_behavior = max
	priority = 12

	agot_dr_gear_default = {
		dna_modifiers = {
			accessory = {
				mode = add
				gene = agot_dr_gear_saddle
				template = agot_dr_gear_none
				value = 0.5
			}
		}
		outfit_tags = { dragonrider }
		require_outfit_tags = yes
		weight = {
			base = 0
			modifier = {
				add = 100
				NOT = { var:current_dragon ?= { has_variable = agot_dr_gear_style } }
			}
		}
	}

"@)
foreach ($k in $combos) {
	$cond = "var:agot_dr_gear_style ?= flag:$($k.style)"
	if ($k.colors) { $cond += " var:agot_dr_gear_metal ?= flag:$($k.metal) var:agot_dr_gear_colors ?= flag:$($k.colors)" }
	[void]$sb.Append(@"
	agot_dr_gear_pm_$($k.id) = {
		dna_modifiers = {
			accessory = {
				mode = add
				gene = gene_dragon_saddle
				template = no_saddle
				value = 0.5
			}
			accessory = {
				mode = add
				gene = agot_dr_gear_saddle
				template = agot_dr_gear_$($k.id)
				value = 0.5
			}
		}
		outfit_tags = { dragonrider }
		require_outfit_tags = yes
		weight = {
			base = 0
			modifier = {
				add = 100
				var:current_dragon ?= { $cond }
			}
		}
	}

"@)
}
[void]$sb.Append("}`n")
Out-ModFile 'gfx\portraits\portrait_modifiers\agot_dr_gear_saddle_modifiers.txt' $sb.ToString()
"combos: $($combos.Count)"

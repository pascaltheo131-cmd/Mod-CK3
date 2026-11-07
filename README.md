# Mod-CK3

## AGOT - Dragon Events (`agot_dragon_events/`)

Sous-mod pour **A Game of Thrones (CK3)** ajoutant des événements aléatoires liés aux dragons :
- 5 événements annuels (dragon rétif, troupeaux dévorés, croissance, rêves de feu, courtisan attaqué)
- 3 événements de bataille (victoire : feu et sang, terreur des cieux ; défaite : dragon blessé)
- Localisation française et anglaise

### Installation
Copier `agot_dragon_events/` et `agot_dragon_events.mod` dans
`Documents/Paradox Interactive/Crusader Kings III/mod/`, puis charger **après** AGOT.

### Compatibilité
Les noms AGOT (trait `dragon`, variable `var:current_dragon`) sont centralisés dans
`agot_dragon_events/common/scripted_triggers/dre_triggers.txt` — à vérifier contre les fichiers d'AGOT.

### Test
Lancer CK3 avec `-debug_mode`, puis dans la console : `event dragon_ev.0001`.

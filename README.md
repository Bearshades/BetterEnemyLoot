# BetterEnemyLoot
A mod for Road to Vostok that gives AI enemies a configurable chance to carry consumables, medical supplies, magazines, and loose ammo matching their weapon's caliber. By default enemies are just another loot container, so are generally empty and don't have any special rules governing what they're holding. This mod is intended to make looting bodies more worthwhile and logical.

Settings are exposed through the Mod Configuration Menu (MCM), letting you tune spawn rates and quantities for each loot category independently.

### What it does
When an AI enemy is killed the game runs the AI.Death(direction, force) method which in turn calls AI.ActivateContainer() to enable collision (and consequently interaction) with the corpse's container. This mod hooks into that activation to add appropriate items to the body:
- Consumables — food and drink items (civilian, industrial, or military depending on enemy type)
- Medical — bandages, meds, etc.
- Magazines — spare mags compatible with the enemy's equipped weapon
- Ammo — loose rounds matching the weapon's caliber

### Building the .vmz
A .vmz is just a renamed .zip archive. To package the mod:

1. Select all the files in Windows Explorer (or your file manager).
2. Right-click → **7-Zip → Add to archive…**
3. Set **Archive format** to `zip`.
4. Name the file `BetterEnemyLoot.vmz` (just type the `.vmz` extension directly).
5. Click **OK**.

The resulting `BetterEnemyLoot.vmz` can be dropped directly into the game's mods folder provided you have a mod loader like [Vostok Mod Loader](https://github.com/ametrocavich/vostok-mod-loader)

Editing settings in-game requires the Mod Configuration Menu (https://modworkshop.net/mod/53713). Without it the mod runs on its default settings.

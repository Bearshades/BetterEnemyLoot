# BetterEnemyLoot

A mod for Road to Vostok that gives AI enemies a configurable chance to carry consumables, medical supplies, magazines, and loose ammo matching their weapon's caliber. By default enemies are just another loot container, so are generally empty, so this mod makes looting bodies actually worthwhile.

Settings are exposed through the Mod Configuration Menu (MCM), letting you tune spawn rates and quantities for each loot category independently.

What it does
When an AI enemy is killed the game runs the AI.death(...) method which calls AI.ActivateContainer(). This mod hooks into that to add appropriate items to the body:

Consumables — food and drink items (civilian, industrial, or military depending on enemy type)
Medical — bandages, meds, etc.
Magazines — spare mags compatible with the enemy's equipped weapon
Ammo — loose rounds matching the weapon's caliber

Building the .vmz
A .vmz is a renamed .zip archive. To package the mod:

Place all mod files inside a folder named BetterEnemyLoot/.
Select the folder in Windows Explorer (or your file manager).
Right-click → 7-Zip → Add to archive…
Set Archive format to zip.
Name the file BetterEnemyLoot.vmz (just type the .vmz extension directly).
Click OK.

The resulting BetterEnemyLoot.vmz can be dropped into the game's mods folder provided you have a mod loader like https://modworkshop.net/mod/55623

Editing settings in-game requires the Mod Configuration Menu (https://modworkshop.net/mod/53713). Without it the mod runs on its default settings.
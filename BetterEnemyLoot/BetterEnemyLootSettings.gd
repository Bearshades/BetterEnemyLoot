extends Resource
class_name BetterEnemyLootSettings

var max_consumables = 2
var max_medical = 2
var max_magazines = 2
var max_ammo = 10
var debug = false
# Signed roll counts: positive = max-biased, negative = min-biased, 0 = Off
# e.g.  2 = max of 2 rolls (Most),  -3 = min of 3 rolls (Less)
var consumable_rolls = -2  # Common
var medical_rolls = -3     # Less
var magazine_rolls = -3    # Less
var ammo_rolls = -2        # Common
var rare_chance = 0.25

extends Node

var configSettings = preload("res://BetterEnemyLoot/BetterEnemyLootSettings.tres")
var McmHelpers = null

const FILE_PATH = "user://MCM/BetterEnemyLoot"
const MOD_ID = "BetterEnemyLoot"

const ABUNDANCE_OPTIONS = [
    "Highest (maximum of 2 rolls)",
    "High    (1 roll)",
    "Normal  (minimum of 2 rolls)",
    "Low     (minimum of 3 rolls)",
    "Lowest  (minimum of 4 rolls)",
    "None    (Off)"
]

# Maps dropdown index to a signed roll count.
# Positive = max-biased, negative = min-biased, 0 = Off.
func _rolls_from_index(idx: int) -> int:
    match idx:
        0: return 2   # Most:   max of 2
        1: return 1   # More:   1 roll (no bias)
        2: return -2  # Common: min of 2
        3: return -3  # Less:   min of 3
        4: return -4  # Least:  min of 4
        _: return 0   # Off

func _ready():
    
    if ResourceLoader.exists("res://ModConfigurationMenu/Scripts/Doink Oink/MCM_Helpers.tres"):
        McmHelpers = load("res://ModConfigurationMenu/Scripts/Doink Oink/MCM_Helpers.tres")
    
    var _config = ConfigFile.new()

    # ── Consumables ──────────────────────────────────────────────────────────
    _config.set_value("Int", "max_consumables", {
        "name" = "Maximum",
        "tooltip" = "Maximum food/drink items an AI can carry. Note increasing the maximum will also increase how commonly the item is found.",
        "default" = 2,
        "value" = 2,
        "minRange" = 0,
        "maxRange" = 10,
        "category" = "Consumables"
    })
    _config.set_value("Dropdown", "consumable_rolls", {
        "name" = "Amount",
        "tooltip" = "Controls how frequently consumables are found on enemies.",
        "default" = 2,  # Common (min of 2 rolls)
        "value" = 2,
        "options" = ABUNDANCE_OPTIONS,
        "category" = "Consumables"
    })

    # ── Medical ──────────────────────────────────────────────────────────────
    _config.set_value("Int", "max_medical", {
        "name" = "Maximum",
        "tooltip" = "Maximum medical items an AI can carry. Note increasing the maximum will also increase how commonly the item is found.",
        "default" = 2,
        "value" = 2,
        "minRange" = 0,
        "maxRange" = 10,
        "category" = "Medical"
    })
    _config.set_value("Dropdown", "medical_rolls", {
        "name" = "Amount",
        "tooltip" = "Controls how frequently medical supplies are found on enemies.",
        "default" = 3,  # Less (min of 3 rolls)
        "value" = 3,
        "options" = ABUNDANCE_OPTIONS,
        "category" = "Medical"
    })

    # ── Magazines ────────────────────────────────────────────────────────────
    _config.set_value("Int", "max_magazines", {
        "name" = "Maximum",
        "tooltip" = "Maximum matching magazines an AI can carry. Note increasing the maximum will also increase how commonly the item is found.",
        "default" = 2,
        "value" = 2,
        "minRange" = 0,
        "maxRange" = 5,
        "category" = "Magazines"
    })
    _config.set_value("Dropdown", "magazine_rolls", {
        "name" = "Amount",
        "tooltip" = "Controls how frequently magazines for the weapon the enemy is using is found on enemies",
        "default" = 3,  # Less (min of 3 rolls)
        "value" = 3,
        "options" = ABUNDANCE_OPTIONS,
        "category" = "Magazines"
    })

    # ── Ammo ─────────────────────────────────────────────────────────────────
    _config.set_value("Int", "max_ammo", {
        "name" = "Maximum",
        "tooltip" = "Maximum matching ammo an AI can carry. Note increasing the maximum will also increase how commonly the item is found.",
        "default" = 10,
        "value" = 10,
        "minRange" = 0,
        "maxRange" = 50,
        "category" = "Ammo"
    })
    _config.set_value("Dropdown", "ammo_rolls", {
        "name" = "Amount",
        "tooltip" = "Controls how frequently loose ammo of the appropriate weapon's caliber is found on enemies.",
        "default" = 2,  # Common (min of 2 rolls)
        "value" = 2,
        "options" = ABUNDANCE_OPTIONS,
        "category" = "Ammo"
    })

    # ── Rarity / Debug ───────────────────────────────────────────────────────
    _config.set_value("Float", "rare_chance", {
        "name" = "Rare Chance",
        "tooltip" = "Chance a loot item will be rare instead of common",
        "default" = 0.25,
        "value" = 0.25,
        "minRange" = 0,
        "maxRange" = 1,
        "category" = "Rarity"
    })

    _config.set_value("Bool", "debug", {
        "name" = "Debug Logging",
        "tooltip" = "Add verbose debug logging to game log",
        "default" = false,
        "value" = false,
        "category" = "Settings - Debug"
    })

    if McmHelpers:
        if !FileAccess.file_exists(FILE_PATH + "/config.ini"):
            DirAccess.open("user://").make_dir(FILE_PATH)
            _config.save(FILE_PATH + "/config.ini")
        else:
            McmHelpers.CheckConfigurationHasUpdated(MOD_ID, _config, FILE_PATH + "/config.ini")
            _config.load(FILE_PATH + "/config.ini")

        McmHelpers.RegisterConfiguration(
            MOD_ID,
            "Better Enemy Loot",
            FILE_PATH,
            "Configures bonus loot dropped by AI enemies",
            UpdateConfigProperties,
            self
        )

        UpdateConfigProperties(_config)

func UpdateConfigProperties(config: ConfigFile):
    configSettings.max_consumables  = config.get_value("Int",      "max_consumables")["value"]
    configSettings.max_medical      = config.get_value("Int",      "max_medical")["value"]
    configSettings.max_magazines    = config.get_value("Int",      "max_magazines")["value"]
    configSettings.max_ammo         = config.get_value("Int",      "max_ammo")["value"]
    configSettings.debug            = config.get_value("Bool",     "debug")["value"]
    configSettings.rare_chance      = config.get_value("Float",    "rare_chance")["value"]
    configSettings.consumable_rolls = _rolls_from_index(config.get_value("Dropdown", "consumable_rolls")["value"])
    configSettings.medical_rolls    = _rolls_from_index(config.get_value("Dropdown", "medical_rolls")["value"])
    configSettings.magazine_rolls   = _rolls_from_index(config.get_value("Dropdown", "magazine_rolls")["value"])
    configSettings.ammo_rolls       = _rolls_from_index(config.get_value("Dropdown", "ammo_rolls")["value"])

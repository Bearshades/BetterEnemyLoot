extends "res://Scripts/AI.gd"

var cfg = preload("res://BetterEnemyLoot/BetterEnemyLootSettings.tres")

func _ready():
    super()
    _logBEL(["AI ready"])

func ActivateContainer():
    super()
    _logBEL(["ActivateContainer called"])
        
    _logBEL(["max_consumables: ", cfg.max_consumables, " | rolls: ", cfg.consumable_rolls])
    _logBEL(["max_medical: ",     cfg.max_medical,     " | rolls: ", cfg.medical_rolls])
    _logBEL(["max_magazines: ",   cfg.max_magazines,   " | rolls: ", cfg.magazine_rolls])
    _logBEL(["max_ammo: ",        cfg.max_ammo,        " | rolls: ", cfg.ammo_rolls])
    
    var all_items = container.LT_Master.items

    var valid_items: Array
    if container.military:
        valid_items = all_items
    elif container.industrial:
        valid_items = all_items.filter(func(i): return i.civilian or i.industrial)
    else:
        valid_items = all_items.filter(func(i): return i.civilian)

    var consumable_common = valid_items.filter(func(i): return i.type == "Consumables" and i.rarity == i.Rarity.Common)
    var consumable_rare   = valid_items.filter(func(i): return i.type == "Consumables" and i.rarity == i.Rarity.Rare)

    var medical_common = valid_items.filter(func(i): return i.type == "Medical" and i.rarity == i.Rarity.Common)
    var medical_rare   = valid_items.filter(func(i): return i.type == "Medical" and i.rarity == i.Rarity.Rare)

    var food_count = _weighted_count_BEL(cfg.max_consumables, cfg.consumable_rolls)
    for _i in food_count:
        container.CreateLoot(_pick_item_BEL(consumable_common, consumable_rare))

    var med_count = _weighted_count_BEL(cfg.max_medical, cfg.medical_rolls)
    for _i in med_count:
        container.CreateLoot(_pick_item_BEL(medical_common, medical_rare))

    var mag_count = 0
    if weaponData && weaponData.compatible.size() > 0:
        var mag = weaponData.compatible[0]
        if mag.subtype == "Magazine":
            _logBEL(["magazine: ", mag.name])
            mag_count = _weighted_count_BEL(cfg.max_magazines, cfg.magazine_rolls)
            for _i in mag_count:
                container.CreateLoot(mag)
    
    var ammo_count = 0
    if weaponData:
        var ammo = weaponData.ammo
        if ammo:
            _logBEL(["ammo: ", ammo.name])
            ammo_count = _weighted_count_BEL(cfg.max_ammo, cfg.ammo_rolls)
            if ammo_count > 0:
                _add_ammo_BEL(container, ammo, ammo_count)
    
    container.SpawnItems()
    _logBEL(["container loot amount: ", container.loot.size()])
    _logBEL(["created food: ",  food_count])
    _logBEL(["created meds: ",  med_count])
    _logBEL(["created mag: ",   mag_count])
    _logBEL(["created ammo: ",  ammo_count])


# rolls > 0: take the MAX of |rolls| rolls (biased toward max_val)
# rolls < 0: take the MIN of |rolls| rolls (biased toward zero)
# rolls = 0: Off — always returns 0
func _weighted_count_BEL(max_val: int, rolls: int) -> int:
    if rolls == 0 or max_val == 0:
        return 0
    
    var result = randi_range(0, max_val)
    if rolls > 0:
        for _i in rolls - 1:
            result = max(result, randi_range(0, max_val))
    else:
        var n = abs(rolls)
        for _i in n - 1:
            result = min(result, randi_range(0, max_val))
    return result

func _logBEL(parts: Array) -> void:
    if cfg.debug:
        print("[BetterEnemyLoot] ", " ".join(parts.map(func(p): return str(p))))

func _add_ammo_BEL(container: LootContainer, ammo: ItemData, amount: int):
    var newSlotData = SlotData.new()
    newSlotData.itemData = ammo
    newSlotData.amount = max(1, amount)
    container.loot.append(newSlotData)

func _pick_item_BEL(common: Array, rare: Array) -> ItemData:
    _logBEL(["_pick_item pool sizes — common:", common.size(), " | rare:", rare.size()])
    var roll = randf()
    _logBEL(["_pick_item roll:", roll, " | rare chance:", cfg.rare_chance])
    if roll < cfg.rare_chance and rare.size() > 0:
        var item = rare.pick_random()
        _logBEL(["_pick_item: rare ->", item.name])
        return item
    var item = common.pick_random()
    _logBEL(["_pick_item: common ->", item.name])
    return item

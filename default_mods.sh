function remap () {
rm -rf "$1"
echo "Setting Default for $1"
ln -s "`find /data/7DTD/Mods-Available -name \"ModInfo.xml\" | sed 's|/ModInfo.xml||g' | grep "$1" | tail -1`"
}

cd $INSTALL_DIR/Mods

remap Allocs_CommandExtensions
remap Allocs_CommonFunc
remap Allocs_WebAndMapRendering
remap Botman
remap 1CSMM_Patrons
remap ServerTools
remap WhiteRiverToC_Bambis_Bow
remap WhiteRiverToC_Dundees_Knife
remap WhiteRiverToC_Everdeens_Arrows
remap WhiteRiverToC_Guptas_Bandages
remap WhiteRiverToC_Ivankas_Dig_Tools
remap WhiteRiverToC_Jasons_Machete
remap WhiteRiverToC_Kuvas_Armor
remap WhiteRiverToC_Leons_SMG
remap WhiteRiverToC_REQUIRED
remap WhiteRiverToC_Tazas_Axe
remap Origin_UI
remap BCManager
remap RELXIX_UI_CompassCenterHighlight
#remap RELXIX_UI_CompassStats
remap RELXIX_UI_MenuTime
remap RELXIX_UI_Tweaks
remap RELXIX_UI_ZDP3_ZombieKillsDeathsPlayerKills
remap Delmod_Stack_Sizes
remap Delmod_Jail_Door
remap Delmod_Combiner
remap Pickup_Plants_A18
remap COMPOPACK
remap androughYeahSolar
remap Xal_SetZombiesAttackAnimals
remap Guppycur\'s_Random_ZombieGetterUpper
remap donovan-pickmeup
remap donovan-lootcleanup
remap donovan-craftspikes
remap SteelBars
remap JaxTeller718_EggsInFridges
remap Claymore_Stainless_Steel_Returns
remap "Valmars Door Lock Smash"

# remap "Arrow-Xbow Conversion"
# remap BH_TrapMod
# remap "Barrels and Alcohol"
# remap BetterHoeMod
# remap "Colors Everywhere"
# remap Craftworx-ScrapTools
# remap Craftworx-paraffin
# remap Duke_FuelLog
# remap Duke_MoreBrass
# remap "EN_Doors And Blocks AMK"
# remap Elevator
# remap Elysium_81-2Skillpointslevel
# remap Elysium_81-AdditionalQuestSkillpoints
# remap Elysium_81-MoreResourceFromBoulders
# remap Elysium_81-MotherLode
# remap Elysium_81-RWGBuildingTweaker
# remap FarmLifeMod
# remap FarmLifeMod_Icons
# remap FarmLifeMod_Models
# remap Farming
# remap GG2015_SniperTurretAnd50CalAmmo
# remap HDHQBiomeAlpineBaseline
# remap HDHQBiomeAlpineRedux
# remap HDHQBiomeBurntBaseline
# remap HDHQBiomeBurntRedux
# remap HDHQBiomeDesertBaseline
# remap HDHQBiomeDesertRedux
# remap HDHQBiomePineBaseline
# remap HDHQBiomePineRedux
# remap HDHQBiomeWasteBaseline
# remap HDHQBiomeWasteRedux
# remap HDHQGuns
# remap HDHQItems
# remap HDHQParticles
# remap HDHQPlants
# remap HDHQPlants-Wind
# #remap HDHQVehicles
# remap HH_35_New_Dyes_Workstation
# remap JSS
# remap "Jail Door"
# remap JaxTeller718_BackpackTimer
# remap JaxTeller718_BiggerWanderingHordes
# remap JaxTeller718_Charcoal
# remap JaxTeller718_CookingPotBalance
# remap JaxTeller718_DestroyableBirdsNest
# remap JaxTeller718_EggsInFridges
# remap JaxTeller718_FeralRadiatedLootBagChance
# remap JaxTeller718_LessWaterInLoot
# remap JaxTeller718_Lockpicks
# remap JaxTeller718_MoreQuestXP
# remap JaxTeller718_MoreStorageOptions
# remap JaxTeller718_NicerVultures
# remap JaxTeller718_ReducedZombieBlockDamage
# remap JaxTeller718_SlowerGamestages
# remap KHLogSpikes
# remap Khelldon-BabyBears
# remap Khelldon-BadCompanyUMAZeds
# remap Khelldon-ComplexCobble
# remap Khelldon-ScreamerBears
# #remap Lights
# remap Makabriel_RealisticSafes
# remap PolishedSteelMod
# remap "Quality Damage Bonuses"
# remap RussianDoodMSP
# remap S420_Acid
# remap S420_BrassCoins
# remap S420_CarRespawner
# remap S420_DamagedVan
# remap S420_FireTruck
# remap S420_PolymerArrows
# remap S420_SemiTruck
# remap S420_TransportTanker
# remap S420_TransportTruck
# remap ScriptingMod
# remap Sol_BioFuel
# remap Sol_BrassMining
# remap Sol_DailyTraderRestocks
# remap Sol_RabbitTraps
# remap Sol_WildCropHarvestBonus
# remap Sol_Zombie_Loot_Timers
# remap StrongerSteelMod
# remap TheWildLand
# remap VPlus-BalanceMoreCoffee
# remap Xajar_ArrowRecipes
# remap Xajar_BeakersFromMedicalPiles
# remap Xajar_FlagstoneFrames
# remap Xajar_HaybaleFallDamage
# remap Xajar_PerkTweaks
# remap Xajar_WaterRefill
# remap n4bb12_AutoDestroyJunk
# remap n4bb12_Bugs
# remap n4bb12_ContainerDummies
# remap n4bb12_CraftLight
# remap n4bb12_CraftSecureStorages
# remap n4bb12_CraftWithForgedIron
# remap n4bb12_DestroyPaintings
# remap n4bb12_EngineQuality
# remap n4bb12_HarvestAnimals
# remap n4bb12_HarvestBirdNestsInTrees
# remap n4bb12_HarvestChemistryStation
# remap n4bb12_HarvestNuggets
# remap n4bb12_HarvestRock
# remap n4bb12_LootGuns
# remap n4bb12_LootJunk
# #remap n4bb12_LootWeaponMods
# remap n4bb12_TradePricing
# remap n4bb12_TradeVehiclesAndMore
# remap n4bb12_UICraftingQueue
# remap n4bb12_UIScale
# remap n4bb12_VehicleSpeed
# remap n4bb12_WeaponHeadshotDamage
# remap n4bb12_XPForBlocks
# remap n4bb12_Zombie+AnimalSpawning
# #remap n4bb12_Zombie+Animal_Size+Range
# remap n4bb12_ZombieBagDrop
# remap n4bb12_ZombieKnockdownDuration
# remap rewtgr_Asphalt-and-bed-buffs
# remap rewtgr_craftable_dye
# remap "zQuality Effectiveness Bonuses"
# remap "zReduced Stamina Usage by Quality Level"


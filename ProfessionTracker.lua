-- ########################################################
-- ## Profession Tracker: Core OOP Implementation
-- ########################################################

-- ========================================================
-- Namespace & Constants
-- ========================================================
local ADDON_NAME = "ProfessionTracker"
local ADDON_VERSION = "1.0.0"

-- Create main addon namespace
ProfessionTracker = ProfessionTracker or {}
local PT = ProfessionTracker

-- Constants
PT.Constants = {
    KNOWLEDGE_SYSTEM_START = 10, -- Dragon Isles and later
    CONCENTRATION_REGEN_RATE = 10.41667, -- 250 per 24 hours
}
KPReference = {

    ---------------------------------------------------------------------
    -- 171: ALCHEMY
    ---------------------------------------------------------------------
    [171] = {
        [10] = {  -- Dragonflight / Dragon Isles
            weekly = {
                treatise = {
                    questID = 12345,  
                    label = "Treatise: Alchemy",
                    icon = "Interface\\Icons\\inv_inscription_treatise",
                },
                craftingOrder = {
                    questID = 12346,
                    label = "Weekly Alchemy Profession Quest",
                    icon = "Interface\\Icons\\inv_crafting_orders",
                },
                treasures = {
                    label = "Alchemy Knowledge Treasures",
                    icon = "Interface\\Icons\\inv_misc_book_07",
                    questIDs = { 11111, 11112, 11113 }, -- replace with actual one-time treasure quests
                }
            },

            oneTime = {
                treasures = {
                    label = "One-Time Knowledge Treasures",
                    icon = "",
                    locations = {
                        { mapID = 2022, x = 25.1, y = 73.3, name = "Well Insulated Mug", questID = 01001 },
                        { mapID = 2022, x = 55.0, y = 81.0, name = "Frostforged Potion", questID = 01002 },
                        { mapID = 2023, x = 79.2, y = 83.8, name = "Canteen of Suspicious Water", questID = 01003 },
                        { mapID = 2024, x = 16.4, y = 38.5, name = "Experimental Decay Sample", questID = 01004 },
                        { mapID = 2024, x = 67.0, y = 13.2, name = "Firewater Powder Sample", questID = 01005 },
                        { mapID = 2025, x = 55.2, y = 30.5, name = "Tasty Candy", questID = 01006 },
                        { mapID = 2025, x = 59.5, y = 38.4, name = "Contraband Concoction", questID = 01007 },
                        { mapID = 2133, x = 62.10, y = 41.12, name = "Marrow-Ripened Slime", questID = 01008 },
                        { mapID = 2133, x = 52.68, y = 18.30, name = "Nutrient Diluted Protofluid", questID = 01009 },
                        { mapID = 2133, x = 40.48, y = 59.18, name = "Suspicious Mold", questID = 01010 },
                        { mapID = 2200, x = 50.91, y = 49.43, name = "Splash Potion of Narcolepsy", questID = 01011 },
                        { mapID = 2200, x = 54.05, y = 32.64, name = "Half-Filled Dreamless Sleep Potion", questID = 01012 },
                        { mapID = 2200, x = 36.21, y = 46.63, name = "Blazeroot", questID = 01013 },
                    }
                }
            },
        },
        [11] = { 
             -- The War Within / Khaz Algar
            weekly = {
                treatise = {
                    questID = 83725,  
                    label = "Treatise: Alchemy",
                    icon = "Interface\\Icons\\inv_misc_profession_book_alchemy",
                },
                craftingOrder = {
                    questID = 12346,
                    label = "Weekly Alchemy Profession Quest",
                    icon = "Interface\\Icons\\inv_crafting_orders",
                },
                treasures = {
                    label = "Alchemy Knowledge Treasures",
                    icon = "Interface\\Icons\\inv_misc_book_07",
                    questIDs = { 11111, 11112, 11113 }, -- replace with actual one-time treasure quests
                }
            },
            oneTime = {
                treasures = {
                    label = "One-Time Knowledge Treasures",
                    icon = "",
                    locations = {
                        { mapID = 2339, x = 32.5, y = 60.1, name = "Earthen Iron Powder", questID = 83840 },
                        { mapID = 2248, x = 57.7, y = 61.7, name = "Metal Dornogal Frame", questID = 83841 },
                        { mapID = 2214, x = 64.9, y = 61.8, name = "Engraved Stirring Rod", questID = 83843 },
                        { mapID = 2214, x = 42.2, y = 24.1, name = "Reinforced Beaker", questID = 83842 },
                        { mapID = 2215, x = 42.6, y = 55.0, name = "Chemist's Purified Water", questID = 83844 },
                        { mapID = 2215, x = 41.6, y = 55.8, name = "Sanctified Mortar and Pestle", questID = 83845 },
                        { mapID = 2255, x = 42.8, y = 57.3, name = "Dark Apothecary's Vial", questID = 83847 },
                        { mapID = 2216, x = 45.5, y = 13.2, name = "Nerubian Mixing Salts", questID = 83846 },
                    }
                }
            }
        }
    },

    ---------------------------------------------------------------------
    -- 164: BLACKSMITHING
    ---------------------------------------------------------------------
    [164] = {
        [10] = {
            weekly = {
                treatise = {
                    questID = 12355,
                    label = "Treatise: Blacksmithing",
                    icon = "Interface\\Icons\\inv_inscription_treatise",
                },
                craftingOrder = {
                    questID = 12356,
                    label = "Weekly Blacksmithing Profession Quest",
                    icon = "Interface\\Icons\\inv_crafting_orders",
                },
                treasures = {
                    label = "Blacksmithing Knowledge Treasures",
                    icon = "Interface\\Icons\\inv_misc_book_07",
                    questIDs = { 44111, 44112, 44113 },
                }
            },

            oneTime = {
                treasures = {
                    label = "One-Time Knowledge Treasures",
                    icon = "",
                    locations = {
                        { mapID = 2022, x = 56.4, y = 19.5, name = "Glimmer of Blacksmithing Wisdom", questID = 04001 },
                        { mapID = 2022, x = 22.0, y = 87.0, name = "Ancient Monument", questID = 04002 },
                        { mapID = 2022, x = 65.5, y = 25.7, name = "Curious Ingots", questID = 04003 },
                        { mapID = 2022, x = 35.5, y = 64.3, name = "Molten Ingot", questID = 04004 },
                        { mapID = 2022, x = 34.5, y = 67.1, name = "Qalashi Weapon Diagram", questID = 04005 },

                        { mapID = 2023, x = 81.1, y = 37.9, name = "Ancient Spear Shards", questID = 04006 },
                        { mapID = 2023, x = 50.9, y = 66.5, name = "Falconer Gauntlet Drawings", questID = 04007 },

                        { mapID = 2024, x = 53.1, y = 65.3, name = "Spelltouched Tongs", questID = 04008 },

                        { mapID = 2025, x = 52.2, y = 80.5, name = "Draconic Flux", questID = 04009 },

                        { mapID = 2133, x = 48.30, y = 21.95, name = "Brimstone Rescue Ring", questID = 04010 },
                        { mapID = 2133, x = 57.15, y = 54.64, name = "Well-Worn Kiln", questID = 04011 },
                        { mapID = 2133, x = 27.53, y = 42.87, name = "Zaqali Elder Spear", questID = 04012 },

                        { mapID = 2200, x = 36.34, y = 46.79, name = "Deathstalker Chasis", questID = 04013 },
                        { mapID = 2200, x = 37.29, y = 22.94, name = "Flamesworn Render", questID = 04014 },
                        { mapID = 2200, x = 49.83, y = 62.99, name = "Amirdrassil Defender's Shield", questID = 04015 },
                    }
                }
            },
        },
        [11] = {  -- The War Within / Khaz Algar
            weekly = {
                treatise = {
                    questID = 83726,  
                    label = "Treatise: Blacksmithing",
                    icon = "Interface\\Icons\\inv_misc_profession_book_blacksmithing",
                },
                craftingOrder = {
                    questID = 12346,
                    label = "Weekly Alchemy Profession Quest",
                    icon = "Interface\\Icons\\inv_crafting_orders",
                },
                treasures = {
                    label = "Alchemy Knowledge Treasures",
                    icon = "Interface\\Icons\\inv_misc_book_07",
                    questIDs = { 11111, 11112, 11113 }, -- replace with actual one-time treasure quests
                }
            },
            oneTime = {
                treasures = {
                    label = "One-Time Knowledge Treasures",
                    icon = "",
                    locations = {
                        { mapID = 2339, x = 47.6, y = 26.2, name = "Dornogal Hammer", questID = 83849 },
                        { mapID = 2248, x = 59.8, y = 61.8, name = "Ancient Earthen Anvil", questID = 83848 },
                        { mapID = 2214, x = 47.7, y = 33.2, name = "Ringing Hammer Vise", questID = 83850 },
                        { mapID = 2214, x = 60.6, y = 53.8, name = "Earthen Chisels", questID = 83851 },
                        { mapID = 2215, x = 44.1, y = 55.6, name = "Radiant Tongs", questID = 83853 },
                        { mapID = 2215, x = 47.6, y = 61.0, name = "Holy Flame Forge", questID = 83852 },
                        { mapID = 2255, x = 53.0, y = 51.3, name = "Spiderling's Wire Brush", questID = 83855 },
                        { mapID = 2216, x = 46.6, y = 22.7, name = "Nerubian Smith's Kit", questID = 83854 },
                    }
                }
            }
        }

    },

    ---------------------------------------------------------------------
    -- 333: ENCHANTING
    ---------------------------------------------------------------------
    [333] = {
        [10] = {
            weekly = {
                treatise = {
                    questID = 12355,
                    label = "Treatise: Enchanting",
                    icon = "Interface\\Icons\\inv_inscription_treatise",
                },
                craftingOrder = {
                    questID = 12356,
                    label = "Weekly Enchanting Profession Quest",
                    icon = "Interface\\Icons\\inv_crafting_orders",
                },
                treasures = {
                    label = "Enchanting Knowledge Treasures",
                    icon = "Interface\\Icons\\inv_misc_book_07",
                    questIDs = { 44111, 44112, 44113 },
                }
            },

            oneTime = {
                treasures = {
                    label = "One-Time Knowledge Treasures",
                    icon = "",
                    locations = {
                        { mapID = 2022, x = 57.5, y = 83.6, name = "Flashfrozen Scroll", questID = 03001 },
                        { mapID = 2022, x = 68.0, y = 26.8, name = "Lava-Infused Seed", questID = 03002 },
                        { mapID = 2022, x = 57.5, y = 58.5, name = "Enchanted Debris", questID = 03003 },

                        { mapID = 2023, x = 61.4, y = 67.6, name = "Stormbound Horn", questID = 03004 },

                        { mapID = 2024, x = 38.5, y = 59.2, name = "Forgotten Arcane Tome", questID = 03005 },
                        { mapID = 2024, x = 45.1, y = 61.2, name = "Faintly Enchanted Remains", questID = 03006 },
                        { mapID = 2024, x = 21.0, y = 45.0, name = "Enriched Earthen Shard", questID = 03007 },

                        { mapID = 2025, x = 59.9, y = 70.4, name = "Fractured Titanic Sphere", questID = 03008 },

                        { mapID = 2133, x = 48.00, y = 17.00, name = "Lava-Drenched Shadow Crystal", questID = 03009 },
                        { mapID = 2133, x = 36.66, y = 69.33, name = "Resonating Arcane Crystal", questID = 03010 },
                        { mapID = 2133, x = 62.39, y = 53.80, name = "Shimmering Aqueous Orb", questID = 03011 },

                        { mapID = 2200, x = 46.16, y = 20.51, name = "Everburning Core", questID = 03012 },
                        { mapID = 2200, x = 38.37, y = 30.20, name = "Pure Dream Water", questID = 03013 },
                        { mapID = 2200, x = 66.36, y = 74.20, name = "Essence of Dreams", questID = 03014 },
                    }
                }
            },
        },
        [11] = {            
            -- The War Within / Khaz Algar
            weekly = {
                treatise = {
                    questID = 83727,  
                    label = "Treatise: Enchanting",
                    icon = "Interface\\Icons\\inv_misc_profession_book_enchanting",
                },
                craftingOrder = {
                    questID = 12346,
                    label = "Weekly Alchemy Profession Quest",
                    icon = "Interface\\Icons\\inv_crafting_orders",
                },
                treasures = {
                    label = "Alchemy Knowledge Treasures",
                    icon = "Interface\\Icons\\inv_misc_book_07",
                    questIDs = { 11111, 11112, 11113 }, -- replace with actual one-time treasure quests
                }
            },
            oneTime = {
                treasures = {
                    label = "One-Time Knowledge Treasures",
                    icon = "",
                    locations = {
                        { mapID = 2339, x = 58.0, y = 56.9, name = "Silver Dornogal Rod", questID = 83859 },
                        { mapID = 2248, x = 57.6, y = 61.1, name = "Grinded Earthen Gem", questID = 83856 },
                        { mapID = 2214, x = 67.1, y = 65.9, name = "Animated Enchanting Dust", questID = 83861 },
                        { mapID = 2214, x = 44.6, y = 22.3, name = "Soot-Coated Orb", questID = 83860 },
                        { mapID = 2215, x = 48.6, y = 64.5, name = "Enchanted Arathi Scroll", questID = 83863 },
                        { mapID = 2215, x = 40.0, y = 70.5, name = "Essence of Holy Fire", questID = 83862 },
                        { mapID = 2255, x = 57.3, y = 44.1, name = "Void Shard", questID = 83865 },
                        { mapID = 2216, x = 61.5, y = 21.7, name = "Book of Dark Magic", questID = 83864 },
                    }
                }
            }
        }
    },

    ---------------------------------------------------------------------
    -- 202: ENGINEERING
    ---------------------------------------------------------------------
    [202] = {
        [10] = {
            weekly = {
                treatise = {
                    questID = 12355,
                    label = "Treatise: Engineering",
                    icon = "Interface\\Icons\\inv_inscription_treatise",
                },
                craftingOrder = {
                    questID = 12356,
                    label = "Weekly Engineering Profession Quest",
                    icon = "Interface\\Icons\\inv_crafting_orders",
                },
                treasures = {
                    label = "Engineering Knowledge Treasures",
                    icon = "Interface\\Icons\\inv_misc_book_07",
                    questIDs = { 44111, 44112, 44113 },
                }
            },

            oneTime = {
                treasures = {
                    label = "One-Time Knowledge Treasures",
                    icon = "",
                    locations = {
                        { mapID = 2022, x = 56.0, y = 44.9, name = "Boomthyr Rocket", questID = 02001 },
                        { mapID = 2022, x = 49.09, y = 77.54, name = "Intact Coil Capacitor", questID = 02002 },

                        -- Zaralek Cavern heavy engineering zone
                        { mapID = 2133, x = 37.82, y = 58.83, name = "Busted Wyrmhole Generator", questID = 02003 },
                        { mapID = 2133, x = 50.51, y = 47.85, name = "Defective Survival Pack", questID = 02004 },
                        { mapID = 2133, x = 49.44, y = 78.99, name = "Discarded Dracothyst Drill", questID = 02005 },
                        { mapID = 2133, x = 57.65, y = 73.94, name = "Handful of Khaz'gorite Bolts", questID = 02006 },
                        { mapID = 2133, x = 48.15, y = 27.99, name = "Haphazardly Discarded Bomb", questID = 02007 },
                        { mapID = 2133, x = 49.87, y = 59.25, name = "Inconspicuous Data Miner", questID = 02008 },
                        { mapID = 2133, x = 48.47, y = 48.61, name = "Misplaced Aberrus Outflow Blueprints", questID = 02009 },
                        { mapID = 2133, x = 48.10, y = 16.59, name = "Overclocked Determination Core", questID = 02010 },

                        { mapID = 2200, x = 40.49, y = 89.42, name = "Insomniotron", questID = 02011 },
                        { mapID = 2200, x = 39.55, y = 52.28, name = "Experimental Dreamcatcher", questID = 02012 },
                        { mapID = 2200, x = 62.66, y = 36.27, name = "Unhatched Battery", questID = 02013 },
                    }
                }
            },
        },
        [11] = { -- The War Within / Khaz Algar
            weekly = {
                treatise = {
                    questID = 83728,  
                    label = "Treatise: Engineering",
                    icon = "Interface\\Icons\\inv_misc_profession_book_engineering",
                },
                craftingOrder = {
                    questID = 12346,
                    label = "Weekly Alchemy Profession Quest",
                    icon = "Interface\\Icons\\inv_crafting_orders",
                },
                treasures = {
                    label = "Alchemy Knowledge Treasures",
                    icon = "Interface\\Icons\\inv_misc_book_07",
                    questIDs = { 11111, 11112, 11113 }, -- replace with actual one-time treasure quests
                }
            },
            oneTime = {
                treasures = {
                    label = "One-Time Knowledge Treasures",
                    icon = "",
                    locations = {
                        { mapID = 2339, x = 64.8, y = 52.8, name = "Dornogal Spectacles", questID = 83867 },
                        { mapID = 2248, x = 61.3, y = 69.5, name = "Rock Engineer's Wrench", questID = 83866 },
                        { mapID = 2214, x = 64.5, y = 58.8, name = "Earthen Construct Blueprints", questID = 83869 },
                        { mapID = 2214, x = 42.7, y = 27.3, name = "Inert Mining Bomb", questID = 83868 },
                        { mapID = 2215, x = 41.6, y = 48.9, name = "Arathi Safety Gloves", questID = 83871 },
                        { mapID = 2215, x = 46.3, y = 61.4, name = "Holy Firework Dud", questID = 83870 },
                        { mapID = 2255, x = 56.9, y = 38.6, name = "Puppeted Mechanical Spider", questID = 83872 },
                        { mapID = 2216, x = 63.2, y = 11.3, name = "Emptied Venom Canister", questID = 83873 },
                    }
                }
            }
        }
    },

    ---------------------------------------------------------------------
    -- 773: INSCRIPTION
    ---------------------------------------------------------------------
    [773] = {
        [10] = {
            weekly = {
                treatise = {
                    questID = 12355,
                    label = "Treatise: Inscription",
                    icon = "Interface\\Icons\\inv_inscription_treatise",
                },
                craftingOrder = {
                    questID = 12356,
                    label = "Weekly Inscription Profession Quest",
                    icon = "Interface\\Icons\\inv_crafting_orders",
                },
                treasures = {
                    label = "Inscription Knowledge Treasures",
                    icon = "Interface\\Icons\\inv_misc_book_07",
                    questIDs = { 44111, 44112, 44113 },
                }
            },

            oneTime = {
                treasures = {
                    label = "One-Time Knowledge Treasures",
                    icon = "",
                    locations = {
                        { mapID = 2022, x = 67.87, y = 57.96, name = "Pulsing Earth Rune", questID = 07001 },

                        { mapID = 2023, x = 85.7, y = 25.2, name = "Sign Language Reference Sheet", questID = 07002 },

                        { mapID = 2024, x = 46.2, y = 23.9, name = "Dusty Darkmoon Card", questID = 07003 },
                        { mapID = 2024, x = 43.7, y = 30.9, name = "Frosted Parchment", questID = 07004 },

                        -- Valdrakken (non-mapID zone)
                        { mapID = 2112, x = 13.2, y = 63.68, name = "How to Train Your Whelpling", questID = 07005 },

                        { mapID = 2025, x = 56.3, y = 41.2, name = "Forgetful Apprentice's Tome A", questID = 07006 },
                        { mapID = 2025, x = 47.24, y = 40.1, name = "Forgetful Apprentice's Tome B", questID = 07007 },
                        { mapID = 2025, x = 56.1, y = 40.9, name = "Counterfeit Darkmoon Deck", questID = 07008 },

                        { mapID = 2133, x = 53.01, y = 74.27, name = "Hissing Rune Draft", questID = 07009 },
                        { mapID = 2133, x = 54.57, y = 20.21, name = "Ancient Research", questID = 07010 },
                        { mapID = 2133, x = 36.73, y = 46.32, name = "Intricate Zaqali Runes", questID = 07011 },

                        { mapID = 2200, x = 55.64, y = 27.49, name = "Winnie's Notes on Flora and Fauna", questID = 07012 },
                        { mapID = 2200, x = 36.04, y = 46.64, name = "Primalist Shadowbinding Rune", questID = 07013 },
                        { mapID = 2200, x = 63.50, y = 71.52, name = "Grove Keeper's Pillar", questID = 07014 },
                    }
                }
            },
        },
        [11] = { -- The War Within / Khaz Algar
            weekly = {
                treatise = {
                    questID = 83730,  
                    label = "Treatise: Inscription",
                    icon = "Interface\\Icons\\inv_misc_profession_book_inscription",
                },
                craftingOrder = {
                    questID = 12346,
                    label = "Weekly Alchemy Profession Quest",
                    icon = "Interface\\Icons\\inv_crafting_orders",
                },
                treasures = {
                    label = "Alchemy Knowledge Treasures",
                    icon = "Interface\\Icons\\inv_misc_book_07",
                    questIDs = { 11111, 11112, 11113 }, -- replace with actual one-time treasure quests
                }
            },
            oneTime = {
                treasures = {
                    label = "One-Time Knowledge Treasures",
                    icon = "",
                    locations = {
                        { mapID = 2339, x = 57.2, y = 46.9, name = "Dornogal Scribe's Quill", questID = 83882 },
                        { mapID = 2248, x = 55.9, y = 60.0, name = "Historian's Dip Pen", questID = 83883 },
                        { mapID = 2214, x = 62.5, y = 58.15, name = "Blue Earthen Pigment", questID = 83885 },
                        { mapID = 2214, x = 48.6, y = 34.3, name = "Runic Scroll", questID = 83884 },
                        { mapID = 2215, x = 42.8, y = 49.1, name = "Calligrapher's Chiseled Marker", questID = 83887 },
                        { mapID = 2215, x = 43.2, y = 58.9, name = "Informant's Fountain Pen", questID = 83886 },
                        { mapID = 2255, x = 55.9, y = 44.0, name = "Nerubian Texts", questID = 83888 },
                        { mapID = 2216, x = 50.1, y = 30.6, name = "Venomancer's Ink Well", questID = 83889 },
                    }
                }
            }
        }
    },


    ---------------------------------------------------------------------
    -- 755: JEWELCRAFTING
    ---------------------------------------------------------------------
    [755] = {
        [10] = {
            weekly = {
                treatise = {
                    questID = 12355,
                    label = "Treatise: Jewelcrafting",
                    icon = "Interface\\Icons\\inv_inscription_treatise",
                },
                craftingOrder = {
                    questID = 12356,
                    label = "Weekly Jewelcrafting Profession Quest",
                    icon = "Interface\\Icons\\inv_crafting_orders",
                },
                treasures = {
                    label = "Jewelcrafting Knowledge Treasures",
                    icon = "Interface\\Icons\\inv_misc_book_07",
                    questIDs = { 44111, 44112, 44113 },
                }
            },

            oneTime = {
                treasures = {
            label = "One-Time Knowledge Treasures",
            icon = "",
            locations = {
                { mapID = 2022, x = 50.4, y = 45.1, name = "Closely Guarded Shiny", questID = 05001 },
                { mapID = 2022, x = 33.9, y = 63.7, name = "Igneous Gem", questID = 05002 },

                { mapID = 2023, x = 25.2, y = 35.4, name = "Lofty Malygite", questID = 05003 },
                { mapID = 2023, x = 61.8, y = 13.0, name = "Fragmented Key", questID = 05004 },

                { mapID = 2024, x = 45.0, y = 61.3, name = "Crystalline Overgrowth", questID = 05005 },
                { mapID = 2024, x = 44.6, y = 61.2, name = "Harmonic Crystal Harmonizer", questID = 05006 },

                { mapID = 2025, x = 59.8, y = 65.2, name = "Alexstraszite Cluster", questID = 05007 },
                { mapID = 2025, x = 56.91, y = 43.72, name = "Painter's Pretty Jewel", questID = 05008 },

                { mapID = 2133, x = 54.41, y = 32.47, name = "Broken Barter Boulder", questID = 05009 },
                { mapID = 2133, x = 34.47, y = 45.43, name = "Gently Jostled Jewels", questID = 05010 },
                { mapID = 2133, x = 40.37, y = 80.66, name = "Snubbed Snail Shells", questID = 05011 },

                { mapID = 2200, x = 33.23, y = 46.57, name = "Petrified Hope", questID = 05012 },
                { mapID = 2200, x = 43.51, y = 33.36, name = "Handful of Pebbles", questID = 05013 },
                { mapID = 2200, x = 58.95, y = 53.89, name = "Coalesced Dreamstone", questID = 05014 },
                    },
                },
            },
        },
        [11] = {
            -- The War Within / Khaz Algar
            weekly = {
                treatise = {
                    questID = 83731,  
                    label = "Treatise: Jewelcrafting",
                    icon = "Interface\\Icons\\inv_misc_profession_book_jewelcrafting",
                },
                craftingOrder = {
                    questID = 12346,
                    label = "Weekly Alchemy Profession Quest",
                    icon = "Interface\\Icons\\inv_crafting_orders",
                },
                treasures = {
                    label = "Alchemy Knowledge Treasures",
                    icon = "Interface\\Icons\\inv_misc_book_07",
                    questIDs = { 11111, 11112, 11113 }, -- replace with actual one-time treasure quests
                }
            },
            oneTime = {
                treasures = {
                    label = "One-Time Knowledge Treasures",
                    icon = "",
                    locations = {
                        { mapID = 2339, x = 34.8, y = 52.2, name = "Earthen Gem Pliers", questID = 83891 },
                        { mapID = 2248, x = 63.5, y = 66.8, name = "Gentle Jewel Hammer", questID = 83890 },
                        { mapID = 2214, x = 57.0, y = 54.6, name = "Jeweler's Delicate Drill", questID = 83893 },
                        { mapID = 2214, x = 48.5, y = 35.2, name = "Carved Stone File", questID = 83892 },
                        { mapID = 2215, x = 44.6, y = 50.9, name = "Librarian's Magnifiers", questID = 83895 },
                        { mapID = 2215, x = 47.4, y = 60.6, name = "Arathi Sizing Gauges", questID = 83894 },
                        { mapID = 2255, x = 56.2, y = 58.8, name = "Nerubian Bench Blocks", questID = 83897 },
                        { mapID = 2216, x = 47.7, y = 19.4, name = "Ritual Caster's Crystal", questID = 83896 },
                    }
                }
            }
        }
    },

    ---------------------------------------------------------------------
    -- 165: LEATHERWORKING
    ---------------------------------------------------------------------
    [165] = {
        [10] = {
            weekly = {
                treatise = {
                    questID = 12355,
                    label = "Treatise: Leatherworking",
                    icon = "Interface\\Icons\\inv_inscription_treatise",
                },
                craftingOrder = {
                    questID = 12356,
                    label = "Weekly Leatherworking Profession Quest",
                    icon = "Interface\\Icons\\inv_crafting_orders",
                },
                treasures = {
                    label = "Leatherworking Knowledge Treasures",
                    icon = "Interface\\Icons\\inv_misc_book_07",
                    questIDs = { 44111, 44112, 44113 },
                }
            },

            oneTime = {
                treasures = {
                    label = "One-Time Knowledge Treasures",
                    icon = "",
                    locations = {
                        { mapID = 2022, x = 39.0, y = 86.0, name = "Poacher's Pack", questID = 06001 },
                        { mapID = 2022, x = 64.3, y = 25.4, name = "Spare Djaradin Tools", questID = 06002 },

                        { mapID = 2023, x = 86.4, y = 53.7, name = "Wind-Blessed Hide", questID = 06003 },

                        { mapID = 2024, x = 12.5, y = 49.4, name = "Well-Danced Drum", questID = 06004 },
                        { mapID = 2024, x = 16.7, y = 38.8, name = "Decay-Infused Tanning Oil", questID = 06005 },
                        -- Your line had corrupted coords; used two separate entries:
                        { mapID = 2024, x = 57.5, y = 41.3, name = "Treated Hides", questID = 06006 },

                        { mapID = 2025, x = 56.8, y = 30.5, name = "Decayed Scales", questID = 06007 },

                        { mapID = 2133, x = 41.16, y = 48.81, name = "Flame-Infused Scale Oil", questID = 06008 },
                        { mapID = 2133, x = 45.25, y = 21.12, name = "Lava-Forged Leatherworker's Knife", questID = 06009 },
                        { mapID = 2133, x = 49.56, y = 54.80, name = "Sulfur-Soaked Skins", questID = 06010 },

                        { mapID = 2200, x = 34.04, y = 29.73, name = "Dreamtalon Claw", questID = 06011 },
                        { mapID = 2200, x = 41.75, y = 66.49, name = "Tuft of Dreamsaber Fur", questID = 06012 },
                        { mapID = 2200, x = 37.45, y = 71.02, name = "Molted Faerie Dragon Scales", questID = 06013 },
                    }
                }
            },
        },
        [11] = {  -- The War Within / Khaz Algar
            weekly = {
                treatise = {
                    questID = 83732,  
                    label = "Treatise: Leatherworking",
                    icon = "Interface\\Icons\\inv_misc_profession_book_leatherworking",
                },
                craftingOrder = {
                    questID = 12346,
                    label = "Weekly Alchemy Profession Quest",
                    icon = "Interface\\Icons\\inv_crafting_orders",
                },
                treasures = {
                    label = "Alchemy Knowledge Treasures",
                    icon = "Interface\\Icons\\inv_misc_book_07",
                    questIDs = { 11111, 11112, 11113 }, -- replace with actual one-time treasure quests
                }
            },
            oneTime = {
                treasures = {
                    label = "One-Time Knowledge Treasures",
                    icon = "",
                    locations = {
                        { mapID = 2339, x = 68.2, y = 23.3, name = "Earthen Lacing Tools", questID = 83898 },
                        { mapID = 2248, x = 58.7, y = 30.7, name = "Dornogal Craftsman's Flat Knife", questID = 83899 },
                        { mapID = 2214, x = 47.1, y = 34.8, name = "Underground Stropping Compound", questID = 83900 },
                        { mapID = 2214, x = 64.3, y = 65.4, name = "Earthen Awl", questID = 83901 },
                        { mapID = 2215, x = 41.5, y = 57.8, name = "Arathi Leather Burnisher", questID = 83903 },
                        { mapID = 2215, x = 47.6, y = 65.1, name = "Arathi Beveler Set", questID = 83902 },
                        { mapID = 2255, x = 60.0, y = 53.9, name = "Curved Nerubian Skinning Knife", questID = 83905 },
                        { mapID = 2216, x = 55.2, y = 26.8, name = "Nerubian Tanning Mallet", questID = 83904 },
                    }
                }
            }
        }
    },

    ---------------------------------------------------------------------
    -- 197: TAILORING
    ---------------------------------------------------------------------
    [197] = {
        [10] = {
            weekly = {
                treatise = {
                    questID = 12355,
                    label = "Treatise: Tailoring",
                    icon = "Interface\\Icons\\inv_inscription_treatise",
                },
                craftingOrder = {
                    questID = 12356,
                    label = "Weekly Tailoring Profession Quest",
                    icon = "Interface\\Icons\\inv_crafting_orders",
                },
                treasures = {
                    label = "Tailoring Knowledge Treasures",
                    icon = "Interface\\Icons\\inv_misc_book_07",
                    questIDs = { 44111, 44112, 44113 },
                }
            },

            oneTime = {
                treasures = {
                    label = "One-Time Knowledge Treasures",
                    icon = "",
                    locations = {
                        { mapID = 2022, x = 74.7, y = 37.9, name = "Mysterious Banner", questID = 08001 },
                        { mapID = 2022, x = 24.9, y = 69.7, name = "Itinerant Singed Fabric", questID = 08002 },

                        { mapID = 2023, x = 35.34, y = 40.12, name = "Noteworthy Scrap of Carpet", questID = 08003 },

                        { mapID = 2024, x = 16.2, y = 38.8, name = "Decaying Brackenhide Blanket", questID = 08004 },
                        { mapID = 2024, x = 40.7, y = 54.5, name = "Intriguing Bolt of Blue Cloth", questID = 08005 },

                        { mapID = 2025, x = 60.4, y = 79.7, name = "Miniature Bronze Dragonflight Banner", questID = 08006 },
                        { mapID = 2025, x = 58.6, y = 45.8, name = "Ancient Dragonweave Bolt", questID = 08007 },

                        { mapID = 2133, x = 47.21, y = 48.55, name = "Abandoned Reserve Chute", questID = 08008 },
                        { mapID = 2133, x = 44.52, y = 15.65, name = "Exquisitely Embroidered Banner", questID = 08009 },
                        { mapID = 2133, x = 59.11, y = 73.14, name = "Used Medical Wrap Kit", questID = 08010 },

                        { mapID = 2200, x = 53.27, y = 27.92, name = "Exceedingly Soft Wildercloth", questID = 08011 },
                        { mapID = 2200, x = 40.70, y = 86.16, name = "Snuggle Buddy", questID = 08012 },
                        { mapID = 2200, x = 49.83, y = 61.48, name = "Plush Pillow", questID = 08013 },
                    }
                }
            },
        },
        [11] = { -- The War Within / Khaz Algar
            weekly = {
                treatise = {
                    questID = 83735,  
                    label = "Treatise: Tailoring",
                    icon = "Interface\\Icons\\inv_misc_profession_book_tailoring",
                },
                craftingOrder = {
                    questID = 12346,
                    label = "Weekly Alchemy Profession Quest",
                    icon = "Interface\\Icons\\inv_crafting_orders",
                },
                treasures = {
                    label = "Alchemy Knowledge Treasures",
                    icon = "Interface\\Icons\\inv_misc_book_07",
                    questIDs = { 11111, 11112, 11113 }, -- replace with actual one-time treasure quests
                }
            },
            oneTime = {
                treasures = {
                    label = "One-Time Knowledge Treasures",
                    icon = "",
                    locations = {
                        { mapID = 2339, x = 61.5, y = 18.5, name = "Dornogal Seam Ripper", questID = 83922 },
                        { mapID = 2248, x = 56.2, y = 60.9, name = "Earthen Tape Measure", questID = 83923 },
                        { mapID = 2214, x = 64.2, y = 60.3, name = "Earthen Stitcher's Snips", questID = 83925 },
                        { mapID = 2214, x = 48.9, y = 32.9, name = "Runed Earthen Pins", questID = 83924 },
                        { mapID = 2215, x = 49.3, y = 62.3, name = "Arathi Rotary Cutter", questID = 83926 },
                        { mapID = 2215, x = 40.1, y = 68.1, name = "Royal Outfitter's Protractor", questID = 83927 },
                        { mapID = 2255, x = 53.3, y = 53.0, name = "Nerubian Quilt", questID = 83928 },
                        { mapID = 2216, x = 50.3, y = 16.6, name = "Nerubian's Pincushion", questID = 83929 },
                    }
                }
            }
        }
    },
    ---------------------------------------------------------------------
    -- GATHERING PROFESSIONS — SPECIAL DATA STRUCTURE
    -- Herbalism (182), Mining (186), Skinning (393)
    -- These use *node-based* KP sources instead of treatises/crafting-order quests.
    ---------------------------------------------------------------------

    -- ======================================================
    -- 182: HERBALISM
    -- ======================================================
    [182] = {
        [10] = {
                weekly = {
                    surveying = {
                        questID = 50001,
                        label = "Herbalism Survey Weekly",
                        icon = "Interface\\Icons\\inv_herbalism",
                    },
                    rareNodes = {
                        label = "Rare Herb Node KP",
                        icon = "Interface\\Icons\\inv_misc_herb_09",
                        questIDs = { 50011, 50012 }, -- each rare node grants KP once
                    },
                },

                oneTime = {
                    treasures = {
                        label = "Unique Herb Discoveries",
                        icon = "Interface\\Icons\\inv_misc_herb_08",
                        locations = {}, -- one-time KP from special finds
                    },
                },
        },
        [11] = { -- The War Within / Khaz Algar
            weekly = {
                treatise = {
                    questID = 83729,  
                    label = "Treatise: Herbalism",
                    icon = "Interface\\Icons\\inv_misc_profession_book_herbalism",
                },
                craftingOrder = {
                    questID = 12346,
                    label = "Weekly Alchemy Profession Quest",
                    icon = "Interface\\Icons\\inv_crafting_orders",
                },
                treasures = {
                    label = "Alchemy Knowledge Treasures",
                    icon = "Interface\\Icons\\inv_misc_book_07",
                    questIDs = {}, -- replace with actual one-time treasure quests
                }
            },
            oneTime = {
                treasures = {
                    label = "One-Time Knowledge Treasures",
                    icon = "",
                    locations = {
                        { mapID = 2339, x = 59.1, y = 23.7, name = "Dornogal Gardening Scythe", questID = 83875 },
                        { mapID = 2248, x = 57.5, y = 61.5, name = "Ancient Flower", questID = 83874 },
                        { mapID = 2214, x = 52.8, y = 65.8, name = "Fungarian Slicer's Knife", questID = 83877 },
                        { mapID = 2214, x = 48.3, y = 34.9, name = "Earthen Digging Fork", questID = 83876 },
                        { mapID = 2215, x = 47.7, y = 63.3, name = "Arathi Garden Trowel", questID = 83878 },
                        { mapID = 2215, x = 36.01, y = 55.0, name = "Arathi Herb Pruner", questID = 83879 },
                        { mapID = 2216, x = 46.6, y = 15.9, name = "Tunneler's Shovel", questID = 83881 },
                        { mapID = 2216, x = 54.8, y = 20.6, name = "Web-Entangled Lotus", questID = 83880 },
                    }
                }
            }
        }
    },

    -- ======================================================
    -- 186: MINING
    -- ======================================================
    [186] = {
        [10] = {
                weekly = {
                    surveying = {
                        questID = 60001,
                        label = "Mining Survey Weekly",
                        icon = "Interface\\Icons\\inv_pick_03",
                    },
                    rareNodes = {
                        label = "Rare Ore Node KP",
                        icon = "Interface\\Icons\\inv_ore_tin_01",
                        questIDs = { 60011, 60012 },
                    },
                },
                oneTime = {
                    treasures = {
                        label = "Unique Ore Discoveries",
                        icon = "Interface\\Icons\\inv_ore_mithril_01",
                        locations = {},
                    },
                },
        },
        [11] = { -- The War Within / Khaz Algar
            weekly = {
                treatise = {
                    questID = 83733,  
                    label = "Treatise: Mining",
                    icon = "Interface\\Icons\\inv_misc_profession_book_mining",
                },
                craftingOrder = {
                    questID = 12346,
                    label = "Weekly Alchemy Profession Quest",
                    icon = "Interface\\Icons\\inv_crafting_orders",
                },
                treasures = {
                    label = "Alchemy Knowledge Treasures",
                    icon = "Interface\\Icons\\inv_misc_book_07",
                    questIDs = { }, -- replace with actual one-time treasure quests
                }
            },
            oneTime = {
                treasures = {
                    label = "One-Time Knowledge Treasures",
                    icon = "",
                    locations = {
                        { mapID = 2339, x = 36.6, y = 79.3, name = "Dornogal Chisel", questID = 83907 },
                        { mapID = 2248, x = 58.2, y = 62.0, name = "Earthen Miner's Gavel", questID = 83906 },
                        { mapID = 2214, x = 45.2, y = 27.5, name = "Earthen Excavator's Shovel", questID = 83908 },
                        { mapID = 2214, x = 62, y = 66.2, name = "Regenerating Ore", questID = 83909 },
                        { mapID = 2215, x = 46.1, y = 64.4, name = "Arathi Precision Drill", questID = 83910 },
                        { mapID = 2215, x = 43.1, y = 56.8, name = "Devout Archaeologist's Excavator", questID = 83911 },
                        { mapID = 2216, x = 46.8, y = 21.8, name = "Heavy Spider Crusher", questID = 83912 },
                        { mapID = 2216, x = 48.3, y = 40.8, name = "Nerubian Mining Cart", questID = 83913 },
                    }
                }
            }
        }
    },

    -- ======================================================
    -- 393: SKINNING
    -- ======================================================
    [393] = {
        [10] = {
                weekly = {
                    huntQuest = {
                        questID = 70001,
                        label = "Skinning Hunt Weekly",
                        icon = "Interface\\Icons\\inv_misc_pelt_wolf_01",
                    },
                },
                oneTime = {
                    treasures = {
                        label = "Rare Creature Knowledge",
                        icon = "Interface\\Icons\\inv_misc_pelt_bear_01",
                        locations = {},
                    },
                },
        },
        [11] = {
            -- The War Within / Khaz Algar
            weekly = {
                treatise = {
                    questID = 83734,  
                    label = "Treatise: Skinning",
                    icon = "Interface\\Icons\\inv_misc_profession_book_skinning",
                },
                craftingOrder = {
                    questID = 12346,
                    label = "Weekly Alchemy Profession Quest",
                    icon = "Interface\\Icons\\inv_crafting_orders",
                },
                treasures = {
                    label = "Alchemy Knowledge Treasures",
                    icon = "Interface\\Icons\\inv_misc_book_07",
                    questIDs = { 11111, 11112, 11113 }, -- replace with actual one-time treasure quests
                }
            },
            oneTime = {
                treasures = {
                    label = "One-Time Knowledge Treasures",
                    icon = "",
                    locations = {
                        { mapID = 2339, x = 28.8, y = 51.7, name = "Dornogal Carving Knife", questID = 83914 },
                        { mapID = 2248, x = 60.0, y = 28.0, name = "Earthen Worker's Beams", questID = 83915 },
                        { mapID = 2214, x = 47.3, y = 28.3, name = "Artisan's Drawing Knife", questID = 83916 },
                        { mapID = 2214, x = 65.8, y = 61.88, name = "Fungarian's Rich Tannin", questID = 83917 },
                        { mapID = 2215, x = 42.3, y = 53.8, name = "Arathi Craftsman's Spokeshave", questID = 83919 },
                        { mapID = 2215, x = 49.3, y = 62.1, name = "Arathi Tanning Agent", questID = 83918 },
                        { mapID = 2255, x = 56.6, y = 55.3, name = "Carapace Shiner", questID = 83921 },
                        { mapID = 2216, x = 44.6, y = 49.3, name = "Nerubian Slicking Iron", questID = 83920 },
                    }
                }
            }
        }
    },

}

PT.ExpansionIndex = {
    ["Classic"] = 1,
    ["Outland"] = 2,
    ["Northrend"] = 3,
    ["Cataclysm"] = 4,
    ["Pandaria"] = 5,
    ["Draenor"] = 6,
    ["Legion"] = 7,
    ["Zandalari"] = 8,
    ["Kul Tiran"] = 8,
    ["Shadowlands"] = 9,
    ["Dragon Isles"] = 10,
    ["Khaz Algar"] = 11,
}

PT.ProfessionData = {
    {name = "Alchemy", id = 171, expansions = {2485, 2484, 2483, 2482, 2481, 2480, 2479, 2478, 2750, 2823, 2871}},
    {name = "Blacksmithing", id = 164, expansions = {2477, 2476, 2475, 2474, 2473, 2472, 2454, 2437, 2751, 2822, 2872}},
    {name = "Cooking", id = 185, expansions = {2548, 2547, 2546, 2545, 2544, 2543, 2542, 2541, 2752, 2824, 2873}},
    {name = "Enchanting", id = 333, expansions = {2494, 2493, 2492, 2491, 2489, 2488, 2487, 2486, 2753, 2825, 2874}},
    {name = "Engineering", id = 202, expansions = {2506, 2505, 2504, 2503, 2502, 2501, 2500, 2499, 2755, 2827, 2875}},
    {name = "Fishing", id = 356, expansions = {2592, 2591, 2590, 2589, 2588, 2587, 2586, 2585, 2754, 2826, 2876}},
    {name = "Herbalism", id = 182, expansions = {2556, 2555, 2554, 2553, 2552, 2551, 2550, 2549, 2760, 2832, 2877}},
    {name = "Inscription", id = 773, expansions = {2514, 2513, 2512, 2511, 2510, 2509, 2508, 2507, 2756, 2828, 2878}},
    {name = "Jewelcrafting", id = 755, expansions = {2524, 2523, 2522, 2521, 2520, 2519, 2518, 2517, 2757, 2829, 2879}},
    {name = "Leatherworking", id = 165, expansions = {2532, 2531, 2530, 2529, 2528, 2527, 2526, 2525, 2758, 2830, 2880}},
    {name = "Mining", id = 186, expansions = {2572, 2571, 2570, 2569, 2568, 2567, 2566, 2565, 2761, 2833, 2881}},
    {name = "Skinning", id = 393, expansions = {2564, 2563, 2562, 2561, 2560, 2559, 2558, 2557, 2762, 2834, 2882}},
    {name = "Tailoring", id = 197, expansions = {2540, 2539, 2538, 2537, 2536, 2535, 2534, 2533, 2759, 2831, 2883}},
}

-- ========================================================
-- Utility Module
-- ========================================================
PT.Util = {}

function PT.Util.GetCharacterKey()
    local name, realm = UnitFullName("player")
    if not realm or realm == "" then
        realm = GetRealmName() or "UnknownRealm"
    end
    if not name then
        name = UnitName("player") or "UnknownPlayer"
    end
    return string.format("%s-%s", name, realm)
end

function PT.Util.EnsureTable(t, key)
    if not t[key] then t[key] = {} end
    return t[key]
end

function PT.Util.GetCurrentWeekTimestamp()
    local serverTime = GetServerTime()
    local weekday = date("%w", serverTime)
    local daysSinceTuesday = (weekday - 2) % 7
    local tuesdayMidnight = serverTime - (daysSinceTuesday * 86400)
    return tuesdayMidnight - (tuesdayMidnight % 86400)
end

function PT.Util.DeepCopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[PT.Util.DeepCopy(orig_key)] = PT.Util.DeepCopy(orig_value)
        end
        setmetatable(copy, PT.Util.DeepCopy(getmetatable(orig)))
    else
        copy = orig
    end
    return copy
end

-- ========================================================
-- Database Manager Class
-- ========================================================
PT.DatabaseManager = {}
PT.DatabaseManager.__index = PT.DatabaseManager

function PT.DatabaseManager:New()
    local instance = setmetatable({}, self)
    instance:Initialize()
    return instance
end

function PT.DatabaseManager:Initialize()
    if not ProfessionTrackerDB then
        ProfessionTrackerDB = {
            version = ADDON_VERSION,
            characters = {},
        }
    end
    self.db = ProfessionTrackerDB
end

function PT.DatabaseManager:GetCharacterData(charKey)
    charKey = charKey or PT.Util.GetCharacterKey()
    return self.db.characters[charKey]
end

function PT.DatabaseManager:EnsureCharacterData(charKey)
    charKey = charKey or PT.Util.GetCharacterKey()
    local charData = PT.Util.EnsureTable(self.db.characters, charKey)
    
    if not charData.name then
        local name, realm = UnitFullName("player")
        charData.name = name or UnitName("player") or "Unknown"
        charData.realm = realm or GetRealmName() or "UnknownRealm"
        charData.class = select(2, UnitClass("player"))
        charData.level = UnitLevel("player")
        charData.faction = UnitFactionGroup("player")
    end
    
    charData.lastLogin = time()
    PT.Util.EnsureTable(charData, "professions")
    
    return charData
end

function PT.DatabaseManager:GetAllCharacters()
    local chars = {}
    for key, data in pairs(self.db.characters) do
        if type(data) == "table" then
            chars[key] = data
        end
    end
    return chars
end

function PT.DatabaseManager:RemoveProfession(charKey, professionName)
    local charData = self:GetCharacterData(charKey)
    if charData and charData.professions then
        charData.professions[professionName] = nil
    end
end

-- ========================================================
-- Knowledge Point Calculator Class
-- ========================================================
PT.KnowledgeCalculator = {}
PT.KnowledgeCalculator.__index = PT.KnowledgeCalculator

function PT.KnowledgeCalculator:New()
    return setmetatable({}, self)
end

function PT.KnowledgeCalculator:GetPointsMissingForTree(configID, nodeID)
    local todo = { nodeID }
    local missing = 0
    
    while next(todo) do
        local currentNodeID = table.remove(todo)
        
        local children = C_ProfSpecs.GetChildrenForPath(currentNodeID)
        if children then
            for _, childID in ipairs(children) do
                table.insert(todo, childID)
            end
        end
        
        local info = C_Traits.GetNodeInfo(configID, currentNodeID)
        if info then
            local enableFix = info.activeRank == 0 and 1 or 0
            missing = missing + info.maxRanks - info.activeRank - enableFix
        end
    end
    
    return missing
end

function PT.KnowledgeCalculator:CalculateMissing(skillLineID)
    if not skillLineID then return 0 end
    
    local configID = C_ProfSpecs.GetConfigIDForSkillLine(skillLineID)
    if not configID then return 0 end
    
    local traitTreeIDs = C_ProfSpecs.GetSpecTabIDsForSkillLine(skillLineID)
    if not traitTreeIDs then return 0 end
    
    local totalMissing = 0
    
    for _, traitTreeID in ipairs(traitTreeIDs) do
        local tabInfo = C_ProfSpecs.GetTabInfo(traitTreeID)
        if tabInfo and tabInfo.rootNodeID then
            totalMissing = totalMissing + self:GetPointsMissingForTree(configID, tabInfo.rootNodeID)
        end
    end
    
    local currencyInfo = C_ProfSpecs.GetCurrencyInfoForSkillLine(skillLineID)
    if currencyInfo and currencyInfo.numAvailable then
        totalMissing = totalMissing - currencyInfo.numAvailable
    end
    
    return totalMissing
end

-- ========================================================
-- Treasure Tracker Class
-- ========================================================
PT.TreasureTracker = {}
PT.TreasureTracker.__index = PT.TreasureTracker

function PT.TreasureTracker:New(kpReference)
    local instance = setmetatable({}, self)
    instance.kpReference = kpReference or KPReference
    return instance
end

function PT.TreasureTracker:RecalculateForCharacter(charKey, dbManager)
    local charData = dbManager:GetCharacterData(charKey)
    if not charData or not charData.professions then return end

    local profNameToID = {}
    for _, p in ipairs(PT.ProfessionData) do
        profNameToID[p.name] = p.id
    end

    for profName, profData in pairs(charData.professions) do
        local profID = profNameToID[profName]
        
        if not profID and profData.expansions then
            for _, exp in pairs(profData.expansions) do
                if exp.skillLineID then
                    profID = exp.skillLineID
                    break
                end
            end
        end

        if profID then
            for expName, expData in pairs(profData.expansions or {}) do
                self:UpdateExpansionTreasures(profID, expData)
            end
        end
    end
end

function PT.TreasureTracker:UpdateExpansionTreasures(profID, expData)
    local expIndex = expData and expData.id
    local hasRef = expIndex and
                   self.kpReference[profID] and
                   self.kpReference[profID][expIndex] and
                   self.kpReference[profID][expIndex].oneTime
    
    if not hasRef then
        expData.oneTimeCollectedAll = true
        expData.missingOneTimeTreasures = {}
        return
    end

    local ref = self.kpReference[profID][expIndex].oneTime.treasures
    local missing = {}
    local allCollected = true

    if ref and ref.locations then
        for _, loc in ipairs(ref.locations) do
            if loc.questID then
                local completed = pcall(function()
                    return C_QuestLog.IsQuestFlaggedCompleted(loc.questID)
                end) and C_QuestLog.IsQuestFlaggedCompleted(loc.questID)

                if not completed then
                    allCollected = false
                    table.insert(missing, {
                        name = loc.name,
                        mapID = loc.mapID,
                        x = loc.x,
                        y = loc.y,
                        questID = loc.questID,
                    })
                end
            end
        end
    end

    expData.oneTimeCollectedAll = allCollected
    expData.missingOneTimeTreasures = missing
end

-- ========================================================
-- Profession Scanner Class
-- ========================================================
PT.ProfessionScanner = {}
PT.ProfessionScanner.__index = PT.ProfessionScanner

function PT.ProfessionScanner:New(dbManager, knowledgeCalc, treasureTracker)
    local instance = setmetatable({}, self)
    instance.dbManager = dbManager
    instance.knowledgeCalc = knowledgeCalc
    instance.treasureTracker = treasureTracker
    return instance
end

function PT.ProfessionScanner:GetExpansionData(professionName)
    local expansions = {}

    if C_TradeSkillUI and C_TradeSkillUI.GetChildProfessionInfos then
        local childInfos = C_TradeSkillUI.GetChildProfessionInfos()
        if childInfos then
            for _, info in ipairs(childInfos) do
                if info.parentProfessionName == professionName then
                    table.insert(expansions, {
                        expansionName = info.expansionName or "Unknown",
                        skillLineID = info.professionID,
                        skillLevel = info.skillLevel,
                        maxSkillLevel = info.maxSkillLevel,
                    })
                end
            end
        end
    end

    return expansions
end

function PT.ProfessionScanner:ScanCharacter()
    local charData = self.dbManager:EnsureCharacterData()
    local professions = charData.professions
    local currentProfs = {}

    local profIndices = { GetProfessions() }
    for _, profIndex in ipairs(profIndices) do
        if profIndex then
            local name, _, skillLevel, maxSkillLevel, _, _, skillLine = GetProfessionInfo(profIndex)
            if name and not self:IsExcluded(name) then
                currentProfs[name] = true
                self:UpdateProfessionData(professions, name, skillLine)
            end
        end
    end

    -- Remove unlearned professions
    for savedName in pairs(professions) do
        if not currentProfs[savedName] then
            self.dbManager:RemoveProfession(PT.Util.GetCharacterKey(), savedName)
        end
    end

    -- Recalculate treasures
    self.treasureTracker:RecalculateForCharacter(PT.Util.GetCharacterKey(), self.dbManager)

    return charData
end

function PT.ProfessionScanner:IsExcluded(professionName)
    local excluded = {
        ["Cooking"] = true,
        ["Fishing"] = true,
        ["Archaeology"] = true,
        ["First Aid"] = true,
    }
    return excluded[professionName]
end

function PT.ProfessionScanner:UpdateProfessionData(professions, profName, skillLine)
    local profession = PT.Util.EnsureTable(professions, profName)
    profession.lastUpdated = time()
    profession.name = profName

    local expansions = PT.Util.EnsureTable(profession, "expansions")
    local expansionList = self:GetExpansionData(profName)

    if expansionList and #expansionList > 0 then
        for _, exp in ipairs(expansionList) do
            self:UpdateExpansionData(expansions, exp)
        end
    end
end

function PT.ProfessionScanner:UpdateExpansionData(expansions, expInfo)
    local expName = expInfo.expansionName or "Unknown"
    local expID = PT.ExpansionIndex[expName] or 0
    local hasKnowledgeSystem = expID >= PT.Constants.KNOWLEDGE_SYSTEM_START

    local expData = expansions[expName] or {}
    expData.name = expName
    expData.id = expID
    expData.skillLineID = expInfo.skillLineID or expData.skillLineID
    expData.skillLevel = expInfo.skillLevel or expData.skillLevel or 0
    expData.maxSkillLevel = expInfo.maxSkillLevel or expData.maxSkillLevel or 0

    if hasKnowledgeSystem and expInfo.skillLineID then
        local missing = self.knowledgeCalc:CalculateMissing(expInfo.skillLineID)
        expData.pointsUntilMaxKnowledge = missing or 0
        expData.knowledgePoints = expData.knowledgePoints or 0
        expData.weeklyKnowledgePoints = expData.weeklyKnowledgePoints or {
            treatise = false,
            treasures = false,
            craftingOrderQuest = false,
        }

        -- Update concentration
        self:UpdateConcentration(expData, expInfo.skillLineID)
    end

    expansions[expName] = expData
end

function PT.ProfessionScanner:UpdateConcentration(expData, skillLineID)
    local concentrationCurrencyID = C_TradeSkillUI.GetConcentrationCurrencyID and 
                                     C_TradeSkillUI.GetConcentrationCurrencyID(skillLineID)
    if concentrationCurrencyID then
        local currencyInfo = C_CurrencyInfo.GetCurrencyInfo(concentrationCurrencyID)
        if currencyInfo then
            expData.concentration = currencyInfo.quantity or 0
            expData.maxConcentration = currencyInfo.maxQuantity or 1000
            expData.concentrationLastUpdated = time()
        end
    end
end

-- ========================================================
-- Event Manager Class
-- ========================================================
PT.EventManager = {}
PT.EventManager.__index = PT.EventManager

function PT.EventManager:New(scanner)
    local instance = setmetatable({}, self)
    instance.scanner = scanner
    instance.frame = CreateFrame("Frame")
    instance:RegisterEvents()
    return instance
end

function PT.EventManager:RegisterEvents()
    local events = {
        "TRADE_SKILL_SHOW",
        "SKILL_LINES_CHANGED",
        "TRAIT_TREE_CURRENCY_INFO_UPDATED",
        "TRADE_SKILL_DATA_SOURCE_CHANGED",
        "TRADE_SKILL_LIST_UPDATE",
        "LEARNED_SPELL_IN_SKILL_LINE",
        "CURRENCY_DISPLAY_UPDATE",
        "PLAYER_LOGIN",
        "BAG_UPDATE_DELAYED",
    }

    for _, event in ipairs(events) do
        self.frame:RegisterEvent(event)
    end

    self.frame:SetScript("OnEvent", function(frame, event, ...)
        self:OnEvent(event, ...)
    end)
end

function PT.EventManager:OnEvent(event, ...)
    local updateEvents = {
        TRADE_SKILL_SHOW = true,
        PLAYER_LOGIN = true,
        SKILL_LINES_CHANGED = true,
        BAG_UPDATE_DELAYED = true,
        TRADE_SKILL_LIST_UPDATE = true,
    }

    if updateEvents[event] then
        self.scanner:ScanCharacter()
        self:NotifyUI()
    end
end

function PT.EventManager:NotifyUI()
    if PT.UI and PT.UI.OnDataUpdate then
        C_Timer.After(0.25, function()
            PT.UI:OnDataUpdate()
        end)
    end
end

-- ========================================================
-- Main Addon Class
-- ========================================================
PT.Core = {}
PT.Core.__index = PT.Core

function PT.Core:New()
    local instance = setmetatable({}, self)
    instance:Initialize()
    return instance
end

function PT.Core:Initialize()
    self.dbManager = PT.DatabaseManager:New()
    self.knowledgeCalc = PT.KnowledgeCalculator:New()
    self.treasureTracker = PT.TreasureTracker:New(KPReference)
    self.scanner = PT.ProfessionScanner:New(
        self.dbManager,
        self.knowledgeCalc,
        self.treasureTracker
    )
    self.eventManager = PT.EventManager:New(self.scanner)
end

function PT.Core:GetCharacterData(charKey)
    return self.dbManager:GetCharacterData(charKey)
end

function PT.Core:GetAllCharacters()
    return self.dbManager:GetAllCharacters()
end

function PT.Core:PrintDebug()
    local charData = self:GetCharacterData()
    if not charData then
        print("|cffff0000[Profession Tracker]|r No data found for this character")
        return
    end
    
    print("|cff00ff00[Profession Tracker]|r Character Data:")
    print(string.format("  Name: %s-%s", charData.name or "Unknown", charData.realm or "Unknown"))
    print(string.format("  Class: %s, Level: %d", charData.class or "Unknown", charData.level or 0))
    
    if charData.professions then
        print("  Professions:")
        for profName, profData in pairs(charData.professions) do
            print(string.format("    - %s", profName))
            if profData.expansions then
                for expName, expData in pairs(profData.expansions) do
                    local knowledgeInfo = ""
                    if expData.pointsUntilMaxKnowledge then
                        knowledgeInfo = string.format(" [Knowledge Remaining: %d]",
                            expData.pointsUntilMaxKnowledge)
                    end
                    print(string.format("      %s: %d/%d%s",
                        expName,
                        expData.skillLevel or 0,
                        expData.maxSkillLevel or 0,
                        knowledgeInfo))
                end
            end
        end
    end
end

-- ========================================================
-- Initialize Addon
-- ========================================================
function PT:Initialize()
    self.core = PT.Core:New()
    print("|cff00ff00[Profession Tracker]|r Core loaded successfully (OOP version)")
end

-- Auto-initialize on load
PT:Initialize()

-- Legacy compatibility
ProfessionTracker.GetCharacterData = function(self) return PT.core:GetCharacterData() end
ProfessionTracker.GetAllCharacters = function(self) return PT.core:GetAllCharacters() end
ProfessionTracker.PrintCharacterData = function(self) PT.core:PrintDebug() end
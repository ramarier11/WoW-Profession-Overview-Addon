-- ########################################################
-- ## Profession Tracker: Data Initialization & Storage  ##
-- ########################################################

ProfessionTracker = CreateFrame("Frame")

-- Register the UI so it can be refreshed later
function ProfessionTracker:RegisterUI(uiFrame)
    self.UI = uiFrame
end

-- ========================================================
-- Constants & Configuration
-- ========================================================

-- ############################################################
-- # Profession Knowledge Reference Table (Prototype)
-- # 
-- # Structure:
-- #   KPReference[professionID][expansionIndex] = {
-- #       weekly = { ... },      -- Weekly reset activities
-- #       oneTime = { ... },     -- Permanent collectibles
-- #       gathering = { ... },   -- Special cases (Herb, Mining, Skinning)
-- #   }
-- #
-- # Notes:
-- #  - All questIDs here are placeholders. Replace with real IDs later.
-- #  - Weekly entries mark activities that reset every Tuesday.
-- #  - oneTime entries allow tracking collectible KP sources.
-- ############################################################

KPReference = {

    ---------------------------------------------------------------------
    -- 171: ALCHEMY
    ---------------------------------------------------------------------
    [171] = {
        [10] = {  -- Dragonflight / Dragon Isles
            weekly = {
                treatise = {
                    questID = 12345,  
                    name = "Treatise: Alchemy",
                    icon = "Interface\\Icons\\inv_inscription_treatise",
                },
                craftingOrder = {
                    questID = 12346,
                    name = "Weekly Alchemy Profession Quest",
                    icon = "Interface\\Icons\\inv_crafting_orders",
                },
                treasures = {
                    name = "Alchemy Knowledge Treasures",
                    icon = "Interface\\Icons\\inv_misc_book_07",
                    questID = { 11111, 11112, 11113 }, -- replace with actual one-time treasure quests
                }
            },

            oneTime = {
                treasures = {
                    name = "One-Time Knowledge Treasures",
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
                    name = "Treatise: Alchemy",
                    icon = "Interface\\Icons\\inv_misc_profession_book_alchemy",
                },
                craftingOrder = {
                    questID = 84133,
                    name = "Alchemy Services Requested",
                    icon = "Interface\\Icons\\inv_crafting_orders",
                },
                treasures = {
                    { questID = 83253, name = "Alchemical Sediment", icon = "Interface\\Icons\\inv_misc_powder_mithril"  },
                    { questID = 83255, name = "Deepstone Crucible", icon = "Interface\\Icons\\inv_archaeology_ogres_mortarpestle"  },
                }
            },
            oneTime = {
                treasures = {
                    name = "One-Time Knowledge Treasures",
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
        },
        darkmoonFaire = {
            questID = 29506,
            x = 51,
            y = 69.2,
            mapID = 407,
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
                    name = "Treatise: Blacksmithing",
                    icon = "Interface\\Icons\\inv_inscription_treatise",
                },
                craftingOrder = {
                    questID = 12356,
                    name = "Weekly Blacksmithing Profession Quest",
                    icon = "Interface\\Icons\\inv_crafting_orders",
                },
                treasures = {
                    name = "Blacksmithing Knowledge Treasures",
                    icon = "Interface\\Icons\\inv_misc_book_07",
                    questID = { 44111, 44112, 44113 },
                }
            },

            oneTime = {
                treasures = {
                    name = "One-Time Knowledge Treasures",
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
                    name = "Treatise: Blacksmithing",
                    icon = "Interface\\Icons\\inv_misc_profession_book_blacksmithing",
                },
                craftingOrder = {
                    questID = 84127,
                    name = "Blacksmithing Services Requested",
                    icon = "Interface\\Icons\\inv_crafting_orders",
                },
                treasures = {
                    { questID = 83257, name = "Coreway Billet", icon = "Interface\\Icons\\inv_ingot_titansteel_dark"  },
                    { questID = 83256, name = "Dense Bladestone", icon = "Interface\\Icons\\inv_stone_sharpeningstone_05"  },
                }
            },
            oneTime = {
                treasures = {
                    name = "One-Time Knowledge Treasures",
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
        },
        darkmoonFaire = {
            questID = 29508,
            x = 51,
            y = 81.8,
            mapID = 407,
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
                    name = "Treatise: Enchanting",
                    icon = "Interface\\Icons\\inv_inscription_treatise",
                },
                craftingOrder = {
                    questID = 12356,
                    name = "Weekly Enchanting Profession Quest",
                    icon = "Interface\\Icons\\inv_crafting_orders",
                },
                treasures = {
                    name = "Enchanting Knowledge Treasures",
                    icon = "Interface\\Icons\\inv_misc_book_07",
                    questID = { 44111, 44112, 44113 },
                }
            },

            oneTime = {
                treasures = {
                    name = "One-Time Knowledge Treasures",
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
                    name = "Treatise: Enchanting",
                    icon = "Interface\\Icons\\inv_misc_profession_book_enchanting",
                },
                craftingOrder = {
                    questID = {84085, 84086, 84084},
                    name = "Weekly Enchanting Profession Quest",
                    icon = "Interface\\Icons\\inv_crafting_orders",
                },
                treasures = {
                    { questID = 83259, name = "Crystalline Repository", icon = "Interface\\Icons\\inv_jewelcrafting_dawnstone_03"  },
                    { questID = 83258, name = "Powdered Fulgurance", icon = "Interface\\Icons\\inv_enchanting_wod_dust"  },
                },
                gatherNodes = { 
                    {name = "Fleeting Arcane Manifestation", questID = {84290, 84291, 84292, 84293, 84294}, icon ="Interface\\Icons\\inv_magic_swirl_color2" },
                    {name = "Gleaming Telluric Crystal", questID = 84295, icon ="Interface\\Icons\\inv_10_enchanting_crystal_color3" }
                },
            },
            oneTime = {
                treasures = {
                    name = "One-Time Knowledge Treasures",
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
        },
        darkmoonFaire = {
            questID = 29510,
            x = 53.6,
            y = 75.6,
            mapID = 407,
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
                    name = "Treatise: Engineering",
                    icon = "Interface\\Icons\\inv_inscription_treatise",
                },
                craftingOrder = {
                    questID = 12356,
                    name = "Weekly Engineering Profession Quest",
                    icon = "Interface\\Icons\\inv_crafting_orders",
                },
                treasures = {
                    name = "Engineering Knowledge Treasures",
                    icon = "Interface\\Icons\\inv_misc_book_07",
                    questID = { 44111, 44112, 44113 },
                }
            },

            oneTime = {
                treasures = {
                    name = "One-Time Knowledge Treasures",
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
                    name = "Treatise: Engineering",
                    icon = "Interface\\Icons\\inv_misc_profession_book_engineering",
                },
                craftingOrder = {
                    questID = 84128,
                    name = "Engineering Services Requested",
                    icon = "Interface\\Icons\\inv_crafting_orders",
                },
                treasures = {
                    { questID = 83260, name = "Rust-Locked Mechanism", icon = "Interface\\Icons\\inv_misc_enggizmos_14"  },
                    { questID = 83261, name = "Earthen Induction Coil", icon = "Interface\\Icons\\inv_misc_gear_03"  },
                }
            },
            oneTime = {
                treasures = {
                    name = "One-Time Knowledge Treasures",
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
        },
        darkmoonFaire = {
            questID = 29511,
            x = 49.6,
            y = 60.8,
            mapID = 407,
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
                    name = "Treatise: Inscription",
                    icon = "Interface\\Icons\\inv_inscription_treatise",
                },
                craftingOrder = {
                    questID = 12356,
                    name = "Weekly Inscription Profession Quest",
                    icon = "Interface\\Icons\\inv_crafting_orders",
                },
                treasures = {
                    name = "Inscription Knowledge Treasures",
                    icon = "Interface\\Icons\\inv_misc_book_07",
                    questID = { 44111, 44112, 44113 },
                }
            },

            oneTime = {
                treasures = {
                    name = "One-Time Knowledge Treasures",
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
                    name = "Treatise: Inscription",
                    icon = "Interface\\Icons\\inv_misc_profession_book_inscription",
                },
                craftingOrder = {
                    questID = 84129,
                    name = "Inscription Services Requested",
                    icon = "Interface\\Icons\\inv_crafting_orders",
                },
                treasures = {
                    { questID = 83264, name = "Striated Inkstone", icon = "Interface\\Icons\\inv_ore_shadestone"  },
                    { questID = 83262, name = "Wax-Sealed Records", icon = "Interface\\Icons\\inv_letter_02"  },
                }
            },
            oneTime = {
                treasures = {
                    name = "One-Time Knowledge Treasures",
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
        },
        darkmoonFaire = {
            questID = 29515,
            x = 53.6,
            y = 75.6,
            mapID = 407,
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
                    name = "Treatise: Jewelcrafting",
                    icon = "Interface\\Icons\\inv_misc_profession_book_jewelcrafting",
                },
                craftingOrder = {
                    questID = 12356,
                    name = "Weekly Jewelcrafting Profession Quest",
                    icon = "Interface\\Icons\\inv_crafting_orders",
                },
                treasures = {
                    name = "Jewelcrafting Knowledge Treasures",
                    icon = "Interface\\Icons\\inv_misc_book_07",
                    questID = { 44111, 44112, 44113 },
                }
            },

            oneTime = {
                treasures = {
            name = "One-Time Knowledge Treasures",
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
                    name = "Treatise: Jewelcrafting",
                    icon = "Interface\\Icons\\inv_misc_profession_book_jewelcrafting",
                },
                craftingOrder = {
                    questID = 84130,
                    name = "Jewelcrafting Services Requested",
                    icon = "Interface\\Icons\\inv_crafting_orders",
                },
                treasures = {
                    { questID = 83265, name = "Diaphanous Gem Shards", icon = "Interface\\Icons\\inv_jewelcrafting_70_gem01_white"  },
                    { questID = 83266, name = "Deepstone Fragment", icon = "Interface\\Icons\\inv_misc_gem_x4_uncommon_cut_green"  },
                }
            },
            oneTime = {
                treasures = {
                    name = "One-Time Knowledge Treasures",
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
        },
        darkmoonFaire = {
            questID = 29516,
            x = 55,
            y = 70.6,
            mapID = 407,
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
                    name = "Treatise: Leatherworking",
                    icon = "Interface\\Icons\\inv_inscription_treatise",
                },
                craftingOrder = {
                    questID = 12356,
                    name = "Weekly Leatherworking Profession Quest",
                    icon = "Interface\\Icons\\inv_crafting_orders",
                },
                treasures = {
                    name = "Leatherworking Knowledge Treasures",
                    icon = "Interface\\Icons\\inv_misc_book_07",
                    questID = { 44111, 44112, 44113 },
                }
            },

            oneTime = {
                treasures = {
                    name = "One-Time Knowledge Treasures",
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
                    name = "Treatise: Leatherworking",
                    icon = "Interface\\Icons\\inv_misc_profession_book_leatherworking",
                },
                craftingOrder = {
                    questID = 84131,
                    name = "Leatherworking Services Requested",
                    icon = "Interface\\Icons\\inv_crafting_orders",
                },
                treasures = {
                    { questID = 83268, name = "Stone-Leather Swatch", icon = "Interface\\Icons\\inv_10_skinning_scales_black"  },
                    { questID = 83267, name = "Sturdy Nerubian Carapace", icon = "Interface\\Icons\\inv_shoulder_04"  },
                }
            },
            oneTime = {
                treasures = {
                    name = "One-Time Knowledge Treasures",
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
        },
        darkmoonFaire = {
            questID = 29517,
            x = 49.6,
            y = 60.8,
            mapID = 407,
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
                    name = "Treatise: Tailoring",
                    icon = "Interface\\Icons\\inv_inscription_treatise",
                },
                craftingOrder = {
                    questID = 12356,
                    name = "Weekly Tailoring Profession Quest",
                    icon = "Interface\\Icons\\inv_crafting_orders",
                },
                treasures = {
                    name = "Tailoring Knowledge Treasures",
                    icon = "Interface\\Icons\\inv_misc_book_07",
                    questID = { 44111, 44112, 44113 },
                }
            },

            oneTime = {
                treasures = {
                    name = "One-Time Knowledge Treasures",
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
                    name = "Treatise: Tailoring",
                    icon = "Interface\\Icons\\inv_misc_profession_book_tailoring",
                },
                craftingOrder = {
                    questID = 84132,
                    name = "Tailoring Services Requested",
                    icon = "Interface\\Icons\\inv_crafting_orders",
                },
                treasures = {
                    { questID = 83270, name = "Chitin Needle", icon = "Interface\\Icons\\inv_10_tailoring_purchasedthread_color1"  },
                    { questID = 83269, name = "Spool of Webweave", icon = "Interface\\Icons\\inv_misc_thread_01"  },
                }
            },
            oneTime = {
                treasures = {
                    name = "One-Time Knowledge Treasures",
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
        },
        darkmoonFaire = {
            questID = 29520,
            x = 55.6,
            y = 55.8,
            mapID = 407,
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
                        name = "Herbalism Survey Weekly",
                        icon = "Interface\\Icons\\inv_herbalism",
                    },
                    rareNodes = {
                        name = "Rare Herb Node KP",
                        icon = "Interface\\Icons\\inv_misc_herb_09",
                        questID = { 50011, 50012 }, -- each rare node grants KP once
                    },
                },

                oneTime = {
                    specialHerbs = {
                        name = "Unique Herb Discoveries",
                        icon = "Interface\\Icons\\inv_misc_herb_08",
                        questID = { 51001, 51002 }, -- one-time KP from special finds
                    },
                },
        },
        [11] = { -- The War Within / Khaz Algar
            weekly = {
                treatise = {
                    questID = 83729,  
                    name = "Treatise: Herbalism",
                    icon = "Interface\\Icons\\inv_misc_profession_book_herbalism",
                },
                craftingOrder = {
                    questID = {82970, 82962, 82965, 82958, 82916},
                    name = "Weekly Herbalism Profession Quest",
                    icon = "Interface\\Icons\\inv_crafting_orders",
                },
                gatherNodes = {
                    {name = "Deepgrove Petal", questID = { 81416, 81417, 81418, 81419, 81420 }, icon ="Interface\\Icons\\inv_magic_swirl_color2" },
                    {name = "Deepgrove Rose", questID = 81421, icon ="Interface\\Icons\\inv_10_enchanting_crystal_color3" }
                }
            },
            oneTime = {
                treasures = {
                    name = "One-Time Knowledge Treasures",
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
        },
        darkmoonFaire = {
            questID = 29514,
            x = 55,
            y = 70.6,
            mapID = 407,
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
                        name = "Mining Survey Weekly",
                        icon = "Interface\\Icons\\inv_misc_profession_book_mining",
                    },
                    rareNodes = {
                        name = "Rare Ore Node KP",
                        icon = "Interface\\Icons\\inv_ore_tin_01",
                        questID = { 60011, 60012 },
                    },
                },
                oneTime = {
                    specialOre = {
                        name = "Unique Ore Discoveries",
                        icon = "Interface\\Icons\\inv_ore_mithril_01",
                        questID = { 61001, 61002 },
                    },
                },
        },
        [11] = { -- The War Within / Khaz Algar
            weekly = {
                treatise = {
                    questID = 83733,  
                    name = "Treatise: Mining",
                    icon = "Interface\\Icons\\inv_misc_profession_book_mining",
                },
                craftingOrder = {
                    questID = {83103, 83102, 83104, 83106, 83105},
                    name = "Weekly Mining Profession Quest",
                    icon = "Interface\\Icons\\inv_crafting_orders", 
                },
                gatherNodes = {
                    {name = "Slab of Slate", questID = { 83054, 83053, 83052, 83051, 83050 }, icon ="Interface\\Icons\\inv_magic_swirl_color2" },
                    {name = "Erosion-Polished Slate", questID = 83049, icon ="Interface\\Icons\\inv_10_enchanting_crystal_color3" }
                }
            },
            oneTime = {
                treasures = {
                    name = "One-Time Knowledge Treasures",
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
        },
        darkmoonFaire = {
            questID = 29518,
            x = 49.6,
            y = 60.8,
            mapID = 407,
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
                        name = "Skinning Hunt Weekly",
                        icon = "Interface\\Icons\\inv_misc_pelt_wolf_01",
                    },
                },
                oneTime = {
                    rareCreatures = {
                        name = "Rare Creature Knowledge",
                        icon = "Interface\\Icons\\inv_misc_pelt_bear_01",
                        questID = { 71001, 71002 },
                    },
                },
        },
        [11] = {
            -- The War Within / Khaz Algar
            weekly = {
                treatise = {
                    questID = 83734,  
                    name = "Treatise: Skinning",
                    icon = "Interface\\Icons\\inv_misc_profession_book_skinning",
                },
                craftingOrder = {
                    questID = {83097, 83100, 82993, 83098, 82992},
                    name = "Weekly Skinning Profession Quest",
                    icon = "Interface\\Icons\\inv_crafting_orders",
                },
                gatherNodes = {
                    {name = "Toughened Tempest Pelt", questID = { 81459, 81460, 81461, 81462, 81463 }, icon ="Interface\\Icons\\inv_magic_swirl_color2" },
                    {name = "Abyssal Fur", questID = 81464, icon ="Interface\\Icons\\inv_10_enchanting_crystal_color3" }
                }
            },
            oneTime = {
                treasures = {
                    name = "One-Time Knowledge Treasures",
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
        },
        darkmoonFaire = {
            questID = 29519,
            x = 55,
            y = 70.6,
            mapID = 407,
        }
    },

}

ProfessionData = {
    {
        name = "Alchemy",
        id = 171,
        expansions = { 2485, 2484, 2483, 2482, 2481, 2480, 2479, 2478, 2750, 2823, 2871 },
    },
    {
        name = "Blacksmithing",
        id = 164,
        expansions = { 2477, 2476, 2475, 2474, 2473, 2472, 2454, 2437, 2751, 2822, 2872 },
    },
    {
        name = "Cooking",
        id = 185,
        expansions = { 2548, 2547, 2546, 2545, 2544, 2543, 2542, 2541, 2752, 2824, 2873 },
    },
    {
        name = "Enchanting",
        id = 333,
        expansions = { 2494, 2493, 2492, 2491, 2489, 2488, 2487, 2486, 2753, 2825, 2874 },
    },
    {
        name = "Engineering",
        id = 202,
        expansions = { 2506, 2505, 2504, 2503, 2502, 2501, 2500, 2499, 2755, 2827, 2875 },
    },
    {
        name = "Fishing",
        id = 356,
        expansions = { 2592, 2591, 2590, 2589, 2588, 2587, 2586, 2585, 2754, 2826, 2876 },
    },
    {
        name = "Herbalism",
        id = 182,
        expansions = { 2556, 2555, 2554, 2553, 2552, 2551, 2550, 2549, 2760, 2832, 2877 },
    },
    {
        name = "Inscription",
        id = 773,
        expansions = { 2514, 2513, 2512, 2511, 2510, 2509, 2508, 2507, 2756, 2828, 2878 },
    },
    {
        name = "Jewelcrafting",
        id = 755,
        expansions = { 2524, 2523, 2522, 2521, 2520, 2519, 2518, 2517, 2757, 2829, 2879 },
    },
    {
        name = "Leatherworking",
        id = 165,
        expansions = { 2532, 2531, 2530, 2529, 2528, 2527, 2526, 2525, 2758, 2830, 2880 },
    },
    {
        name = "Mining",
        id = 186,
        expansions = { 2572, 2571, 2570, 2569, 2568, 2567, 2566, 2565, 2761, 2833, 2881 },
    },
    {
        name = "Skinning",
        id = 393,
        expansions = { 2564, 2563, 2562, 2561, 2560, 2559, 2558, 2557, 2762, 2834, 2882 },
    },
    {
        name = "Tailoring",
        id = 197,
        expansions = { 2540, 2539, 2538, 2537, 2536, 2535, 2534, 2533, 2759, 2831, 2883 },
    },
}

local ExpansionIndex = {
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

-- ========================================================
-- CONSTANTS (File-Level)
-- ========================================================

local EXCLUDED_PROFESSIONS = {
    ["Cooking"] = true,
    ["Fishing"] = true,
    ["Archaeology"] = true,
    ["First Aid"] = true,
}

local GATHERING_PROFESSIONS = {
    [182] = true,  -- Herbalism
    [186] = true,  -- Mining
    [393] = true,  -- Skinning
}

local KNOWLEDGE_SYSTEM_START = 10 -- Dragon Isles and later

-- Build profession lookup once
local ProfessionNameToID = {}
for _, p in ipairs(ProfessionData) do
    ProfessionNameToID[p.name] = p.id
end

------------------------------------------------------------
-- Helper: Update most current expansion's skill values
-- Uses the highest numeric expansion id present for a profession.
-- Called even when TradeSkill UI is closed so long as GetProfessionInfo
-- gave us a skillLevel/maxSkillLevel (only reflects current expansion).
------------------------------------------------------------
local function UpdateMostCurrentExpansionSkill(profession, skillLevel, maxSkillLevel)
    if not profession or not profession.expansions then return end
    if not skillLevel or not maxSkillLevel then return end

    local latest
    for _, expData in pairs(profession.expansions) do
        local id = expData.id or 0
        if not latest or (id > (latest.id or 0)) then
            latest = expData
        end
    end
    if latest then
        -- Only overwrite if new value differs to avoid churn
        if latest.skillLevel ~= skillLevel then
            latest.skillLevel = skillLevel
        end
        if latest.maxSkillLevel ~= maxSkillLevel then
            latest.maxSkillLevel = maxSkillLevel
        end
    end
end


-- ========================================================
-- Utility Functions
-- ========================================================

local function GetCharacterKey()
    local name, realm = UnitFullName("player")

    -- Fallback if realm isn't available yet
    if not realm or realm == "" then
        realm = GetRealmName() or "UnknownRealm"
    end

    if not name then
        name = UnitName("player") or "UnknownPlayer"
    end

    return string.format("%s-%s", name, realm)
end

local function EnsureTable(t, key)
    if not t[key] then t[key] = {} end
    return t[key]
end

-- ========================================================
-- Weekly Reset Helpers (run once per reset across entire DB)
-- ========================================================

local WEEK_SECONDS = 7 * 24 * 60 * 60

-- Returns a stable token that changes each weekly reset.
-- Prefers Blizzard's weekly reset API; falls back to coarse week bucket.
local function GetWeeklyResetToken()
    local now = time()
    if C_DateAndTime and C_DateAndTime.GetSecondsUntilWeeklyReset then
        local untilNext = C_DateAndTime.GetSecondsUntilWeeklyReset()
        if type(untilNext) == "number" and untilNext >= 0 then
            local nextReset = now + untilNext
            local lastReset = nextReset - WEEK_SECONDS
            return math.floor(lastReset / WEEK_SECONDS)
        end
    end
    -- Fallback: coarse week bucket (not region-specific but stable)
    return math.floor(now / WEEK_SECONDS)
end

-- Clears weekly-computed flags so UI shows fresh state after reset
local function ResetWeeklyStateIfNeeded()
    if not ProfessionTrackerDB then return end
    ProfessionTrackerDB.meta = ProfessionTrackerDB.meta or {}
    local meta = ProfessionTrackerDB.meta
    local token = GetWeeklyResetToken()

    -- Already reset for this weekly token
    if meta.lastWeeklyResetToken == token then
        return
    end

    -- Iterate entire DB and reset weekly state
    if ProfessionTrackerDB.characters then
        for _, charData in pairs(ProfessionTrackerDB.characters) do
            if type(charData) == "table" and charData.professions then
                for _, profData in pairs(charData.professions) do
                    if type(profData) == "table" and profData.expansions then
                        for _, expData in pairs(profData.expansions) do
                            if type(expData) == "table" then
                                -- Legacy/manual progress table
                                if type(expData.weeklyKnowledgeProgress) == "table" then
                                    for k, v in pairs(expData.weeklyKnowledgeProgress) do
                                        if type(v) == "table" then
                                            v.completed = false
                                            v.lastCompleted = nil
                                            v.count = 0
                                        elseif type(v) == "boolean" then
                                            expData.weeklyKnowledgeProgress[k] = false
                                        end
                                    end
                                end

                                -- Computed snapshot used by UI
                                if type(expData.weeklyKnowledgePoints) == "table" then
                                    local wk = expData.weeklyKnowledgePoints
                                    if type(wk.treatise) == "boolean" then wk.treatise = false end
                                    if type(wk.craftingOrderQuest) == "boolean" then wk.craftingOrderQuest = false end

                                    if type(wk.treasures) == "table" then
                                        for _, t in ipairs(wk.treasures) do
                                            if type(t) == "table" then
                                                t.completed = false
                                            end
                                        end
                                        wk.treasuresAllComplete = false
                                    end

                                    if type(wk.gatherNodes) == "table" then
                                        for _, n in ipairs(wk.gatherNodes) do
                                            if type(n) == "table" then
                                                n.count = 0
                                                n.completed = false
                                            end
                                        end
                                        wk.gatherNodesAllComplete = false
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    meta.lastWeeklyResetToken = token
    meta.lastWeeklyResetAt = time()
end

-- ========================================================
-- Darkmoon Faire Tracking Functions
-- ========================================================

-- Helper: Get day of week for a given timestamp (1=Monday, 7=Sunday)
-- Uses Zeller's Congruence algorithm adapted for our needs
local function GetDayOfWeek(year, month, day)
    -- Adjust for Zeller's algorithm (January and February are months 13 and 14 of the previous year)
    if month < 3 then
        month = month + 12
        year = year - 1
    end
    
    local q = day
    local m = month
    local k = year % 100
    local j = math.floor(year / 100)
    
    -- Zeller's formula
    local h = (q + math.floor((13 * (m + 1)) / 5) + k + math.floor(k / 4) + math.floor(j / 4) - 2 * j) % 7
    
    -- Convert Zeller's result (0=Saturday) to our format (1=Monday, 7=Sunday)
    local dayOfWeek = ((h + 5) % 7) + 1
    return dayOfWeek
end

-- Helper: Days in month
local function GetDaysInMonth(year, month)
    local daysInMonth = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}
    if month == 2 and ((year % 4 == 0 and year % 100 ~= 0) or year % 400 == 0) then
        return 29  -- Leap year
    end
    return daysInMonth[month]
end

-- Helper: Create timestamp from date components
local function MakeTimestamp(year, month, day, hour, min, sec)
    return time({year = year, month = month, day = day, hour = hour or 0, min = min or 0, sec = sec or 0})
end

-- Returns the timestamp of the next upcoming Darkmoon Faire start
-- The event always starts on the first Sunday of each month
local function GetNextDarkmoonFaireStart()
    local now = time()
    local dateTable = date("*t", now)
    
    -- Find first Sunday of current month
    local year = dateTable.year
    local month = dateTable.month
    
    for day = 1, GetDaysInMonth(year, month) do
        local dow = GetDayOfWeek(year, month, day)
        if dow == 7 then  -- Sunday
            local timestamp = MakeTimestamp(year, month, day, 0, 0, 0)
            if timestamp > now then
                return timestamp
            end
        end
    end
    
    -- No future Sunday in current month, check next month
    month = month + 1
    if month > 12 then
        month = 1
        year = year + 1
    end
    
    -- Find first Sunday of next month
    for day = 1, 7 do  -- First Sunday will always be in first 7 days
        local dow = GetDayOfWeek(year, month, day)
        if dow == 7 then
            return MakeTimestamp(year, month, day, 0, 0, 0)
        end
    end
    
    -- Fallback (should never reach here)
    return now + (30 * 86400)
end

-- Returns the timestamp of the current Darkmoon Faire start (or last if not active)
local function GetCurrentDarkmoonFaireStart()
    local now = time()
    local dateTable = date("*t", now)
    
    -- Find first Sunday of current month
    local year = dateTable.year
    local month = dateTable.month
    
    for day = 1, GetDaysInMonth(year, month) do
        local dow = GetDayOfWeek(year, month, day)
        if dow == 7 then  -- Sunday
            local timestamp = MakeTimestamp(year, month, day, 0, 0, 0)
            if timestamp <= now then
                return timestamp
            else
                -- First Sunday hasn't happened yet, get previous month's
                month = month - 1
                if month < 1 then
                    month = 12
                    year = year - 1
                end
                
                -- Find first Sunday of previous month
                for prevDay = 1, 7 do
                    local prevDow = GetDayOfWeek(year, month, prevDay)
                    if prevDow == 7 then
                        return MakeTimestamp(year, month, prevDay, 0, 0, 0)
                    end
                end
            end
        end
    end
    
    -- Fallback
    return now - (30 * 86400)
end

-- Returns true if Darkmoon Faire is currently active (within the month starting on first Sunday)
local function IsDarkmoonFaireActive()
    local now = time()
    local currentStart = GetCurrentDarkmoonFaireStart()
    local nextStart = GetNextDarkmoonFaireStart()
    
    -- If current start is in the future, faire is not active
    if currentStart > now then
        return false
    end
    
    -- If we're before the next start, we're in the current faire month
    return now < nextStart
end

-- Returns seconds until the next Darkmoon Faire begins
local function GetSecondsUntilDarkmoonFaire()
    local now = time()
    local nextStart = GetNextDarkmoonFaireStart()
    
    if nextStart > now then
        return nextStart - now
    else
        -- Should not happen, but recalculate
        return 0
    end
end

-- Returns the Darkmoon Faire token (changes once per month when faire resets)
local function GetDarkmoonFaireToken()
    local currentStart = GetCurrentDarkmoonFaireStart()
    return math.floor(currentStart / (24 * 60 * 60))
end

-- Clears monthly Darkmoon Faire state if a new event has started
local function ResetDarkmoonFaireStateIfNeeded()
    print("Checking Darkmoon Faire reset...")
    if not ProfessionTrackerDB then return end
    ProfessionTrackerDB.meta = ProfessionTrackerDB.meta or {}
    local meta = ProfessionTrackerDB.meta
    
    local token = GetDarkmoonFaireToken()
    
    -- Already reset for this faire token
    if meta.lastDarkmoonFaireToken == token then
        return
    end
    
    -- Iterate entire DB and reset Darkmoon Faire state at profession level
    if ProfessionTrackerDB.characters then
        for _, charData in pairs(ProfessionTrackerDB.characters) do
            if type(charData) == "table" and charData.professions then
                for profName, profData in pairs(charData.professions) do
                    if type(profData) == "table" then
                        -- Initialize darkmoonFaire table if it doesn't exist
                        profData.darkmoonFaire = profData.darkmoonFaire or {}
                        profData.darkmoonFaire.lastReset = time()
                    end
                end
            end
        end
    end
    
    meta.lastDarkmoonFaireToken = token
    meta.lastDarkmoonFaireResetAt = time()
    print("Darkmoon Faire reset token:", meta.lastDarkmoonFaireToken)
end

-- ========================================================
-- Helper Functions
-- ========================================================

local function ForEachProfessionExpansion(callback)
    if not ProfessionTrackerDB or not ProfessionTrackerDB.characters then return end

    -- Only operate on the currently logged-in character
    local charKey = GetCharacterKey()
    local charData = ProfessionTrackerDB.characters[charKey]
    if not charData or not charData.professions then return end


    -- Iterate only this character's professions
    for profName, profData in pairs(charData.professions) do
        
        -- Resolve profession ID
        local profID = ProfessionNameToID[profName]

        -- Fallback: infer from expansions
        if not profID and profData.expansions then
            for _, exp in pairs(profData.expansions) do
                if exp.skillLineID then
                    profID = exp.skillLineID
                    break
                end
            end
        end

        -- Process expansions
        if profID and profData.expansions then
            for expName, expData in pairs(profData.expansions) do
                local expIndex = expData.id

                if expIndex
                    and KPReference[profID]
                    and KPReference[profID][expIndex] then

                    local ref = KPReference[profID][expIndex]

                    callback(
                        charKey, charData,
                        profName, profData, profID,
                        expName, expData, expIndex,
                        ref
                    )
                end
            end
        end
    end
end

local function CheckQuestCompletion(questID, checkType)
    if not questID then return false end
    
    if type(questID) == "number" then
        return C_QuestLog.IsQuestFlaggedCompleted(questID)
    elseif type(questID) == "table" then
        if checkType == "all" then
            for _, q in ipairs(questID) do
                if not C_QuestLog.IsQuestFlaggedCompleted(q) then
                    return false
                end
            end
            return true
        else -- "any" is default
            for _, q in ipairs(questID) do
                if C_QuestLog.IsQuestFlaggedCompleted(q) then
                    return true
                end
            end
            return false
        end
    end
    return false
end

-- Handles a questID that may be:
--  • a number  
--  • a list of numbers (ANY needed)  
local function WeeklyQuestCompleted(questID)
    if type(questID) == "number" then
        return C_QuestLog.IsQuestFlaggedCompleted(questID)
    elseif type(questID) == "table" then
        return CheckQuestCompletion(questID)
    end
    return false
end

-- Helper: Get quest name from questID
local function GetQuestName(questID)
    print("Getting quest name for ID:", questID)
    if not questID then return "Unknown Quest" end
    
    local questInfo = C_QuestLog.GetTitleForQuestID(questID)
    if questInfo and questInfo.name then
        return questInfo.name
    end
    return "Unknown Quest"
end

-- ========================================================
-- Profession Data Retrieval
-- ========================================================

-- Attempts to dynamically fetch expansion data from Blizzard API
local function GetCharacterProfessionExpansions(professionName)
    local expansions = {} -- creates local table called expansions

    -- Attempt dynamic retrieval from API
    if C_TradeSkillUI and C_TradeSkillUI.GetChildProfessionInfos then --checks if C_TradeSkillUI and C_TradeSkillUI.GetChildProfessionInfos is true (is tradeskill window open?)
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


-- ============================================================
-- Recalculate one-time treasure completion for a character
-- Runs independent of TradeSkill UI. Uses KPReference table only.
-- ============================================================
local function RecalculateOneTimeTreasures(charKey)
    ForEachProfessionExpansion(function(
        iterCharKey, charData,
        profName, profData, profID,
        expName, expData, expIndex,
        ref
    )
        -- Only run for selected character if charKey provided
        if charKey and iterCharKey ~= charKey then return end
        if not ref.oneTime or not ref.oneTime.treasures then return end

        local treasureRef = ref.oneTime.treasures
        local missing = {}
        local allDone = true

        if treasureRef.locations then
            for _, loc in ipairs(treasureRef.locations) do
                local completed = CheckQuestCompletion(loc.questID)
                if not completed then
                    allDone = false
                    table.insert(missing, {
                        name = loc.name,
                        mapID = loc.mapID,
                        x = loc.x,
                        y = loc.y,
                        questID = loc.questID
                    })
                end
            end
        end

        expData.oneTimeCollectedAll = allDone
        expData.missingOneTimeTreasures = missing
    end)
end

local function GetPointsMissingForTree(configID, nodeID, missing)
    missing = missing or 0
    
    local info = C_Traits.GetNodeInfo(configID, nodeID)
    if info then
        local enableFix = info.activeRank == 0 and 1 or 0
        missing = missing + info.maxRanks - info.activeRank - enableFix
    end
    
    local children = C_ProfSpecs.GetChildrenForPath(nodeID)
    if children then
        for _, childID in ipairs(children) do
            missing = GetPointsMissingForTree(configID, childID, missing)
        end
    end
    
    return missing
end

-- Calculate how many knowledge points are still missing for a profession
local function CalculateMissingKnowledgePoints(skillLineID)
    if not skillLineID then return 0 end
    
    local configID = C_ProfSpecs.GetConfigIDForSkillLine(skillLineID)
    if not configID then return 0 end
    
    local traitTreeIDs = C_ProfSpecs.GetSpecTabIDsForSkillLine(skillLineID)
    if not traitTreeIDs then return 0 end
    
    local totalMissing = 0
    
    for _, traitTreeID in ipairs(traitTreeIDs) do
        local tabInfo = C_ProfSpecs.GetTabInfo(traitTreeID)
        if tabInfo and tabInfo.rootNodeID then
            totalMissing = totalMissing + GetPointsMissingForTree(configID, tabInfo.rootNodeID)
        end
    end
    
    -- Subtract available unspent points
    local currencyInfo = C_ProfSpecs.GetCurrencyInfoForSkillLine(skillLineID)
    if currencyInfo and currencyInfo.numAvailable then
        totalMissing = totalMissing - currencyInfo.numAvailable
    end
    
    return totalMissing
end


-- ========================================================
-- Helper function to safely update knowledge points
-- Only calculates if the expansion has a knowledge system
-- Uses stored skillLineID from expData (populated during initialization)
-- ========================================================
local function UpdateKnowledgePointsIfApplicable(expData)
    if not expData then return end
    
    -- Check if this expansion has a knowledge system
    local expIndex = expData.id
    if not expIndex or expIndex < KNOWLEDGE_SYSTEM_START then
        return
    end
    
    -- Need skillLineID to calculate - must have been stored during initialization
    local skillLineID = expData.skillLineID
    if not skillLineID then
        return
    end
    
    -- Initialize knowledge tracking if not present
    if not expData.knowledgePoints then
        expData.knowledgePoints = 0
    end
    
    -- Calculate current missing points
    local missing = CalculateMissingKnowledgePoints(skillLineID)
    if missing then
        expData.pointsUntilMaxKnowledge = missing
    elseif not expData.pointsUntilMaxKnowledge then
        expData.pointsUntilMaxKnowledge = 0
    end
end

local function RecalculateWeeklyKnowledgePoints()
    ForEachProfessionExpansion(function(
        charKey, charData,
        profName, profData, profID,
        expName, expData, expIndex,
        ref
    )
        if not ref.weekly then return end

        expData.weeklyKnowledgePoints = expData.weeklyKnowledgePoints or {}
        local wk = expData.weeklyKnowledgePoints

        --------------------------------------------------
        -- Helper: check if ANY quest in array is complete
        --------------------------------------------------
        local function AnyCompleted(questList)
            for _, q in ipairs(questList) do
                if CheckQuestCompletion(q) then
                    return true
                end
            end
            return false
        end

        --------------------------------------------------
        -- Helper: check if ALL quests (single or arrays)
        -- inside a set of treasure entries are complete
        --------------------------------------------------
        local function AllTreasureEntriesComplete(entries)
            for _, entry in ipairs(entries) do
                local q = entry.questID

                if type(q) == "table" then
                    -- must complete *all* inside this table
                    for _, innerID in ipairs(q) do
                        if not CheckQuestCompletion(innerID) then
                            return false
                        end
                    end
                else
                    -- single quest
                    if not CheckQuestCompletion(q) then
                        return false
                    end
                end
            end
            return true
        end

        --------------------------------------------------
        -- Treatise (always single quest)
        --------------------------------------------------
        if ref.weekly.treatise and ref.weekly.treatise.questID then
            wk.treatise = CheckQuestCompletion(ref.weekly.treatise.questID)
        end

        --------------------------------------------------
        -- Crafting Orders (array of questIDs)
        -- Weekly is complete if ANY assigned weekly is done
        --------------------------------------------------
        if ref.weekly.craftingOrder and ref.weekly.craftingOrder.questID then
            local q = ref.weekly.craftingOrder.questID
            if type(q) == "table" then
                wk.craftingOrderQuest = AnyCompleted(q)
            else
                wk.craftingOrderQuest = CheckQuestCompletion(q)
            end
        end

        --------------------------------------------------
        -- Weekly Gathering Nodes
        -- Each entry: questID (single or table)
        -- Entire weekly = TRUE if *all* entries done
        --------------------------------------------------
        -- if ref.weekly.gatherNodes and type(ref.weekly.gatherNodes) == "table" then
        --     wk.gatherNodes = AllTreasureEntriesComplete(ref.weekly.gatherNodes)
        -- end
        if ref.weekly.gatherNodes and type(ref.weekly.gatherNodes) == "table" then
            wk.gatherNodes = {}  -- Fresh array each time
            local allCompleted = true

            for i, entry in ipairs(ref.weekly.gatherNodes) do
                local q = entry.questID
                local completedCount = 0
                local totalCount = type(q) == "table" and #q or 1

                if type(q) == "table" then
                    -- Count ALL completed quests in the array
                    for _, innerID in ipairs(q) do
                        if CheckQuestCompletion(innerID, "all") then
                            completedCount = completedCount + 1
                        end
                    end
                else
                    -- Single quest: 0 or 1
                    if CheckQuestCompletion(q) then
                        completedCount = 1
                    end
                end

                -- ✅ Store as indexed array entry
                wk.gatherNodes[i] = {
                    name = entry.name or ("Node " .. i),
                    count = completedCount,
                    total = totalCount,
                    completed = (completedCount == totalCount)
                }

                if completedCount < totalCount then
                    allCompleted = false
                end
            end

            wk.gatherNodesAllComplete = allCompleted
        end



        --------------------------------------------------
        -- Weekly Treasures (individual + overall)
        --------------------------------------------------
        if ref.weekly.treasures and type(ref.weekly.treasures) == "table" then
            wk.treasures = {}  -- Fresh array each time
            local allCompleted = true

            for i, entry in ipairs(ref.weekly.treasures) do
                local q = entry.questID
                local completed = false

                if type(q) == "table" then
                    --------------------------------------------------
                    -- Multi-quest treasure (must complete ANY)
                    --------------------------------------------------
                    for _, innerID in ipairs(q) do
                        if CheckQuestCompletion(innerID) then
                            completed = true
                            break
                        end
                    end
                else
                    --------------------------------------------------
                    -- Single quest treasure
                    --------------------------------------------------
                    completed = CheckQuestCompletion(q)
                end

                -- ✅ Store as indexed array entry
                wk.treasures[i] = {
                    label = entry.name or entry.label or ("Treasure " .. i),
                    completed = completed
                }

                if not completed then
                    allCompleted = false
                end
            end

            wk.treasuresAllComplete = allCompleted
        end


    end)
end

-- ========================================================
-- Darkmoon Faire Quest Tracking
-- ========================================================

local function RecalculateDarkmoonFaireQuests()
    if not ProfessionTrackerDB or not ProfessionTrackerDB.characters then return end
    
    local charKey = GetCharacterKey()
    local charData = ProfessionTrackerDB.characters[charKey]
    if not charData or not charData.professions then return end
    
    -- Only track if Darkmoon Faire is currently active
    if not IsDarkmoonFaireActive() then return end
    
    for profName, profData in pairs(charData.professions) do
        -- Get profession ID
        local profID = ProfessionNameToID[profName]
        if not profID then
            -- Try to infer from expansions
            if profData.expansions then
                for _, exp in pairs(profData.expansions) do
                    if exp.skillLineID then
                        profID = exp.skillLineID
                        break
                    end
                end
            end
        end
        
        -- Check if this profession has Darkmoon Faire data in KPReference
        if profID and KPReference[profID] and KPReference[profID].darkmoonFaire then
            local faireRef = KPReference[profID].darkmoonFaire
            
            -- Initialize darkmoonFaire structure if not present
            profData.darkmoonFaire = profData.darkmoonFaire or {
                lastReset = 0
            }
            
            -- Check quest completion
            local questID = faireRef.questID
            if questID then
                local isComplete = C_QuestLog.IsQuestFlaggedCompleted(questID)
                profData.darkmoonFaire.completed = isComplete
                profData.darkmoonFaire.questID = questID
                
                -- Store location data for UI display
                if faireRef.x and faireRef.y and faireRef.mapID then
                    profData.darkmoonFaire.location = {
                        x = faireRef.x,
                        y = faireRef.y,
                        mapID = faireRef.mapID
                    }
                end
            end
        end
    end
end

-- ========================================================
-- Data Initialization & Update (patched merged version)
-- ========================================================
local function UpdateCharacterProfessionData()
    if not ProfessionTrackerDB then
        ProfessionTrackerDB = {
            version = "1.0.0",
            characters = {},
        }
    end
    
    -- Ensure characters table exists
    if not ProfessionTrackerDB.characters then
        ProfessionTrackerDB.characters = {}
    end

    -- One-time weekly reset across entire DB (before any recalculations)
    ResetWeeklyStateIfNeeded()
    
    -- One-time monthly reset for Darkmoon Faire state
    ResetDarkmoonFaireStateIfNeeded()

    local currentTime = time()
    local charKey = GetCharacterKey()
    local charData = EnsureTable(ProfessionTrackerDB.characters, charKey)

    -- Initialize metadata if not set yet
    if not charData.name then
        local name, realm = UnitFullName("player")
        charData.name = name or UnitName("player") or "Unknown"
        charData.realm = realm or GetRealmName() or "UnknownRealm"
        charData.class = select(2, UnitClass("player"))
        charData.level = UnitLevel("player")
        charData.faction = UnitFactionGroup("player")
    end

    charData.lastLogin = currentTime

    local professions = EnsureTable(charData, "professions")
    local currentProfs = {}

    local profIndices = { GetProfessions() }
    for _, profIndex in ipairs(profIndices) do
        if profIndex then
            local name, _, skillLevel, maxSkillLevel, _, _, skillLine = GetProfessionInfo(profIndex)
            if name then

                if not EXCLUDED_PROFESSIONS[name] then
                    currentProfs[name] = true
                    local profession = EnsureTable(professions, name)
                    profession.lastUpdated = currentTime
                    profession.name = name

                    -- Ensure expansions table exists (may have been populated by previous full-scan)
                    local expansions = EnsureTable(profession, "expansions")

                    -- ===== Attempt to get detailed expansion info from TradeSkill UI (only available when tradeskill is open) =====
                    local expansionList = GetCharacterProfessionExpansions(name)
                    if expansionList and #expansionList > 0 then
                        -- Merge the fresh expansion data into saved expansions
                        for _, exp in ipairs(expansionList) do
                            local expName = exp.expansionName or "Unknown"
                            local expID = ExpansionIndex[expName] or 0
                            local hasKnowledgeSystem = expID >= KNOWLEDGE_SYSTEM_START

                            local expData = expansions[expName] or {}
                            expData.name = expName
                            expData.id = expID
                            expData.baseSkillLineID = skillLine or 0
                            expData.skillLineID = exp.skillLineID or expData.skillLineID
                            expData.skillLevel = exp.skillLevel or expData.skillLevel or 0
                            expData.maxSkillLevel = exp.maxSkillLevel or expData.maxSkillLevel or 0

                            if hasKnowledgeSystem and exp.skillLineID then
                                -- IMPORTANT: Store skillLineID for later use outside this loop
                                expData.skillLineID = exp.skillLineID
                                
                                -- Update knowledge points
                                UpdateKnowledgePointsIfApplicable(expData)

                                -- Get concentration currency info
                                local concentrationCurrencyID = C_TradeSkillUI.GetConcentrationCurrencyID and C_TradeSkillUI.GetConcentrationCurrencyID(exp.skillLineID)
                                if concentrationCurrencyID then
                                    local currencyInfo = C_CurrencyInfo.GetCurrencyInfo(concentrationCurrencyID)
                                    if currencyInfo then

                                        if not GATHERING_PROFESSIONS[skillLine] then
                                            expData.concentration = currencyInfo.quantity or 0
                                            expData.maxConcentration = currencyInfo.maxQuantity or 1000
                                            expData.concentrationLastUpdated = currentTime
                                        else
                                            -- Make sure they're cleared so UI hides it
                                            expData.concentration = nil
                                            expData.maxConcentration = nil
                                            expData.concentrationLastUpdated = nil
                                        end

                                    end
                                end
                            end

                            expansions[expName] = expData
                        end
                    else
                        -- If TradeSkill UI isn't open, we don't touch expansion list structure here.
                        -- This preserves previously stored expansion entries so RecalculateOneTimeTreasures can still work.
                        -- (No-op)
                    end

                    -- Always update the most current expansion's skill values using generic profession skillLevel/maxSkillLevel.
                    UpdateMostCurrentExpansionSkill(profession, skillLevel, maxSkillLevel)
                end
            end
        end
    end

    -- Remove unlearned professions from saved DB
    for savedName in pairs(professions) do
        if not currentProfs[savedName] then
            professions[savedName] = nil
        end
    end

    -- Iterate through all stored professions and update their knowledge points
    for profName, profData in pairs(professions) do
        if profData.expansions then
            for expName, expData in pairs(profData.expansions) do
                -- Update knowledge points using stored skillLineID
                -- This works even when tradeskill window is closed
                UpdateKnowledgePointsIfApplicable(expData)
            end
        end
    end


    -- ===== ALWAYS re-evaluate one-time treasures AFTER we've merged/kept expansion structure =====
    -- This is the key: RecalculateOneTimeTreasures doesn't require TradeSkill UI.
    RecalculateOneTimeTreasures(charKey)
    RecalculateWeeklyKnowledgePoints()
    RecalculateDarkmoonFaireQuests()


-- Find this section in your ProfessionTracker.lua (around line 750-780)
-- Replace the existing auto-refresh code with this:

    -- Auto-refresh UI if open (small delay to avoid racing other events)
    if ProfessionTracker.UI and ProfessionTracker.UI:IsShown() then
        C_Timer.After(0.25, function()
            if ProfessionTracker.UI.Refresh then
                ProfessionTracker.UI:Refresh()
            elseif ProfessionTracker.UI.RedrawCharacterDetail then
                ProfessionTracker.UI:RedrawCharacterDetail()
            end
        end)
    end
    
    -- Refresh Character Detail Window if open
    if ProfessionTrackerUI and ProfessionTrackerUI.CharacterDetailWindow then
        C_Timer.After(0.25, function()
            if ProfessionTrackerUI.CharacterDetailWindow.Refresh then
                ProfessionTrackerUI.CharacterDetailWindow:Refresh()
            end
        end)
    end

    -- Close stale missing treasure window if present (prevents stale list)
    if ProfessionTrackerUI and ProfessionTrackerUI.missingTreasureWindow and ProfessionTrackerUI.missingTreasureWindow:IsShown() then
        ProfessionTrackerUI.missingTreasureWindow:Hide()
    end

    print("|cff00ff00[Profession Tracker]|r Data updated for:", charKey)
end



-- ========================================================
-- Public Accessors
-- ========================================================

function ProfessionTracker:GetCharacterData()
    local key = GetCharacterKey()
    return ProfessionTrackerDB and ProfessionTrackerDB[key]
end

function ProfessionTracker:GetProfessionData(profession)
    local charData = self:GetCharacterData()
    if not charData then return end
    return charData.professions and charData.professions[profession]
end

function ProfessionTracker:GetAllCharacters()
    if not ProfessionTrackerDB or not ProfessionTrackerDB.characters then return {} end
    local chars = {}
    for key, data in pairs(ProfessionTrackerDB.characters) do
        if type(data) == "table" then
            chars[key] = {
                name = data.name,
                realm = data.realm,
                class = data.class,
                level = data.level,
                lastLogin = data.lastLogin,
                professions = data.professions, -- ✅ Add this line
            }
        end
    end
    return chars
end


-- ========================================================
-- Darkmoon Faire Accessors
-- ========================================================

function ProfessionTracker:IsDarkmoonFaireActive()
    return IsDarkmoonFaireActive()
end

function ProfessionTracker:GetDarkmoonFaireStatus()
    local isActive = IsDarkmoonFaireActive()
    local currentStart = GetCurrentDarkmoonFaireStart()
    local nextStart = GetNextDarkmoonFaireStart()
    local secondsUntilNext = GetSecondsUntilDarkmoonFaire()
    
    -- Format dates using date table instead of format strings
    local currentDate = date("*t", currentStart)
    local nextDate = date("*t", nextStart)
    
    local monthNames = {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"}
    local currentFormatted = string.format("%s %d, %d", monthNames[currentDate.month], currentDate.day, currentDate.year)
    local nextFormatted = string.format("%s %d, %d", monthNames[nextDate.month], nextDate.day, nextDate.year)
    
    return {
        isActive = isActive,
        currentStart = currentStart,
        nextStart = nextStart,
        secondsUntilNext = secondsUntilNext,
        currentStartFormatted = currentFormatted,
        nextStartFormatted = nextFormatted,
    }
end

function ProfessionTracker:GetCharacterDarkmoonFaireData()
    local charData = self:GetCharacterData()
    if not charData or not charData.professions then return {} end
    
    -- Collect Darkmoon Faire data from all professions
    local faireData = {}
    for profName, profData in pairs(charData.professions) do
        if profData.darkmoonFaire then
            faireData[profName] = profData.darkmoonFaire
        end
    end
    
    return faireData
end

-- Get Darkmoon Faire data for a specific profession
function ProfessionTracker:GetProfessionDarkmoonFaireData(professionName)
    local charData = self:GetCharacterData()
    if not charData or not charData.professions then return nil end
    
    local profData = charData.professions[professionName]
    if not profData then return nil end
    
    -- Initialize if not present
    profData.darkmoonFaire = profData.darkmoonFaire or {
        lastReset = 0
    }
    
    return profData.darkmoonFaire
end

-- Get quest name for a given questID
function ProfessionTracker:GetQuestName(questID)
    return GetQuestName(questID)

end

-- ========================================================
-- Weekly Activity Tracking
-- ========================================================

function ProfessionTracker:MarkWeeklyActivityComplete(profession, expansion, activity)
    local charData = self:GetCharacterData()
    if not charData or not charData.professions then return false end
    
    local profData = charData.professions[profession]
    if not profData or not profData.expansions then return false end
    
    local expData = profData.expansions[expansion]
    if not expData or not expData.weeklyKnowledgeProgress then return false end
    
    if expData.weeklyKnowledgeProgress[activity] then
        expData.weeklyKnowledgeProgress[activity].completed = true
        expData.weeklyKnowledgeProgress[activity].lastCompleted = time()
        print(string.format("|cff00ff00[Profession Tracker]|r Marked %s complete for %s (%s)", 
            activity, profession, expansion))
        return true
    end
    
    return false
end

-- ========================================================
-- Event Registration & Handling
-- ========================================================

ProfessionTracker:RegisterEvent("TRADE_SKILL_SHOW")
ProfessionTracker:RegisterEvent("SKILL_LINES_CHANGED")
ProfessionTracker:RegisterEvent("TRAIT_TREE_CURRENCY_INFO_UPDATED")
ProfessionTracker:RegisterEvent("TRADE_SKILL_DATA_SOURCE_CHANGED")
ProfessionTracker:RegisterEvent("TRADE_SKILL_LIST_UPDATE")
ProfessionTracker:RegisterEvent("LEARNED_SPELL_IN_SKILL_LINE")
ProfessionTracker:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
ProfessionTracker:RegisterEvent("PLAYER_LOGIN")
ProfessionTracker:RegisterEvent("BAG_UPDATE_DELAYED")
ProfessionTracker:RegisterEvent("QUEST_TURNED_IN")


ProfessionTracker:SetScript("OnEvent", function(self, event, ...)
    print("|cffff00ff[DEBUG]|r Event fired:", event)
    -- Run DB update
    if  event == "TRADE_SKILL_SHOW" or
        event == "PLAYER_LOGIN" or
        event == "SKILL_LINES_CHANGED" or
        event == "BAG_UPDATE_DELAYED" or
        event == "TRADE_SKILL_LIST_UPDATE" or
        event == "QUEST_TURNED_IN" then
        if UpdateCharacterProfessionData then
            UpdateCharacterProfessionData()
        elseif ProfessionTracker and ProfessionTracker.UpdateCharacterProfessionData then
            ProfessionTracker:UpdateCharacterProfessionData()
        end

       
        -- Refresh the missing treasure window if it exists
        if self.UI and self.UI.RefreshMissingTreasureWindow then
            C_Timer.After(0.1, function()
                self.UI:RefreshMissingTreasureWindow()
            end)
        end
        
    end
end)

-- ========================================================
-- Debug Commands
-- ========================================================

function ProfessionTracker:PrintCharacterData()
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
                    if expData.knowledgePoints then
                        knowledgeInfo = string.format(" [Knowledge: %d Remaining %d]",
                            expData.knowledgePoints or 0,
                            expData.pointsUntilMaxKnowledge or 0)
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
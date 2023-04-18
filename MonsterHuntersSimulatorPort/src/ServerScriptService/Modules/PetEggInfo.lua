local module = {
	["CommonEgg"] = {
		["CommonPet"] = {
			["Name"] = "Doggy",
			["BaseRarity"] = 50,
			["x5GamepassRarity"] = 46
		},
		["UncommonPet"] = {
			["Name"] = "Kitty",
			["BaseRarity"] = 30,
			["x5GamepassRarity"] = 30
		},
		["RarePet"] = {
			["Name"] = "Bunny",
			["BaseRarity"] = 15,
			["x5GamepassRarity"] = 15
		},
		["EpicPet"] = {
			["Name"] = "Bear",
			["BaseRarity"] = 4,
			["x5GamepassRarity"] = 4
		},
		["MythicalPet"] = {
			["Name"] = "Dino",
			["BaseRarity"] = 1,	
			["x5GamepassRarity"] = 5
		},
		["Cost"] = 50,
	},
	["UncommonEgg"] = {
		["CommonPet"] = {
			["Name"] = "Panda",
			["BaseRarity"] = 50,--50
			["x5GamepassRarity"] = 46
		},
		["UncommonPet"] = {
			["Name"] = "PolarBear",
			["BaseRarity"] = 30,--30	
			["x5GamepassRarity"] = 30
		},
		["RarePet"] = {
			["Name"] = "Wolf",
			["BaseRarity"] = 15,--15
			["x5GamepassRarity"] = 15
		},
		["EpicPet"] = {
			["Name"] = "Fox",
			["BaseRarity"] = 4,--4	
			["x5GamepassRarity"] = 4
		},
		["MythicalPet"] = {
			["Name"] = "Golem",
			["BaseRarity"] = 1,	
			["x5GamepassRarity"] = 5
		},
		["Cost"] = 200,
	},
	["RareEgg"] = {
		["CommonPet"] = {
			["Name"] = "MagmaDoggy",
			["BaseRarity"] = 50,--50
			["x5GamepassRarity"] = 46
		},
		["UncommonPet"] = {
			["Name"] = "FirePiggy",
			["BaseRarity"] = 30,--30	
			["x5GamepassRarity"] = 30
		},
		["RarePet"] = {
			["Name"] = "FireFox",
			["BaseRarity"] = 15,--15
			["x5GamepassRarity"] = 15
		},
		["EpicPet"] = {
			["Name"] = "FireDeer",
			["BaseRarity"] = 4,--4	
			["x5GamepassRarity"] = 4
		},
		["MythicalPet"] = {
			["Name"] = "Demon",
			["BaseRarity"] = 1,	
			["x5GamepassRarity"] = 5
		},
		["Cost"] = 500,
	},
	["EpicEgg"] = {
		["CommonPet"] = {
			["Name"] = "SpaceBunny",
			["BaseRarity"] = 50,
			["x5GamepassRarity"] = 46
		},
		["UncommonPet"] = {
			["Name"] = "LunarFox",
			["BaseRarity"] = 30,
			["x5GamepassRarity"] = 30
		},
		["RarePet"] = {
			["Name"] = "SpaceBull",
			["BaseRarity"] = 15,
			["x5GamepassRarity"] = 15
		},
		["EpicPet"] = {
			["Name"] = "AmethystGolem",
			["BaseRarity"] = 4,
			["x5GamepassRarity"] = 4
		},
		["MythicalPet"] = {
			["Name"] = "GalacticAngel",
			["BaseRarity"] = 1,	
			["x5GamepassRarity"] = 5
		},
		["Cost"] = 1000,
	},	
	["Pets"] ={
		["Doggy"] = {
			["DisplayName"] = "Doggy",
			["Rarity"] = "Common",
			["Stats"] = {
				["Attack"] = 1.1,
				["Coins"] = 1.05,
			},
		},
		["Kitty"] = {
			["DisplayName"] = "Kitty",
			["Rarity"] = "Uncommon",
			["Stats"] = {
				["Attack"] = 1.15,
				["Coins"] = 1.1,
			},
		},
		["Bunny"] = {
			["DisplayName"] = "Bunny",
			["Rarity"] = "Rare",
			["Stats"] = {
				["Attack"] = 1.25,
				["Coins"] = 1.25,
			},
		},
		["Bear"] = {
			["DisplayName"] = "Bear",
			["Rarity"] = "Epic",
			["Stats"] = {
				["Attack"] = 1.3,
				["Coins"] = 1.3,
			},
		},
		["Dino"] = {
			["DisplayName"] = "Dino",
			["Rarity"] = "Mythical",
			["Stats"] = {
				["Attack"] = 1.5,
				["Coins"] = 1.5,
			},
		},
		["Panda"] = {
			["DisplayName"] = "Panda",
			["Rarity"] = "Common",
			["Stats"] = {
				["Attack"] = 1.3,
				["Coins"] = 1.3,
			},
		},
		["PolarBear"] = {
			["DisplayName"] = "Polar Bear",
			["Rarity"] = "Uncommon",
			["Stats"] = {
				["Attack"] = 1.4,
				["Coins"] = 1.4,
			},
		},
		["Wolf"] = {
			["DisplayName"] = "Wolf",
			["Rarity"] = "Rare",
			["Stats"] = {
				["Attack"] = 1.5,
				["Coins"] = 1.5,
			},
		},
		["Fox"] = {
			["DisplayName"] = "Fox",
			["Rarity"] = "Epic",
			["Stats"] = {
				["Attack"] = 1.6,
				["Coins"] = 1.6,
			},
		},
		["Golem"] = {
			["DisplayName"] = "Golem",
			["Rarity"] = "Mythical",
			["Stats"] = {
				["Attack"] = 1.8,
				["Coins"] = 1.8,
			},
		},
		["MagmaDoggy"] = {
			["DisplayName"] = "Magma Doggy",
			["Rarity"] = "Common",
			["Stats"] = {
				["Attack"] = 1.6,
				["Coins"] = 1.6,
			},
		},
		["FirePiggy"] = {
			["DisplayName"] = "Fire Piggy",
			["Rarity"] = "Uncommon",
			["Stats"] = {
				["Attack"] = 1.7,
				["Coins"] = 1.7,
			},
		},
		["FireFox"] = {
			["DisplayName"] = "Fire Fox",
			["Rarity"] = "Rare",
			["Stats"] = {
				["Attack"] = 1.8,
				["Coins"] = 1.8,
			},
		},
		["FireDeer"] = {
			["DisplayName"] = "Fire Deer",
			["Rarity"] = "Epic",
			["Stats"] = {
				["Attack"] = 1.9,
				["Coins"] = 1.9,
			},
		},
		["Demon"] = {
			["DisplayName"] = "Demon",
			["Rarity"] = "Mythical",
			["Stats"] = {
				["Attack"] = 2.1,
				["Coins"] = 2.1,
			},
		},
		["SpaceBunny"] = {
			["DisplayName"] = "Space Bunny",
			["Rarity"] = "Common",
			["Stats"] = {
				["Attack"] = 1.9,
				["Coins"] = 1.9,
			},
		},
		["LunarFox"] = {
			["DisplayName"] = "Lunar Fox",
			["Rarity"] = "Uncommon",
			["Stats"] = {
				["Attack"] = 2,
				["Coins"] = 2,
			},
		},
		["SpaceBull"] = {
			["DisplayName"] = "Space Bull",
			["Rarity"] = "Rare",
			["Stats"] = {
				["Attack"] = 2.1,
				["Coins"] = 2.1,
			},
		},
		["AmethystGolem"] = {
			["DisplayName"] = "Amethyst Golem",
			["Rarity"] = "Epic",
			["Stats"] = {
				["Attack"] = 2.2,
				["Coins"] = 2.2,
			},
		},
		["GalacticAngel"] = {
			["DisplayName"] = "Galactic Angel",
			["Rarity"] = "Mythical",
			["Stats"] = {
				["Attack"] = 2.4,
				["Coins"] = 2.4,
			},
		},
	}
}

return module

local module = {
	--base damage for each gun along with other info if needed in future.
	["Silencer"] = {
		["BaseDamage"] = 10,
		["Description"] = "Pistol type gun that easily penetrates enemies.",
		["Price"] = 0,
		["Name"] = "Silencer",
		["DisplayName"] = "Silencer",
	},
	["DB"] = {
		["BaseDamage"] = 40,
		["Description"] = "Only has 2 ammo. However, it deals a lot of damage.",
		["Price"] = 250,
		["Name"] = "DB",
		["DisplayName"] = "Double Barrel Shotgun",
	},
	["SMG"] = {
		["BaseDamage"] = 10,
		["Description"] = "Chews through its clip extremely quickly.",
		["Price"] = 1000,
		["Name"] = "SMG",
		["DisplayName"] = "SMG",
	},
	["Revolver"] = {
		["BaseDamage"] = 40,
		["Description"] = "Very strong sidearm with high base damage.",
		["Price"] = 4000,
		["Name"] = "Revolver",
		["DisplayName"] = "Revolver",
	},
	["LMG"] = {
		["BaseDamage"] = 25,
		["Description"] = "A machine gun with a huge clip.",
		["Price"] = 40000,
		["Name"] = "LMG",
		["DisplayName"] = "Light Machine Gun",
	},
	["TacticalShotgun"] = {
		["BaseDamage"] = 100,
		["Description"] = "A shotgun that deals an extreme amount of damage.",
		["Price"] = 10000,
		["Name"] = "TacticalShotgun",
		["DisplayName"] = "Tactical Shotgun",
	},
	["RPG"] = {
		["BaseDamage"] = 1000,
		["Description"] = "An extremely powerful rocket launcher, dealing extreme amounts of explosive damage to enemies.",
		["Price"] = nil,
		["Name"] = "RPG",
		["DisplayName"] = "RPG",
	},
	["Flamethrower"] = {
		["BaseDamage"] = 22,
		["Description"] = "An powerful weapon capable of burning enemies to dust.",
		["Price"] = nil,
		["Name"] = "Flamethrower",
		["DisplayName"] = "Flamethrower",
	},
}

return module

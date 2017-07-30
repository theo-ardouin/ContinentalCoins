_G.AddContinentalCoins = _G.AddContinentalCoins or {}
AddContinentalCoins._path = ModPath
AddContinentalCoins._data_path = ModPath .. "continental_coins.txt"
AddContinentalCoins._data = { ["coins"] = 10 }

function AddContinentalCoins:Save()
	local file = io.open(self._data_path, "w+")
	if file then
		file:write(json.encode(self._data))
		file:close()
	end
end

function AddContinentalCoins:Load()
	local file = io.open(self._data_path, "r")
	if file then
		self._data = json.decode(file:read("*all"))
		file:close()
	end
end

function AddContinentalCoins:Add()
  local current = Application:digest_value(managers.custom_safehouse._global.total)
	Global.custom_safehouse_manager.total = Application:digest_value(current + self._data["coins"], true)
end

Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInit_AddContinentalCoins", function(loc)
	loc:load_localization_file(AddContinentalCoins._path .. "loc/en.txt")
end)

Hooks:Add("MenuManagerInitialize", "MenuManagerInitialize_AddContinentalCoins", function(menu_manager)

	MenuCallbackHandler.callback_cc_slider = function(self, item)
		AddContinentalCoins._data["coins"] = item:value()
		AddContinentalCoins:Save()
	end

	MenuCallbackHandler.callback_cc_add = function(self, item)
    AddContinentalCoins:Add()
    local _menu = QuickMenu:new("Continental Coins", "Added " .. AddContinentalCoins._data["coins"] .. " Coins", {{text = "OK", is_cancel_button = true}})
    _menu:Show()
	end

	AddContinentalCoins:Load()
	MenuHelper:LoadFromJsonFile(AddContinentalCoins._path .. "menu/options.txt", AddContinentalCoins, AddContinentalCoins._data)
end)
_G.ContinentalCoins = _G.ContinentalCoins or {}
ContinentalCoins._path = ModPath

ContinentalCoins.coins = 10

FLAG_ADD     = 1
FLAG_REMOVE  = -1

function ContinentalCoins:Balance()
  return Application:digest_value(managers.custom_safehouse._global.total)
end

function ContinentalCoins:Set(value)
  if value < 0 then
    value = 0
  end
  Global.custom_safehouse_manager.total = Application:digest_value(value, true)
  QuickMenu:new("Continental Coins", "Current balance: " .. math.floor(self:Balance()) .. " coins", {{text = "OK", is_cancel_button = true}}):Show()
end

function ContinentalCoins:Update(flag)
  self:Set(self:Balance() + (ContinentalCoins.coins * flag))
end

Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInit_ContinentalCoins", function(loc)
  loc:load_localization_file(ContinentalCoins._path .. "loc/en.txt")
end)

Hooks:Add("MenuManagerInitialize", "MenuManagerInitialize_ContinentalCoins", function(menu_manager)
  MenuCallbackHandler.callback_cc_slider = function(self, item)
    ContinentalCoins.coins = item:value()
  end

  MenuCallbackHandler.callback_cc_set = function(self, item)
    ContinentalCoins:Set(ContinentalCoins.coins)
  end

  MenuCallbackHandler.callback_cc_add = function(self, item)
    ContinentalCoins:Update(FLAG_ADD)
  end

  MenuCallbackHandler.callback_cc_remove = function(self, item)
    ContinentalCoins:Update(FLAG_REMOVE)
  end

  MenuHelper:LoadFromJsonFile(ContinentalCoins._path .. "menu/options.txt", ContinentalCoins, ContinentalCoins._data)
end)
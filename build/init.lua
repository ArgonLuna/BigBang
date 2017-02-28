local dcopy
dcopy = function(t)
  local tt = { }
  for k, v in pairs(t) do
    tt[dcopy(k)] = dcopy(v)
  end
  return tt
end
local standardConfig = {
  initScript = "/boot/boot.lua",
  rescueScript = "/boot/rescue.lua"
}
local config = standardConfig
if fs.exists(".bigbang") then
  local handle = fs.open(".bigbang", "r")
  local content = handle.readAll()
  handle.close()
  config = loadstring("return " .. content)()
end
local a = _G.printError
_G.printError = function()
  _G.printError = a
  term.redirect(term.native())
  term.clear()
  term.setCursorPos(1, 1)
  local ok, err = pcall(function()
    return dofile(config.initScript)
  end)
  if not ok then
    printError(err)
    os.pullEvent("key")
    return dofile(config.rescueScript)
  end
end
return os.queueEvent("modem_message", 0)

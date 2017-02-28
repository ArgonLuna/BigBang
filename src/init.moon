dcopy = (t) ->
  tt = {}
  for k,v in pairs t
    tt[dcopy(k)] = dcopy(v)
  return tt

standardConfig =
  initScript: "/boot/boot.lua"
  rescueScript: "/boot/rescue.lua"

config = standardConfig

if fs.exists ".bigbang"
  handle = fs.open ".bigbang", "w"
  content = handle.readAll!
  handle.close!
  config = loadstring("return " .. content)()

-- TLCO magic
a = _G.printError
_G.printError = ->
  _G.printError = a
  term.redirect term.native!
  term.clear!
  term.setCursorPos 1,1
  ok, err = pcall ->
    dofile config.initScript
  if not ok
    printError err
    os.pullEvent "key"
    dofile config.rescueScript
    
os.queueEvent "modem_message", 0

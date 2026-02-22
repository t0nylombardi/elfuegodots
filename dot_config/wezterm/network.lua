#!/usr/bin/env lua

-- Returns true if the specified interface has link and an IP address
local function is_interface_active(iface)
  local handle = io.popen("/sbin/ifconfig " .. iface)
  local data = handle:read("*a") or ""
  handle:close()
  return data:match("status:%s+active") and data:match("%sin%s+[0-9%.]+")
end

-- Returns a list of en* interfaces on the system
local function list_en_interfaces()
  local result = {}
  local handle = io.popen("networksetup -listallhardwareports 2>/dev/null")
  local current_port
  for line in handle:lines() do
    local port = line:match("^Hardware Port: (.+)")
    if port then
      current_port = port
    end
    local dev = line:match("^Device: (.+)")
    if dev and dev:match("^en") then
      -- Only consider Ethernet‑type ports (ignore Wi‑Fi)
      if not current_port:lower():match("wi%-fi") then
        table.insert(result, dev)
      end
    end
  end
  handle:close()
  return result
end

-- Find an active wired interface
local active
for _, iface in ipairs(list_en_interfaces()) do
  if is_interface_active(iface) then
    active = iface
    break
  end
end

if active then
  print("Active Ethernet interface: " .. active)
else
  print("No active Ethernet connection found (likely using Wi‑Fi or Thunderbolt Bridge).")
end


function inspect_tool.inspect_tool_use(itemstack, user, pointed_thing)
  if not user then
    return
  end
  local player_name = user:get_player_name()
  if player_name=="" then
    return
  end
  local def = itemstack:get_definition()
  if def._inspect_interval then
    local meta = itemstack:get_meta()
    local last_inspect = meta:get_int("last_inspect")
    local gametime = minetest.get_gametime()
    if (gametime-last_inspect)<def._inspect_interval then
      if def._inspect_wait_msg then
        minetest.chat_send_player(player_name, def._inspect_wait_msg)
      end
      return
    end
    meta:set_int("last_inspect", gametime)
  end
  
  def = nil
  local data = nil
  if pointed_thing.type == "node" then
    local node = minetest.get_node(pointed_thing.under)
    def = minetest.registered_nodes[node.name]
    data = pointed_thing.under
  elseif pointed_thing.type == "object" then
    def = pointed_thing.ref:get_luaentity()
    data = def
  end
  if def then
    if def._inspect_msg then
      minetest.chat_send_player(player_name, def._inspect_msg)
    elseif def._inspect_msg_func then
      local level = minetest.get_item_group(itemstack:get_name(), "inspect_level")
      minetest.chat_send_player(player_name, def._inspect_msg_func(data, level))
    elseif def.description then
      minetest.chat_send_player(player_name, def.description)
    end
  end
  return itemstack
end


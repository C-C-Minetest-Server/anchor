Inspired by [Teleport Waypoints in Genshin Impact](https://genshin-impact.fandom.com/wiki/Teleport_Waypoint), this mod provides a special type of block for similar purpose. The admin should place and configure these, and then players can unlock the anchor once they approach and right-click the anchor.

This mod provides a basic anchor node, though modders are strongly recommended to create their own, as the basic one is lack of visual features.

Please refer to [`API.md`](https://github.com/C-C-Minetest-Server/anchor/blob/master/API.md) for developer-specific tutorials.

### List of installed anchors
In some inventory mods (e.g. Unified Inventory), it's posible to get a list of them by typing `group:anchor` in the search bar.

### How to set up or modify an anchor
Only those with `server` privilege can set up or modify anchors. To set up an anchor, place down one and then right-click on it. A menu will be shown and details can be typed in.

To modify an existing one, right-click on it. The menu is the same as the previous one but with a new option, "Keep original UUID". If unchecked, the anchor will be removed from all players' record, and players have to re-approach there to unlock the anchor.

To remove an anchor, simply dig it.

### How to teleport to anchors?
Only those with `interact` privilege can interact with or teleport to anchors.

Before teleporting, players should first approach and right-click the anchor. The anchor will then be recorded into player's list and avaliable for them to teleport.

Use the chat command `/anchors` to get a list of unlocked anchors. Players can then select one from the list, if any, and teleport to them.

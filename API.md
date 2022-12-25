## Node database APIs
### `anchor.storage` (Table)
`anchor.storage` contains the node database of anchors. It is a table with coordinates in `minetest.pos_to_string` format as the keys and another table as the values. The structure of the values are descripted below:

* `uuid` (String): The unique identifier of the anchor, in the format `"(<x>,<y>,<z>)<os.time()>"`.
* `name` (String): The title of the anchor.
* `subtitle` (String, optional): Short description
* `description` (String): The long description of the anchor.

### `anchor.update_anchor(pos[,meta])`
Sync a anchor's data to the node database. `pos` should be a valid position of a anchor, and `meta` should be the metadata of the anchor. If `meta` is absent, the mod will try to get one from the `pos` provided.

### `anchor.add_anchor(pos,data)`
Write a anchor's data to both node metadata and node database. `pos` should be a valid position of a anchor, and `data` should be a key-value pair in the `anchor.storage` value format, with the following exceptions:

* `uuid` (String or Boolean): If `true`, a new one will always be generated. If string, the string will be the new UUID. If no uuid is detected from the anchor's metadata, and no string is passed, a new one will be generated.

### `anchor.get_anchor(pos)`
Return a anchor's data in the `anchor.storage` value format by reading the given anchor's metadata.

## Player Storage APIs
Anchor mod uses up two field in player metadata: `anchor_list` and `anchor_list_alt`. Unless otherwise specified, in this section, `player` means a player ObjectRef.

### `anchor.playerstorage.get_list(player)`
Get a list of valid anchors unlocked by the player. Not that this function will automatically remove all invalid anchors from player's list.

### `anchor.playerstorage.clear_list(player)`
Remove all anchors from the player's list. The player then have to re-unlock all the anchors one-by-one in order to use them

### `anchor.playerstorage.add_item(player,item)`
Add an anchor into the player's list. `item` should be a coordinate table with a extra optional `uuid` field. If duplications is detected, `false` is returned, otherwise `true`.

### `anchor.playerstorage.remove_item(player,item)`
Remove an anchor from the player's list. The syntax is the same as above.

## Registeration APIs
### `anchor.register_anchor(name,def)`
Register an anchor. `def` should be a [node defination table](https://minetest.gitlab.io/minetest/definition-tables/#node-definition), with the following fields modified by anchor mod:

* `on_rightclick`: To handle anchor edit formspec and unlock.
* `can_dig`: To disallow non-admins to dig the anchor.
* `on_construct`: To set up inital metadata of the node.
* `on_destruct`: To remove the anchor from the node database.
* `groups.anchor`: Always set to `1` to add all anchors to `group:anchor`.

## GUI Objects
Unless otherwise specified, all objects within `anchor.gui` are `[flow](https://content.minetest.net/packages/luk3yx/flow/).make_gui` returned values. Please refer to [README.md of that mod](https://gitlab.com/luk3yx/minetest-flow/-/blob/main/README.md) for full usage of the following objects.

### `anchor.gui.setup`
The formspec used to set up new anchors. When calling `:show(player,ctx)`, `ctx` should be a table with a field `pos` containing the coordinate of the target anchor.

### `anchor.gui.modify`
The formspec used to modify existing anchors. When calling `:show(player,ctx)`, `ctx` should be a table with a field `pos` containing the coordinate of the target anchor.

### `anchor.gui.list`
The formspec used to list anchors a player unlocked.

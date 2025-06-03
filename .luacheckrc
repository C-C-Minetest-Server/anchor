read_globals = {
    "DIR_DELIM", "INIT",

    "core",
    "dump", "dump2",

    "Raycast",
    "Settings",
    "PseudoRandom",
    "PerlinNoise",
    "VoxelManip",
    "SecureRandom",
    "VoxelArea",
    "PerlinNoiseMap",
    "PcgRandom",
    "ItemStack",
    "AreaStore",

    "vector",

    "flow",

    table = {
        fields = {
            "copy",
            "indexof",
            "insert_all",
            "key_value_swap",
            "shuffle",
        }
    },

    string = {
        fields = {
            "split",
            "trim",
        }
    },

    math = {
        fields = {
            "hypot",
            "sign",
            "factorial"
        }
    },
}

files["anchor_core"] = {
    globals = {
        "anchor",
    }
}

files["anchor_basicanchor"] = {
    read_globals = {
        "anchor",
        "default",
    }
}

ignore = {
    "212",
}
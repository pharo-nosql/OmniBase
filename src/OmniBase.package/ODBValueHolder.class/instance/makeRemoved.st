public/unclassified
makeRemoved
        "Mark valueHolder as removed."

    contents at: 8 put: ((contents at: 8) bitOr: 128)
load/store
loadPreviousVersionFrom: oldHolders
        "Load previous version holder from oldHolders."

    oldVersion := true.
    oldHolders loadAt: self previousVersionPosition for: contents
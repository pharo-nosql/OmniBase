private/searching
loadCurrentKey
        "Private - Load current key from file when it is going to be updated."

    currentKey := nextKey.
    currentKeyExists := false.
    self clearSearchPath; searchCurrentKeyFrom: rootPagePosition
public/iterator interface
getNext
        "Move to the next key and answer association."

    self updateCurrentKey.
    ^self searchNextAssociation
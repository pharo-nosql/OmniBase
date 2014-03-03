public/iterator interface
getPrevious
        "Move to the previous key and answer association."

    self updateCurrentKey.
    ^self searchPreviousAssociation
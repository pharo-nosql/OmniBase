public/unclassified
rightNext
        "Answer rightmost pointer to next page and set 
        indexOnPage to numberOfItems."

    indexOnPage := self numberOfItems.
    ^self nextAt: indexOnPage
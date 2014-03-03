public
containers
        "Answer collection of all containers in database."

    | coll |
    coll := OrderedCollection new.
    idTable indexesAndValuesDo: [:i :pos | coll add: (self containerAt: i)].
    ^coll
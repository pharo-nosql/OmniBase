private/unclassified
collectChangeClassIDsFrom: rootClass to: aDictionary
        "Private - Collect all change classIDs and store them to aDictionary."

    rootClass changeClassID notNil
        ifTrue: [aDictionary at: rootClass changeClassID put: rootClass].
    rootClass subclasses do: [:each | self collectChangeClassIDsFrom: each to: aDictionary]
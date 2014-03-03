private/unclassified
collectLockClassIDsFrom: rootClass to: aDictionary
                "Private - Collect all lock classIDs and store them to aDictionary."

        rootClass lockClassID notNil
                ifTrue: [aDictionary at: rootClass lockClassID put: rootClass].
        rootClass subclasses do: [:each | self collectLockClassIDsFrom: each to: aDictionary]
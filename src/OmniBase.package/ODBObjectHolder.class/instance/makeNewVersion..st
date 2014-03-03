load/store
makeNewVersion: oldHolders

        | position |
        self versionNumber = 0 "new object"
                ifTrue: [ position := 0]
                ifFalse: [ position := oldHolders store: contents ].
        ^(self class createOn: contents shallowCopy)
                setContainer: container objectID: objectID;
                previousVersionPosition: position
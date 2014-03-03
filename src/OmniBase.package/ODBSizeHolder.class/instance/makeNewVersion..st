public/unclassified
makeNewVersion: oldHolders
        "Store receiver to oldHolders and make new instance 
        of receiver class that points to receiver in oldHolders."

    | newVersion position |
    self versionNumber = 0
        ifTrue: [ position := 0 ]
        ifFalse: [ position := oldHolders store: contents ].
    newVersion := self class new.
    ^newVersion previousVersionPosition: position
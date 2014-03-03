private/unclassified
addClassInfo: aClassInfo
        "Private - Add class info to names dictionary."

    | id |
    id := aClassInfo classID.
    id > classes size
        ifTrue: [
            id - classes size timesRepeat: [ classes add: nil].
            classes at: id put: aClassInfo.
            self addToDict: aClassInfo]
        ifFalse: [
            (classes at: id) isNil ifTrue: [
                classes at: id put: aClassInfo.
                self addToDict: aClassInfo]]
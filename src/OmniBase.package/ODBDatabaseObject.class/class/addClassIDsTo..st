private
addClassIDsTo: aDictionary
        "Private - Add classID of each subclass of receiver 
        to aDictionary. Answer class ID maximum."

    | maxID |
    maxID := 0.
    self subclasses do: [:each |
        aDictionary at: each classID put: each.
        maxID := (each classID max: maxID) max: (each addClassIDsTo: aDictionary)].
    ^maxID
private/unclassified
numberOfItems: anInteger
        "Private - Set number of items on page."

    (contents at: 1) < 128
        ifTrue: [contents at: 1 put: anInteger]
        ifFalse: [contents at: 1 put: anInteger + 128]
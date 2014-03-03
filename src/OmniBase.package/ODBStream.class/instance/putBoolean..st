public
putBoolean: aBool

    self putByte: (aBool ifTrue: [ 1] ifFalse: [0])
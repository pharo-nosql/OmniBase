public
putWord: anInteger

    self putByte: (anInteger bitAnd: 255); putByte: (anInteger bitShift: -8)
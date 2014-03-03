public
putLong: anInteger

    self putWord: (anInteger bitAnd: 65535); putWord: (anInteger bitShift: -16)
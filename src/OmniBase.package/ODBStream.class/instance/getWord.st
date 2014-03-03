public
getWord

    ^self getByte bitOr: (self getByte bitShift: 8)
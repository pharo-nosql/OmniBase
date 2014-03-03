accessing
objectLength

    ^((contents at: 10) bitOr: ((contents at: 11) bitShift: 8)) bitOr: ((contents at: 12) bitShift: 16)
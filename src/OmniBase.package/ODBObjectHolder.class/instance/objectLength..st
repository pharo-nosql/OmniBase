accessing
objectLength: anInteger

    contents
        at: 10 put: (anInteger bitAnd: 255);
        at: 11 put: ((anInteger bitShift: -8) bitAnd: 255);
        at: 12 put: (anInteger bitShift: -16)
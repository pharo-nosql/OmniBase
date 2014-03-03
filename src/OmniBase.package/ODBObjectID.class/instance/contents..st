public/accessing
contents: aByteArray
        "Initialize receiver from aByteArray."

    containerID := aByteArray at: 4.
    index := ((aByteArray at: 3) bitShift: 16) + ((aByteArray at: 2) bitShift: 8) + (aByteArray at: 1)
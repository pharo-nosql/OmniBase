public/accessing
fromBytes: aByteArray at: pos
        "Initialize receiver from aByteArray at pos."

    containerID := aByteArray at: pos + 3.
    index := ((aByteArray at: pos + 2) bitShift: 16) +
                ((aByteArray at: pos + 1) bitShift: 8) +
                (aByteArray at: pos)
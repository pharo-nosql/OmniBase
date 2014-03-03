private/unclassified
shiftPageLeft: count
        "Private - Shift page to left count times. 
        Used for splitting pages."

    | nextOffset |
    indexOnPage := indexOnPage - count.
    nextOffset := self pageSize * itemLength + 1.
    self bytesAtOffset: 1
        put: (contents copyFrom: itemLength * count + 2 to: nextOffset).
    self bytesAtOffset: nextOffset
        put: (contents copyFrom: count * 4 + nextOffset + 1 to: contents size)
public/unclassified
association

    | offset |
    offset := itemLength * indexOnPage + 2.
    ^Association
        key: (contents copyFrom: offset to: offset + keyLength - 1)
        value: (contents copyFrom: offset + keyLength to: offset + keyLength + valueLength - 1)
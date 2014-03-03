private/searching
isCurrentKeySet
        "Private - Answer <true> if currentKey is the same as the next key."

    nextKey == currentKey ifTrue: [^true].
    1 to: keyLength do: [:i | (currentKey at: i) == (nextKey at: i) ifFalse: [^false]].
    ^true
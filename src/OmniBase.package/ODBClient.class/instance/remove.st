public/unclassified
remove
        "Remove client from database."

    | cf |
    clientFile isNil ifFalse: [
        clientManager removePending: id.
        self transactions copy do: [:t | t abort].
        cf := clientFile.
        clientFile := nil.
        cf remove ifTrue: [clientManager removed: id]]
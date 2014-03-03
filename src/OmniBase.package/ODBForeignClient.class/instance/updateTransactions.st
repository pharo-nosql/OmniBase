private/unclassified
updateTransactions
        "Private - Update transactions from transaction files."

"   | vn res coll |
    coll := OrderedCollection new.
    clientFile transactions do: [:each |
        vn := each versionNumber.
        res := transactions detect: [:t | t versionNumber = vn ] ifNone: [
            res := ODForeignTransaction new client: self.
            res transactionFile: each.
            res
        ].
        coll add: res.
    ].
    transactions := coll.
"
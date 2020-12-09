Class {
	#name : #ODBForeignClient,
	#superclass : #ODBClient,
	#category : 'OmniBase'
}

{ #category : #'public/accessing' }
ODBForeignClient >> isForeign [

    ^true
]

{ #category : #'public/create/open/close' }
ODBForeignClient >> openOn: aClientManager clientID: clientID [

    | fName |
    id := clientID.
    clientManager := aClientManager.
    fName := clientManager clientFileName: id.
    [ clientFile := ODBClientFile new openReadOnlyOn: fName ]
        on: Error do: [ :er | ^nil ].
    clientManager addOpenedClient: self
]

{ #category : #public }
ODBForeignClient >> remove [
	"Remove client from database. 
	Close files only, because client may be still active."

	clientFile isNil 
		ifFalse: 
			[self transactions copy do: [:each | each abort].
			clientFile close.
			clientFile := nil.
			clientManager removeForeignActiveClient: id]
]

{ #category : #'public/accessing' }
ODBForeignClient >> transactions [
        "Answer all R/W transactions started by receiver."

    self updateTransactions.
    ^transactions
]

{ #category : #'private/unclassified' }
ODBForeignClient >> updateTransactions [
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
]

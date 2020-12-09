Class {
	#name : #ODBClient,
	#superclass : #Object,
	#instVars : [
		'id',
		'clientFile',
		'transactions',
		'clientManager',
		'transactionFiles'
	],
	#category : 'OmniBase'
}

{ #category : #'instance creation' }
ODBClient class >> new [

    ^super new initialize
]

{ #category : #'public/accessing' }
ODBClient >> clientID [
        "Answer client ID."

    ^id
]

{ #category : #'public/accessing' }
ODBClient >> description [
        "Answer client description string."

    ^clientFile clientDescription
]

{ #category : #private }
ODBClient >> initialize [

    transactions := OrderedCollection new.
    transactionFiles := OrderedCollection new
]

{ #category : #'public/accessing' }
ODBClient >> isForeign [

    ^false
]

{ #category : #'public/accessing' }
ODBClient >> isTerminated [

    ^false
]

{ #category : #'public/unclassified' }
ODBClient >> remove [
        "Remove client from database."

    | cf |
    clientFile isNil ifFalse: [
        clientManager removePending: id.
        self transactions copy do: [:t | t abort].
        cf := clientFile.
        clientFile := nil.
        cf remove ifTrue: [clientManager removed: id]]
]

{ #category : #'private/unclassified' }
ODBClient >> transactionAdd: aTransaction [
        "Private - Add aTransaction to client."

    transactions add: aTransaction.
    aTransaction setClient: self environment: clientManager environment
]

{ #category : #'private/unclassified' }
ODBClient >> transactionRemove: aTransaction [
        "Private - Remove aTransaction."

    | trnFile trID |
    (trnFile := aTransaction transactionFile) == nil
        ifFalse: [
            trID := trnFile transactionID.
            trnFile remove
                ifTrue: [
                    transactionFiles remove: trID ifAbsent: [].
                    clientFile transactionIDs: transactionFiles.
                    transactionFiles isEmpty
                        ifTrue: [ clientManager removeLocksFor: id ]
                ]
        ].
    transactions remove: aTransaction ifAbsent: []
]

{ #category : #'public/accessing' }
ODBClient >> transactions [
        "Answer collection of R/W transactions started by client."

    ^transactions asArray
]

{ #category : #private }
ODBClient >> trnFileName: fileID [ 
	"Private - Answer transaction file name."

	^clientManager dirName , ODBFileStream pathSeparatorString , fileID printString , '.trn'
]

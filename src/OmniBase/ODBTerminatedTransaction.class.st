Class {
	#name : #ODBTerminatedTransaction,
	#superclass : #ODBTransaction,
	#category : #OmniBase
}

{ #category : #'public/start/commit/abort' }
ODBTerminatedTransaction >> start [
        "Start transaction. Transaction has been terminated 
        without being aborted in previous session."

    transactionManager transactionStart: self.
    versionDescriptor versionNumber: transactionFile versionNumber.

    transactionFile locks do: [ :each |
		dbConnection lockRegistry addLock: each ]
]

{ #category : #'private/accessing' }
ODBTerminatedTransaction >> transactionFile: aTransactionFile [

    transactionFile := aTransactionFile
]

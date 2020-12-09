Class {
	#name : #ODBClientManager,
	#superclass : #Object,
	#instVars : [
		'localClient',
		'environment',
		'idTable',
		'clients'
	],
	#category : 'OmniBase'
}

{ #category : #private }
ODBClientManager >> addOpenedClient: aClient [ 
	"Private - Add opened client to array of clients."

	(clients at: aClient clientID) isNil 
		ifFalse: [OmniBase signalError: 'Client already exists'].
	clients at: aClient clientID put: aClient
]

{ #category : #public }
ODBClientManager >> clientAt: clientID [ 
	"Answer client object for clientID or <nil> if none."

	| client |
	client := clients at: clientID.
	client isNil 
		ifTrue: 
			[client := ODBTerminatedClient new openOn: self clientID: clientID.
			client isNil 
				ifTrue: 
					[client := ODBForeignClient new openOn: self clientID: clientID.
					client isNil 
						ifTrue: 
							[(ODBFileStream exists: (self clientFileName: clientID)) 
								ifFalse: 
									[self
										removePending: clientID;
										removed: clientID]]]].
	^client
]

{ #category : #private }
ODBClientManager >> clientFileName: clientID [ 
	"Private - Answer client file name for clientID."

	^self dirName , ODBFileStream pathSeparatorString , clientID printString , '.usr'
]

{ #category : #public }
ODBClientManager >> clients [
	"Answer collection of all clients currently connected to database."

	| client coll |
	coll := OrderedCollection new.
	idTable 
		onClientIDsDo: [:clientID | (client := self clientAt: clientID) == nil ifFalse: [coll add: client]].
	^coll
]

{ #category : #'public/create/open/close' }
ODBClientManager >> close [

    clients isNil
        ifFalse: [
            clients do: [:each | each == nil ifFalse: [ each remove ]].
            clients := nil ].
    idTable isNil
        ifFalse: [
            idTable close.
            idTable := nil ]
]

{ #category : #public }
ODBClientManager >> closeForeignClients [
	"Close cached foreign clients."

	clients do: [:each | (each notNil and: [each isForeign]) ifTrue: [each remove]]
]

{ #category : #'public/create/open/close' }
ODBClientManager >> createOn: anEnvironment [
        "Create new user manager."

    environment := anEnvironment.
    [   idTable := ODBClientTable createOn: self idFileName.
        self opened
    ] ifCurtailed: [ self close ]
]

{ #category : #private }
ODBClientManager >> dirName [
	"Private - Answer directory where user files are placed."

	^environment dirName , ODBFileStream pathSeparatorString , 'Users'
]

{ #category : #'public/accessing' }
ODBClientManager >> environment [

    ^environment
]

{ #category : #'private/unclassified' }
ODBClientManager >> globalUnlock [
                "Private - Remove global lock."

        idTable globalUnlock
]

{ #category : #private }
ODBClientManager >> idFileName [
	"Private - Answer name of file where client statuses are stored."

	^environment dirName , ODBFileStream pathSeparatorString , 'omnibase.usr'
]

{ #category : #'public/unclassified' }
ODBClientManager >> localClient [
        "Answer local client."

    localClient == nil
        ifFalse: [ ^localClient ]
        ifTrue: [ ^localClient := self newClient ]
]

{ #category : #public }
ODBClientManager >> newClient [
	"Answer new local client."

	| newClient |
	idTable 
		onNewClientIDDo: [:newID | newClient := ODBLocalClient new createOn: self clientID: newID].
	newClient isNil ifTrue: [OmniBase signalError: 'Maximum number of clients reached'].
	^newClient
]

{ #category : #'public/create/open/close' }
ODBClientManager >> openOn: anOmniBase [

	environment := anOmniBase.
	[	idTable := ODBClientTable openOn: self idFileName.
		self opened
	] ifCurtailed: [ self close ]
]

{ #category : #private }
ODBClientManager >> opened [
	"Private - Receiver has just been opened."

	clients := Array new: ODBClientTable maxClients.
	"ensure that directory exists in case the database was unzipped
	(WinZIP does not zip and later create empty directories)."
	(ODBFileStream directoryExists: self dirName) 
		ifFalse: [ODBFileStream directoryCreate: self dirName]
]

{ #category : #public }
ODBClientManager >> removeDisconnectedClients [
	"Remove all disconnected clients."

	self clients do: 
			[:client | 
			(client isTerminated or: [idTable isBeingRemoved: client clientID]) 
				ifTrue: [client remove]]
]

{ #category : #'private/unclassified' }
ODBClientManager >> removeForeignActiveClient: clientID [
                "Private - Foreign active client has been closed."

        clients at: clientID put: nil
]

{ #category : #'private/unclassified' }
ODBClientManager >> removeLocksFor: clientID [
                "Private - Client has no RW transactions anymore."

        ^idTable activateClientID: clientID
]

{ #category : #'private/unclassified' }
ODBClientManager >> removePending: clientID [
                "Private - Client is about to be removed."

        (localClient notNil and: [localClient clientID == clientID]) ifTrue: [localClient := nil].
        clients at: clientID put: nil.
        idTable removingClientID: clientID
]

{ #category : #'private/unclassified' }
ODBClientManager >> removed: clientID [
                "Private - Client has been completely removed."

        idTable removeClientID: clientID
]

{ #category : #'private/unclassified' }
ODBClientManager >> requestLocksFor: clientID [
                "Private - Client wants to set locks. Answer <true> if OK."

        ^idTable requestLockForClientID: clientID
]

{ #category : #'private/unclassified' }
ODBClientManager >> setGlobalLockFor: clientID [
                "Private - Client wants to set global lock. Answer <true> if OK."

        ^idTable setGlobalLockFor: clientID
]

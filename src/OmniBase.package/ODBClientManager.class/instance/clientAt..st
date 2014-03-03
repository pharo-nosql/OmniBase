public
clientAt: clientID 
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
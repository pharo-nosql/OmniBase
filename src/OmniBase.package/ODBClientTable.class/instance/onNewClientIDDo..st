public
onNewClientIDDo: aBlock 
	"Evaluate aBlock with new clientID.
	aBlock will not be evaluated if no clientID is avaiable."

	self lockTable.
	
	[self loadTable.
	1 to: self class maxClients
		do: 
			[:i | 
			(self clientTableAt: i) == 0 
				ifTrue: 
					[self clientTableAt: i put: 2.
					stream flush.
					aBlock value: i.
					self clientTableAt: i put: 1.
					^self]]] 
			ensure: [self unlockTable]
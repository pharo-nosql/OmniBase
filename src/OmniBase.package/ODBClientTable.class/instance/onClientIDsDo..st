public
onClientIDsDo: aBlock 
	"Evaluate aBlock on every active or disconnected clientID."

	self loadTable.
	1 to: self class maxClients
		do: [:i | (self clientTableAt: i) == 0 ifFalse: [aBlock value: i]]
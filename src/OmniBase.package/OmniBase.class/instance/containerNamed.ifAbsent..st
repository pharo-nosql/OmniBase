public
containerNamed: aName ifAbsent: aBlock
	"Answers the container the receiver locates 
	at aName or executes aBlock if not found."

	^ objectManager containerNamed: aName ifAbsent: aBlock 
public
containerAt: containerID ifAbsent: aBlock 
	"Answer container at containerID. Evaluate aBlock if absent."

	| cont pos |
	containerID < 1 ifTrue: [^aBlock value].
	containerID > containers size 
		ifFalse: [(cont := containers at: containerID) isNil ifFalse: [^cont]].
	pos := idTable at: containerID ifAbsent: [^aBlock value].
	pos == 0 ifTrue: [^aBlock value].
	^self initContainerAt: pos
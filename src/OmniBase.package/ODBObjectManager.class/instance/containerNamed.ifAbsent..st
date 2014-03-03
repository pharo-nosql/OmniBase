public
containerNamed: containerName ifAbsent: aBlock 
	"Answer container with containerName. 
        Evaluate aBlock, if container is not found."

	| name pos |
	name := self unifyContainerName: containerName.
	containers do: [:each | (each isNil or: [each name ~= name]) ifFalse: [^each]].
	pos := infoFile at: name ifAbsent: [^aBlock value].
	pos == 0 ifTrue: [^aBlock value].
	^self initContainerAt: pos
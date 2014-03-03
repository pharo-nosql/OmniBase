public
defaultContainer
	"Answer default container."

	| cont |
	^(cont := containers at: 1) isNil 
		ifFalse: [cont]
		ifTrue: [self initContainerAt: (idTable at: 1)]
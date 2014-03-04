*omnibasePatch
odbLoadVariables: deserializer classInfo: classInfo

	| stream order iSize object basicSize varArray |
	stream := deserializer stream.
	classInfo isVariable
		ifTrue: [ object := self basicNew: (basicSize := stream getPositiveInteger) ]
		ifFalse: [
			basicSize := 0.
			object := self basicNew.
		].
	deserializer register: object.
	classInfo isBytes ifTrue: [
		classInfo realClass isWords 
			ifTrue: [1 to: basicSize do: [:i | object basicAt: i put: stream getInteger]]
			ifFalse: [stream getBytesFor: object len: basicSize].
		^object
	].
	varArray := Array new: (iSize := classInfo realInstSize) + 1.
	order := classInfo variableOrder.
	1 to: classInfo instSize do: [:i | varArray at: (order at: i) put: deserializer odbNextObject ].
	1 to: iSize do: [:i | object instVarAt: i put: (varArray at: i) ].
	iSize + 1 to: iSize + basicSize do: [:i | object instVarAt: i put: deserializer odbNextObject ].
	^object odbDeserialized: deserializer
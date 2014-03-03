*omnibase
odbBasicSerialize: serializer

	| stream classInfo instSize |
	classInfo := serializer registerClass: self class.
	stream := serializer stream.
	classInfo isVariable ifTrue: [ stream putPositiveInteger: self basicSize ].
	classInfo isBytes ifFalse: [
		classInfo instVarIndexes do: [:i | (self instVarAt: i) odbSerialize: serializer ].
		instSize := self class instSize.
		instSize + 1 to: instSize + self basicSize do: [:i | 
			(self instVarAt: i) odbSerialize: serializer ].
		^self].
	"variable - need to check whether we have bytes or words"
	self class isWords
		ifFalse: [ stream putBytesFrom: self len: self basicSize ]
		ifTrue: [1 to: self basicSize do: [:i | stream putInteger: (self basicAt: i)]].
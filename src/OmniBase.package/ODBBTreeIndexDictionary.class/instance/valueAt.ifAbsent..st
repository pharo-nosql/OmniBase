private
valueAt: aKey ifAbsent: aBlock 
	"Private - Answer correct version of value holder at aKey, evaluate aBlock if absent."

	| value |
	changed isNil 
		ifFalse: 
			[value := changed at: aKey.
			value isNil ifFalse: [^value]].
	dataBaseObject isNil ifTrue: [^aBlock value].
	(value := dataBaseObject iterator goToAndGetCurrentAt: aKey) isNil 
		ifTrue: [^aBlock value].
	value := ODBValueHolder createOn: value value.
	[transaction versionDescriptor versionOK: value versionNumber] 
		whileFalse: [value loadPreviousVersionFrom: transaction oldHolders].
	^value
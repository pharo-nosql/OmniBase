Class {
	#name : #ODBWeakValueIdentityDictionary,
	#superclass : #ODBIdentityDictionary,
	#category : 'OmniBase'
}

{ #category : #public }
ODBWeakValueIdentityDictionary >> at: anObject [
		"Answer value at anObject, <nil> if absent."

	| index lastIndex key value |
	lastIndex := keys size.
	index := anObject identityHash \\ lastIndex.
	[ anObject == (key := keys at: (index := index + 1)) ]
		whileFalse: [
			key == nil ifTrue: [ ^nil ].
			index == lastIndex ifTrue: [ index := 0 ]].
	(value := values at: index) == 0 ifFalse: [ ^value ].
	^nil
]

{ #category : #public }
ODBWeakValueIdentityDictionary >> at: anObject ifAbsent: aBlock [

	| index lastIndex key value |
	lastIndex := keys size.
	index := anObject identityHash \\ lastIndex.
	[ anObject == (key := keys at: (index := index + 1)) ]
		whileFalse: [
			key == nil ifTrue: [ ^aBlock value ].
			index == lastIndex ifTrue: [ index := 0 ]].
	(value := values at: index) == 0 ifFalse: [ ^value ].
	^aBlock value
]

{ #category : #public }
ODBWeakValueIdentityDictionary >> at: aKey put: anObject [
		"Answer anObject. If aKey exists in the receiver,
		replace the corresponding value with anObject, else
		add the aKey/anObject pair to the receiver."

	| index lastIndex key |
	lastIndex := keys size.
	index := aKey identityHash \\ lastIndex.
	[ aKey == (key := keys at: (index := index + 1)) ]
		whileFalse: [
			key == nil ifTrue: [
				keys at: index put: aKey.
				values at: index put: anObject.
				(elementCount := elementCount + 1) >= sizeLimit ifTrue: [ self grow ].
				^anObject ].
			(values at: index) == 0
				ifTrue: [
					keys at: index put: aKey.
					^values at: index put: anObject ].
			index == lastIndex ifTrue: [ index := 0 ]].
	^values at: index put: anObject
]

{ #category : #public }
ODBWeakValueIdentityDictionary >> do: aBlock [
		"Evaluate aBlock for each value in dictionary."

	| value key |
	1 to: keys size do: [:i |
		key := keys at: i.
		(key == nil or: [(value := values at: i) == 0])
			ifFalse: [ aBlock value: value ]]
]

{ #category : #private }
ODBWeakValueIdentityDictionary >> initialize: anInteger [

	elementCount := 0.
	keys := Array new: anInteger.
	values := WeakArray new: anInteger.
	sizeLimit := anInteger - 2 * 11 // 23
]

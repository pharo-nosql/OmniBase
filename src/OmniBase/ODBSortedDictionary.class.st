Class {
	#name : #ODBSortedDictionary,
	#superclass : #Object,
	#instVars : [
		'keys',
		'values',
		'elementCount',
		'currentIndex'
	],
	#category : 'OmniBase'
}

{ #category : #'as yet unclassified' }
ODBSortedDictionary class >> new [

    ^super new initialize
]

{ #category : #public }
ODBSortedDictionary >> at: aKey [ 
	| index |
	(index := self findKey: aKey) > 0 ifTrue: [^values at: index].
	^nil
]

{ #category : #'public/unclassified' }
ODBSortedDictionary >> at: aKey put: value [ 
	| index |
	(index := self findKey: aKey) > 0
		ifTrue: [^ values at: index put: value].
	index := 0 - index.
	elementCount = keys size
		ifTrue: [
			keys := (Array new: elementCount * 2)
						replaceFrom: 1
						to: elementCount
						with: keys
						startingAt: 1.
			values := (Array new: elementCount * 2)
						replaceFrom: 1
						to: elementCount
						with: values
						startingAt: 1].
	elementCount := elementCount + 1.
	"avoid primitive here, it seems Squeak's #replaceFrom:... doesn't handle  
	overlaps."
	elementCount to: index + 1 by: -1 do: [:i | 
		keys at: i put: (keys at: i - 1).
		values at: i put: (values at: i - 1)].
	"keys replaceFrom: index + 1 to: elementCount with: keys startingAt:  
	index. values replaceFrom: index + 1 to: elementCount with: values  
	startingAt: index."
	keys at: index put: aKey.
	^ values at: index put: value
]

{ #category : #public }
ODBSortedDictionary >> do: aBlock [ 
	1 to: elementCount do: [:i | aBlock value: (values at: i)]
]

{ #category : #private }
ODBSortedDictionary >> findKey: aKey [ 
	"Private - Answer index of aKey. If aKey does not 
        exist answer its index as negative integer."

	| a b key i |
	elementCount == 0 ifTrue: [^-1].
	a := 1.
	b := elementCount + 1.
	
	[key := keys at: (i := (a + b) // 2).
	(aKey odbIsLessOrEqualTo: key) 
		ifTrue: 
			[key = aKey ifTrue: [^i].
			b := i]
		ifFalse: [a := i + 1].
	a == b] 
			whileFalse: [].
	^0 - a
]

{ #category : #public }
ODBSortedDictionary >> getCurrent [
	currentIndex < 1 ifTrue: [^nil].
	^ODBBTreeDictionaryAssociation new setKey: (keys at: currentIndex)
		value: (values at: currentIndex)
]

{ #category : #'public/iterator' }
ODBSortedDictionary >> getFirst [

    currentIndex := 1.
    ^ODBBTreeDictionaryAssociation new setKey: (keys at: 1) value: (values at: 1)
]

{ #category : #'public/iterator' }
ODBSortedDictionary >> getLast [

    currentIndex := elementCount.
    ^ODBBTreeDictionaryAssociation new
        setKey: (keys at: currentIndex) value: (values at: currentIndex)
]

{ #category : #'public/iterator' }
ODBSortedDictionary >> goTo: aKey [

    currentIndex := self findKey: aKey
]

{ #category : #public }
ODBSortedDictionary >> goToNext [
	currentIndex := (currentIndex < 1 ifTrue: [0 - currentIndex] ifFalse: [currentIndex + 1]) 
				min: elementCount
]

{ #category : #public }
ODBSortedDictionary >> goToPrevious [
	currentIndex := currentIndex abs - 1 max: 1
]

{ #category : #'public/unclassified' }
ODBSortedDictionary >> includes: aKey [

    ^(self findKey: aKey) > 0
]

{ #category : #'private/initialization' }
ODBSortedDictionary >> initialize [

    keys := Array new: 128.
    values := Array new: 128.
    elementCount := 0
]

{ #category : #public }
ODBSortedDictionary >> keysAndValuesDo: aBlock [ 
	1 to: elementCount do: [:i | aBlock value: (keys at: i) value: (values at: i)]
]

{ #category : #public }
ODBSortedDictionary >> peekNext [
	| i |
	currentIndex < 1 ifTrue: [i := 0 - currentIndex] ifFalse: [i := currentIndex + 1].
	i > elementCount ifTrue: [^nil].
	^ODBBTreeDictionaryAssociation new setKey: (keys at: i) value: (values at: i)
]

{ #category : #public }
ODBSortedDictionary >> peekPrevious [
	| i |
	i := currentIndex abs - 1.
	i < 1 ifTrue: [^nil].
	^ODBBTreeDictionaryAssociation new setKey: (keys at: i) value: (values at: i)
]

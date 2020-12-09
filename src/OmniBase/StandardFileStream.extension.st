Extension { #name : #StandardFileStream }

{ #category : #'*omnibase' }
StandardFileStream >> lock: aBoolean for: length [
	self odbToDo.
	^true
]

{ #category : #'*omnibase' }
StandardFileStream >> readInto: aString startingAt: startIndex for: n [
	"Read n bytes into the given string."
	^self primRead: fileID into: aString
				startingAt: startIndex count: n.
]

{ #category : #'*omnibase' }
StandardFileStream >> writeFrom: aString startingAt: startIndex for: anInteger [
	"Store the next anInteger elements from the given collection."
	rwmode ifFalse: [^ self error: 'Cannot write a read-only file'].
	^self primWrite: fileID from: aString startingAt: startIndex count: anInteger
]

public
addReference: aReference 
	references isNil ifTrue: [references := OrderedCollection new].
	references add: aReference.
	^references size
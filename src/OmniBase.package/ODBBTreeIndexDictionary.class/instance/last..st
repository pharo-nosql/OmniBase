accessing
last: anInteger

	| assoc result |
	
	result := OrderedCollection new.

	self basicGoTo: ((ByteArray new: keySize) atAllPut: 255).
	(assoc := self getCurrent) isNil ifTrue: [
		assoc := self getPrevious].

	assoc isNil ifTrue:[^#()].
	result add: assoc value.
	
	1 to: (anInteger -1) do:[:i| |current|
		current := self getPrevious.
		current isNil ifTrue: [^result].
		result add: current value].
	
	^ result
*omnibaseExtensions
first: anInteger

	| assoc result |
	
	result := OrderedCollection new.
	self basicGoTo: (ByteArray new: keySize).
	assoc := self getNext.
	assoc isNil ifTrue:[^#()].
	result add: assoc value.
	
	1 to: (anInteger -1) do:[:i| |current|
		current := self getNext.
		current isNil ifTrue: [^result].
		result add: current value].
	
	^ result
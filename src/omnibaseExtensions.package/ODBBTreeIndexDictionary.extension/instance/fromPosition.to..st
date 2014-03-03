*omnibaseExtensions
fromPosition: start to: end
	"Returns occurrences from start to end."
	
	"Better implementations of this are very welcome :)"

	| assoc result cursor startKey endKey current |
	result := OrderedCollection new..
	startKey := self bytesFromKey: start.
	endKey := self bytesFromKey: end.
	self basicGoTo: startKey.
	assoc := self getCurrent.
	assoc ifNil:[^ result].

	[currentKey asInteger <= endKey asInteger] whileTrue:[
		assoc ifNotNil:[
			result add: assoc value].
		current := self getNext.
		current isNil ifTrue: [^result]].
	
	^ result
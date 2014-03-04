accessing
oldFromPosition: start to: end
	"Returns occurrences from start to end."
	
	"Better implementations of this are very welcome :)"

	| assoc result cursor |

	result := OrderedCollection new.
	self basicGoTo: (ByteArray new: keySize).
	assoc := self getFirst.

	start = 1 ifTrue:[
		result add: assoc value].
	
	"jump to the position"
	cursor := 1.
	[cursor = start] whileFalse:[
		assoc := self getNext.
		cursor := cursor + 1.
		cursor = start ifTrue:[
			result add: assoc value]].

	"collect from start to end"
	start to: end do:[:i| |current|
		current := self getNext.
		current isNil ifTrue: [^result].
		result add: current value].
	
	^ result
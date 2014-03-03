*omnibaseExtensions
from: start to: end
	"Returns occurrences from start to end."

	| assoc result cursor startKey endKey current |
	result := OrderedCollection new..
	startKey := self bytesFromKey: start.
	endKey := self bytesFromKey: end.
	self basicGoTo: startKey.
	assoc := self getCurrent.

	[currentKey asInteger <= endKey asInteger] whileTrue:[
		assoc ifNotNil:[
			result add: assoc value].
		current := self getNext].
	
	^ result
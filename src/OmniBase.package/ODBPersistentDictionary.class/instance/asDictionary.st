public
asDictionary
	| dict |
	dict := Dictionary new.
	self associationsDo: [:assoc | dict add: assoc].
	^dict
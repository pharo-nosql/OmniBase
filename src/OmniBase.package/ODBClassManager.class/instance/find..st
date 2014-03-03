private
find: aClass 
	"Private - Answer class description for aClass or <nil> if none.
	Uses #createdFor: to check if class description corresponds to aClass."

	| coll |
	(coll := names at: aClass) isNil ifTrue: [^nil].
	coll class == OrderedCollection ifFalse: [^(coll createdFor: aClass) ifTrue: [coll]].
	coll reverseDo: [:classInfo | (classInfo createdFor: aClass) ifTrue: [^classInfo]].
	^nil
private
addToDict: aClassInfo 
	"Private - Add class info to names dictionary."

	| coll |
	(coll := names at: aClassInfo realClass) isNil 
		ifTrue: [^names at: aClassInfo realClass put: aClassInfo].
	coll class == OrderedCollection ifTrue: [^coll add: aClassInfo].
	names at: aClassInfo realClass put: (OrderedCollection with: coll with: aClassInfo)
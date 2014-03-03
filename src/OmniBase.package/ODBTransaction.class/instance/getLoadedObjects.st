public
getLoadedObjects
	"Answer collection of associations of all objects loaded in current transaction."

	| coll |
	coll := OrderedCollection new.
	objectIndex do: [:each | each objectID containerID > 0 ifTrue: [coll add: each value]].
	^coll
public
objectHoldersDo: aBlock 
	| objectHolder |
	indexFile indexesAndValuesDo: 
			[:index :value | 
			objectHolder := (ODBObjectHolder createOn: value) setContainer: self
						objectID: (ODBObjectID containerID: id index: index).
			aBlock value: objectHolder]
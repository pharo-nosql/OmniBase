private
loadFromStream: stream 
	| n classDescription |
	n := stream getPositiveInteger.
	n > 10000 ifTrue: [self error: '[Deserializer] Number of classes is too big'].
	idToClassDescription := OrderedCollection new.
	1 to: n
		do: 
			[:i | 
			classDescription := ODBSerializer classDescriptionFrom: stream.
			classDescription classID: i.
			idToClassDescription add: classDescription]
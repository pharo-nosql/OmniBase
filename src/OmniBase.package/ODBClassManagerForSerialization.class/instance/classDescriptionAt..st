public
classDescriptionAt: anInteger 
	^idToClassDescription at: anInteger
		ifAbsent: [self error: '[Deserializer] Class description not found']
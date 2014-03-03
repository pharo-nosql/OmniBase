public
register: aClass 
	| classDescription |
	^classesToDescription at: aClass
		ifAbsentPut: 
			[classDescription := ODBSerializer classDescriptionFor: aClass.
			idToClassDescription add: classDescription.
			classDescription classID: idToClassDescription size.
			classDescription]
private
copyClassManager
	| lastClassId classDescription |
	self progressNotification: 'Copying class meta information' value: 0.
	lastClassId := db classManager lastClassId.
	1 to: lastClassId
		do: 
			[:i | 
			classDescription := nil.
			[classDescription := db classManager classDescriptionAt: i] on: Error do: [:ex | ].
			newDb classManager addClassDescription: classDescription withId: i.
			self progressNotification: nil value: i / lastClassId]
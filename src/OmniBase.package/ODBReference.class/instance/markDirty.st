accessing
markDirty
	self odbNotLoaded ifFalse: [self odbGetTransaction markDirty: self odbResolve]
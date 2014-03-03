running
tearDown
	self dir asFileReference exists ifTrue: [
		self dir asFileReference deleteAll]
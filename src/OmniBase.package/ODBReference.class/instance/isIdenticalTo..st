accessing
isIdenticalTo: anObject 
	"Answer true if anObject is identical to receiver. This is necessary since with database
	proxies the real object identity is lost because while the object is not yet loaded from the
	database it is represented by its proxy. Later when the real object is loaded this proxy still
	represents the identical object but the #== identity check will answer false because it is not
	aware of this. It is implemented in this way because the #== method is inlined and can not
	be overridden."

	anObject isODBReference ifTrue: [^self odbObjectID = anObject odbObjectID].
	(anObject isNil or: [self odbNotLoaded]) ifTrue: [^false].
	^self odbTransactionObject value == anObject
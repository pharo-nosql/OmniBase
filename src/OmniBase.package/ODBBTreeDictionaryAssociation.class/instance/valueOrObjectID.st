public
valueOrObjectID
	| obj |
	(obj := valueHolder object) isNil ifFalse: [^obj].
	^valueHolder objectID
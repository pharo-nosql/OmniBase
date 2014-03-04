private
copyObjects
	"Private - Copy objects from oldObject space to new object space."

	| set objectSpace |
	gcFile status = 5 ifFalse: [^self].
	objectSpace := objectManager defaultObjectSpace.
	containers do: 
			[:container | 
			[set := ODBIntegerSet openOn: (self oidSetFilenameFor: container)] on: Error do: [set := nil].
			set isNil 
				ifFalse: 
					[self compactObjectSpaceForContainer: container reachableObjectsSet: set.
					set remove.
					container removeObjectSpace: 1 - objectSpace]].
	gcFile status: 6
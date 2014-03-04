*omnibasePatch
checkDiskSpace: containersColl 
	"Private - Check for avaiable disk space and set total number of objects in wait dialog."

	| maxContainerSize n gcSpace |
	maxContainerSize := 0.
	gcSpace := 0.
	containersColl do: 
			[:container | 
			n := container numberOfObjects.
			gcSpace := n // 8 + gcSpace.
			maxContainerSize := container bytesAllocated max: maxContainerSize].
	maxContainerSize + gcSpace < objectManager environment freeDiskSpace ifTrue: [^true].
	^progressDialog isNil 
		ifTrue: [OmniBase logWarning: '[OmniBase GC] Warning disk space low']
		ifFalse: [OmniBase confirmationMessage: 'Disk space low.
Are you sure you want to continue ?']
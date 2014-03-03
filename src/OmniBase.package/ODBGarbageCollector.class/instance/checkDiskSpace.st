private
checkDiskSpace
	"Private - Check for avaiable disk space and set total number of objects in wait dialog."

	"       | totalObjects maxContainerSize n gcSpace |
        maxContainerSize := 0.
        gcSpace := 0.
        totalObjects := 0.
        containers do: [:container |
                n := container numberOfObjects.
                gcSpace := n // 8 + gcSpace.
                maxContainerSize := container bytesAllocated max: maxContainerSize.
                totalObjects := totalObjects + n
        ].
        waitDialog maxValue: totalObjects.
        maxContainerSize + gcSpace < objectManager environment freeDiskSpace ifTrue: [ ^true ].
        ^OmniBase confirmationMessage: 'Disk space low.
Are you sure you want to continue ?'!
"

	^true
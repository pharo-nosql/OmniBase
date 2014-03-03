public
garbageCollectOn: anODBGarbageCollector 
	objectHolder container 
		addByteStorageRequest: (ODBGarbageCollectorRequest new objectHolder: objectHolder
				bytes: objectHolder loadBytes)
Class {
	#name : #ODBStreamLockedNotification,
	#superclass : #Notification,
	#category : #'OmniBase-Exceptions'
}

{ #category : #public }
ODBStreamLockedNotification >> defaultAction [
	^OmniBase 
		confirmationMessage: 'File can not be read because it is locked. Do you want to try again ?'
]

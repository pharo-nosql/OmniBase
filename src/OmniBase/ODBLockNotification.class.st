Class {
	#name : #ODBLockNotification,
	#superclass : #Notification,
	#category : 'OmniBase'
}

{ #category : #public }
ODBLockNotification >> defaultAction [
	"Display a notifier and then continue."

	^OmniBase confirmationMessage: 'File can not be locked. Do you want to try again?'
]

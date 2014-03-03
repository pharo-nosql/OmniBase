*omnibaseExtensions
freshObjectAt: objectID 
	"Answers a recently read object fount at objectID, <nil> if it does not exist."

	| transactionObject |

	objects isNil ifTrue: [OmniBase signalError: 'Transaction was already aborted'].
	objectID containerID == 0 ifTrue: [^self transactionReferenceAt: objectID index].

	^ (transactionObject := self freshTransactionObjectAt: objectID) isNil ifFalse: [
		transactionObject value]
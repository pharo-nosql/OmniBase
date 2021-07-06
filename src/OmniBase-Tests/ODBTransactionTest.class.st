Class {
	#name : #ODBTransactionTest,
	#superclass : #ODBDiskBasedTest,
	#category : #'OmniBase-Tests'
}

{ #category : #tests }
ODBTransactionTest >> testTransactionPreservesState [
	| transaction  transaction2 accountA accountB balanceB oldBalanceA oldBalanceB |
	"populate accounts"
	[  OmniBase root at: 'Accounts'  put: (Dictionary new 
		at: 'A' put: (Account new balance: 100);
		at: 'B' put: (Account new balance: 200);
		yourself)] evaluateAndCommitIn: db newTransaction.
	
	"create transaction at a point in time before the modifying transaction"
	transaction := db newTransaction.
	"get account A balance"
	oldBalanceA := ((transaction root at: 'Accounts') at: 'A') balance.
	self assert: oldBalanceA equals: 100.
	oldBalanceB := ((transaction root at: 'Accounts') at: 'B') balance.
	self assert: oldBalanceB equals: 200.
	"start another transaction in parallel and make the transfer in transaction 2 "
	transaction2 := db newTransaction.
	accountA := (transaction2 root at: 'Accounts') at: 'A'.
	accountB := (transaction2 root at: 'Accounts') at: 'B'.
	accountA transfer: 1000 to: accountB.
	self assert: accountA balance equals: -900.
	self assert: accountB balance equals: 1200.
	transaction2 commit.
	
	"now get balance of account B" 
	balanceB := ((transaction root at: 'Accounts') at: 'B') balance.
	"should be still the old value as the transaction should snapshot data to the time 
	of transaction creation"
	self assert: balanceB equals: 200

]

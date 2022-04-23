OmniBase API Reference
======================

Block methods (aka BlockClosure)
--------------------------------

**evaluateAndCommitIn: anODBTransaction**

Evaluates the receiver block in the context of anODBTransaction.

Inside a block the active process current transaction will be anODBTransaction. Sending OmniBase currentTransaction will answer anODBTransaction. Using OmniBase class methods the developer can access the database without referencing transaction explicitly. After the block is evaluated the transaction is committed i.e. all changes are writtten into the database. If the receiver block is curtailed during its evaluation the transaction is automatically aborted and all locks are freed. Answer the result of evaluating the receiver block.

**evaluateIn: anODBTransaction**

Evaluates the receiver block in the context of anODBTransaction.

Inside a block the active process current transaction will be anODBTransaction. Sending OmniBase currentTransaction will answer anODBTransaction. Using OmniBase class methods (e.g. OmniBase root, OmniBase commit, ...) the developer can access the database without referencing transaction explicitly. After the block is evaluated the transaction is still active and has to be aborted or committed. If the receiver block is curtailed during its evaluation the transaction is automatically aborted and all locks are freed. Answer the result of evaluating the receiver block.

Object methods
--------------

**asBtreeKeyOfSize: keySize**

Subclass and implement this method for objects which can be used as a b-tree dictionary keys. Method should answer a ByteArray of size keySize. See also Object>>newBTreeDictionary: and class ODBBTreeDictionary.

**isIdenticalTo: anObject**

Use this method to check for object identify of persistent objects.

Referenced persistent objects are replaced by proxy objects upon load (instances of class ODBReference). Since the usual identity operator #== is implemented by a primitive comparing a proxy and a real object will answer even if they are indeed one and the same object.

**isODBReference**

Answer true if the receiver object is a proxy object (a proxy object only forwards messages to the real object), it also fetches the real object from the database upon first message send.

**makePersistent**

Make the receiver object persistent in the current transaction. The object will be stored into the default container. Do nothing if the receiver object is already persistent.

**markDirty**

Mark the receiver object as dirty. A new version of the object will be stored into the database upon transaction commit. Signal an error if the object is not already persistent.

**odbLoadedIn: anODBTransaction**

This method is sent to every persistent object when it is fetched from the database in anODBTransaction.

**odbMadePersistentIn: anODBTransaction**

This method is sent to the object when it has been made persistent in a transaction.

**odbSerialize: serializer**

Implement this method if application specific object serialization is needed. The basic serialization mechanism in OmniBase covers all the usual needs. Implementing a special serialization method is useful only for space and performance reasons (data compression, etc.). 

Object class side methods
-----

**newPersistent**

Answer a new instance of the receiver class and make it persistent at the same time.

Class methods
-------------

**odbTransientInstanceVariables**

Answer a collection of instance variable names which are transient.

Transient instance variables i.e. their contents will not be stored into the database upon commit. During the object serialization their contents will be ignored, upon load transient instance variable will have a value of nil. Define transient instance variables for file handles, view resources and similar objects that can not live outside a Smalltalk image. Application specific initialization of transient instance variables can be done at load time by implementing a method #odbLoadedIn:.

OmniBase class methods
----------------------

**allSessions**

Answer all opened database sessions i.e. instance of OmniBase.

**checkpoint**

Checkpoint current transaction. Current transaction must exist, if there is none an error will be thrown. Checkpointing transaction writes all changes to the database but does not abort the transaction, the transaction can still be used and all locks are left in place.

**closeAll**

Closes all opened database sessions in the image.

**commit**

Commits current transaction. Current transaction must exist, if there is none an error will be thrown. Committing transaction writes all changes to the database and aborts the transaction releasing all object locks and dictionary key locks. The transaction object can not be used anymore.

**createOn: aString**

Creates a new database on a directory aString e.g. `'c:\temp\MyDB'`.

It will create directory MyDB if it does not exist. If will throw an error if a database already exists in the given directory. Answer an instance of class OmniBase which is the opened database session.

**current**

Answer the database session of the current transaction. Thows an error if there is no current transaction.

**currentTransaction**

Answer database transaction in the current process or global context.

A transaction can be associated either with the active Smalltalk process or there is one global OmniBase transaction set. If the active process has a transaction associated it will answer the transaction of the active process even if there is a global transaction set. The use of a global transaction is discouraged and should be used only for testing purposes e.g. evaluating code in a workspace. See also Block loose methods for better understanding of the current transaction idea.

**newBTreeDictionary: keySize**

Answer an instance of ODBBTreeDictionary initialized to the key size of the given argument (meaning maximum key size). A b-tree dictionary is a persistent object which can be used to store large amounts of key-value pairs and can be simultaneuosly updated by multiple users each having impression as he is the only one working with the database. A key of the b-tree dictionary can be any object implementing a method #asBtreeKeyOfSize:. A value inside a b-tree dictionary can be any other persistent object or nil. Keys are sorted. Key size can be set only at creation time. If the value put into the dictionary has not been stored before - is not a persistent object - then it will be stored in the container in which the dictionary itself is stored.

**newBTreeIndexDictionary: keySize**

Answer an instance of ODBBTreeIndexDictionary initialized to the key size of the given argument. A b-tree index dictionary is a persistent object which can be used to index large amounts of key-value pairs and can be simultaneuosly updated by multiple users each having impression as he is the only one working with the database. A key of the b-tree index dictionary can be any object implementing a method #asBtreeKeyOfSize:. The difference between a b-tree dictionary and a b-tree index dictionary is that an index dictionary is used for secondary indices and its keys need not be unique. In an index dictionary key-value pairs are unique, but there can be many values sharing the same key.

**newPersistentDictionary**

Answer an instance of ODBPersistentDictionary which is a special kind of dictionary which automatically detects changes to itself (adding or removing association). It is a Smalltalk Dictionary in which all values are automatically made persistent and stored after they are put into a dictionary. Dictionary itself is not automatically stored in the database but has to be stored in some way before (either by putting it in another persistent dictionary or by explicitly storing it using the makePersistent: or store: method). The database root object is also a persistent dictionary (created by default). A persistent dictionary can not be updated by multiple users at the same time as a new version of the object is always stored into the database on each change.

**objectAt: anODBObjectID**

Answer a persistent object with id anODBObjectID. The object is loaded in the current transaction. Throws an error if there is no current transaction. Answer nil if there is no object with the given object ID.

**openOn: aString**

Open an existing database on a directory aString. Answer an instance of OmniBase. Throws an error if a database does not exist in the given directory.

**rollback**

Aborts the current transaction. No changes are written to the disk and all object locks and key locks are released.

**root**

Answer the database root object. All objects in the database should be accessible from the root object, otherwise they are automatically garbage collected the next time a database GC is run. The root object is an instance of `ODBPersistentObject` by default, but it can be changed to any other object.

OmniBase methods
----------------

**close**

Closes open database. All transactions are aborted and locks are released. Do nothing if the database is already closed.

**existsContainerNamed: aString**

Answer true if container named aString exists in the database, false if not. A container is a special file where serialized objects are stored to. There can be up to 65535 containers in a database. Using containers one can speed up object access by storing objects which are usualy sequentialy accessed into the same file. Also by clustering objects sensibly into multiple containers the database will need less additional space when doing database garbage collection.

**globalLock**

Globally locks the database so that no other user can change objects while it is locked. Global lock will fail if any user (including yourself) holds a lock on at least one object. Answers true if successful, false otherwise.

**globalUnlock**

Releases global lock. Afterwards all other users will be able to lock objects for writing and change their contents. Answers true if successfull, false otherwise.

**isGlobalLocked**

Answer true if the database is globally locked, false otherwise.

**newContainer: aString**

Creates new object container in the database. A new subdirectory will be created in the database subdirectory Objects/ where the object storage file and b-tree files of objects in this container will be stored.

**newReadOnlyTransaction**

Answer new read-only transaction. The difference between a normal transaction and the read-only transaction is that every object lock or store attempt will be ignored. Sending #markDirty of #makePersistent will be ignored and no #abort is necessary. This way persistence enabled objects can be changed without setting a lock in the database.

**newTransaction**

Answer new database transaction. The transaction always starts in a read only mode needs no finalization. Only when you set a lock, change or store an object the transaction has to be released by sending abort.

**numberOfClients**

Answer total number of database connections currently open in the database.

**setUserDescription: aString**

Set user description string for this database connection. Other database users i.e. other database connections can see this string which is sometimes usefull to see who is using the database at the same time.

**garbageCollect**

Garbage collects entire database. All unreferenced objects are removed. All containers are compacted. This method is available in the registered version only.

**reorganize**

Same as garbage collection plus all b-tree dictionaries are reorganized to consume the minimum amount of disk space. This method is available in the registered version only. OmniBase transaction methods Objects in the database can be accessed only through transaction. First you access the root object from which you can navigate to whatever object in the database. While a transaction is active it can hold locks on objects. While an object is locked in one transaction it can not be locked and changed in any other transaction. See instance methods of class ODBLocalTransaction for further details.

**abort**

Aborts active transaction. All locks on objects in transaction are released. Sending #abort is not needed, if no locks were obtained in the transaction and no objects were stored. z commit commits transaction i.e. writes all changes made in transaction to database. Two-phase commit process is used to write changes to the databases. If commit succeds all changes made during the transaction will be written to the database. Otherwise nothing will be changed (e.g. if network or some other HW error occurs). Locks are not released. After commit transaction is still active until it receives the #abort message.

**isChanged**

Answer if any object in transaction has been changed.

**becomeInconsistent**

Mark transaction as inconsistent. After receiving this message transaction can not be committed anymore.

**isInconsistent**

Answer if transaction is inconsistent.

**rootObject**

Answer the root object of the database.

**rootObject: anObject**

Set the root object of the database to anObject.

**lock: anObject**

Lock anObject for writing. Answer if successfull, if failed. Method will fail if an object is locked in some other transaction or if it has been changed in a transaction that has already committed. Locking will also fail if database is globally locked by another user.

**unlock: anObject**

Unlock anObject. Lock can not be released if object has been changed i.e. stored.

**store: anObject**

Inform receiver that anObject has been changed. When transaction commits this object will be written to database. All transactions started after transaction commit will get new version of this object. Transaction started before commit will still access the old version. Exception will be signaled if anObject can not be locked. This method has to be called everytime anObject is changed, otherwise it will not be written when transaction commits.

**store: anObject in: aStringOrOmniBaseContainer**

Store anObject to a given container. Container name (or container) is relevant only when object is stored for the first time. Afterwards its location (the container it is stored in) can not be changed. Exception will be signaled if anObject can not be locked. 

ODBBTreeDictionary instance methods
------
A b-tree dictionary provides a way to store and access large number ofobjects in the database. Dictionary keys can be only objects of class String or ByteArray (maximum length of a key has to be set at creation time, see method OmniBase class>>#newBTreeDictionary:). Multiple users can access and change dictionary at the same time. BTreeDictionary also includes a cursor that points to a specific key and provides a way to iterate through objects in the dictionary. See instance methods of class `ODBBTreeDictionary` for further details.

**at: aString**

Answer value stored at aString.

**at: aString put: anObject**

Associate anObject with aString. If anObject is not already persistent it will be stored in the same container the BTreeDictionary is in. Else anObject will not be stored i.e. it wont be marked as changed. Method will fail if key aString is locked or has been already changed in some other transaction.

**lockKey: aString**

Locks key in a dictionary. No other transaction will be able to

change the association while a key is locked. Unexisting keys can also be locked. Answer true if successfull, false if failed. Method will fail if association has already been locked or changed in some other transaction.

**unlockKey: aString**

Unlocks key aString.

**size**

Answer number of (key, value) pairs contained in the dictionary.  Method always answers the exact number of items in the dictionary regardless of simultaneus changes (adding, removing) of other users.

**goTo: aString**

Positions iterator cursor to key aString.

**getCurrent**

Answers association at current cursor position or nil if none.

**getNext**

Answers next association from current cursor position or nil if at end.

**getPrevious**

Answers previous association from current cursor position or nil if at beginning. Positiones cursor to previous key.

**getFirst**

Answers first association and positions cursor to the first key in the dictionary. Answer nil if dictionary is empty.

**getLast**

Answers the last association and positions cursor to the last key in the dictionary. Answer nil if dictionary is empty.

This class implements an ODBFileStream for *nix filesystems using the locking mechanism provided in the OSProcess package.

The main thing it needs to do is map the various windows-like mode flags to Unix equivalents.  The ugliest ones to map (aside from FILE_FLAG_ATOMIC_WRITE and FILE_FLAG_SEQUENTIAL_SCAN, which we ignore) are the share mode flags.

In Windows, when you open a file you can specify what read modes will succeed on future calls to open the same file.  So, if you specify FILE_SHARE_READ but not FILE_SHARE_WRITE, another application would be able to open the file in read mode but not in read-write mode. Unix does not support this concept since locks are advisory and have no effect on an whether another application can open a file for reading or writing later.
	
The best approximation I can come up with is to lock a special byte.  If you want to write to the file you need to able to get a write-lock on that byte.  If you only want to read the file, you only need to be able to read-lock that byte.  Note that you don't actually perform this lock, you just test for it.  Then you lock the byte based on what you want to allow other applications to do.
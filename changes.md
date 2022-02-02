Changes
=======

- introduced unicode serialization/deserialization with new type code 36
- a fix for Floats to be written as immediates. Solves a problem when the same floats are written
- changed from travis to github actions
- Removed dependency to OSProcess
- Added FLock mechanism based on unified FFI to make a fcntl call available for locking
- Added BSDFlock to cope with the different setup for the same named LibC call

Release v1.6
------------

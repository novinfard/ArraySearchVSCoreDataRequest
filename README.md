# Array Search VS Core Data Request Performance Measurement

In this test we checked the differences between searching data objects in these two different setting:

### A) `testSearchByArray`
Getting the all objects once and then find the object inside the array.

### B) `testSearchBySingleRequest`
Requesting for each entry by single `NSFetchRequst`

------

In this experiment we first added 1000 entries. Then we randomly searched for 100 entries.

The result has shown that the time of search inside all entries is almost half of the time spent on requesting for each entry (`0.23` against `0.43`)

*************************************************************************************************_PRACTICE-1_*********************************************************************************************************
Part A: Insert Multiple Fee Payments in a Transaction
Description:

Given a table FeePayments, the task is to simulate a transaction where multiple payment entries are inserted at once. The goal is to demonstrate that all inserts happen successfully together as a single transaction unit (Atomicity).

Input Format:

Table FeePayments with columns:

payment_id (INT, Primary Key)

student_name (VARCHAR(100))

amount (DECIMAL(10,2))

payment_date (DATE)

Output Format:

List of newly inserted payment records when the transaction is committed.

Constraints:

Each payment has a unique ID.

All inserts must succeed together as one unit of work.

Sample Input:

FeePayments

payment_id	student_name	amount	payment_date
1	Ashish	5000.00	2024-06-01
2	Smaran	4500.00	2024-06-02
3	Vaibhav	5500.00	2024-06-03
Sample Output:

payment_id	student_name	amount	payment_date
1	Ashish	5000.00	2024-06-01
2	Smaran	4500.00	2024-06-02
3	Vaibhav	5500.00	2024-06-03
Explanation:

This transaction ensures that either all inserts succeed or none do, demonstrating Atomicity. The COMMIT makes changes durable.

Part B: Demonstrate ROLLBACK for Failed Payment Insertion
Description:

Simulate a transaction failure in a FeePayments table by attempting to insert an invalid payment (e.g., duplicate payment_id). Use ROLLBACK to undo the entire transaction and demonstrate Atomicity and Consistency — ensuring that no partial data is committed to the table.

Input Format:

Table FeePayments with columns:

payment_id (INT, Primary Key)

student_name (VARCHAR(100))

amount (DECIMAL(10,2))

payment_date (DATE)

Output Format:

No new records should be present from the failed transaction after ROLLBACK.

Constraints:

payment_id must be unique.

amount must be a positive decimal.

If any operation in the transaction fails, the entire transaction must be rolled back.

Sample Input:

Initial successful inserts:

payment_id	student_name	amount	payment_date
1	Ashish	5000.00	2024-06-01
2	Smaran	4500.00	2024-06-02
3	Vaibhav	5500.00	2024-06-03
Transaction with failure (duplicate ID = 1):

Sample Output:

Only the first 3 valid records should exist after rollback:

payment_id	student_name	amount	payment_date
1	Ashish	5000.00	2024-06-01
2	Smaran	4500.00	2024-06-02
3	Vaibhav	5500.00	2024-06-03
Explanation:

The first transaction inserts 3 valid records and is committed.

The second transaction attempts 2 inserts:

The first insert (Kiran) is valid.

The second insert (Ashish) fails due to duplicate payment_id = 1 and negative amount (which violates CHECK constraint).

Because of the failure, the entire transaction is rolled back, ensuring:

Atomicity: No partial data is committed.

Consistency: Database returns to a consistent state.

The final SELECT confirms that only the first 3 records exist.

Part C: Simulate Partial Failure and Ensure Consistent State
Description:

Demonstrate how inserting one valid and one invalid record within a transaction causes the entire operation to be rolled back, keeping the table in a consistent state.

Input Format:

Table FeePayments as before.
Output Format:

payment_id	student_name	amount	payment_date
1	Ashish	5000.00	2024-06-01
2	Smaran	4500.00	2024-06-02
3	Vaibhav	5500.00	2024-06-03
Constraints:

Transactions must fail completely if any operation fails.
Sample Input:

Invalid record has NULL in student_name.

Sample Output:

No new records inserted.

Explanation:

Even though the first insert was valid, the second insert fails, causing the entire transaction to rollback, proving Atomicity and Consistency.

Part D: Verify ACID Compliance with Transaction Flow
Description:

Combine all transaction techniques into one example and verify that all ACID properties — Atomicity, Consistency, Isolation, and Durability — are preserved.

Input Format:

Table FeePayments
Output Format:

Final state of the table reflecting successful committed transactions only.

Constraints:

All four ACID properties should be demonstrated.

Isolation can be simulated using sessions if DBMS supports.

Sample Input:

Valid inserts and a failed one using the same payment_id.

**********************************************************************************************************************************************************************************************************************

*************************************************************************************************_PRACTICE-2_*********************************************************************************************************

Part A: Prevent Duplicate Enrollments Using Locking
Description:

Simulate concurrent users attempting to enroll students in courses. Implement a mechanism that prevents two users from enrolling the same student into the same course simultaneously by using transactions and unique constraints.

Input Format:

Table StudentEnrollments with columns:

enrollment_id (INT, Primary Key)

student_name (VARCHAR(100))

course_id (VARCHAR(10))

enrollment_date (DATE)

Output Format:

Only one user should be able to insert the record successfully for a given (student_name, course_id) pair.

Constraints:

Each student can enroll in a course only once.

The pair (student_name, course_id) must be unique.

Use transactions to handle concurrent access.

Sample Input:

enrollment_id	student_name	course_id	enrollment_date
1	Ashish	CSE101	2024-07-01
2	Smaran	CSE102	2024-07-01
3	Vaibhav	CSE101	2024-07-01
Sample Output:

If two users try to enroll 'Ashish' in 'CSE101', only the first will succeed; the second will get a constraint violation.

Part B: Use SELECT FOR UPDATE to Lock Student Record
Description:

Use row-level locking via SELECT FOR UPDATE to prevent conflicts. Simulate a situation where a student is being verified before enrollment and locked until confirmation, preventing other users from updating it simultaneously.

Input Format:

Same table: StudentEnrollments
Output Format:

The selected row will be locked until the transaction is committed or rolled back. Other users trying to access that row will be blocked.

Constraints:

Use START TRANSACTION and SELECT FOR UPDATE.

Locking should block conflicting transactions on the same record.

Sample Input:

Simulation Steps (Using Row-Level Locking with SELECT FOR UPDATE)

User A:

Start a transaction.

Use a SELECT FOR UPDATE query to lock the specific row where:

Student name is 'Ashish'

Course ID is 'CSE101'

Keep the transaction open (do not commit or rollback yet).

This locks the row so that no one else can update it until User A finishes.

User B (while User A's transaction is still open):

Try to update the same row (student_name = 'Ashish' and course_id = 'CSE101').
This update will be blocked (it will wait) because the row is locked by User A.

Sample Output:

User B will be blocked until User A finishes the transaction.


Part C: Demonstrate Locking Preserving Consistency in Concurrent Transactions
Description:

Demonstrate how locking preserves data consistency when multiple users attempt concurrent updates. Show how update conflicts are avoided when row-level locks are used appropriately in transactions.

Input Format:

Same StudentEnrollments table as above.

Output Format:

Conflicting operations are serialized due to locking, and data remains consistent without corruption or duplication.

Constraints:

Each user must use transactions with locking.

Show that without locking, both users could overwrite each other's changes.

Sample Input:

enrollment_id	student_name	course_id	enrollment_date
1	Ashish	CSE101	2024-07-01
Sample Output:

After both users run their updates one after the other, only the last committed update is reflected — no race condition or inconsistent data.

**********************************************************************************************************************************************************************************************************************

*************************************************************************************************_PRACTICE-3_*********************************************************************************************************

Part A: Simulating a Deadlock Between Two Transactions
Description:

Given a table StudentEnrollments containing student records, simulate a situation where two concurrent transactions (from different users) try to update overlapping records in different orders, resulting in a deadlock. Demonstrate how such deadlocks are detected and how they can be avoided using proper transaction ordering.

Input Format:

Table StudentEnrollments with columns:

student_id (INT, Primary Key)

student_name (VARCHAR(100))

course_id (VARCHAR(10))

enrollment_date (DATE)

Output Format:

Demonstrate that one transaction will be rolled back automatically by the database to resolve the deadlock.

Constraints:

Use two user sessions to run START TRANSACTION simultaneously.

Ensure the transactions access rows in reverse order to trigger a deadlock.

Database must support deadlock detection (e.g., MySQL, PostgreSQL).

Sample Input:

StudentEnrollments

student_id	student_name	course_id	enrollment_date
1	Ashish	CSE101	2024-06-01
2	Smaran	CSE102	2024-06-01
3	Vaibhav	CSE103	2024-06-01
Sample Output:

Transaction 2 is aborted due to a detected deadlock.

Explanation of Output:

Both transactions try to lock each other's rows in reverse order. This causes a deadlock, and the database automatically rolls back one transaction (usually the one that waited longest) to break the cycle.

Part B: Applying MVCC to Prevent Conflicts During Concurrent Reads/Writes
Description:

Use the MVCC (Multiversion Concurrency Control) approach to allow User A to read a record and User B to update the same record concurrently without blocking or conflict. Demonstrate how MVCC provides a consistent snapshot to the reader while allowing the writer to update.

Input Format:

Table StudentEnrollments with the same structure.
Output Format:

User A sees the old value during the transaction.
User B successfully updates the row without waiting.

Constraints:

Use databases that support MVCC (e.g., PostgreSQL, MySQL InnoDB).

Avoid SELECT FOR UPDATE; use normal SELECT in repeatable read or snapshot isolation mode.

Sample Input:

student_id	student_name	course_id	enrollment_date
1	Ashish	CSE101	2024-06-01
Sample Output:

User A sees: enrollment_date = 2024-06-01

User B updates to: 2024-07-10

User A continues to see the old value in the transaction until commit.

Explanation of Output:

MVCC ensures User A reads a consistent snapshot taken at the start of the transaction, unaffected by concurrent updates. This enables non-blocking concurrency.

Part C: Comparing Behavior With and Without MVCC in High-Concurrency
Description:

Evaluate how MVCC vs. traditional locking behaves when multiple users access the same row for read and write. Use SELECT FOR UPDATE to demonstrate blocking in a non-MVCC system and contrast that with MVCC-based reads and updates.

Input Format:

Same StudentEnrollments table and data.

Output Format:

Two scenarios:

With Locking: Readers are blocked until the writer commits.

With MVCC: Readers get consistent data without blocking.

Constraints:

MVCC-supported database (e.g., PostgreSQL).

Use different isolation levels or query techniques to simulate both cases.

Sample Input:

student_id	student_name	course_id	enrollment_date
1	Ashish	CSE101	2024-06-01
Sample Output:

Without MVCC: Reader blocks until writer commits.

With MVCC: Reader sees 2024-06-01 even while the writer updates to 2024-07-10.

Explanation of Output:

Traditional locking causes blocking and delays.

MVCC enables concurrent operations with no blocking, ensuring performance and consistency.

**********************************************************************************************************************************************************************************************************************

As an application developer, you wouldn't normally be running INSERT statements
 ad-hoc in a production environment (whether at the terminal or in a graphical 
 client such as pgAdmin). As you saw in the previous step, inserts are typically
 part of an input process involving other operations. 

In database-speak, a transaction is a series of operations - that must be either
 completely processed or not processed at all - that together make up a unit of 
work. For example, a client entering a registration for an event, or 
submitting an online payment, would be handled with transactions. 

### INSERT in transactions

We won't be discussing transactions in detail here, but a very basic idea we'll 
touch on is that the work that happens in a transaction does not have to be 
permanent. You could _rollback_ a transaction if there are errors, such as a 
conflict. 

It's pretty standard to wrap inserts within a transaction - this is 
a safeguard for the database against unwanted changes. Also, you could 
have concurrent sessions that are trying to do inserts that actually conflict 
with each other. Wrapping it in a transaction basically allows the database 
to decide the best thing to do next in that situation.

### Batch inserts

You've probably also noticed by now that it's possible to add multiple rows 
with a single INSERT. Many application developers won't need to carry these 
out themselves, but it's good to know that it's possible. And, if a batch 
insert is executed within a transaction and a conflict or error takes place on,
 say, the last row to be inserted, a rollback will take the database back to a 
 point where none of the rows have been inserted - even if all of them except the 
 last were successful.

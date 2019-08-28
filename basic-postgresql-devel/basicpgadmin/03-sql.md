# Working with SQL in PgAdmin4

Now that we know how to get around in PgAdmin4 let's look at how to do some SQL queries using this GUI.

## Creating a SQL query on a database or table

There are several ways to create a SQL query, most of which involve a right-click of the mouse. 

To bring up an empty query box on your database:
1. Make sure your database or one of it sub-objects is selected in the left nav
2. Click on the lighting icon on the top of the left nav area

![Icon for Query](basicpgadmin/assets/03-lightning.png)

In the right pane you now have a right text area to write a query or multiple queries. 

> For now just write:
>
> ```SELECT * FROM se_locations;```{{copy}}

to select all the records of storm event locations. **Hint** you can hit <kbd>ctrl</kbd>+<kbd>space</kbd> to get name completion in the editor. 
Try it for the table name, type "se_lo" and then hit <kbd>ctrl</kbd>+<kbd>space</kbd>. 

To execute this query either:
1. Press F5 on your keyboard 
1. Click on the lightning icon on the top of the query area

![Execute Query](basicpgadmin/assets/03-execute-query.png)

Once the query is done executing you will see a nice tabular view of the data on the bottom of the right pane. The column names and data values will be displayed as well. 

![Data Table](basicpgadmin/assets/03-data-table.png)

**Note** You can not edit data in this table view.

### Other ways to bring up a query

The other ways to bring up a query are:
1. Right click on the table and select the "Query Tool..." menu option ![Right click query](basicpgadmin/assets/03-right-query.png)
1. Right click on the table and select  "Scripts" > "Select Script" . This creates a query with all the columns listed and 
the table fully schema qualified. 
![Right Click scripts](basicpgadmin/assets/03-right-script.png)

If you had SQL files saved on your local machine you can bring them into the editor by click on the folder icon right under 
the "Dashboard" right pane menu. This will allow you to load a file from your local machine. If you want to save the contents of the editor to your local machine you would click on the disc icon.

## Editing data in the table
If you want to edit data in the table, you can: 
1. Click on the table
1. Click on the little table icon in the top of the left nav

![Data Table](basicpgadmin/assets/03-edit-table.png)

To edit a value, just double click on the cell and when you are done, click save.

### Closing a Panel

To close a panel either:
1. Right click on the panel and select "Remove Panel"
2. Click on the **x** found on the  far right side on the same line as the table titles. This will close the active panel. 

## Wrap Up

Now we have seen how to bring up a SQL Query and use it to query our database. 

While we only used one table in the query dialog, you can actually use as many tables as you have permissions to use in 
the database.

*NOTE* You can actually have multiple SQL statements in the editor. If you select a line in the editor, that is the SQL 
that will be executed when you click the lightning icon. If no lines are selected then the last statement is executed. 

Let's do one more section on creating objects in the database.
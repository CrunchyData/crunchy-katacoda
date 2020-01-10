## Formatting results using `\pset`

Sometimes, your query might return a long list of results. The following statement, for example, returns over 55,000 rows:

```
SELECT state FROM se_details;
```{{execute}}

Remember that you can press `q` any time to return to the `psql` prompt.

You can use the `\pset` command to customize the way results are displayed. 

Taking the example above: instead of having to scroll through the entire result set, you can instead have the terminal take you directly to the end:

```\pset pager```{{execute}}

Running this command without a value (i.e. `\pset pager on` or `off`) toggles the pager use on or off.

```
SELECT state FROM se_details;
```{{execute}}

`\pset` also has other options you can use to format the results display. Try `\pset border 1` and `\pset border 2` to see how the display changes.

Note: There is also an option to set these preferences in a [startup file](https://www.postgresql.org/docs/current/app-psql.html#id-1.9.4.18.10), which can be run each time `psql` starts.

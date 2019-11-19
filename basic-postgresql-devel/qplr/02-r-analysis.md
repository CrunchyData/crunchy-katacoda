# Doing more with our analysis

Now that you have seen the basics of how we write a function in R, let's do something a bit more interesting. 

Let's write a simple function that calculates the [Pearson's correlation](https://www.rdocumentation.org/packages/stats/versions/3.5.3/topics/cor.test) 
between two input columns and then returns the full text of the analysis from R. It will allow the user to pass in any
two columns and we will calculate the correlation. 

```
CREATE OR REPLACE FUNCTION r_corr(first float8[], second float8[])
RETURNS TEXT as $$
    result <- cor.test(first,second)
    return(toString(result))
$$ LANGUAGE 'plr';

```{{execute}}

And now let's exercise our function:


`select r_corr(array_agg(aland), array_agg(awater)) from county_geometry;`{{execute}}

What we get back is the string which represents the DataFrame (R term for dataset) for the results of the correlation test. 
The first three elemets are the statistical test score, the degrees of freedom, and the P value respectively, the _cor =_ represents the correlation coefficient,
the last element with c(a,b) represents the 95% confidence interval on our correlation coefficient. 

Let's compare that to the answer we get from the built in PostgreSQL correlation statistic:

``` select corr(aland, awater) from county_geometry; ```{{execute}}

All we get is just the correlation coefficient with no sense of how strong it is. 

As one final exercise, instead of a string, let's return the results as a DB row.

Our new function looks like:

```
create function r_corr_row(first double precision[], second double precision[], out method text,
  out corr_value float8, out lower_value float8, out upper_value float8, out probab float8) returns record
  language plr
as
$$
    result <- cor.test(first,second)
    output <- data.frame(
     method = result$method,
     corr_value = result$estimate,
     lower_value = result$conf.int[1],
     upper_value = result$conf.int[2],
     probab. = result$p.value)
    return(data.frame(output))
$$;
```{{execute}}

And now we call it like this:
```
WITH get_aggs AS (                                                                              
  select array_agg(aland) AS aland_vector, array_agg(awater) AS awater_vector FROM county_geometry
) SELECT r_corr_output.* FROM get_aggs, r_corr_row(get_aggs.aland_vector, get_aggs.awater_vector) AS r_corr_output;

```{{execute}}

This is using a common table expression (CTE). With a CTE we get a much nicer subquery syntax. We start the statement
 with "WITH get_aggs AS (" which is basically saying that next section in the ( ) can be used later in the query as a
 table named get_aggs.  We do this first call to get our 

The second select statement then treats our function call as a table. 
 
`SELECT r_corr_output.* FROM get_aggs, r_corr_row(get_aggs.aland_vector, get_aggs.awater_vector) AS r_corr_output;` 

Remember, everything after the FROM is table declarations, so 

`from ... r_corr_row(get_aggs.aland_vector, get_aggs.awater_vector) as r_corr_output;`     

Is saying "call the function and name its results as r_corr_output". Once we have our function results with a table
 like structyre  we can call it like any other table in the beginning part of our SELECT statement.


## Final Notes

Joe Conway has quite a few [presentations](http://www.joeconway.com/index.html#presentations) where he gives a lot of examples.
There is also [good documentation](https://github.com/postgres-plr/plr/blob/master/userguide.md) for PL/R so feel free to dig 
in more and take advantage of all the power of R in PostgreSQL.


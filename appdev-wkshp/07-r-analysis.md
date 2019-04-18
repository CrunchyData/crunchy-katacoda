# Using R **Inside** Postgresql

R is a FOSS statistical language that is well know in the data analysis and statistical fields. It is a specialized 
programming language that is focused on statistical work and visualization. It does have a syntax that  is different than 
most other programming languages and it really good at doing matrix and vector calculations.Analysis that would take 
the inclusion of numerous specialized libraries and many lines of code are simple and concise in R.

For example, here is how you tell R to calculate correlation between cost of a car and years the car lasts

```corr(car_data$car_cost, car_data$car_lasts)```

and then solve a regression where years of life for the car is directly affected by cost of the car:

```lm(car_lasts ~ car_cost, data = car_data)```

Here lm stands for linear model (another name for linear regression). The output would show you the intercept and slope and 
it is quite easy to get summary statistics on the model as well. 

Having this language embedded within your database is **extremely** powerful. We have can have our analysis routines living 
right next to the data. No need to move it across the wire and then run the analysis. Now we also can use R in functions 
(stored procedures and by extension, trigger). This means we as the data scientist can write the linear regression as a fucntion 
that is triggered to update the results everytime there is a new data entry. Then we can expose that to application developers 
as a simple function that they can call in their sql like:

```SELECT my_r_regression() ```

and get back the slope, intercept, and any other summary stats you want to give them. Data scientists and statisticians can 
feel comfortable that the correct analysis is being done without anyone changing their methods. Application developers are 
excited because they get just the answers they want without having to figure out how to code it themselves or use yet another 
programming language.

#### Use R a little

We installed R on your machines, so let's start by showing you the simplest flow possible.

1. Write 2x2 in R function
2. Take the function and make it a function in Postgresql
3. Call it and see the amazing results

After this we will quickly do the linear regression we talked about earlier. 

To start R just type:

```R```{{execute}}

at the terminal.

Now to do 2x2 you just do:

```2x2```{{execute}}

and hit enter. Wow, amazing right ;)

To quite R just type:

```quit()```{{execute}} 

and say N when it asks if you want to save your workspace. A workspace is just as it sounds - in your profile it will store 
your command history and data you may have output.

## Stored Procedures and Functions in R

Stored procedures and functions allow you to write code, embed it into the database, and then be called the same as other normal
database functions. A stored procedure is the same as a stored function except the procedure does not return anything.

There are [many languages](https://www.postgresql.org/docs/11/external-pl.html) you can use to write a stored function in Postgresql, 
but today we will be working with R. If you go look at that list you will notice many of those languages can interact with 
the Operating System. That is why, in general, most languages are treated as **untrusted**. Since stored functions execute with 
the OS privileges of the Postgres user - you don't want just anyone writing stored functions unless they are using a trusted 
language.  

#### What this means for development.

Our proposed workflow for development, which will we do below, is to allow the language to be trusted **only** in the development 
environment. In this was developers can make their own functions, iterate them, and get them working correctly. Then, when it's 
time to go to production, someone with DB superuser privileges transfers the function to the production database. This will involve
tracking changes to function and having a migration procedure but the extra work is well worth it given the alternative. 

Again - make the language trusted in your development environment NOT your production environment.

Here is the overview documentation on [stored functions](https://www.postgresql.org/docs/11/xfunc.html) and here is the 
reference doc on how to create a [stored function](https://www.postgresql.org/docs/11/sql-createfunction.html) 
or a [stored procedure](https://www.postgresql.org/docs/11/sql-createprocedure.html).

#### Putting R in PostgreSQL
We already installed the R language (PL/R) into PostgreSQL for you, so let's get started.

First we need to make PL/R a trusted language - this has to be done as the postgres user:

```psql -U postgres -h localhost workshop```{{execute}}

Unless you specified a different password when we started the container, the password will be "password" just like the user 
groot.

Now update the language status:

```UPDATE pg_language SET lanpltrusted = true WHERE lanname LIKE 'plr';```{{execute}}

Now logout:

`\q`{{execute}}

Changing the language status only has to happen once in the lifetime of the database. 

Now log back in as normal user groot. 

```psql -U groot -h localhost workshop```{{execute}}

and then enter the following command:

```sql
CREATE OR REPLACE FUNCTION two_times_two()
RETURNS INTEGER as $$
    result <- 2*2
    return(result)
$$ LANGUAGE 'plr';

```

1. We name our function *two_times_two*
1. We are not accepting any input, hence the () 
1. We are going to return an integer
1. Everything between the set of $$s is the actual function
1. We declare that the function uses the language extension PL/R.

and now let's call our highly technical new function:

` select two_times_two();`{{execute}}

#### Doing more with our analysis

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

```

And now let's exercise our function:

```select r_corr(array_agg(aland), array_agg(awater)) from county_geometry;```{{execute}}

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
```

And now we call it like this:
```
WITH get_aggs AS (                                                                              
  select array_agg(aland) as aland_vector, array_agg(awater) as awater_vector from county_geometry
) SELECT r_corr_output.* from get_aggs, r_corr_row(get_aggs.aland_vector, get_aggs.awater_vector) as r_corr_output;

```

Those statements have a lot to unpack but your head is probably full - let's handle it in person. 

## Final Notes

Joe Conway has quite a few [presentations](http://www.joeconway.com/index.html#presentations) where he gives a lot of examples.
There is also [good documentation](https://github.com/postgres-plr/plr/blob/master/userguide.md) for PL/R so feel free to dig 
in more and take advantage of all the power of R in PostgreSQL.


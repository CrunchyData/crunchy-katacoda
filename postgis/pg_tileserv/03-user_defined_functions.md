All of the commands on this page should be run within Terminal 2.

To create a user-defined function, first we must log into the running database.

>**WAIT!** Before you execute the code block below, make sure you've navigated back to ```Terminal 2```. 

```PGPASSWORD="password" psql -h localhost -U groot nyc```{{execute}}

## Create a user-defined function

For this part of the exercise, we'll use a couple of the functions from Paul Ramsey's blog post on [Serving Tiles with Dynamic Geometry](https://info.crunchydata.com/blog/tile-serving-with-dynamic-geometry).

First we need to create the hexagons.

```
CREATE OR REPLACE 
FUNCTION 
hexagon(i integer, j integer, edge float8) 
RETURNS geometry 
AS $$ 
DECLARE 
h float8 := edge*cos(pi()/6.0); 
cx float8 := 1.5*i*edge; 
cy float8 := h*(2*j+abs(i%2)); 
BEGIN 
RETURN ST_MakePolygon(ST_MakeLine(ARRAY[ 
            ST_MakePoint(cx - 1.0*edge, cy + 0), 
            ST_MakePoint(cx - 0.5*edge, cy + -1*h), 
            ST_MakePoint(cx + 0.5*edge, cy + -1*h), 
            ST_MakePoint(cx + 1.0*edge, cy + 0), 
            ST_MakePoint(cx + 0.5*edge, cy + h), 
            ST_MakePoint(cx - 0.5*edge, cy + h), 
            ST_MakePoint(cx - 1.0*edge, cy + 0) 
         ])); 
END; 
$$ 
LANGUAGE 'plpgsql' 
IMMUTABLE 
STRICT 
PARALLEL SAFE;
```{{execute}}

Then we'll fill tiles with those Hexagons.

```
CREATE OR REPLACE 
FUNCTION hexagoncoordinates(bounds geometry, edge float8, 
                            OUT i integer, OUT j integer) 
RETURNS SETOF record 
AS $$ 
    DECLARE 
        h float8 := edge*cos(pi()/6); 
        mini integer := floor(st_xmin(bounds) / (1.5*edge)); 
        minj integer := floor(st_ymin(bounds) / (2*h)); 
        maxi integer := ceil(st_xmax(bounds) / (1.5*edge)); 
        maxj integer := ceil(st_ymax(bounds) / (2*h)); 
    BEGIN 
    FOR i, j IN 
    SELECT a, b 
    FROM generate_series(mini, maxi) a, 
         generate_series(minj, maxj) b 
    LOOP 
       RETURN NEXT; 
    END LOOP; 
    END; 
$$
LANGUAGE 'plpgsql' 
IMMUTABLE 
STRICT 
PARALLEL SAFE;
```{{execute}}

Now we need to create the ```ST_TileEnvelope``` Function (we have to create it here since the version of PostGIS we're using in this container is Postgis 2.4. This function is included in Postgis 3.0+)


```
CREATE OR REPLACE
FUNCTION ST_TileEnvelope(z integer, x integer, y integer)
RETURNS geometry
AS $$
  DECLARE
    size float8;
    zp integer = pow(2, z);
    gx float8;
    gy float8;
  BEGIN
    IF y >= zp OR y < 0 OR x >= zp OR x < 0 THEN
        RAISE EXCEPTION 'invalid tile coordinate (%, %, %)', z, x, y;
    END IF;
    size := 40075016.6855784 / zp;
    gx := (size * x) - (40075016.6855784/2);
    gy := (40075016.6855784/2) - (size * y);
    RETURN ST_SetSRID(ST_MakeEnvelope(gx, gy, gx + size, gy - size), 3857);
  END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE
STRICT
PARALLEL SAFE;
```{{execute}}

Now we can create a function to generate hexagons for any sized tile.

```
CREATE OR REPLACE 
FUNCTION tilehexagons(z integer, x integer, y integer, step integer, 
                      OUT geom geometry(Polygon, 3857), OUT i integer, OUT j integer) 
RETURNS SETOF record 
AS $$ 
    DECLARE 
        bounds geometry; 
        maxbounds geometry := ST_TileEnvelope(0, 0, 0); 
        edge float8; 
    BEGIN 
    bounds := ST_TileEnvelope(z, x, y); 
    edge := (ST_XMax(bounds) - ST_XMin(bounds)) / pow(2, step); 
    FOR geom, i, j IN 
    SELECT ST_SetSRID(hexagon(h.i, h.j, edge), 3857), h.i, h.j 
    FROM hexagoncoordinates(bounds, edge) h 
    LOOP 
       IF maxbounds ~ geom AND bounds && geom THEN 
            RETURN NEXT; 
         END IF; 
     END LOOP; 
     END; 
$$ 
LANGUAGE 'plpgsql' 
IMMUTABLE 
STRICT 
PARALLEL SAFE;
```{{execute}}

And finally we can pull them all together in a function that allows us to have dynamic hexagons as vector tiles.

```
CREATE OR REPLACE 
FUNCTION public.hexagons(z integer, x integer, y integer, step integer default 4) 
RETURNS bytea 
AS $$ 
WITH 
bounds AS ( 
    -- Convert tile coordinates to web mercator tile bounds 
    SELECT ST_TileEnvelope(z, x, y) AS geom  
 ),
 rows AS (
    -- All the hexes that interact with this tile 
    SELECT h.i, h.j, h.geom 
    FROM TileHexagons(z, x, y, step) h 
 ), 
 mvt AS ( 
     -- Usual tile processing, ST_AsMVTGeom simplifies, quantizes, 
     -- and clips to tile boundary 
    SELECT ST_AsMVTGeom(rows.geom, bounds.geom) AS geom, 
           rows.i, rows.j 
    FROM rows, bounds 
) 
-- Generate MVT encoding of final input record 
SELECT ST_AsMVT(mvt, 'public.hexagons') FROM mvt 
$$ 
LANGUAGE 'sql' 
STABLE 
STRICT 
PARALLEL SAFE; 
COMMENT ON FUNCTION public.hexagons IS 'Hex coverage dynamically generated. Step parameter determines how approximately many hexes (2^step) to generate per tile.';
```{{execute}}

Now, go back to the pg_tileserv tab and you should now see two new functions. (You may need to hit the refresh symbol in the pg_tileserv tab.)

Now that you have these tiles, you could use them to do real-time filtering and analysis of data in your database. That is a more advanced use case that goes beyond the scope of this exercise.


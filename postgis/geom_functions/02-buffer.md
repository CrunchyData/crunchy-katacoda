The buffering operation is common in GIS workflows, and is also available in PostGIS. `ST_Buffer(geometry,distance)` takes in a buffer distance and geometry type and outputs a polygon with a boundary the buffer distance away from the input geometry.

![ST_Buffer](geom_functions/assets/st_buffer.png)

For example, if the US Park Service wanted to enforce a marine traffic zone around Liberty Island, they might build a 500 meter buffer polygon around the island. Liberty Island is a single census block in our `nyc_census_blocks` table, so we can easily extract and buffer it.

```{.sql}
SELECT ST_Buffer(geom,500) AS geom
FROM nyc_census_blocks
WHERE blkid = '360610001001001';
```{{execute}}

![Liberty Island buffer](geom_functions/assets/liberty_positive.jpg)

The ST_Buffer function also accepts negative distances and builds inscribed polygons within polygonal inputs. For lines and points you will just get an empty return.

```{.sql}
SELECT ST_Buffer(geom, -500) AS geom
FROM nyc_census_blocks
WHERE blkid = '360610001001001';
```{{execute}}

![Liberty Island negative buffer](geom_functions/assets/liberty_negative.jpg)

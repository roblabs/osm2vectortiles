## Rhode Island to Vector Tiles

### make sure to run these commands from the root of git project
`cd ./osm2vectortiles`

### Start up your PostGIS container with the data container attached.
```
docker-compose up -d postgis
```

### Download a PBF and put it into the local import directory.
* http://download.geofabrik.de/north-america/us/rhode-island.html

`wget http://download.geofabrik.de/north-america/us/massachusetts-latest.osm.pbf -P ./pbf`

##### Copy to ./import

``` bash
cp ./pbf/massachusetts-latest.osm.pbf ./import
```

### Import water polygons from OpenStreetMapData.com, Natural Earth data for lower zoom levels and custom country, sea and state labels.

* Do this only once

```
docker-compose up import-external
```

### the downloaded PBF file gets imported into PostGIS.
```
docker-compose up import-osm
```

### imports custom SQL utilities such as functions and views, which are needed to create the vector tiles.
```
docker-compose up import-sql
```

### export a MBTiles file by passing the bounding box you want your desired extract for.

* To find bounding boxes, Go to [https://openmaptiles.com/extracts/](https://openmaptiles.com/extracts/)

```
docker-compose run \
  -e BBOX="-71.14500,42.21671,-70.78383,42.44007" \
  -e MIN_ZOOM="0" \
  -e MAX_ZOOM="14" \
  export
```


### Serve up your tiles
tileserver-gl-light export/tiles.mbtiles


### Useful links to show your region of interest

#### OSM bright
http://localhost:8080/styles/bright-v9/?vector#6/41.7144/-71.3717

#### X-Ray
http://localhost:8080/data/osm2vectortiles/#9.43/41.7353/-71.5263

### Demo

[![Rhode Island Demo](https://img.youtube.com/vi/9v05n5H_EgA/0.jpg)]
  (https://www.youtube.com/watch?v=9v05n5H_EgA)


### Update the SQL in the container `import-sql`
```
# list -all container ids
docker ps -a

# Modify your src SQL
export CONTAINER_ID=c8211d1957bc   # your container id here
docker cp src/import-sql/layers/road.sql $CONTAINER_ID:/usr/src/app/layers

# run import-sql & export as before
```

#### Sample SQL change, add `tertiary` roads in at zoom 8
```sql
CREATE OR REPLACE VIEW road_z8toz9 AS
    SELECT id AS osm_id, geometry, type, construction, tracktype, service, access, oneway, 'none'::varchar(4) AS structure, z_order
    FROM osm_road_geometry
    WHERE road_class(type, service, access) IN ('motorway', 'motorway_link', 'trunk', 'primary', 'secondary', 'tertiary', 'major_rail');
```

## Rhode Island to Vector Tiles

### make sure to run these commands from the root of git project
`cd ./osm2vectortiles`

### Start up your PostGIS container with the data container attached.
```
docker-compose up -d postgis
```

### Download a PBF and put it into the local import directory.
* http://download.geofabrik.de/north-america/us/rhode-island.html

`wget http://download.geofabrik.de/north-america/us/rhode-island-latest.osm.pbf -P ./import`

### Import water polygons from OpenStreetMapData.com, Natural Earth data for lower zoom levels and custom country, sea and state labels.
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

```
docker-compose run \
  -e BBOX="-71.472672,41.772411,-71.376541,41.861572" \
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

![[Rhode Island Demo](https://www.youtube.com/watch?v=9v05n5H_EgA)](https://img.youtube.com/vi/9v05n5H_EgA/0.jpg)


### Update the SQL in the container `import-sql`
```
# list -all container ids
docker ps -a

# Modify your src SQL
export CONTAINER_ID=c8211d1957bc   # your container id here
docker cp src/import-sql/layers/road.sql $CONTAINER_ID:/usr/src/app/layers

# run import-sql & export as before
```

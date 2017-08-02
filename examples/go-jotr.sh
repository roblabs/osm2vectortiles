docker-compose up -d postgis

docker-compose up import-external

docker-compose up import-osm

docker-compose up import-sql

docker-compose run --rm \
  -e BBOX="-116.604767,33.652923,-115.212936,34.148181" \
  -e MIN_ZOOM="0" \
  -e MAX_ZOOM="14" \
  export

mv export/tiles.mbtiles export/jotr.mbtiles
tileserver-gl-light export/jotr-z0-z14.mbtiles

### Update the SQL in the container `import-sql`
```
# list -all container ids
docker ps -a

# Modify your src SQL
export CONTAINER_ID=034bdd0e7622   # your container id here
docker cp src/import-sql/layers/road.sql $CONTAINER_ID:/usr/src/app/layers
docker cp src/import-sql/layers/road_label.sql $CONTAINER_ID:/usr/src/app/layers


# run import-sql & export as before
```



# docker-compose up export

#./patch "./export/planet_2016-06-20_7088ce06a738dcb3104c769adc11ac2c_z0-z5.mbtiles" "./export/tiles.mbtiles"




http://localhost:8080/styles/bright-v9/?vector#10.75/34.0085/-116.1078
# xray
http://localhost:8080/data/osm2vectortiles/#8.66/33.7916/-116.0151


# mbtiles
# https://github.com/roblabs/vector-tiles-sample#host-the-vector-tiles-without-any-server-at-all
mb-util --image_format=pbf export/tiles.mbtiles jotr

# --decompress --recursive --suffix (change from .gz to .pbf)
cd jotr
gzip -d -r -S .pbf *
find . -type f -exec mv '{}' '{}'.pbf \;

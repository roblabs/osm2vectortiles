docker-compose up import-external

docker-compose up import-osm

docker-compose up import-sql

docker-compose run \
  -e BBOX="-117.4068,32.5248,-116.0884,33.5059" \
  -e MIN_ZOOM="0" \
  -e MAX_ZOOM="14" \
  export

docker-compose up export

#./patch "./export/planet_2016-06-20_7088ce06a738dcb3104c769adc11ac2c_z0-z5.mbtiles" "./export/tiles.mbtiles"

tileserver-gl-light export/tiles.mbtiles


http://localhost:8080/styles/basic-v9/?vector#9.5/41.7144/-71.3717

http://localhost:8080/styles/bright-v9/?vector#7.5/41.644/-71.245

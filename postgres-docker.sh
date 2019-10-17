# before running this, make sure stop the travis postgres
# sudo /etc/init.d/postgresql stop || true

docker pull postgres

# on macos, you can only run port forwards
docker run --name dbtest-postgres -p 5432:5432 -e POSTGRES_USER=travis -d postgres:latest

# retry until postgres is up (or 15 times)
sleep 5
n=0
until [ $n -ge 15 ]
do
  sh .postgres.reset.sh && break  # substitute your command here
  n=$[$n+1]
  sleep 5
done

# docker exec -it -e PGPASSWORD=r2N5y7V -e POSTGRES_USER=travis dbtest-postgres psql -U travis -c "CREATE USER IF NOT EXISTS travis@'%' IDENTIFIED BY ''; GRANT ALL ON *.* TO travis@'%'; FLUSH PRIVILEGES;"
#
# docker stop dbtest-postgres
# docker rm dbtest-postgres
#
# docker exec -it dbtest-postgres mysql -p6c9FT%Kj -e "DROP DATABASE nycflights;"

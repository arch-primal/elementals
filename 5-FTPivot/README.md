docker network create ftpivot
docker run -d --name ftpivot1 -p 2002:22 --network ftpivot kradbyte/ftpivot:pivot1
docker run -d --name ftpivot2 --network ftpivot kradbyte/ftpivot:pivot2

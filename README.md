# panfp
panfp is a Function Program E-C demo,backend writed by Haskell.

requirements: 

1.postgressql DB, should verified the connect string in "src/Lib.hs",like this ("host='127.0.0.1' user='test' dbname='test' password='111111'"),
create tables with "db.sql",used command postgresql "psql";

2.Haskell Stack package manager,and Haskell IDE for example IntelliJ IDEA,VS code.

status:

1.Offered a REST API with Scotty,return the result with popular json format;

2.The Order、OrderDetail、 Product、ProductDetail CRUD,with file server can provide service;
 

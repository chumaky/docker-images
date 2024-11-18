let objs = [
  {id: 1, name: "John"},
  {id: 2, name: "Mary"},
  {id: 3, name: "Peter"}
];

db.users.insertMany(objs);

/*
db.users.find()
db.users.insertOne({id: 5, name: 'zxcv'})
db.users.find()
*/

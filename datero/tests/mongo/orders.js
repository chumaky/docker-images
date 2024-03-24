// mongo database intialization script
let objs = [
  { id: 1, customer_id: 1, product_id: 1, employee_id: 1, quantity: 10 },
  { id: 2, customer_id: 1, product_id: 2, employee_id: 2, quantity: 2 },
  { id: 3, customer_id: 1, product_id: 3, employee_id: 3, quantity: 5 },
  { id: 4, customer_id: 2, product_id: 1, employee_id: 3, quantity: 5 },
  { id: 5, customer_id: 2, product_id: 3, employee_id: 2, quantity: 3 },
  { id: 6, customer_id: 3, product_id: 1, employee_id: 3, quantity: 8 }
];

db.orders.insertMany(objs);


**Inventory Management System**
  
-- Question-1: Checking Product Stock Levels.
```sql
select p.product_name, i.quantity from products as p join inventory as i on p.product_id=i.product_id
```
  
-- Results:
-- product_name|quantity|
-- ------------+--------+
-- Laptop      |      10|
-- Desk Chair  |      20|
-- Notebook    |     100|

  
-- Question-2: Decrease the quantity of the product with product_id 2 (desks) by 3 units after a sale.
-- Update Stock After a Sale.
```sql
update inventory 
set quantity = quantity-3
where product_id= 2;
```

-- Results:
-- inventory_id|product_id|quantity|supplier_id|last_updated|
-- ------------+----------+--------+-----------+------------+
--            1|         1|      10|	        1|	2025-07-13|
--            2|	       2|	     17|	        2|	2025-07-13|
--            3|       	 3|   	100|	        2|	2025-07-13|


-- Question-3: Increase the quantity of the product with product_id 1 (laptops) by 10 units after a purchase.
```sql
update inventory
set quantity = quantity+10
where product_id = 1;
```

-- Results:
-- inventory_id|product_id|quantity|supplier_id|last_updated|
-- ------------+----------+--------+-----------+------------+
--            1|         1|      20|	        1|	2025-07-13|
--            2|	       2|	     17|	        2|	2025-07-13|
--            3|       	 3|   	100|	        2|	2025-07-13|


-- Question-4: View Transaction History for the product_name Laptop.
```sql
select p.product_name, t.transaction_type, t.transaction_date, t.quantity 
from products as p join transactions as t 
on p.product_id=t.product_id
where p.product_id =1;
```

-- Results:
-- product_name|transaction_type|transaction_date|quantity|
-- ------------+----------------+----------------+--------+
-- Laptop      |purchase        |      2025-07-13|      10|
-- Laptop      |sale            |	     2025-07-13|	     5|


-- Question-5: Identify products that have stock levels below a certain threshold, such as 5 units.
```sql
select p.product_name, i.quantity from products as p join inventory as i on p.product_id=i.product_id
where i.quantity<5
```
  
-- Results:
-- product_name|quantity|
-- ------------+--------+
--             |        | -- No output was generated here because no product was less than 5 units

  
-- Question-6: Generate a report showing the total number of products sold in july 2025.
```sql
select p.product_name, sum(t.quantity) as total_quantity_sold
from products as p join transactions as t 
on p.product_id=t.product_id
where t.transaction_type ='sale' and t.transaction_date between '2025-07-01' and '2025-07-31'
group by p.product_name
```
  
-- Results:
-- product_name|total_quantity_sold|
-- ------------+-------------------+
-- Laptop      |                  5|


-- Question-7: Insert a new product 'Monitor' into the Products table with category 'Electronics' and price 150.00 and 
-- Insert an initial stock quantity of 20 for the new product in the Inventory table.
```sql
insert into products (product_name, category, price)
values ('Monitor', 'Electronics', 150.00);

insert into inventory (product_id, quantity)
values ((select product_id from products where product_name = 'Monitor'),20);

select * from inventory
select * from products
```
  
-- Results:
-- inventory_id|product_id|quantity|supplier_id|last_updated|
-- ------------+----------+--------+-----------+------------+
--            1|         1|      20|	        1|	2025-07-13|
--            2|	       2|	     17|	        2|	2025-07-13|
--            3|       	 3|   	100|	        2|	2025-07-13|
--            4|         4|      20|       NULL|	2025-07-13|
  
-- product_id|product_name|price   |category   |
-- ----------+------------+--------+-----------+
--          1|Laptop      | 1200.00|Electronics|
--          2|Desk Chair  |	 150.00|Furniture  |
--          3|Notebook    |    2.50|Stationery |
--          4|Monitor     |  150.00|Electronics|

  
-- Question-8: Delete product_id = 3 from the inventory table and from the products table.
```sql
delete from inventory
where product_id = 3

-- Step 1: Drop the existing FK    --(before deleting product_id from id we need to Drop the existing FK and then provide a new FK with on delete cascade so the query won't through an error)
Drop the existing FK
ALTER TABLE Transactions
DROP CONSTRAINT FK__Transacti__produ__4316F928;

-- Step 2: Add new FK with ON DELETE CASCADE
ALTER TABLE Transactions
ADD CONSTRAINT FK_Transactions_Products
FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE CASCADE;

delete from products
where product_id = 3

select * from inventory
select * from products
```
  
-- Results:
-- inventory_id|product_id|quantity|supplier_id|last_updated|
-- ------------+----------+--------+-----------+------------+
--            1|         1|      10|	        1|	2025-07-13|
--            2|	       2|	     17|	        2|	2025-07-13|
--            4|       	 4|   	 20|	     NULL|	2025-07-13|

-- product_id|product_name|price   |category    |
-- ----------+------------+--------+-----------+
--          1|Laptop      | 1200.00|Electronics|
--          2|Desk Chair  |	 150.00|Furniture  |
--          4|Monitor     |  150.00|Electronics|

  
-- Question-9: calculate total value for each product.
```sql
select p.product_name, i.quantity, p.price, (i.quantity * p.price) as total_value
from products as p join inventory as i on p.product_id=i.product_id;
```

-- Results:
-- product_name|quantity|price   |total_value|
-- ------------+--------+--------+-----------+
-- Laptop      |      20| 1200.00|   24000.00|
-- Desk Chair  |	    17|  150.00|    2550.00|
-- Monitor     |      20|  150.00|    3000.00|


-- Question-10: Show Products with Transactions to include all products, even those with no matching transactions.
```sql
select p.product_name from products as p left join transactions as t 
on p.product_id = t.product_id and t.transaction_type = 'sale'
group by p.product_name
having MAX(t.transaction_date) is null or MAX(t.transaction_date) < '2025-07-01';
```

-- Results:
-- product_name|
-- ------------+
-- Desk Chair  |
-- Monitor     |


-- Question-11:List Products with No Stock.
```sql
select p.product_name from Inventory as i join products as p on i.product_id = p.product_id
WHERE i.quantity = 0;
```

-- Results:
-- product_name|
-- ------------+
--             |   -- No output was generated here because no product quantity was zero


-- Question-12: View Stock Levels for Multiple Products.
```sql
select p.product_name, i.quantity from products as p join inventory as i on p.product_id=i.product_id
where p.product_id In (1,2)
```
-- Results:
-- product_name|quantity|
-- ------------+--------+
-- Laptop      |      20|
-- Desk Chair  |	    17|

  
-- Question-13: List All Products Sold Today.
```sql
select p.product_name, t.quantity
from Transactions as t
join Products p on t.product_id = p.product_id
where t.transaction_type = 'sale' and t.transaction_date = cast(getdate() as date);
```

-- Results:
-- product_name|quantity|
-- ------------+--------+
-- Laptop      |       5|


-- Question-14: Find the Most Sold Product.
```sql
select top 1 p.product_name, SUM(t.quantity) as total_sold
from products as p join transcations as t on t.product_id = p.product_id
where t.transaction_type = 'sale'
and t.transaction_date between '2025-07-01' and '2025-07-31'
group by p.product_name
order by total_sold desc
```
  
-- Results:
-- product_name|quantity|
-- ------------+--------+
-- Laptop      |       5|


-- Question-15: Calculate Total Revenue for a Given Period.
```sql
select sum(t.quantity * p.price) as total_revenue
from products as p join transactions as t
on p.product_id = t.product_id
WHERE t.transaction_type = 'sale'
AND t.transaction_date BETWEEN '2025-07-01' AND '2025-07-31';
```

-- Results:
-- total_revenue|
-- -------------+
--       6000.00|

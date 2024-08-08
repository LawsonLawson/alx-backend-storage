-- SQL script that creates a trigger to automatically decrease the quantity of an item
-- in the `items` table whenever a new order is added to the `orders` table.
-- The trigger performs the following actions:
--   - It is triggered before a new row is inserted into the `orders` table.
--   - For each new order, the trigger updates the `items` table by decreasing the quantity
--     of the ordered item based on the `number` of items specified in the new order.
--   - The `quantity` is decreased by the value in `NEW.number`, which refers to the number
--     of items ordered in the new order.
--   - The update is applied to the item whose `name` matches the `item_name` in the new order.

CREATE TRIGGER order_decrease 
BEFORE INSERT ON orders
FOR EACH ROW 
UPDATE items
SET quantity = quantity - NEW.number
WHERE name = NEW.item_name;

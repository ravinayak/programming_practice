1. Customers Table:
   • customer_id: Unique identifier for each customer.
   • customer_name: Name of the customer.
   • email: Email of the customer.
   • created_at: Date when the customer was added.
2. Products Table:
   • product_id: Unique identifier for each product.
   • product_name: Name of the product.
   • category: Category of the product (e.g., Electronics, Clothing).
   • price: Price of the product.
3. Suppliers Table:
   • supplier_id: Unique identifier for each supplier.
   • supplier_name: Name of the supplier.
   • contact_name: Contact person for the supplier.
4. Supplies Table:
   • supply_id: Unique identifier for each supply record.
   • supplier_id: Foreign key referencing the suppliers table.
   • product_id: Foreign key referencing the products table.
   • supply_date: Date when the product was supplied.
   • quantity_supplied: Quantity of the product supplied.
5. Orders Table:
   • order_id: Unique identifier for each order.
   • customer_id: Foreign key referencing the customers table.
   • order_date: Date when the order was placed.
   • total_amount: Total amount for the order.
6. Order Items Table:
   • order_item_id: Unique identifier for each order item.
   • order_id: Foreign key referencing the orders table.
   • product_id: Foreign key referencing the products table.
   • quantity: Quantity of the product ordered.
   • price: Price of the product ordered.

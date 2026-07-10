# CartFlow

CartFlow is a console-based Java application I built to simulate an e-commerce shopping cart system backed by a MySQL database. I developed this project to demonstrate core relational database concepts, including complex table relationships, JDBC integration, and ACID-compliant transaction management.

## Features

* **Command-Line Interface:** The application allows users to seamlessly add items to a cart, view product catalogs, and review past billing invoices.
* **Relational Schema Design:** The backend is powered by a 7-table MySQL schema that manages users, wallets, products, active carts, and historical bills.
* **Strict Transaction Handling:** The system utilizes JDBC manual commit controls (`setAutoCommit(false)`) to ensure data integrity during multi-step checkout processes.
* **Edge-Case Management:** The checkout process automatically intercepts insufficient funds, rolling back the transaction and dynamically replenishing product inventory.
* **Real-time Stock Validation:** The application prevents users from adding out-of-stock items or exceeding available inventory limits.

## Tech Stack

* **Language:** Java
* **Database:** MySQL / MariaDB
* **API:** Java Database Connectivity (JDBC)

## Setup and Installation

1. **Initialize the Database:**
   * Open your MySQL client.
   * Run the provided `schema.sql` script to create the `shopping_cart_db` database, establish the tables, and insert the initial seed data.
2. **Configure Credentials:**
   * Open `ShoppingCart.java`.
   * Update the `URL`, `USER`, and `PASS` constants to match your local MySQL configuration.
3. **Add the JDBC Driver:**
   * Ensure the MySQL Connector/J driver is included in your project's build path or classpath.
4. **Compile and Run:**
   * Compile the Java file: `javac ShoppingCart.java`
   * Run the application: `java ShoppingCart`

## Usage Example

Upon launching, the system displays a main menu. You can enter a user ID (for example, ID `1` or `2` from the seed data) to begin managing your cart and executing checkouts.

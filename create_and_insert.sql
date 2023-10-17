DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS accounts;
DROP TABLE IF EXISTS customers;
DROP TYPE IF EXISTS account_type;
DROP TYPE IF EXISTS transaction_type;

CREATE TABLE customers (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) NOT NULL,
	address TEXT NOT NULL,
	phone_number VARCHAR(20) NOT NULL,
	createdAt TIMESTAMP NOT NULL DEFAULT NOW(),
	updatedAt TIMESTAMP DEFAULT NOW()
);

CREATE TYPE account_type AS ENUM ('Tabungan', 'Giro', 'Deposito');
CREATE TABLE akun (
    id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(id) ON DELETE CASCADE,
	account_number VARCHAR(20) NOT NULL,
    type account_type,
    balance NUMERIC(12, 2) DEFAULT 0.00,
    createdAt TIMESTAMP NOT NULL DEFAULT NOW(),
    updatedAt TIMESTAMP DEFAULT NOW()
);
ALTER TABLE akun RENAME TO accounts;

CREATE TYPE transaction_type AS ENUM ('debit', 'credit', 'transfer');
CREATE TABLE transactions (
    id SERIAL PRIMARY KEY,
    account_id INT REFERENCES accounts(id) ON DELETE CASCADE,
	amount NUMERIC(12, 2) NOT NULL,
	type transaction_type,
    createdAt TIMESTAMP NOT NULL DEFAULT NOW(),
    updatedAt TIMESTAMP DEFAULT NOW()
);

CREATE INDEX index_customers ON "customers" (id);
CREATE INDEX index_account ON "accounts" (id);
CREATE INDEX index_transaction ON "transactions" (id);

INSERT INTO customers (name, address, phone_number) VALUES
('Agi Sahriza', 'Banjarmasin', '085849314100'),
('Daan Nor', 'Handil Bakti', '081234567'),
('Budi Badali', 'Banjarbaru', '084422567');

INSERT INTO accounts (customer_id, account_number, type) VALUES
(1, '1234567', 'Tabungan'),
(2, '1357911', 'Tabungan'),
(1, '2468910', 'Deposito');

INSERT INTO transactions (account_id, amount, type) VALUES
(1, 1000000, 'credit'),
(1, 100000, 'debit'),
(2, 500000, 'credit');

SELECT * FROM customers;

UPDATE customers SET name = 'Daan Nur', updatedAt = NOW() WHERE id = 2;
UPDATE accounts SET balance = 900000, updatedAt = NOW() WHERE id = 1;
UPDATE accounts SET balance = 500000, updatedAt = NOW() WHERE id = 2;

SELECT
    customers.name,
    customers.address,
    customers.phone_number,
	accounts.account_number,
    accounts.type,
	accounts.balance
FROM customers
JOIN accounts ON customers.id = accounts.customer_id;

DELETE FROM customers WHERE id = 3;
	
SELECT
    customers.name,
    customers.address,
    customers.phone_number,
	accounts.account_number,
    accounts.type,
	accounts.balance
FROM
    customers
JOIN
    accounts ON customers.id = accounts.customer_id;
	
SELECT
    customers.name,
	accounts.account_number,
	transactions.amount
FROM
    customers
JOIN
    accounts ON customers.id = accounts.customer_id
JOIN
    transactions ON accounts.id = transactions.account_id;
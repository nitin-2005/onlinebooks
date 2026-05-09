CREATE DATABASE if not exists onlinebooks;

USE onlinebooks;

CREATE TABLE if not exists books 
  ( 
     barcode   VARCHAR(100) PRIMARY KEY, 
     name      TEXT NOT NULL, 
     author    VARCHAR(100) NOT NULL, 
     price     INT, 
     quantity  REAL
  ); 
  
  CREATE TABLE if not exists users
  ( 
     username  VARCHAR(100) PRIMARY KEY, 
     password  VARCHAR(100) NOT NULL, 
     firstname VARCHAR(100) NOT NULL, 
     lastname  VARCHAR(100) NOT NULL, 
     address   TEXT NOT NULL, 
     phone     VARCHAR(100) NOT NULL, 
     mailid    VARCHAR(100) NOT NULL,
     usertype  INT
  );

  CREATE TABLE if not exists orders
  (
     order_id       VARCHAR(100) PRIMARY KEY,
     username       VARCHAR(100) NOT NULL,
     order_date     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
     total_amount   DECIMAL(10,2) NOT NULL,
     status         VARCHAR(50) DEFAULT 'PENDING',
     FOREIGN KEY (username) REFERENCES users(username) ON DELETE CASCADE
  );

  CREATE TABLE if not exists order_items
  (
     item_id        INT AUTO_INCREMENT PRIMARY KEY,
     order_id       VARCHAR(100) NOT NULL,
     barcode        VARCHAR(100) NOT NULL,
     quantity       INT NOT NULL,
     price          DECIMAL(10,2) NOT NULL,
     FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
     FOREIGN KEY (barcode) REFERENCES books(barcode) ON DELETE CASCADE
  );

  CREATE TABLE if not exists reviews
  (
     review_id      INT AUTO_INCREMENT PRIMARY KEY,
     barcode        VARCHAR(100) NOT NULL,
     username       VARCHAR(100) NOT NULL,
     rating         INT CHECK (rating >= 1 AND rating <= 5),
     review_text    TEXT,
     review_date    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
     FOREIGN KEY (barcode) REFERENCES books(barcode) ON DELETE CASCADE,
     FOREIGN KEY (username) REFERENCES users(username) ON DELETE CASCADE
  );
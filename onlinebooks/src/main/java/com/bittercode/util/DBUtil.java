package com.bittercode.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

import com.bittercode.constant.ResponseCode;
import com.bittercode.model.StoreException;

public class DBUtil {

    private static Connection connection;

    static {

        try {

            Class.forName(DatabaseConfig.DRIVER_NAME);
            
            connection = DriverManager.getConnection(DatabaseConfig.CONNECTION_STRING, DatabaseConfig.DB_USER_NAME,
                    DatabaseConfig.DB_PASSWORD);
        } catch (SQLException | ClassNotFoundException e) {

            e.printStackTrace();

        }

        try {
            if (connection != null) {
                // Create tables if they do not exist
                try {
                    connection.createStatement().execute("CREATE TABLE IF NOT EXISTS books(barcode varchar(100) primary key, name varchar(100), author varchar(100), price int, quantity int)");
                } catch (Exception ignore) {}
                try {
                    connection.createStatement().execute("CREATE TABLE IF NOT EXISTS users(username varchar(100) primary key,password varchar(100), firstname varchar(100),lastname varchar(100),address text, phone varchar(100),mailid varchar(100),usertype int)");
                } catch (Exception ignore) {}
                
                // Add new columns if needed
                try {
                    connection.createStatement().execute("ALTER TABLE books ADD COLUMN image_path VARCHAR(255)");
                } catch (Exception ignore) {}
                try {
                    connection.createStatement().execute("ALTER TABLE books ADD COLUMN pdf_path VARCHAR(255)");
                } catch (Exception ignore) {}
                try {
                    connection.createStatement().execute("ALTER TABLE users ADD COLUMN profile_image VARCHAR(255)");
                } catch (Exception ignore) {}
                
                // Create orders table
                try {
                    connection.createStatement().execute("CREATE TABLE IF NOT EXISTS orders (order_id VARCHAR(50) PRIMARY KEY, customer_email VARCHAR(100), order_date VARCHAR(50), total_amount DOUBLE, items_json TEXT)");
                } catch (Exception ignore) {}
                
                // Insert default Admin user if it doesn't exist
                try {
                    connection.createStatement().execute("INSERT INTO users (username, password, firstname, lastname, address, phone, mailid, usertype) VALUES ('Admin', 'Admin', 'Mr.', 'Admin', 'Haldia WB', '9584552224521', 'admin@gmail.com', 1)");
                } catch (Exception ignore) {}
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

    }// End of static block

    public static Connection getConnection() throws StoreException {

        if (connection == null) {
            throw new StoreException(ResponseCode.DATABASE_CONNECTION_FAILURE);
        }

        return connection;
    }

}

package com.bittercode.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.bittercode.model.Cart;
import com.bittercode.model.Order;
import com.bittercode.util.DBUtil;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

public class OrderDAO {

    public boolean saveOrder(Order order, String customerEmail) {
        boolean success = false;
        try {
            Connection con = DBUtil.getConnection();
            String query = "INSERT INTO orders (order_id, customer_email, order_date, total_amount, items_json) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, order.getOrderId());
            ps.setString(2, customerEmail);
            ps.setString(3, order.getDate());
            ps.setDouble(4, order.getTotalAmount());
            
            // Convert List<Cart> to JSON string
            Gson gson = new Gson();
            String itemsJson = gson.toJson(order.getItems());
            ps.setString(5, itemsJson);
            
            int result = ps.executeUpdate();
            if (result > 0) {
                success = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return success;
    }

    public List<Order> getOrdersByUser(String customerEmail) {
        List<Order> orderList = new ArrayList<>();
        try {
            Connection con = DBUtil.getConnection();
            String query = "SELECT * FROM orders WHERE customer_email = ? ORDER BY order_date DESC";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, customerEmail);
            ResultSet rs = ps.executeQuery();
            
            Gson gson = new Gson();
            while (rs.next()) {
                Order order = new Order();
                order.setOrderId(rs.getString("order_id"));
                order.setDate(rs.getString("order_date"));
                order.setTotalAmount(rs.getDouble("total_amount"));
                
                String itemsJson = rs.getString("items_json");
                List<Cart> items = gson.fromJson(itemsJson, new TypeToken<List<Cart>>(){}.getType());
                order.setItems(items);
                
                orderList.add(order);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return orderList;
    }
}
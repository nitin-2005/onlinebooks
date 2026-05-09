package servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.bittercode.util.DBUtil;

public class AdminExportServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", "attachment; filename=\"users_sellers_report.csv\"");
        
        try (PrintWriter writer = response.getWriter()) {
            writer.println("Username,First Name,Last Name,Email,Phone,Address,Role");
            
            Connection con = DBUtil.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM users");
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                String username = rs.getString("username");
                String firstName = rs.getString("firstname");
                String lastName = rs.getString("lastname");
                String email = rs.getString("mailid");
                String phone = rs.getString("phone");
                String address = rs.getString("address").replace(",", " "); // escape commas
                int userType = rs.getInt("usertype");
                
                String role = "Customer";
                if (userType == 1) role = "Admin/Seller";
                
                writer.printf("%s,%s,%s,%s,%s,%s,%s\n", username, firstName, lastName, email, phone, address, role);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

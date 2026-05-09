package servlets;

import java.io.IOException;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.sql.Connection;
import java.sql.PreparedStatement;
import com.bittercode.util.DBUtil;

public class CustomerRegisterServlet extends HttpServlet {

    public void service(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
        String uName = req.getParameter("username");
        String pWord = req.getParameter("password");
        String fName = req.getParameter("firstname");
        String lName = req.getParameter("lastname");
        String addr = req.getParameter("address");
        String phNo = req.getParameter("phone");
        String mailId = req.getParameter("mailid");
        String userTypeStr = req.getParameter("usertype");
        
        int userType = 3; // Default Customer
        if (userTypeStr != null) {
            userType = Integer.parseInt(userTypeStr);
        }

        try {
            Connection con = DBUtil.getConnection();
            PreparedStatement ps = con.prepareStatement("INSERT INTO users (username, password, firstname, lastname, address, phone, mailid, usertype) VALUES (?, ?, ?, ?, ?, ?, ?, ?)");
            ps.setString(1, uName);
            ps.setString(2, pWord);
            ps.setString(3, fName);
            ps.setString(4, lName);
            ps.setString(5, addr);
            ps.setString(6, phNo);
            ps.setString(7, mailId);
            ps.setInt(8, userType);
            
            int k = ps.executeUpdate();
            if (k > 0) {
                // Send Welcome Email Asynchronously
                final String userEmail = mailId;
                final String userFirstName = fName;
                new Thread(() -> {
                    String subject = "Welcome to OnlineBooks!";
                    String body = "<h3>Dear " + userFirstName + ",</h3>"
                                + "<p>Welcome to <strong>OnlineBooks</strong>! Your account has been successfully created.</p>"
                                + "<p>Start exploring our massive collection of books and enjoy an uninterrupted reading experience.</p>"
                                + "<br><p>Best Regards,<br>The OnlineBooks Team</p>";
                    com.bittercode.util.EmailUtil.sendEmail(userEmail, subject, body);
                }).start();

                req.setAttribute("successMessage", "Registration Successful! Please login.");
                RequestDispatcher rd = req.getRequestDispatcher("login.jsp");
                rd.forward(req, res);
            } else {
                req.setAttribute("errorMessage", "Registration Failed. Please try again.");
                RequestDispatcher rd = req.getRequestDispatcher("register.jsp");
                rd.forward(req, res);
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "Error: Username might already exist.");
            RequestDispatcher rd = req.getRequestDispatcher("register.jsp");
            rd.forward(req, res);
        }
    }
}
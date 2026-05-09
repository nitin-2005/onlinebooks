package servlets;

import java.io.IOException;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.bittercode.model.User;
import com.bittercode.model.UserRole;
import com.bittercode.service.UserService;
import com.bittercode.service.impl.UserServiceImpl;
import java.sql.Connection;
import java.sql.PreparedStatement;
import com.bittercode.util.DBUtil;

public class CustomerLoginServlet extends HttpServlet {

    UserService authService = new UserServiceImpl();

    public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
        String uName = req.getParameter("username");
        String pWord = req.getParameter("password");
        
        // Since we unified login, we check roles manually to set correct session
        try {
            Connection con = DBUtil.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT usertype, firstname, mailid FROM users WHERE username=? AND password=?");
            ps.setString(1, uName);
            ps.setString(2, pWord);
            java.sql.ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                int role = rs.getInt("usertype");
                String fname = rs.getString("firstname");
                String email = rs.getString("mailid");
                
                req.getSession().setAttribute("USERNAME", uName); // Save ID
                req.getSession().setAttribute("USER_EMAIL", email); // Save actual email for notifications

                if (role == 1) { // Admin
                    req.getSession().setAttribute("ADMIN", fname);
                    res.sendRedirect(req.getContextPath() + "/admin-dashboard");
                } else if (role == 2) { // Seller
                    req.getSession().setAttribute("SELLER", fname);
                    res.sendRedirect(req.getContextPath() + "/seller-dashboard.jsp");
                } else { // Customer
                    req.getSession().setAttribute("CUSTOMER", fname);
                    res.sendRedirect(req.getContextPath() + "/customer-dashboard.jsp");
                }
            } else {
                req.setAttribute("errorMessage", "Invalid Username or Password");
                RequestDispatcher rd = req.getRequestDispatcher("login.jsp");
                rd.forward(req, res);
            }
        } catch(Exception e) {
            e.printStackTrace();
            res.sendRedirect("login.jsp");
        }
    }
}
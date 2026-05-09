package servlets;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.bittercode.service.UserService;
import com.bittercode.service.impl.UserServiceImpl;

public class AdminUserManageServlet extends HttpServlet {

    private UserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        doPost(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        HttpSession session = req.getSession();
        
        // Ensure Admin is logged in
        if (session.getAttribute("ADMIN") == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String action = req.getParameter("action");
        String username = req.getParameter("username");

        if ("delete".equals(action) && username != null) {
            try {
                userService.deleteUser(username);
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else if ("update".equals(action) && username != null) {
            try {
                com.bittercode.model.User user = new com.bittercode.model.User();
                user.setEmailId(username);
                user.setFirstName(req.getParameter("firstName"));
                user.setLastName(req.getParameter("lastName"));
                user.setPhone(Long.parseLong(req.getParameter("phone")));
                user.setAddress(req.getParameter("address"));
                user.setUserType(Integer.parseInt(req.getParameter("userType")));
                userService.updateUser(user);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        // Redirect back to Admin Dashboard
        res.sendRedirect(req.getContextPath() + "/admin-dashboard");
    }
}

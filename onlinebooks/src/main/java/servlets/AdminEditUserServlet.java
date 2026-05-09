package servlets;

import java.io.IOException;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.bittercode.model.User;
import com.bittercode.service.UserService;
import com.bittercode.service.impl.UserServiceImpl;

public class AdminEditUserServlet extends HttpServlet {

    private UserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        HttpSession session = req.getSession();
        
        // Ensure Admin is logged in
        if (session.getAttribute("ADMIN") == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String username = req.getParameter("username");
        
        try {
            if (username != null && !username.trim().isEmpty()) {
                User user = userService.getUserByEmailId(username);
                req.setAttribute("user", user);
            }
            RequestDispatcher dispatcher = req.getRequestDispatcher("/updateuser.jsp");
            dispatcher.forward(req, res);
        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect(req.getContextPath() + "/admin-dashboard");
        }
    }
}

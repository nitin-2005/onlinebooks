package servlets;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.bittercode.model.Book;
import com.bittercode.model.User;
import com.bittercode.service.BookService;
import com.bittercode.service.UserService;
import com.bittercode.service.impl.BookServiceImpl;
import com.bittercode.service.impl.UserServiceImpl;

public class AdminDashboardServlet extends HttpServlet {

    private UserService userService = new UserServiceImpl();
    private BookService bookService = new BookServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        HttpSession session = req.getSession();
        
        // Ensure Admin is logged in
        if (session.getAttribute("ADMIN") == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        try {
            List<User> users = userService.getAllUsers();
            List<Book> books = bookService.getAllBooks();

            int totalUsers = users.size();
            int activeSellers = 0;
            
            for (User u : users) {
                if (u.getUserType() == 1 || u.getUserType() == 2) {
                    // Assuming 1 = Admin, 2 = Seller
                    activeSellers++;
                }
            }

            // Mock Revenue for now
            int totalRevenue = 45200;

            req.setAttribute("users", users);
            req.setAttribute("books", books);
            req.setAttribute("totalUsers", totalUsers);
            req.setAttribute("activeSellers", activeSellers);
            req.setAttribute("totalRevenue", totalRevenue);

            RequestDispatcher dispatcher = req.getRequestDispatcher("/admin-dashboard.jsp");
            dispatcher.forward(req, res);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "Error loading dashboard data.");
            req.getRequestDispatcher("/admin-dashboard.jsp").forward(req, res);
        }
    }
}

package servlets;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.bittercode.service.BookService;
import com.bittercode.service.impl.BookServiceImpl;

public class AdminManageBookServlet extends HttpServlet {

    private BookService bookService = new BookServiceImpl();

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
        String bookId = req.getParameter("bookId");

        if ("delete".equals(action) && bookId != null) {
            try {
                bookService.deleteBookById(bookId);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        // Redirect back to Admin Dashboard
        res.sendRedirect(req.getContextPath() + "/admin-dashboard");
    }
}

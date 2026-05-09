package servlets;

import java.io.IOException;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.bittercode.model.Book;
import com.bittercode.service.BookService;
import com.bittercode.service.impl.BookServiceImpl;

public class AdminEditBookServlet extends HttpServlet {

    private BookService bookService = new BookServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        HttpSession session = req.getSession();
        
        // Ensure Admin is logged in
        if (session.getAttribute("ADMIN") == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String bookId = req.getParameter("bookId");
        
        try {
            if (bookId != null && !bookId.trim().isEmpty()) {
                Book book = bookService.getBookById(bookId);
                req.setAttribute("book", book);
            }
            RequestDispatcher dispatcher = req.getRequestDispatcher("/updatebook.jsp");
            dispatcher.forward(req, res);
        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect(req.getContextPath() + "/admin-dashboard");
        }
    }
}

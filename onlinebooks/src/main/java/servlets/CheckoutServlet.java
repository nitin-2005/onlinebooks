package servlets;

import java.io.IOException;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class CheckoutServlet extends HttpServlet {
    public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
        if (req.getSession().getAttribute("CUSTOMER") == null && req.getSession().getAttribute("SELLER") == null) {
            res.sendRedirect("login.jsp");
            return;
        }
        RequestDispatcher rd = req.getRequestDispatcher("checkout.jsp");
        rd.forward(req, res);
    }
    public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
        doGet(req, res);
    }
}

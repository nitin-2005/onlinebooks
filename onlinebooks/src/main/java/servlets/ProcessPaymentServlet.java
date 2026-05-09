package servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.ArrayList;
import java.util.UUID;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.bittercode.constant.BookStoreConstants;
import com.bittercode.dao.OrderDAO;
import com.bittercode.model.Book;
import com.bittercode.model.Cart;
import com.bittercode.model.Order;
import com.bittercode.model.UserRole;
import com.bittercode.service.BookService;
import com.bittercode.service.impl.BookServiceImpl;
import com.bittercode.util.StoreUtil;

public class ProcessPaymentServlet extends HttpServlet {

    BookService bookService = new BookServiceImpl();

    @SuppressWarnings("unchecked")
    public void service(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
        PrintWriter pw = res.getWriter();
        res.setContentType(BookStoreConstants.CONTENT_TYPE_TEXT_HTML);
        if (!StoreUtil.isLoggedIn(UserRole.CUSTOMER, req.getSession())) {
            RequestDispatcher rd = req.getRequestDispatcher("CustomerLogin.html");
            rd.include(req, res);
            pw.println("<table class=\"tab\"><tr><td>Please Login First to Continue!!</td></tr></table>");
            return;
        }
        try {

            HttpSession session = req.getSession();
            List<Cart> cartItems = null;
            if (session.getAttribute("cartItems") != null)
                cartItems = (List<Cart>) session.getAttribute("cartItems");
                
            StringBuilder receiptHtml = new StringBuilder();
            receiptHtml.append("<h3>Dear Customer,</h3>");
            receiptHtml.append("<p>Thank you for shopping at <strong>OnlineBooks</strong>. Your order has been placed successfully!</p>");
            receiptHtml.append("<table border='1' cellpadding='10' cellspacing='0'><tr><th>Book</th><th>Author</th><th>Price</th><th>Quantity</th></tr>");

            double totalAmount = 0;
            if (cartItems != null) {
                for (Cart cart : cartItems) {
                    Book book = cart.getBook();
                    double bPrice = book.getPrice();
                    String bCode = book.getBarcode();
                    String bName = book.getName();
                    String bAuthor = book.getAuthor(); // Assuming author might be used as Seller ID/Name in this project
                    int availableQty = book.getQuantity();
                    int qtToBuy = cart.getQuantity();
                    availableQty = availableQty - qtToBuy;
                    bookService.updateBookQtyById(bCode, availableQty);
                    
                    // --- Platform Commission Logic (5% to Admin, 95% to Seller) ---
                    double itemTotal = bPrice * qtToBuy;
                    double adminCommission = itemTotal * 0.05;
                    double sellerRevenue = itemTotal * 0.95;
                    System.out.println("Sale Processed for Book: " + bName);
                    System.out.println("-> Total Amount: Rs. " + itemTotal);
                    System.out.println("-> Transferred to Admin Account (5%): Rs. " + String.format("%.2f", adminCommission));
                    System.out.println("-> Transferred to Seller Account (95%): Rs. " + String.format("%.2f", sellerRevenue));
                    // --------------------------------------------------------------
                    
                    receiptHtml.append("<tr><td>").append(bName).append("</td><td>").append(bAuthor).append("</td><td>Rs. ").append(bPrice).append("</td><td>").append(qtToBuy).append("</td></tr>");
                    totalAmount += itemTotal;
                    
                    session.removeAttribute("qty_" + bCode);
                }
            }
            
            receiptHtml.append("</table>");
            receiptHtml.append("<h4>Total Amount Paid: Rs. ").append(totalAmount).append("</h4>");
            receiptHtml.append("<br><p>Best Regards,<br>The OnlineBooks Team</p>");
            
            // Send Order Confirmation Email Asynchronously
            String userEmail = (String) session.getAttribute("USER_EMAIL");
            final String username = (String) session.getAttribute("USERNAME");
            
            if (userEmail == null && username != null) {
                // Fallback if session doesn't have USER_EMAIL (e.g. user was logged in before update)
                try (java.sql.Connection con = com.bittercode.util.DBUtil.getConnection();
                     java.sql.PreparedStatement ps = con.prepareStatement("SELECT mailid FROM users WHERE username=?")) {
                    ps.setString(1, username);
                    java.sql.ResultSet rs = ps.executeQuery();
                    if (rs.next()) {
                        userEmail = rs.getString("mailid");
                    }
                } catch (Exception e) { e.printStackTrace(); }
            }

            final String finalEmail = userEmail;
            if (finalEmail != null && finalEmail.contains("@")) {
                new Thread(() -> {
                    com.bittercode.util.EmailUtil.sendEmail(finalEmail, "OnlineBooks Order Confirmation", receiptHtml.toString());
                }).start();
            }

            // Save Order to Session for the My Orders tab
            if (cartItems != null && !cartItems.isEmpty()) {

                String newOrderId = "ORD-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
                String currentDate = LocalDate.now().format(DateTimeFormatter.ofPattern("dd MMM yyyy"));

                Order newOrder = new Order(newOrderId, currentDate, totalAmount, new ArrayList<>(cartItems));

                // ✅ SAVE IN DATABASE
                OrderDAO dao = new OrderDAO();
                dao.saveOrder(newOrder, userEmail);

                session.setAttribute("paymentSuccessMessage", "Order placed successfully!");
            }

            session.removeAttribute("amountToPay");
            session.removeAttribute("cartItems");
            session.removeAttribute("items");
            session.removeAttribute("selectedBookId");
            
            res.sendRedirect(req.getContextPath() + "/customer-dashboard.jsp?activeTab=tab-orders");
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

package servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.bittercode.model.Book;
import com.bittercode.model.UserRole;
import com.bittercode.service.BookService;
import com.bittercode.service.impl.BookServiceImpl;
import com.bittercode.util.StoreUtil;

public class StoreBookServlet extends HttpServlet {


BookService bookService = new BookServiceImpl();

public void service(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {

    res.setContentType("text/html");
    PrintWriter pw = res.getWriter();

    // 🔐 LOGIN CHECK
    if (!StoreUtil.isLoggedIn(UserRole.SELLER, req.getSession())) {
        RequestDispatcher rd = req.getRequestDispatcher("SellerLogin.html");
        rd.include(req, res);
        pw.println("<h3 style='color:red;text-align:center;'>Please Login First!</h3>");
        return;
    }

    try {

        RequestDispatcher rd = req.getRequestDispatcher("SellerHome.html");
        rd.include(req, res);

        pw.println("<div class='container'>");

        // Active tab highlight
        StoreUtil.setActiveTab(pw, "storebooks");

        List<Book> books = bookService.getAllBooks();

        pw.println("<h2 style='text-align:center;background:grey;color:white;padding:10px;'>Books Available</h2>");

        pw.println("<table class='table table-hover' style='background:white'>");
        pw.println("<thead style='background:black;color:white;'>");
        pw.println("<tr>");
        pw.println("<th>ID</th>");
        pw.println("<th>Image</th>");
        pw.println("<th>Name</th>");
        pw.println("<th>Author</th>");
        pw.println("<th>Price</th>");
        pw.println("<th>Qty</th>");
        pw.println("<th>Action</th>");
        pw.println("</tr>");
        pw.println("</thead>");
        pw.println("<tbody>");

        if (books == null || books.isEmpty()) {
            pw.println("<tr><td colspan='7' style='text-align:center;color:red;'>No Books Available</td></tr>");
        } else {

            // ✅ FIXED LOOP
            for (Book book : books) {
                pw.println(getRowData(book, req.getContextPath()));
            }
        }

        pw.println("</tbody></table>");
        pw.println("</div>");

    } catch (Exception e) {
        e.printStackTrace();
        pw.println("<h3 style='color:red'>Error loading books</h3>");
    }
}

// ✅ FINAL FIXED METHOD
public String getRowData(Book book, String contextPath) {

    String imageName = (book.getImagePath() != null) ? book.getImagePath() : "default.png";
    String imgPath = contextPath + "/uploads/" + imageName;

    return "<tr>"
            + "<td>" + book.getBarcode() + "</td>"
            + "<td><img src='" + imgPath + "' width='60' height='80' style='border-radius:5px'/></td>"
            + "<td>" + book.getName() + "</td>"
            + "<td>" + book.getAuthor() + "</td>"
            + "<td>₹ " + book.getPrice() + "</td>"
            + "<td>" + book.getQuantity() + "</td>"
            + "<td>"
            + "<form method='post' action='updatebook'>"
            + "<input type='hidden' name='bookId' value='" + book.getBarcode() + "'/>"
            + "<button class='btn btn-success'>Update</button>"
            + "</form>"
            + "</td>"
            + "</tr>";
}


}

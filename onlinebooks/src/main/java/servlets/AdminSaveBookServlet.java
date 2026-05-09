package servlets;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import com.bittercode.model.Book;
import com.bittercode.service.BookService;
import com.bittercode.service.impl.BookServiceImpl;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 50,       // 50MB
    maxRequestSize = 1024 * 1024 * 100    // 100MB
)
public class AdminSaveBookServlet extends HttpServlet {

    private BookService bookService = new BookServiceImpl();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        HttpSession session = req.getSession();
        
        // Ensure Admin or Seller is logged in
        if (session.getAttribute("ADMIN") == null && session.getAttribute("SELLER") == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String action = req.getParameter("action");
        String bName = req.getParameter("name");
        String bAuthor = req.getParameter("author");
        
        try {
            double bPrice = Double.parseDouble(req.getParameter("price"));
            int bQty = Integer.parseInt(req.getParameter("quantity"));

            // File Upload Logic
            String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdir();
            
            String imagePath = null;
            String pdfPath = null;
            
            Part imagePart = req.getPart("image");
            if (imagePart != null && imagePart.getSize() > 0) {
                String fileName = UUID.randomUUID().toString() + "_" + Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
                File file = new File(uploadPath + File.separator + fileName);
                try (InputStream input = imagePart.getInputStream()) {
                    Files.copy(input, file.toPath(), StandardCopyOption.REPLACE_EXISTING);
                }
                imagePath = "uploads/" + fileName;
            }

            Part pdfPart = req.getPart("pdf");
            if (pdfPart != null && pdfPart.getSize() > 0) {
                String fileName = UUID.randomUUID().toString() + "_" + Paths.get(pdfPart.getSubmittedFileName()).getFileName().toString();
                File file = new File(uploadPath + File.separator + fileName);
                try (InputStream input = pdfPart.getInputStream()) {
                    Files.copy(input, file.toPath(), StandardCopyOption.REPLACE_EXISTING);
                }
                pdfPath = "uploads/" + fileName;
            }

            if ("add".equals(action)) {
                String bCode = UUID.randomUUID().toString();
                Book book = new Book(bCode, bName, bAuthor, bPrice, bQty, imagePath, pdfPath);
                bookService.addBook(book);
            } else if ("update".equals(action)) {
                String bCode = req.getParameter("barcode");
                
                // If files weren't updated, keep old ones (fetch existing book first)
                if (imagePath == null || pdfPath == null) {
                    Book existingBook = bookService.getBookById(bCode);
                    if (imagePath == null && existingBook != null) imagePath = existingBook.getImagePath();
                    if (pdfPath == null && existingBook != null) pdfPath = existingBook.getPdfPath();
                }
                
                Book book = new Book(bCode, bName, bAuthor, bPrice, bQty, imagePath, pdfPath);
                bookService.updateBook(book);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Redirect back to respective Dashboard after save
        if (session.getAttribute("ADMIN") != null) {
            res.sendRedirect(req.getContextPath() + "/admin-dashboard");
        } else {
            res.sendRedirect(req.getContextPath() + "/seller-dashboard.jsp");
        }
    }
}

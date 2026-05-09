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

import com.bittercode.model.User;
import com.bittercode.service.UserService;
import com.bittercode.service.impl.UserServiceImpl;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 20     // 20MB
)
public class CustomerProfileServlet extends HttpServlet {

    private UserService userService = new UserServiceImpl();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        HttpSession session = req.getSession();
        String customerEmail = (String) session.getAttribute("USERNAME");
        
        if (customerEmail == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        try {
            User user = userService.getUserByEmailId(customerEmail);
            if (user != null) {
                // Handle text updates
                String action = req.getParameter("action");
                if ("updateProfile".equals(action)) {
                    user.setFirstName(req.getParameter("firstName"));
                    user.setLastName(req.getParameter("lastName"));
                    user.setPhone(Long.parseLong(req.getParameter("phone")));
                    user.setAddress(req.getParameter("address"));
                    
                    // Handle profile image upload
                    Part imagePart = req.getPart("profileImage");
                    if (imagePart != null && imagePart.getSize() > 0) {
                        String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
                        File uploadDir = new File(uploadPath);
                        if (!uploadDir.exists()) uploadDir.mkdir();
                        
                        String fileName = "profile_" + UUID.randomUUID().toString() + "_" + Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
                        File file = new File(uploadPath + File.separator + fileName);
                        
                        try (InputStream input = imagePart.getInputStream()) {
                            Files.copy(input, file.toPath(), StandardCopyOption.REPLACE_EXISTING);
                        }
                        user.setProfileImage("uploads/" + fileName);
                    }

                    // Save to Database
                    userService.updateUser(user);
                    
                } else if ("deleteAccount".equals(action)) {
                    userService.deleteUser(customerEmail);
                    session.invalidate();
                    res.sendRedirect(req.getContextPath() + "/login.jsp");
                    return;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Redirect back to dashboard
        String activeTab = req.getParameter("activeTab");
        if (activeTab == null) activeTab = "tab-profile";
        res.sendRedirect(req.getContextPath() + "/customer-dashboard.jsp?activeTab=" + activeTab);
    }
}

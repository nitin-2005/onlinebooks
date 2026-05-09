package servlets;

import java.io.IOException;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.bittercode.util.EmailUtil;

@WebServlet("/contactus")
public class ContactUsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String message = request.getParameter("message");

        if (name == null || email == null || message == null || name.isEmpty() || email.isEmpty() || message.isEmpty()) {
            request.setAttribute("error", "All fields are required!");
            RequestDispatcher rd = request.getRequestDispatcher("contact.jsp");
            rd.forward(request, response);
            return;
        }

        try {
            // Setup email details
            String subject = "New Contact Us Message from " + name;
            String bodyHtml = "<div style='font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #ddd; border-radius: 10px;'>"
                    + "<h2 style='color: #b45309;'>New Contact Form Submission</h2>"
                    + "<p><strong>Name:</strong> " + name + "</p>"
                    + "<p><strong>Email:</strong> " + email + "</p>"
                    + "<div style='background-color: #f9fafb; padding: 15px; border-left: 4px solid #b45309; margin-top: 20px;'>"
                    + "<p style='margin-top: 0;'><strong>Message:</strong></p>"
                    + "<p style='white-space: pre-wrap;'>" + message.replace("\n", "<br>") + "</p>"
                    + "</div>"
                    + "<p style='font-size: 12px; color: #6b7280; margin-top: 30px;'>This email was generated from the OnlineBooks Contact Us page.</p>"
                    + "</div>";

            // Sending email to Nitin (admin)
            EmailUtil.sendEmail("nitintiwari9062@gmail.com", subject, bodyHtml);

            // Forward back to contact page with success message
            request.setAttribute("message", "Your message has been sent successfully! We will get back to you soon.");
            RequestDispatcher rd = request.getRequestDispatcher("contact.jsp");
            rd.forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while sending your message. Please try again later.");
            RequestDispatcher rd = request.getRequestDispatcher("contact.jsp");
            rd.forward(request, response);
        }
    }
}

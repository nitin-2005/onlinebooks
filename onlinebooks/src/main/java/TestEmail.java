import java.util.Properties;
import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

public class TestEmail {

    private static final String SMTP_EMAIL = "nitintiwari9062@gmail.com";
    private static final String SMTP_PASSWORD = "pienumacayxoghbe"; 

    public static void main(String[] args) {
        String toEmail = "nitintiwari9062@gmail.com"; // sending to self for testing
        String subject = "Test Email from Bookstore System";
        String bodyHtml = "<h1>This is a test email</h1><p>Checking if SMTP works.</p>";

        System.out.println("Starting email test...");

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SMTP_EMAIL, SMTP_PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SMTP_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject);
            message.setContent(bodyHtml, "text/html; charset=utf-8");

            Transport.send(message);
            System.out.println("Email sent successfully to: " + toEmail);
            
        } catch (MessagingException e) {
            System.err.println("Failed to send email to: " + toEmail);
            e.printStackTrace();
        }
    }
}

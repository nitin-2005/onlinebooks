package com.bittercode.util;

import java.util.Properties;
import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

public class EmailUtil {

    // IMPORTANT: REPLACE THIS EMAIL PLACEHOLDER BEFORE TESTING
    private static final String SMTP_EMAIL = "nitintiwari9062@gmail.com";
    private static final String SMTP_PASSWORD = "pienumacayxoghbe"; 

    public static void sendEmail(String toEmail, String subject, String bodyHtml) {
        
        // Skip if placeholders are not updated
        if (SMTP_EMAIL.contains("PLACEHOLDER") || SMTP_PASSWORD.contains("PLACEHOLDER")) {
            System.err.println("Email Notifications are skipped: Please configure SMTP credentials in EmailUtil.java");
            return;
        }

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.ssl.protocols", "TLSv1.2"); // Enforce TLSv1.2 for Gmail
        props.put("mail.debug", "true"); // Enable debug logs to trace issues

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SMTP_EMAIL, SMTP_PASSWORD);
            }
        });

        // Fix Thread Context Classloader issue in Tomcat for async threads
        ClassLoader originalClassLoader = Thread.currentThread().getContextClassLoader();
        try {
            Thread.currentThread().setContextClassLoader(EmailUtil.class.getClassLoader());

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
        } finally {
            Thread.currentThread().setContextClassLoader(originalClassLoader);
        }
    }
}

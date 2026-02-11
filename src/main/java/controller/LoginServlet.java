package controller;

import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String role = request.getParameter("role");
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        HttpSession session = request.getSession();

        // Simple Hardcoded Authentication
        if ("admin".equals(role) && "admin".equals(username) && "admin".equals(password)) {

            session.setAttribute("user", username);
            session.setAttribute("role", role);
            response.sendRedirect("adminDashboard.jsp");

        } else if ("doctor".equals(role) && "doctor".equals(username) && "doctor".equals(password)) {

            session.setAttribute("user", username);
            session.setAttribute("role", role);
            response.sendRedirect("doctorDashboard.jsp");

        } else if ("patient".equals(role) && "patient".equals(username) && "patient".equals(password)) {

            session.setAttribute("user", username);
            session.setAttribute("role", role);
            response.sendRedirect("patientDashboard.jsp");

        } else {
            response.sendRedirect("error.jsp");
        }
    }
}

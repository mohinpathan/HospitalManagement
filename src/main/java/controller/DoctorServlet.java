package controller;

import java.io.IOException;
import java.util.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import model.Doctor;

@WebServlet("/DoctorServlet")
public class DoctorServlet extends HttpServlet {

    private static List<Doctor> doctorList = new ArrayList<>();
    private static int idCounter = 1;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            doctorList.removeIf(d -> d.getId() == id);
        }

        request.setAttribute("doctors", doctorList);
        request.getRequestDispatcher("adminDashboard.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("add".equals(action)) {

            String name = request.getParameter("name");
            String specialization = request.getParameter("specialization");

            doctorList.add(new Doctor(idCounter++, name, specialization));

        } else if ("update".equals(action)) {

            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            String specialization = request.getParameter("specialization");

            for (Doctor d : doctorList) {
                if (d.getId() == id) {
                    d.setName(name);
                    d.setSpecialization(specialization);
                }
            }
        }

        response.sendRedirect("DoctorServlet");
    }
}

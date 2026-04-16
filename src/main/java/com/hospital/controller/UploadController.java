package com.hospital.controller;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;

@Controller
public class UploadController {

    @Autowired private JdbcTemplate jdbc;

    private static final String UPLOAD_DIR = System.getProperty("user.home") + "/hms_uploads/";

    @PostMapping("/upload/photo")
    public String uploadPhoto(
            @RequestParam("photo") MultipartFile file,
            HttpSession session,
            RedirectAttributes ra) throws Exception {

        String role = (String) session.getAttribute("role");
        if (role == null) return "redirect:/login.jsp";

        if (file.isEmpty()) {
            ra.addFlashAttribute("error", "Please select a file.");
            return redirectProfile(role);
        }

        String ct = file.getContentType();
        if (ct == null || !ct.startsWith("image/")) {
            ra.addFlashAttribute("error", "Only image files are allowed.");
            return redirectProfile(role);
        }

        if (file.getSize() > 5 * 1024 * 1024) {
            ra.addFlashAttribute("error", "File size must be under 5 MB.");
            return redirectProfile(role);
        }

        // Save file
        File dir = new File(UPLOAD_DIR);
        if (!dir.exists()) dir.mkdirs();

        String ext      = getExt(file.getOriginalFilename());
        String filename = UUID.randomUUID() + "." + ext;
        Path   dest     = Paths.get(UPLOAD_DIR + filename);
        Files.write(dest, file.getBytes());

        // Update DB
        String photoPath = "/hms_uploads/" + filename;
        switch (role) {
            case "patient" -> {
                int pid = (int) session.getAttribute("patientId");
                jdbc.update("UPDATE patients SET photo=? WHERE id=?", photoPath, pid);
                session.setAttribute("patientPhoto", photoPath);
            }
            case "doctor" -> {
                int did = (int) session.getAttribute("doctorId");
                jdbc.update("UPDATE doctors SET photo=? WHERE id=?", photoPath, did);
                session.setAttribute("doctorPhoto", photoPath);
            }
            case "admin" -> {
                int aid = (int) session.getAttribute("adminId");
                jdbc.update("UPDATE admins SET photo=? WHERE id=?", photoPath, aid);
                session.setAttribute("adminPhoto", photoPath);
            }
        }

        ra.addFlashAttribute("success", "Profile photo updated successfully.");
        return redirectProfile(role);
    }

    private String redirectProfile(String role) {
        return switch (role) {
            case "patient" -> "redirect:/patient/profile";
            case "doctor"  -> "redirect:/doctor/profile";
            case "admin"   -> "redirect:/admin/profile";
            default        -> "redirect:/login.jsp";
        };
    }

    private String getExt(String filename) {
        if (filename == null || !filename.contains(".")) return "jpg";
        return filename.substring(filename.lastIndexOf('.') + 1).toLowerCase();
    }
}

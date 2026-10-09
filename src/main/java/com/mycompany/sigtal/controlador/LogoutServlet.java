package com.mycompany.sigtal.controlador;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {

@Override
protected void doGet(
        HttpServletRequest request,
        HttpServletResponse response)
        throws ServletException, IOException {

    cerrarSesion(request, response);
}

@Override
protected void doPost(
        HttpServletRequest request,
        HttpServletResponse response)
        throws ServletException, IOException {

    cerrarSesion(request, response);
}

private void cerrarSesion(
        HttpServletRequest request,
        HttpServletResponse response)
        throws IOException {

    HttpSession session =
            request.getSession(false);

    if (session != null) {
        session.invalidate();
    }

    response.setHeader(
            "Cache-Control",
            "no-cache, no-store, must-revalidate"
    );

    response.setHeader(
            "Pragma",
            "no-cache"
    );

    response.setDateHeader(
            "Expires",
            0
    );

    response.sendRedirect(
            request.getContextPath() + "/login"
    );
}

}


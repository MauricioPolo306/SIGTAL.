package com.mycompany.sigtal.controlador;

import com.mycompany.sigtal.dao.UsuarioDAO;
import com.mycompany.sigtal.modelo.Usuario;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Si ya inició sesión, no mostrar nuevamente el login
        if (session != null
                && session.getAttribute("usuarioLogueado") != null) {

            response.sendRedirect(
        request.getContextPath() + "/dashboard"

            );
            return;
        }

        request.getRequestDispatcher("/login.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                           HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String usuario = request.getParameter("usuario");
        String password = request.getParameter("password");

        if (usuario != null) {
            usuario = usuario.trim();
        }

        if (password != null) {
            password = password.trim();
        }

        // Validar campos
        if (usuario == null || usuario.isEmpty()
                || password == null || password.isEmpty()) {

            request.setAttribute(
                    "error",
                    "Debe ingresar usuario y contraseña."
            );

            request.setAttribute(
                    "usuarioIngresado",
                    usuario
            );

            request.getRequestDispatcher("/login.jsp")
                    .forward(request, response);

            return;
        }

        // Consultar usuario en MySQL
        Usuario usuarioEncontrado =
                usuarioDAO.autenticar(usuario, password);

        if (usuarioEncontrado != null) {

            // Crear sesión
            HttpSession session = request.getSession(true);

            // Guardar usuario completo
            session.setAttribute(
                    "usuarioLogueado",
                    usuarioEncontrado
            );

            // Guardar datos individuales
            session.setAttribute(
                    "idUsuario",
                    usuarioEncontrado.getIdUsuario()
            );

            session.setAttribute(
                    "nombreUsuario",
                    usuarioEncontrado.getNombre()
            );

            session.setAttribute(
                    "usuario",
                    usuarioEncontrado.getUsuario()
            );

            session.setAttribute(
                    "rol",
                    usuarioEncontrado.getRol()
            );

            // Sesión de 30 minutos
            session.setMaxInactiveInterval(30 * 60);

            // Evitar caché del navegador
            response.setHeader(
                    "Cache-Control",
                    "no-cache, no-store, must-revalidate"
            );
            response.setHeader("Pragma", "no-cache");
            response.setDateHeader("Expires", 0);

            // Acceso al sistema
            response.sendRedirect(
                    request.getContextPath() + "/dashboard.jsp"
            );

        } else {

            // Credenciales incorrectas
            request.setAttribute(
                    "error",
                    "Usuario o contraseña incorrectos."
            );

            request.setAttribute(
                    "usuarioIngresado",
                    usuario
            );

            request.getRequestDispatcher("/login.jsp")
                    .forward(request, response);
        }
    }
}
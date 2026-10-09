package com.mycompany.sigtal.controlador;

import com.mycompany.sigtal.modelo.Usuario;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter("/*")
public class AutenticacionFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("Filtro de autenticación SIGTAL iniciado.");
    }

    @Override
    public void doFilter(
            ServletRequest request,
            ServletResponse response,
            FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest =
                (HttpServletRequest) request;

        HttpServletResponse httpResponse =
                (HttpServletResponse) response;

        String uri = httpRequest.getRequestURI();

        String contexto =
                httpRequest.getContextPath();

        String ruta =
                uri.substring(contexto.length());

        // ==========================================
        // RUTAS PÚBLICAS
        // ==========================================

        if (esRutaPublica(ruta)) {

            chain.doFilter(request, response);

            return;
        }

        // ==========================================
        // COMPROBAR SESIÓN
        // ==========================================

        HttpSession session =
                httpRequest.getSession(false);

        boolean autenticado =
                session != null
                && session.getAttribute("usuarioLogueado") != null;

        // ==========================================
        // USUARIO AUTENTICADO
        // ==========================================

        if (autenticado) {

            chain.doFilter(request, response);

            return;
        }

        // ==========================================
        // USUARIO NO AUTENTICADO
        // ==========================================

        httpResponse.setHeader(
                "Cache-Control",
                "no-cache, no-store, must-revalidate"
        );

        httpResponse.setHeader(
                "Pragma",
                "no-cache"
        );

        httpResponse.setDateHeader(
                "Expires",
                0
        );

        httpResponse.sendRedirect(
                contexto + "/login"
        );
    }

    /**
     * Determina qué recursos pueden abrirse
     * sin iniciar sesión.
     */
    private boolean esRutaPublica(String ruta) {

        if (ruta == null || ruta.isEmpty()) {
            return true;
        }

        // Login
        if (ruta.equals("/login")
                || ruta.equals("/login.jsp")) {

            return true;
        }

        // CSS
        if (ruta.startsWith("/css/")) {
            return true;
        }

        // JavaScript
        if (ruta.startsWith("/js/")) {
            return true;
        }

        // Imágenes
        if (ruta.startsWith("/img/")
                || ruta.startsWith("/images/")
                || ruta.equals("/fondo.png")
                || ruta.endsWith(".png")
                || ruta.endsWith(".jpg")
                || ruta.endsWith(".jpeg")
                || ruta.endsWith(".gif")
                || ruta.endsWith(".svg")
                || ruta.endsWith(".ico")) {

            return true;
        }

        // Fuentes
        if (ruta.endsWith(".woff")
                || ruta.endsWith(".woff2")
                || ruta.endsWith(".ttf")) {

            return true;
        }

        // Recursos estáticos
        if (ruta.equals("/favicon.ico")) {
            return true;
        }

        return false;
    }

    @Override
    public void destroy() {
        System.out.println("Filtro de autenticación SIGTAL detenido.");
    }
}
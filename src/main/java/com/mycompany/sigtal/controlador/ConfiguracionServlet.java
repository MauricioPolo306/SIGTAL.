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
import java.util.List;

@WebServlet("/configuracion")
public class ConfiguracionServlet extends HttpServlet {

    private final UsuarioDAO usuarioDAO =
            new UsuarioDAO();


   @Override
protected void doGet(
        HttpServletRequest request,
        HttpServletResponse response)
        throws ServletException, IOException {

    HttpSession session = request.getSession(false);

    if (session == null ||
        !"ADMIN".equalsIgnoreCase(
            String.valueOf(session.getAttribute("rol"))
        )) {

        response.sendRedirect(
            request.getContextPath() + "/dashboard"
        );

        return;
    }

    cargarUsuarios(request, response);
}

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

if (session == null ||
    !"ADMIN".equalsIgnoreCase(
        String.valueOf(session.getAttribute("rol"))
    )) {

    response.sendRedirect(
        request.getContextPath() + "/dashboard"
    );

    return;
}
        String accion =
                request.getParameter("accion");


        if (accion == null || accion.trim().isEmpty()) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/configuracion"
            );

            return;
        }


        switch (accion) {

            case "crear":
                crearUsuario(request, response);
                break;

            case "actualizar":
                actualizarUsuario(request, response);
                break;

            case "estado":
                cambiarEstado(request, response);
                break;

            case "password":
                cambiarPassword(request, response);
                break;

            default:

                response.sendRedirect(
                        request.getContextPath()
                        + "/configuracion"
                );

                break;
        }
    }


    /* =========================================================
       CARGAR USUARIOS
       ========================================================= */

    private void cargarUsuarios(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        List<Usuario> usuarios =
                usuarioDAO.listarUsuarios();


        request.setAttribute(
                "usuarios",
                usuarios
        );


        request.getRequestDispatcher(
                "/configuracion.jsp"
        ).forward(
                request,
                response
        );
    }


    /* =========================================================
       CREAR USUARIO
       ========================================================= */

    private void crearUsuario(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        String nombre =
                request.getParameter("nombre");

        String usuario =
                request.getParameter("usuario");

        String password =
                request.getParameter("password");

        String rol =
                request.getParameter("rol");

        String estado =
                request.getParameter("estado");


        if (estado == null
                || estado.trim().isEmpty()) {

            estado = "ACTIVO";
        }


        boolean resultado =
                usuarioDAO.crearUsuario(
                        nombre,
                        usuario,
                        password,
                        rol,
                        estado
                );


        if (resultado) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/configuracion?mensaje=usuario_creado"
            );

        } else {

            response.sendRedirect(
                    request.getContextPath()
                    + "/configuracion?error=usuario_no_creado"
            );
        }
    }


    /* =========================================================
       ACTUALIZAR USUARIO
       ========================================================= */

    private void actualizarUsuario(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        int idUsuario =
                Integer.parseInt(
                        request.getParameter("idUsuario")
                );


        String nombre =
                request.getParameter("nombre");

        String usuario =
                request.getParameter("usuario");

        String rol =
                request.getParameter("rol");

        String estado =
                request.getParameter("estado");


        boolean resultado =
                usuarioDAO.actualizarUsuario(
                        idUsuario,
                        nombre,
                        usuario,
                        rol,
                        estado
                );


        /*
         * Si el usuario actualiza su propio nombre,
         * actualizamos también la sesión.
         */

        HttpSession session =
                request.getSession(false);


        if (resultado && session != null) {

            Object idSesion =
                    session.getAttribute("idUsuario");


            if (idSesion != null
                    && Integer.parseInt(
                            idSesion.toString()
                    ) == idUsuario) {

                session.setAttribute(
                        "nombreUsuario",
                        nombre
                );

                session.setAttribute(
                        "usuario",
                        usuario
                );

                session.setAttribute(
                        "rol",
                        rol
                );
            }
        }


        if (resultado) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/configuracion?mensaje=usuario_actualizado"
            );

        } else {

            response.sendRedirect(
                    request.getContextPath()
                    + "/configuracion?error=usuario_no_actualizado"
            );
        }
    }


    /* =========================================================
       CAMBIAR ESTADO
       ========================================================= */

    private void cambiarEstado(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        int idUsuario =
                Integer.parseInt(
                        request.getParameter("idUsuario")
                );


        String estado =
                request.getParameter("estado");


        /*
         * Evitar que un administrador desactive
         * accidentalmente su propia cuenta.
         */

        HttpSession session =
                request.getSession(false);


        if (session != null) {

            Object idSesion =
                    session.getAttribute("idUsuario");


            if (idSesion != null
                    && Integer.parseInt(
                            idSesion.toString()
                    ) == idUsuario) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/configuracion?error=propia_cuenta"
                );

                return;
            }
        }


        boolean resultado =
                usuarioDAO.cambiarEstado(
                        idUsuario,
                        estado
                );


        if (resultado) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/configuracion?mensaje=estado_actualizado"
            );

        } else {

            response.sendRedirect(
                    request.getContextPath()
                    + "/configuracion?error=estado_no_actualizado"
            );
        }
    }


    /* =========================================================
       CAMBIAR CONTRASEÑA
       ========================================================= */

    private void cambiarPassword(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        int idUsuario =
                Integer.parseInt(
                        request.getParameter("idUsuario")
                );


        String password =
                request.getParameter("password");


        if (password == null
                || password.trim().isEmpty()) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/configuracion?error=password_vacia"
            );

            return;
        }


        boolean resultado =
                usuarioDAO.cambiarPassword(
                        idUsuario,
                        password
                );


        if (resultado) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/configuracion?mensaje=password_actualizada"
            );

        } else {

            response.sendRedirect(
                    request.getContextPath()
                    + "/configuracion?error=password_no_actualizada"
            );
        }
    }
}

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;
import java.io.IOException;


@WebFilter(urlPatterns = { "/dashboardUser.jsp", "/dashboardSampick.jsp" })
public class AuthFilter implements Filter { 

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
     
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);


        if (session == null || session.getAttribute("user") == null) {
            res.sendRedirect("login.jsp");
            return;
        }

        
        String role = (String) session.getAttribute("role"); 
        String uri = req.getRequestURI();

        
        if (uri.contains("dashboardUser.jsp") && !role.equals("user")) {
            res.sendRedirect("login.jsp"); 
            return;
        }

        
        if (uri.contains("dashboardSampick.jsp") && !role.equals("sampick")) {
            res.sendRedirect("login.jsp");
            return;
        }

        
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        
    }
}
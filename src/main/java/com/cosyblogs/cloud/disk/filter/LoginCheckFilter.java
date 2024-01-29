//package com.cosyblogs.cloud.disk.filter;
//
//
//
//import com.cosyblogs.cloud.disk.common.ApiResult;
//import com.cosyblogs.cloud.disk.model.User;
//import com.alibaba.fastjson.JSON;
//import org.slf4j.Logger;
//import org.slf4j.LoggerFactory;
//import org.springframework.util.AntPathMatcher;
//
//import javax.servlet.*;
////import javax.servlet.annotation.WebFilter;
//import javax.servlet.http.HttpServletRequest;
//import javax.servlet.http.HttpServletResponse;
//import java.io.IOException;
//
///**
// * 检查用户是否完成登录
// *
// * @author 25090
// */
//
////@WebFilter(filterName = "loginCheckFilter", urlPatterns = "/*")
//public class LoginCheckFilter implements Filter {
//
//    Logger logger = LoggerFactory.getLogger(getClass());
//    //路径匹配器、支持通配符
//    public static final AntPathMatcher PATH_MATCHER = new AntPathMatcher();
//
//    @Override
//    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
//        HttpServletRequest request = (HttpServletRequest) servletRequest;
//        HttpServletResponse response = (HttpServletResponse) servletResponse;
//        /**
//         * 1、获取本次请求的URI
//         * 2、判断本次请求是否需要处理
//         * 3、如果不需要处理，则直接放行
//         * 4、判断登录状态，如果已登录，则直接放行
//         * 5、如果未登录，则返回未登录结果
//         */
//        logger.info("拦截器检测到请求：");
//        //1、获取本次请求的URI
//        String requestURI = request.getRequestURI();
//
//        String[] urls = new String[]{ //定义不需要处理的请求
//                "/user/login",
//                "/*"
//        };
//        //2、判断本次请求是否需要处理
//        boolean check = check(urls, requestURI);
//
//        //3、如果不需要处理，则直接放行
//        if (check) {
//            logger.info("本次请求不需要处理...");
//            filterChain.doFilter(request, response);
//            return;
//        }
//        if (request.getSession().getAttribute("user") != null) {
//            logger.info("用户已登录,用户名：{}", ((User)(request.getSession().getAttribute("user"))).getUsername());
//            String userId = ((User)(request.getSession().getAttribute("user"))).getId();
//            filterChain.doFilter(request, response);
//            return;
//        }
//
//        //5、如果未登录，则返回未登录结果(通过输出流方式向客户端页面响应数据)
//        logger.info("用户未登录...");
//        response.getWriter().write(JSON.toJSONString(ApiResult.failure("NOTLOGIN")));
//        return;
//    }
//
//    /**
//     * 路径匹配，检查本次请求
//     *
//     * @param urls
//     * @param requestURI
//     * @return
//     */
//    public boolean check(String[] urls, String requestURI) {
//        for (String url : urls) {
//            boolean match = PATH_MATCHER.match(url, requestURI);
//            if (match) {
//                return true;
//            }
//        }
//        return false;
//
//    }
//}

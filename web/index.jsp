<%-- 
    Document   : index
    Created on : May 3, 2017, 7:38:47 PM
    Author     : gjk
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.io.*,java.util.*,gjk4all.dictu.astest.tools.*" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Application Server Test Page</title>
        <script src="js/jquery-3.3.1.min.js"></script>
        <script src="js/tree.jquery.js"></script>
        <link rel="stylesheet" href="js/jqtree.css">
        <style>
            body {
                font-family: Arial, Helvetica, sans-serif;
            }
            table {
                border: 1px solid black;
                border-collapse: collapse;
                text-align: left;
            }
            td, th{
                padding: 1px 5px;
                border: 1px solid black;
            }
            th {
                background-color: #80c1ff;
            }
            tr:nth-child(even) {
                background-color: #f2f2f2;
            }
            tr:nth-child(odd) {
                background-color: #d9d9d9;
            }
            
            #header, #footer {
                padding: 18px;
            }
            
            #footer {
                text-align: center;
                font-size: 11px;
            }
            
            /* Style the buttons that are used to open and close the accordion panel */
            .accordion {
                background-color: #eee;
                color: #444;
                cursor: pointer;
                padding: 18px;
                width: 100%;
                text-align: left;
                border: none;
                outline: none;
                transition: 0.4s;
                font-size: large;
                font-weight: bold;
            }

            /* Add a background color to the button if it is clicked on (add the .active class with JS), and when you move the mouse over it (hover) */
            .active, .accordion:hover {
                background-color: #ccc;
            }

            .accordion:after {
                content: '\02795'; /* Unicode character for "plus" sign (+) */
                font-size: 13px;
                color: #777;
                float: right;
                margin-left: 5px;
            }

            .active:after {
                content: "\2796"; /* Unicode character for "minus" sign (-) */
            }

            /* Style the accordion panel. Note: hidden by default */
            .panel {
                padding: 4px 18px 18px 18px;
                background-color: white;
                display: none;
                overflow: hidden;
            }
            
            .panel:last-child {
                padding: 4px 18px;
            }
        </style>
        <script>
<%
    out.print("var data = " + JndiWalker.PrintHtml(""));
%>
            
            $(document).ready(function(){
                $(".accordion").click(function(){
                    $(this).toggleClass("active");
                    $(this).next().toggle();
                });
                $("#JNDITree").tree({data:data});
            });
        </script>
    </head>
    <body>
<%
    String hostname = System.getenv("HOSTNAME");
    if (hostname == null) {
        hostname = System.getenv("COMPUTERNAME");
    }
    if (hostname == null) {
        hostname = java.net.InetAddress.getLocalHost().getHostName();
    }
%> 
        <div id="header">
            <h1><%=hostname %> says hello to the World!</h1>
            <h3>
<%
    out.println(getServletContext().getServerInfo());
%>
            </h3>
            <table>
                <tr><td>Request Method</td><td><%=request.getMethod()%></td></tr>
                <tr><td>Request Protocol</td><td><%=request.getProtocol()%></td></tr>
                <tr><td>Request Host</td><td><%=request.getServerName()%></td></tr>
                <tr><td>Request Port</td><td><%=request.getLocalPort()%></td></tr>
                <tr><td>Request URI</td><td><%=request.getRequestURI()%></td></tr>
                <tr><td>Remote Address</td><td><%=request.getRemoteAddr()%></td></tr>
                <tr><td>Remote Host</td><td><%=request.getRemoteHost()%></td></tr>
                <tr><td>Remote User</td><td><%=request.getRemoteUser()%></td></tr>
            </table>
        </div>
        <div id="accordion">
            <button class="accordion">HTTP Request Headers</button>
            <div class="panel">
                <table>
                    <tr><th>Header Name</th><th>Header Value</th></tr>
<%
    Enumeration headerNames = request.getHeaderNames();
    
    while(headerNames.hasMoreElements()) {
        String paramName = (String)headerNames.nextElement();
        out.println("<tr><td>" + paramName + "</td><td> " + request.getHeader(paramName) + "</td></tr>");
    }
%>
                </table>
            </div>
            <button class="accordion">Environment Variables</button>
            <div class="panel">
                <table>
                    <tr><th>Variable</th><th>Value</th></tr>
<%
    Map<String, String> envMap = System.getenv();
    SortedMap<String, String> sortedEnvMap = new TreeMap<String, String>(envMap);
    Set<String> keySet = sortedEnvMap.keySet();
    for (String key : keySet) {
        out.print("<tr><td>" + key + "</td><td> " + envMap.get(key) + "</td></tr>");
    }
%>
                </table>
            </div>
            <button class="accordion">Java System Properties</button>
            <div class="panel">
                <table>
                    <tr><th>Variable</th><th>Value</th></tr>
<%
    Properties p = System.getProperties();
    ArrayList<String> keys = new ArrayList(p.stringPropertyNames());
    Collections.sort(keys);
    for (String key : keys) {
        out.print("<tr><td>" + key + "</td><td> " + ((String)p.get(key)).replaceAll("\r\n", "[CrLf]").replaceAll("\r", "[Cr]").replaceAll("\n", "[Lf]").replaceAll("\t", "[tab]") + "</td></tr>");
    }
%>
                </table>
            </div>
            <button class="accordion">JNDI tree</button>
            <div class="panel" id="JNDITree">
            </div>
        </div>
        <div id="footer">
            <p>Java Application Server testpage (version 2.0) - Made for DICTU - &COPY; 2018 by G.J.Kruizinga</p>
        </div>
    </body>
</html>

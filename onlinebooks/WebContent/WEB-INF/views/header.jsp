<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Online Books - Premium Library</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,700;1,400&family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #fcfbf9; color: #333; }
        h1, h2, h3, .font-playfair { font-family: 'Playfair Display', serif; }
        .glass-nav {
            background: rgba(255, 255, 255, 0.85);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border-bottom: 1px solid rgba(0, 0, 0, 0.05);
            box-shadow: 0 4px 30px rgba(0, 0, 0, 0.05);
        }
        .hover-lift { transition: transform 0.3s ease, box-shadow 0.3s ease; }
        .hover-lift:hover { transform: translateY(-5px); box-shadow: 0 10px 25px rgba(0,0,0,0.1); }
        .smooth-scroll { scroll-behavior: smooth; }
    </style>
</head>
<body class="min-h-screen flex flex-col smooth-scroll">

<nav class="glass-nav fixed w-full z-50 top-0 transition-all duration-300">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex items-center justify-between h-20">
            <div class="flex items-center">
                <a href="${pageContext.request.contextPath}/" class="text-3xl font-bold font-playfair text-amber-900 tracking-tight">
                    <i class="fas fa-book-open mr-2"></i>OnlineBooks
                </a>
            </div>
            <div class="hidden md:block">
                <div class="ml-10 flex items-center space-x-6">
                    <a href="${pageContext.request.contextPath}/" class="text-gray-700 hover:text-amber-700 px-3 py-2 text-md font-semibold transition duration-300 border-b-2 border-transparent hover:border-amber-700">Home</a>
                    <a href="${pageContext.request.contextPath}/about" class="text-gray-700 hover:text-amber-700 px-3 py-2 text-md font-semibold transition duration-300 border-b-2 border-transparent hover:border-amber-700">About Us</a>
                    <a href="${pageContext.request.contextPath}/viewbook" class="text-gray-700 hover:text-amber-700 px-3 py-2 text-md font-semibold transition duration-300 border-b-2 border-transparent hover:border-amber-700">Browse Books</a>
                    <a href="${pageContext.request.contextPath}/contact.jsp" class="text-gray-700 hover:text-amber-700 px-3 py-2 text-md font-semibold transition duration-300 border-b-2 border-transparent hover:border-amber-700">Contact Us</a>
                    
                    <c:choose>
                        <c:when test="${not empty sessionScope.CUSTOMER}">
                            <a href="${pageContext.request.contextPath}/customer-dashboard.jsp" class="text-indigo-700 font-bold px-3 py-2">Dashboard</a>
                            <a href="${pageContext.request.contextPath}/logout" class="bg-red-50 text-red-700 border border-red-200 hover:bg-red-100 px-4 py-2 rounded-full text-sm font-bold transition shadow-sm">Logout</a>
                        </c:when>
                        <c:when test="${not empty sessionScope.SELLER}">
                            <a href="${pageContext.request.contextPath}/seller-dashboard.jsp" class="text-teal-700 font-bold px-3 py-2">Seller Panel</a>
                            <a href="${pageContext.request.contextPath}/logout" class="bg-red-50 text-red-700 border border-red-200 hover:bg-red-100 px-4 py-2 rounded-full text-sm font-bold transition shadow-sm">Logout</a>
                        </c:when>
                        <c:when test="${not empty sessionScope.ADMIN}">
                            <a href="${pageContext.request.contextPath}/admin-dashboard" class="text-purple-700 font-bold px-3 py-2">Admin Panel</a>
                            <a href="${pageContext.request.contextPath}/logout" class="bg-red-50 text-red-700 border border-red-200 hover:bg-red-100 px-4 py-2 rounded-full text-sm font-bold transition shadow-sm">Logout</a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/login.jsp" class="bg-amber-800 hover:bg-amber-900 text-white px-6 py-2.5 rounded-full text-sm font-bold tracking-wide transition shadow-md hover:shadow-lg">Login / Sign Up</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</nav>

<main class="flex-grow pt-20">
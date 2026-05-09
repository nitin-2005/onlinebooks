<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="WEB-INF/views/header.jsp" />
<div class="min-h-screen flex items-center justify-center bg-stone-100 py-12 px-4 sm:px-6 lg:px-8 relative overflow-hidden">
    <div class="absolute inset-0 z-0">
        <img src="https://images.unsplash.com/photo-1507842217343-583bb7270b66?ixlib=rb-4.0.3&auto=format&fit=crop&w=2000&q=80" alt="Library Background" class="w-full h-full object-cover opacity-20">
    </div>
    <div class="max-w-md w-full space-y-8 bg-white/90 backdrop-blur-md p-10 rounded-2xl shadow-2xl relative z-10 border border-white/40">
        <div>
            <h2 class="mt-6 text-center text-3xl font-extrabold text-stone-900 font-playfair">Sign in to your account</h2>
            <p class="mt-2 text-center text-sm text-stone-600">
                Or <a href="register.jsp" class="font-medium text-amber-700 hover:text-amber-600 transition">create a new account</a>
            </p>
        </div>
        
        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative" role="alert">
                <span class="block sm:inline"><%= request.getAttribute("errorMessage") %></span>
            </div>
        <% } %>
        
        <% if (request.getAttribute("successMessage") != null) { %>
            <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded relative" role="alert">
                <span class="block sm:inline"><%= request.getAttribute("successMessage") %></span>
            </div>
        <% } %>

        <form class="mt-8 space-y-6" action="userlog" method="POST">
            <div class="rounded-md shadow-sm -space-y-px">
                <div>
                    <label for="username" class="sr-only">Username</label>
                    <input id="username" name="username" type="text" required class="appearance-none rounded-none relative block w-full px-3 py-3 border border-stone-300 placeholder-stone-500 text-stone-900 rounded-t-md focus:outline-none focus:ring-amber-500 focus:border-amber-500 focus:z-10 sm:text-sm bg-white/50" placeholder="Username (e.g. demo)">
                </div>
                <div>
                    <label for="password" class="sr-only">Password</label>
                    <input id="password" name="password" type="password" required class="appearance-none rounded-none relative block w-full px-3 py-3 border border-stone-300 placeholder-stone-500 text-stone-900 rounded-b-md focus:outline-none focus:ring-amber-500 focus:border-amber-500 focus:z-10 sm:text-sm bg-white/50" placeholder="Password (e.g. demo)">
                </div>
            </div>
            <div>
                <button type="submit" class="group relative w-full flex justify-center py-3 px-4 border border-transparent text-sm font-bold rounded-md text-white bg-amber-800 hover:bg-amber-900 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-amber-500 shadow-lg hover:shadow-xl transition transform hover:-translate-y-0.5">
                    Sign in
                </button>
            </div>
        </form>
    </div>
</div>
<jsp:include page="WEB-INF/views/footer.jsp" />
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/views/header.jsp" />
<div class="min-h-screen flex items-center justify-center bg-stone-100 py-16 px-4 sm:px-6 lg:px-8 relative overflow-hidden">
    <div class="absolute inset-0 z-0">
        <img src="https://images.unsplash.com/photo-1507842217343-583bb7270b66?ixlib=rb-4.0.3&auto=format&fit=crop&w=2000&q=80" alt="Library Background" class="w-full h-full object-cover opacity-20">
    </div>
    <div class="max-w-2xl w-full space-y-8 bg-white/90 backdrop-blur-md p-10 rounded-2xl shadow-2xl relative z-10 border border-white/40">
        <div>
            <h2 class="mt-2 text-center text-3xl font-extrabold text-stone-900 font-playfair">Create your Account</h2>
            <p class="mt-2 text-center text-sm text-stone-600">
                Already have an account? <a href="login.jsp" class="font-medium text-amber-700 hover:text-amber-600 transition">Sign in here</a>
            </p>
        </div>
        
        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative" role="alert">
                <span class="block sm:inline"><%= request.getAttribute("errorMessage") %></span>
            </div>
        <% } %>

        <form class="mt-8 space-y-6" action="userreg" method="POST">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <!-- Username -->
                <div class="md:col-span-2">
                    <label class="block text-sm font-medium text-stone-700 mb-1">Username</label>
                    <input name="username" type="text" required class="appearance-none relative block w-full px-3 py-3 border border-stone-300 placeholder-stone-400 text-stone-900 rounded-lg focus:outline-none focus:ring-amber-500 focus:border-amber-500 sm:text-sm bg-white/70" placeholder="Choose a unique username">
                </div>
                
                <!-- Password -->
                <div>
                    <label class="block text-sm font-medium text-stone-700 mb-1">Password</label>
                    <input name="password" type="password" required class="appearance-none relative block w-full px-3 py-3 border border-stone-300 placeholder-stone-400 text-stone-900 rounded-lg focus:outline-none focus:ring-amber-500 focus:border-amber-500 sm:text-sm bg-white/70" placeholder="Enter password">
                </div>
                
                <!-- Confirm Password -->
                <div>
                    <label class="block text-sm font-medium text-stone-700 mb-1">Confirm Password</label>
                    <input name="repassword" type="password" required class="appearance-none relative block w-full px-3 py-3 border border-stone-300 placeholder-stone-400 text-stone-900 rounded-lg focus:outline-none focus:ring-amber-500 focus:border-amber-500 sm:text-sm bg-white/70" placeholder="Re-enter password">
                </div>

                <!-- First Name -->
                <div>
                    <label class="block text-sm font-medium text-stone-700 mb-1">First Name</label>
                    <input name="firstname" type="text" required class="appearance-none relative block w-full px-3 py-3 border border-stone-300 placeholder-stone-400 text-stone-900 rounded-lg focus:outline-none focus:ring-amber-500 focus:border-amber-500 sm:text-sm bg-white/70" placeholder="First Name">
                </div>

                <!-- Last Name -->
                <div>
                    <label class="block text-sm font-medium text-stone-700 mb-1">Last Name</label>
                    <input name="lastname" type="text" required class="appearance-none relative block w-full px-3 py-3 border border-stone-300 placeholder-stone-400 text-stone-900 rounded-lg focus:outline-none focus:ring-amber-500 focus:border-amber-500 sm:text-sm bg-white/70" placeholder="Last Name">
                </div>

                <!-- Email -->
                <div>
                    <label class="block text-sm font-medium text-stone-700 mb-1">Email Address</label>
                    <input name="mailid" type="email" required class="appearance-none relative block w-full px-3 py-3 border border-stone-300 placeholder-stone-400 text-stone-900 rounded-lg focus:outline-none focus:ring-amber-500 focus:border-amber-500 sm:text-sm bg-white/70" placeholder="you@example.com">
                </div>

                <!-- Phone -->
                <div>
                    <label class="block text-sm font-medium text-stone-700 mb-1">Phone Number</label>
                    <input name="phone" type="text" required class="appearance-none relative block w-full px-3 py-3 border border-stone-300 placeholder-stone-400 text-stone-900 rounded-lg focus:outline-none focus:ring-amber-500 focus:border-amber-500 sm:text-sm bg-white/70" placeholder="e.g. 9876543210">
                </div>

                <!-- Address -->
                <div class="md:col-span-2">
                    <label class="block text-sm font-medium text-stone-700 mb-1">Delivery Address</label>
                    <textarea name="address" required rows="2" class="appearance-none relative block w-full px-3 py-3 border border-stone-300 placeholder-stone-400 text-stone-900 rounded-lg focus:outline-none focus:ring-amber-500 focus:border-amber-500 sm:text-sm bg-white/70" placeholder="Enter your full street address"></textarea>
                </div>
                
                <!-- Account Type -->
                <div class="md:col-span-2">
                    <label class="block text-sm font-medium text-stone-700 mb-2">Account Type</label>
                    <div class="flex space-x-6">
                        <label class="flex items-center text-stone-700">
                            <input type="radio" name="usertype" value="3" checked class="form-radio h-5 w-5 text-amber-600 border-stone-300 focus:ring-amber-500">
                            <span class="ml-2">Customer</span>
                        </label>
                        <label class="flex items-center text-stone-700">
                            <input type="radio" name="usertype" value="2" class="form-radio h-5 w-5 text-amber-600 border-stone-300 focus:ring-amber-500">
                            <span class="ml-2">Seller</span>
                        </label>
                    </div>
                </div>
            </div>

            <div class="pt-4">
                <button type="submit" class="w-full flex justify-center py-4 px-4 border border-transparent text-sm font-bold rounded-lg text-white bg-stone-900 hover:bg-stone-800 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-stone-900 shadow-xl transition transform hover:-translate-y-0.5">
                    Create Account
                </button>
            </div>
        </form>
    </div>
</div>
<jsp:include page="/WEB-INF/views/footer.jsp" />
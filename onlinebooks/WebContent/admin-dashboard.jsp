<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<jsp:include page="WEB-INF/views/header.jsp" />
<% 
  if(session.getAttribute("ADMIN") == null) { 
      response.sendRedirect("login.jsp"); 
      return; 
  }
  if(request.getAttribute("users") == null) {
      response.sendRedirect("admin-dashboard");
      return;
  }
%>
<div class="bg-stone-50 py-16 min-h-screen text-stone-800">
    <div class="max-w-7xl mx-auto p-8">
        <div class="bg-gradient-to-r from-stone-900 to-amber-900 rounded-2xl p-8 text-white shadow-xl mb-12 flex items-center justify-between">
            <div class="flex items-center">
                <div class="w-20 h-20 bg-white/20 rounded-full flex items-center justify-center text-3xl mr-6 border-2 border-white/40">
                    <i class="fas fa-user-shield"></i>
                </div>
                <div>
                    <h2 class="text-3xl font-bold font-playfair mb-1">Welcome, <%= session.getAttribute("ADMIN") %></h2>
                    <p class="text-stone-300">Administrator ID: <span class="font-mono bg-stone-800 px-2 py-1 rounded"><%= session.getAttribute("USERNAME") %></span></p>
                </div>
            </div>
            <a href="admin/export" class="hidden md:flex items-center bg-white text-amber-900 hover:bg-stone-100 font-bold py-3 px-6 rounded-xl transition shadow-lg">
                <i class="fas fa-file-csv mr-2"></i> Export Data (CSV)
            </a>
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-4 gap-8">
            <div class="lg:col-span-1 space-y-8">
                <!-- Stats -->
                <div class="bg-white p-6 rounded-2xl shadow-lg border border-stone-200">
                    <h3 class="text-stone-500 font-bold text-sm uppercase tracking-wider mb-4"><i class="fas fa-chart-line mr-2"></i> Platform Overview</h3>
                    <div class="space-y-4">
                        <div class="flex justify-between items-center bg-stone-50 p-4 rounded-xl border border-stone-100">
                            <span class="text-stone-600">Total Users</span>
                            <span class="font-bold text-xl text-stone-900">${totalUsers}</span>
                        </div>
                        <div class="flex justify-between items-center bg-stone-50 p-4 rounded-xl border border-stone-100">
                            <span class="text-stone-600">Active Sellers</span>
                            <span class="font-bold text-xl text-stone-900">${activeSellers}</span>
                        </div>
                        <div class="flex justify-between items-center bg-green-50 p-4 rounded-xl border border-green-100">
                            <span class="text-green-700">Total Revenue</span>
                            <span class="font-bold text-xl text-green-700">₹ ${totalRevenue}</span>
                        </div>
                    </div>
                </div>
            </div>

            <div class="lg:col-span-3 space-y-8">
                <!-- User Management -->
                <div class="bg-white p-8 rounded-2xl shadow-lg border border-stone-200">
                    <div class="flex justify-between items-center mb-6">
                        <h3 class="text-2xl font-bold text-stone-800 font-playfair"><i class="fas fa-users text-indigo-600 mr-2"></i> Manage Users & Sellers</h3>
                        <div class="flex items-center space-x-4">
                            <a href="#" class="text-indigo-600 font-bold hover:underline flex items-center text-sm"><i class="fas fa-arrow-right mr-1"></i>View All</a>
                            <button onclick="window.location.href='register.jsp'" class="bg-indigo-600 hover:bg-indigo-700 text-white px-4 py-2 rounded-lg text-sm font-bold shadow transition"><i class="fas fa-plus mr-1"></i> Add User</button>
                        </div>
                    </div>
                    <div class="overflow-x-auto">
                        <table class="w-full text-left border-collapse">
                            <thead>
                                <tr class="bg-stone-100 text-stone-600 text-sm uppercase tracking-wider">
                                    <th class="p-3 rounded-tl-lg">ID / Username</th>
                                    <th class="p-3">Role</th>
                                    <th class="p-3">Status</th>
                                    <th class="p-3 rounded-tr-lg text-right">Actions</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-stone-100">
                                <c:forEach var="u" items="${users}">
                                <tr class="hover:bg-stone-50">
                                    <td class="p-3 font-semibold">${u.emailId}</td>
                                    <td class="p-3 text-stone-500">
                                        <c:choose>
                                            <c:when test="${u.userType == 1}">Admin</c:when>
                                            <c:when test="${u.userType == 2}">Seller</c:when>
                                            <c:otherwise>Customer</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="p-3"><span class="bg-green-100 text-green-800 px-2 py-1 rounded text-xs">Active</span></td>
                                    <td class="p-3 text-right">
                                        <a href="admin/editUser?username=${u.emailId}" class="text-blue-600 hover:text-blue-800 mr-3"><i class="fas fa-edit"></i></a>
                                        <form action="admin/manageUser" method="post" class="inline">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="username" value="${u.emailId}">
                                            <button type="submit" class="text-red-600 hover:text-red-800" onclick="return confirm('Are you sure you want to delete this user?');"><i class="fas fa-trash"></i></button>
                                        </form>
                                    </td>
                                </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Global Inventory Management -->
                <div class="bg-white p-8 rounded-2xl shadow-lg border border-stone-200">
                    <div class="flex justify-between items-center mb-6">
                        <h3 class="text-2xl font-bold text-stone-800 font-playfair"><i class="fas fa-book text-amber-700 mr-2"></i> Manage Global Inventory</h3>
                        <div class="flex items-center space-x-4">
                            <a href="viewbook" class="text-amber-700 font-bold hover:underline flex items-center text-sm"><i class="fas fa-arrow-right mr-1"></i>View All</a>
                            <button onclick="window.location.href='addbook.jsp'" class="bg-amber-700 hover:bg-amber-800 text-white px-4 py-2 rounded-lg text-sm font-bold shadow transition"><i class="fas fa-plus mr-1"></i> Add Item Globally</button>
                        </div>
                    </div>
                    <div class="overflow-x-auto">
                        <table class="w-full text-left border-collapse">
                            <thead>
                                <tr class="bg-stone-100 text-stone-600 text-sm uppercase tracking-wider">
                                    <th class="p-4 rounded-tl-lg">Book Name</th>
                                    <th class="p-4">Seller ID</th>
                                    <th class="p-4">Price</th>
                                    <th class="p-4 text-center">Stock</th>
                                    <th class="p-4 rounded-tr-lg text-right">Actions</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-stone-100">
                                <c:forEach var="b" items="${books}">
                                <tr class="hover:bg-stone-50 transition">
                                    <td class="p-4 font-semibold text-stone-800">${b.name}</td>
                                    <td class="p-4 text-stone-500 font-mono">${b.author}</td>
                                    <td class="p-4 font-bold text-amber-700">₹ ${b.price}</td>
                                    <td class="p-4 text-center">${b.quantity}</td>
                                    <td class="p-4 text-right">
                                        <a href="admin/editBook?bookId=${b.barcode}" class="text-blue-600 hover:text-blue-800 mr-3"><i class="fas fa-edit"></i> Edit</a>
                                        <form action="admin/manageBook" method="post" class="inline">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="bookId" value="${b.barcode}">
                                            <button type="submit" class="text-red-600 hover:text-red-800" onclick="return confirm('Remove this book from global inventory?');"><i class="fas fa-trash"></i> Remove</button>
                                        </form>
                                    </td>
                                </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<jsp:include page="WEB-INF/views/footer.jsp" />
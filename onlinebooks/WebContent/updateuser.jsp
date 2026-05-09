<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<jsp:include page="WEB-INF/views/header.jsp" />
<% 
  if(session.getAttribute("ADMIN") == null) { 
      response.sendRedirect("login.jsp"); 
      return; 
  }
  if(request.getAttribute("user") == null) {
      response.sendRedirect("admin-dashboard");
      return;
  }
%>
<div class="min-h-screen flex items-center justify-center bg-stone-100 py-12 px-4 sm:px-6 lg:px-8 relative overflow-hidden">
    <div class="absolute inset-0 z-0">
        <img src="https://images.unsplash.com/photo-1517048676732-d65bc937f952?ixlib=rb-4.0.3&auto=format&fit=crop&w=2000&q=80" alt="Users Background" class="w-full h-full object-cover opacity-20">
    </div>
    <div class="max-w-2xl w-full space-y-8 bg-white/90 backdrop-blur-md p-10 rounded-2xl shadow-2xl relative z-10 border border-white/40">
        <div>
            <h2 class="mt-2 text-center text-3xl font-extrabold text-stone-900 font-playfair"><i class="fas fa-user-edit text-indigo-600 mr-2"></i> Update User Record</h2>
            <p class="mt-2 text-center text-sm text-stone-600">
                Modify the details below to update the user account.
            </p>
        </div>
        
        <form class="mt-8 space-y-6" action="admin/manageUser" method="POST">
            <input type="hidden" name="action" value="update">
            
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div class="md:col-span-2">
                    <label for="username" class="block text-sm font-medium text-stone-700 mb-1">Email ID (Username)</label>
                    <input id="username" name="username" type="text" value="${user.emailId}" readonly class="appearance-none block w-full px-3 py-3 border border-stone-200 rounded-md shadow-sm text-stone-500 sm:text-sm bg-stone-100 cursor-not-allowed">
                </div>

                <div>
                    <label for="firstName" class="block text-sm font-medium text-stone-700 mb-1">First Name</label>
                    <input id="firstName" name="firstName" type="text" value="${user.firstName}" required class="appearance-none block w-full px-3 py-3 border border-stone-300 rounded-md shadow-sm placeholder-stone-400 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm bg-white/70">
                </div>
                
                <div>
                    <label for="lastName" class="block text-sm font-medium text-stone-700 mb-1">Last Name</label>
                    <input id="lastName" name="lastName" type="text" value="${user.lastName}" required class="appearance-none block w-full px-3 py-3 border border-stone-300 rounded-md shadow-sm placeholder-stone-400 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm bg-white/70">
                </div>

                <div>
                    <label for="phone" class="block text-sm font-medium text-stone-700 mb-1">Phone Number</label>
                    <input id="phone" name="phone" type="number" value="${user.phone}" required class="appearance-none block w-full px-3 py-3 border border-stone-300 rounded-md shadow-sm placeholder-stone-400 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm bg-white/70">
                </div>
                
                <div>
                    <label for="userType" class="block text-sm font-medium text-stone-700 mb-1">User Role</label>
                    <select id="userType" name="userType" class="appearance-none block w-full px-3 py-3 border border-stone-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm bg-white/70">
                        <option value="1" ${user.userType == 1 ? 'selected' : ''}>Administrator</option>
                        <option value="2" ${user.userType == 2 ? 'selected' : ''}>Seller</option>
                        <option value="3" ${user.userType == 3 ? 'selected' : ''}>Customer</option>
                    </select>
                </div>
                
                <div class="md:col-span-2">
                    <label for="address" class="block text-sm font-medium text-stone-700 mb-1">Full Address</label>
                    <textarea id="address" name="address" rows="3" required class="appearance-none block w-full px-3 py-3 border border-stone-300 rounded-md shadow-sm placeholder-stone-400 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm bg-white/70">${user.address}</textarea>
                </div>
            </div>
            
            <div class="flex items-center justify-between pt-4">
                <a href="${pageContext.request.contextPath}/admin-dashboard" class="text-stone-600 hover:text-indigo-800 font-medium transition"><i class="fas fa-arrow-left mr-1"></i> Back to Dashboard</a>
                <button type="submit" class="inline-flex justify-center py-3 px-6 border border-transparent shadow-lg text-sm font-bold rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 transition transform hover:-translate-y-0.5">
                    <i class="fas fa-save mr-2 mt-0.5"></i> Update User
                </button>
            </div>
        </form>
    </div>
</div>
<jsp:include page="WEB-INF/views/footer.jsp" />

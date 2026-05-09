<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="WEB-INF/views/header.jsp" />
<% 
  if(session.getAttribute("ADMIN") == null && session.getAttribute("SELLER") == null) { 
      response.sendRedirect("login.jsp"); 
      return; 
  }
%>
<div class="min-h-screen flex items-center justify-center bg-stone-100 py-12 px-4 sm:px-6 lg:px-8 relative overflow-hidden">
    <div class="absolute inset-0 z-0">
        <img src="https://images.unsplash.com/photo-1589998059171-988d887df646?ixlib=rb-4.0.3&auto=format&fit=crop&w=2000&q=80" alt="Books Background" class="w-full h-full object-cover opacity-20">
    </div>
    <div class="max-w-2xl w-full space-y-8 bg-white/90 backdrop-blur-md p-10 rounded-2xl shadow-2xl relative z-10 border border-white/40">
        <div>
            <h2 class="mt-2 text-center text-3xl font-extrabold text-stone-900 font-playfair"><i class="fas fa-book-medical text-amber-700 mr-2"></i> Add Item Globally</h2>
            <p class="mt-2 text-center text-sm text-stone-600">
                Enter the details below to add a new book to the platform inventory.
            </p>
        </div>
        
        <form class="mt-8 space-y-6" action="${pageContext.request.contextPath}/admin/saveBook" method="POST" enctype="multipart/form-data">
            <input type="hidden" name="action" value="add">
            
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div class="md:col-span-2">
                    <label for="name" class="block text-sm font-medium text-stone-700 mb-1">Book Name</label>
                    <input id="name" name="name" type="text" required class="appearance-none block w-full px-3 py-3 border border-stone-300 rounded-md shadow-sm placeholder-stone-400 focus:outline-none focus:ring-amber-500 focus:border-amber-500 sm:text-sm bg-white/70" placeholder="e.g. Advanced Java MVC">
                </div>
                
                <div class="md:col-span-2">
                    <label for="author" class="block text-sm font-medium text-stone-700 mb-1">Author Name</label>
                    <input id="author" name="author" type="text" required class="appearance-none block w-full px-3 py-3 border border-stone-300 rounded-md shadow-sm placeholder-stone-400 focus:outline-none focus:ring-amber-500 focus:border-amber-500 sm:text-sm bg-white/70" placeholder="e.g. John Doe">
                </div>

                <div>
                    <label for="price" class="block text-sm font-medium text-stone-700 mb-1">Price (₹)</label>
                    <input id="price" name="price" type="number" step="0.01" min="0" required class="appearance-none block w-full px-3 py-3 border border-stone-300 rounded-md shadow-sm placeholder-stone-400 focus:outline-none focus:ring-amber-500 focus:border-amber-500 sm:text-sm bg-white/70" placeholder="0.00">
                </div>
                
                <div>
                    <label for="quantity" class="block text-sm font-medium text-stone-700 mb-1">Stock Quantity</label>
                    <input id="quantity" name="quantity" type="number" min="1" required class="appearance-none block w-full px-3 py-3 border border-stone-300 rounded-md shadow-sm placeholder-stone-400 focus:outline-none focus:ring-amber-500 focus:border-amber-500 sm:text-sm bg-white/70" placeholder="e.g. 50">
                </div>
                
                <div>
                    <label for="image" class="block text-sm font-medium text-stone-700 mb-1">Cover Image (Optional)</label>
                    <input id="image" name="image" type="file" accept="image/*" class="appearance-none block w-full px-3 py-2 border border-stone-300 rounded-md shadow-sm focus:outline-none focus:ring-amber-500 focus:border-amber-500 sm:text-sm bg-white/70">
                </div>

                <div>
                    <label for="pdf" class="block text-sm font-medium text-stone-700 mb-1">Book PDF (Optional)</label>
                    <input id="pdf" name="pdf" type="file" accept="application/pdf" class="appearance-none block w-full px-3 py-2 border border-stone-300 rounded-md shadow-sm focus:outline-none focus:ring-amber-500 focus:border-amber-500 sm:text-sm bg-white/70">
                </div>
            </div>
            
            <div class="flex items-center justify-between pt-4">
                <a href="${pageContext.request.contextPath}/admin-dashboard" class="text-stone-600 hover:text-amber-800 font-medium transition"><i class="fas fa-arrow-left mr-1"></i> Back to Dashboard</a>
                <button type="submit" class="inline-flex justify-center py-3 px-6 border border-transparent shadow-lg text-sm font-bold rounded-md text-white bg-amber-800 hover:bg-amber-900 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-amber-500 transition transform hover:-translate-y-0.5">
                    <i class="fas fa-save mr-2 mt-0.5"></i> Save Book
                </button>
            </div>
        </form>
    </div>
</div>
<jsp:include page="WEB-INF/views/footer.jsp" />

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.bittercode.model.Book" %>
<%@ page import="com.bittercode.service.BookService" %>
<%@ page import="com.bittercode.service.impl.BookServiceImpl" %>
<%@ page import="com.bittercode.util.StoreUtil" %>
<jsp:include page="WEB-INF/views/header.jsp" />

<%
    // Process Cart Addition via StoreUtil if requested
    StoreUtil.updateCartItems(request);
    
    boolean showToast = false;
    String toastMessage = "";
    
    if (request.getParameter("addToCart") != null) {
        response.sendRedirect("customer-dashboard.jsp?activeTab=tab-cart");
        return;
    }
    
    // Process Wishlist Actions
    String action = request.getParameter("action");
    String wishlistBookId = request.getParameter("wishlistBookId");
    
    List<String> wishlist = (List<String>) session.getAttribute("wishlistItems");
    if (wishlist == null) {
        wishlist = new ArrayList<String>();
    }
    
    if ("addWishlist".equals(action) && wishlistBookId != null) {
        if (!wishlist.contains(wishlistBookId)) {
            wishlist.add(wishlistBookId);
            showToast = true;
            toastMessage = "Item saved to your Wishlist!";
        }
    } else if ("removeWishlist".equals(action) && wishlistBookId != null) {
        wishlist.remove(wishlistBookId);
        showToast = true;
        toastMessage = "Item removed from your Wishlist!";
    }
    session.setAttribute("wishlistItems", wishlist);

    // Fetch All Books
    BookService bookService = new BookServiceImpl();
    List<Book> allBooks = bookService.getAllBooks();
%>

<!-- JavaScript for Modals (PDF & Notifications) -->
<script>
    function openPdfPreview(pdfUrl, bookName) {
        document.getElementById('pdfModalTitle').innerText = "Preview: " + bookName;
        document.getElementById('pdfModalIframe').src = pdfUrl;
        document.getElementById('pdfModal').classList.remove('hidden');
    }
    function closePdfPreview() {
        document.getElementById('pdfModal').classList.add('hidden');
        document.getElementById('pdfModalIframe').src = "";
    }
</script>

<div class="bg-stone-50 dark:bg-stone-900 min-h-screen text-stone-800 dark:text-stone-200 transition-colors duration-300">
    
    <!-- Hero Header -->
    <div class="bg-stone-900 dark:bg-stone-950 text-white py-12 border-b border-stone-800">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
            <h2 class="text-5xl font-bold font-playfair mb-4 text-amber-500">Explore Our Full Library</h2>
            <p class="text-stone-400 max-w-2xl mx-auto text-lg">Browse our entire collection. Add items directly to your cart or save them to your wishlist for later!</p>
        </div>
    </div>

    <!-- Main Books Grid Section -->
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
        
        <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5 gap-6">
            <% 
               if(allBooks != null && !allBooks.isEmpty()) {
                   for(Book b : allBooks) { 
                       boolean inWishlist = wishlist.contains(b.getBarcode());
            %>
            <div class="bg-white dark:bg-stone-800 rounded-xl shadow-lg overflow-hidden hover:-translate-y-2 transition duration-300 border border-stone-100 dark:border-stone-700 group flex flex-col">
                <!-- Book Cover -->
                <div class="relative h-56 bg-stone-200 dark:bg-stone-700 overflow-hidden flex items-center justify-center">
                    <% if(b.getImagePath() != null && !b.getImagePath().isEmpty()) { %>
                        <img src="<%= b.getImagePath() %>" class="w-full h-full object-cover group-hover:scale-110 transition duration-500">
                    <% } else { %>
                        <i class="fas fa-book text-5xl text-stone-400"></i>
                    <% } %>
                    
                    <!-- Wishlist Button Overlay -->
                    <div class="absolute top-3 right-3 z-10">
                        <form method="post" action="viewbook.jsp">
                            <input type="hidden" name="wishlistBookId" value="<%= b.getBarcode() %>">
                            <% if (inWishlist) { %>
                                <input type="hidden" name="action" value="removeWishlist">
                                <button type="submit" class="w-10 h-10 rounded-full bg-white/90 backdrop-blur text-red-500 shadow hover:scale-110 transition flex items-center justify-center" title="Remove from Wishlist">
                                    <i class="fas fa-heart text-xl"></i>
                                </button>
                            <% } else { %>
                                <input type="hidden" name="action" value="addWishlist">
                                <button type="submit" class="w-10 h-10 rounded-full bg-white/90 backdrop-blur text-stone-400 hover:text-red-500 shadow hover:scale-110 transition flex items-center justify-center" title="Add to Wishlist">
                                    <i class="far fa-heart text-xl"></i>
                                </button>
                            <% } %>
                        </form>
                    </div>

                    <!-- PDF Preview Overlay -->
                    <% if(b.getPdfPath() != null && !b.getPdfPath().isEmpty()) { %>
                    <div class="absolute inset-0 bg-stone-900/60 opacity-0 group-hover:opacity-100 transition duration-300 flex flex-col items-center justify-center gap-3">
                        <button onclick="openPdfPreview('<%= b.getPdfPath() %>', '<%= b.getName().replace("'", "\\'") %>')" class="bg-red-600 hover:bg-red-700 text-white font-bold px-4 py-2 rounded-lg shadow-lg flex items-center text-sm transform transition hover:scale-105">
                            <i class="fas fa-file-pdf mr-2"></i> Preview PDF
                        </button>
                    </div>
                    <% } %>
                </div>

                <!-- Book Details -->
                <div class="p-5 flex flex-col flex-grow">
                    <div class="flex justify-between items-start mb-1">
                        <p class="text-xs text-amber-600 dark:text-amber-500 font-bold uppercase tracking-wider line-clamp-1"><%= b.getBarcode() %></p>
                        <span class="bg-stone-100 dark:bg-stone-700 text-stone-600 dark:text-stone-300 text-xs font-bold px-2 py-0.5 rounded ml-2">Qty: <%= b.getQuantity() %></span>
                    </div>
                    <h4 class="font-bold text-stone-900 dark:text-white line-clamp-2 leading-tight mb-2 h-10" title="<%= b.getName() %>"><%= b.getName() %></h4>
                    <p class="text-sm text-stone-500 dark:text-stone-400 mb-4 line-clamp-1 flex-grow"><%= b.getAuthor() %></p>
                    
                    <div class="flex items-center justify-between mt-auto">
                        <span class="text-xl font-black text-stone-900 dark:text-white">₹ <%= b.getPrice() %></span>
                        
                        <div class="flex space-x-2">
                            <!-- Add to Cart Form -->
                            <form method="post" action="viewbook.jsp">
                                <input type="hidden" name="selectedBookId" value="<%= b.getBarcode() %>">
                                <input type="hidden" name="addToCart" value="true">
                                <% if(b.getQuantity() > 0) { %>
                                    <button type="submit" class="bg-indigo-600 hover:bg-indigo-700 text-white w-10 h-10 rounded-lg shadow-md transition flex items-center justify-center transform hover:-translate-y-1" title="Add to Cart">
                                        <i class="fas fa-cart-plus"></i>
                                    </button>
                                <% } else { %>
                                    <button type="button" disabled class="bg-stone-300 dark:bg-stone-700 text-stone-500 w-10 h-10 rounded-lg cursor-not-allowed flex items-center justify-center" title="Out of Stock">
                                        <i class="fas fa-ban"></i>
                                    </button>
                                <% } %>
                            </form>

                            <!-- Buy Now Form -->
                            <form method="post" action="viewbook.jsp">
                                <input type="hidden" name="selectedBookId" value="<%= b.getBarcode() %>">
                                <input type="hidden" name="addToCart" value="true">
                                <input type="hidden" name="buyNow" value="true">
                                <% if(b.getQuantity() > 0) { %>
                                    <button type="submit" class="bg-amber-600 hover:bg-amber-700 text-white px-4 h-10 rounded-lg shadow-md transition flex items-center justify-center transform hover:-translate-y-1 font-bold text-sm" title="Buy Now">
                                        Buy Now
                                    </button>
                                <% } %>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
            <% 
                   }
               } else { 
            %>
            <div class="col-span-full py-20 text-center">
                <i class="fas fa-books text-6xl text-stone-300 dark:text-stone-700 mb-6 block"></i>
                <h3 class="text-2xl font-bold text-stone-700 dark:text-stone-300">No Books Found</h3>
                <p class="text-stone-500 dark:text-stone-500 mt-2">The library is currently empty. Please check back later.</p>
            </div>
            <% } %>
        </div>
    </div>
</div>

<!-- PDF Preview Modal -->
<div id="pdfModal" class="hidden fixed inset-0 z-50 flex items-center justify-center">
    <!-- Backdrop -->
    <div class="absolute inset-0 bg-stone-900/80 backdrop-blur-sm" onclick="closePdfPreview()"></div>
    
    <!-- Modal Content -->
    <div class="bg-white dark:bg-stone-800 rounded-2xl shadow-2xl w-11/12 md:w-3/4 lg:w-2/3 xl:w-1/2 h-[80vh] flex flex-col relative z-10 overflow-hidden border border-stone-200 dark:border-stone-700">
        <!-- Modal Header -->
        <div class="bg-stone-100 dark:bg-stone-900 p-4 border-b border-stone-200 dark:border-stone-700 flex justify-between items-center">
            <h3 id="pdfModalTitle" class="font-bold text-stone-800 dark:text-white text-lg font-playfair line-clamp-1 flex-grow pr-4">PDF Preview</h3>
            <button onclick="closePdfPreview()" class="text-stone-500 hover:text-red-500 transition w-8 h-8 flex items-center justify-center rounded-full hover:bg-stone-200 dark:hover:bg-stone-800">
                <i class="fas fa-times text-xl"></i>
            </button>
        </div>
        
        <!-- Modal Body (Iframe) -->
        <div class="flex-grow bg-stone-200 dark:bg-stone-700">
            <iframe id="pdfModalIframe" src="" class="w-full h-full border-0"></iframe>
        </div>
    </div>
</div>

<% if (showToast) { %>
<!-- Success Toast Notification -->
<div id="toast-notification" class="fixed bottom-5 right-5 z-50 flex items-center w-full max-w-xs p-4 space-x-3 text-stone-500 bg-white dark:bg-stone-800 rounded-xl shadow-2xl border border-stone-100 dark:border-stone-700 transform translate-y-0 opacity-100 transition duration-500" role="alert">
    <div class="inline-flex items-center justify-center flex-shrink-0 w-10 h-10 text-green-500 bg-green-100 dark:bg-green-900/30 rounded-full">
        <i class="fas fa-check"></i>
    </div>
    <div class="ml-3 text-sm font-semibold text-stone-800 dark:text-white"><%= toastMessage %></div>
    <button type="button" onclick="document.getElementById('toast-notification').classList.add('translate-y-10', 'opacity-0'); setTimeout(() => document.getElementById('toast-notification').remove(), 500);" class="ml-auto -mx-1.5 -my-1.5 bg-white text-stone-400 hover:text-stone-900 rounded-lg focus:ring-2 focus:ring-stone-300 p-1.5 hover:bg-stone-100 inline-flex items-center justify-center h-8 w-8 dark:text-stone-500 dark:hover:text-white dark:bg-stone-800 dark:hover:bg-stone-700">
        <i class="fas fa-times"></i>
    </button>
</div>
<script>
    setTimeout(function() {
        const toast = document.getElementById('toast-notification');
        if(toast) {
            toast.classList.add('translate-y-10', 'opacity-0');
            setTimeout(() => toast.remove(), 500);
        }
    }, 4000); // Auto close after 4 seconds
</script>
<% } %>

<jsp:include page="WEB-INF/views/footer.jsp" />
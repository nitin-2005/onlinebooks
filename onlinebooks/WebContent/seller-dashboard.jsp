<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.bittercode.model.User" %>
<%@ page import="com.bittercode.model.Book" %>
<%@ page import="com.bittercode.service.UserService" %>
<%@ page import="com.bittercode.service.impl.UserServiceImpl" %>
<%@ page import="com.bittercode.service.BookService" %>
<%@ page import="com.bittercode.service.impl.BookServiceImpl" %>
<% 
  String sellerEmail = (String) session.getAttribute("USERNAME");
  if(session.getAttribute("SELLER") == null) { 
      response.sendRedirect(request.getContextPath() + "/login.jsp"); 
      return; 
  }
%>
<jsp:include page="WEB-INF/views/header.jsp" />
  
  String activeTab = request.getParameter("activeTab");
  if(activeTab == null || activeTab.isEmpty()) {
      activeTab = "tab-inventory";
  }

  UserService userService = new UserServiceImpl();
  User userObj = userService.getUserByEmailId(sellerEmail);
  String profileImage = (userObj != null && userObj.getProfileImage() != null) ? userObj.getProfileImage() : "https://ui-avatars.com/api/?name=" + (userObj != null ? userObj.getFirstName() : "S") + "&background=random";

  BookService bookService = new BookServiceImpl();
  List<Book> sellerBooks = bookService.getAllBooks(); // Using all books as global inventory/seller placeholder
%>

<script>
    function switchTab(tabId) {
        document.querySelectorAll('.dashboard-tab').forEach(el => el.classList.add('hidden'));
        document.getElementById(tabId).classList.remove('hidden');
        
        document.querySelectorAll('.nav-link').forEach(el => {
            el.classList.remove('bg-indigo-50', 'text-indigo-700', 'dark:bg-indigo-900', 'dark:text-indigo-300', 'border-r-4', 'border-indigo-600');
            el.classList.add('text-stone-600', 'hover:bg-stone-50', 'dark:text-stone-300', 'dark:hover:bg-stone-800');
        });
        
        const activeLink = document.getElementById('nav-' + tabId);
        if(activeLink) {
            activeLink.classList.remove('text-stone-600', 'hover:bg-stone-50', 'dark:text-stone-300', 'dark:hover:bg-stone-800');
            activeLink.classList.add('bg-indigo-50', 'text-indigo-700', 'dark:bg-indigo-900', 'dark:text-indigo-300', 'border-r-4', 'border-indigo-600');
        }
    }

    function toggleTheme() {
        document.documentElement.classList.toggle('dark');
        const isDark = document.documentElement.classList.contains('dark');
        localStorage.setItem('theme', isDark ? 'dark' : 'light');
    }

    if (localStorage.getItem('theme') === 'dark' || (!('theme' in localStorage) && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
        document.documentElement.classList.add('dark');
    } else {
        document.documentElement.classList.remove('dark');
    }

    window.onload = function() {
        switchTab('<%= activeTab %>');
    };
</script>

<div class="bg-stone-50 dark:bg-stone-900 min-h-screen pt-4 pb-16 transition-colors duration-300">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        
        <div class="flex flex-col md:flex-row gap-6 mt-8">
            
            <!-- Sidebar -->
            <div class="w-full md:w-1/4">
                <div class="bg-white dark:bg-stone-800 rounded-2xl shadow-lg border border-stone-200 dark:border-stone-700 overflow-hidden sticky top-8">
                    <div class="p-6 text-center border-b border-stone-200 dark:border-stone-700 relative">
                        <button onclick="toggleTheme()" class="absolute top-4 right-4 text-stone-400 hover:text-amber-500 transition" title="Toggle Theme">
                            <i class="fas fa-moon dark:hidden"></i>
                            <i class="fas fa-sun hidden dark:inline"></i>
                        </button>
                        
                        <div class="relative w-24 h-24 mx-auto mb-4">
                            <img src="<%= profileImage %>" alt="Profile" class="w-24 h-24 rounded-full object-cover border-4 border-indigo-100 dark:border-indigo-900 shadow-md">
                        </div>
                        <h2 class="text-xl font-bold text-stone-800 dark:text-white font-playfair"><%= userObj != null ? userObj.getFirstName() + " " + userObj.getLastName() : session.getAttribute("SELLER") %></h2>
                        <p class="text-stone-500 dark:text-stone-400 text-sm"><%= sellerEmail %></p>
                        <span class="inline-block mt-2 bg-indigo-100 text-indigo-800 dark:bg-indigo-900/30 dark:text-indigo-400 text-xs px-2 py-1 rounded-full font-bold">Seller Account</span>
                    </div>

                    <div class="py-2">
                        <button id="nav-tab-inventory" onclick="switchTab('tab-inventory')" class="nav-link w-full text-left px-6 py-3 font-medium transition flex items-center bg-indigo-50 text-indigo-700 dark:bg-indigo-900 dark:text-indigo-300 border-r-4 border-indigo-600">
                            <i class="fas fa-boxes w-6 text-center mr-2"></i> My Inventory
                        </button>
                        <button id="nav-tab-addbook" onclick="switchTab('tab-addbook')" class="nav-link w-full text-left px-6 py-3 font-medium text-stone-600 hover:bg-stone-50 dark:text-stone-300 dark:hover:bg-stone-700 transition flex items-center">
                            <i class="fas fa-plus-circle w-6 text-center mr-2"></i> Add New Book
                        </button>
                        <button id="nav-tab-profile" onclick="switchTab('tab-profile')" class="nav-link w-full text-left px-6 py-3 font-medium text-stone-600 hover:bg-stone-50 dark:text-stone-300 dark:hover:bg-stone-700 transition flex items-center">
                            <i class="fas fa-user-edit w-6 text-center mr-2"></i> Store Profile
                        </button>
                        <a href="logout" class="w-full text-left px-6 py-3 font-medium text-red-600 hover:bg-red-50 dark:hover:bg-red-900/20 transition flex items-center border-t border-stone-100 dark:border-stone-700 mt-2">
                            <i class="fas fa-sign-out-alt w-6 text-center mr-2"></i> Logout
                        </a>
                    </div>
                </div>
            </div>

            <!-- Content Area -->
            <div class="w-full md:w-3/4">
                
                <!-- TAB: Inventory -->
                <div id="tab-inventory" class="dashboard-tab bg-white dark:bg-stone-800 p-8 rounded-2xl shadow-lg border border-stone-200 dark:border-stone-700 min-h-[500px]">
                    <div class="flex justify-between items-center mb-6 border-b border-stone-100 dark:border-stone-700 pb-4">
                        <h3 class="text-2xl font-bold text-stone-800 dark:text-white font-playfair"><i class="fas fa-boxes text-indigo-600 mr-2"></i> My Listed Books</h3>
                        <button onclick="switchTab('tab-addbook')" class="text-white font-bold text-sm bg-indigo-600 hover:bg-indigo-700 px-4 py-2 rounded-full transition shadow"><i class="fas fa-plus mr-1"></i> Add Book</button>
                    </div>
                    
                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                        <% if(sellerBooks != null && !sellerBooks.isEmpty()) { 
                             for(Book b : sellerBooks) { %>
                        <div class="bg-stone-50 dark:bg-stone-700/30 rounded-xl p-4 border border-stone-100 dark:border-stone-700 flex flex-col hover:shadow-md transition">
                            <div class="flex space-x-4 mb-4">
                                <div class="w-16 h-24 bg-stone-200 dark:bg-stone-800 rounded overflow-hidden flex-shrink-0">
                                    <% if(b.getImagePath() != null && !b.getImagePath().isEmpty()) { %>
                                        <img src="<%= b.getImagePath() %>" class="w-full h-full object-cover">
                                    <% } else { %>
                                        <div class="w-full h-full flex items-center justify-center text-stone-400"><i class="fas fa-book"></i></div>
                                    <% } %>
                                </div>
                                <div class="flex-grow">
                                    <h4 class="font-bold text-stone-800 dark:text-white line-clamp-2"><%= b.getName() %></h4>
                                    <p class="text-xs text-stone-500 dark:text-stone-400 mb-1"><%= b.getAuthor() %></p>
                                    <p class="text-xs font-bold text-indigo-600 dark:text-indigo-400 mb-2">Stock: <%= b.getQuantity() %></p>
                                    <span class="font-black text-amber-600 dark:text-amber-500 text-lg">₹ <%= b.getPrice() %></span>
                                </div>
                            </div>
                            <div class="mt-auto pt-3 border-t border-stone-200 dark:border-stone-600 flex justify-between">
                                <a href="updatebook.jsp?bookId=<%= b.getBarcode() %>" class="text-indigo-600 hover:text-indigo-800 dark:text-indigo-400 dark:hover:text-indigo-300 font-bold text-sm"><i class="fas fa-edit"></i> Edit</a>
                                <form action="removebook" method="post" onsubmit="return confirm('Remove this book from inventory?');" class="inline">
                                    <input type="hidden" name="bookId" value="<%= b.getBarcode() %>">
                                    <button type="submit" class="text-red-600 hover:text-red-800 dark:text-red-400 dark:hover:text-red-300 font-bold text-sm"><i class="fas fa-trash"></i> Delete</button>
                                </form>
                            </div>
                        </div>
                        <%   }
                           } else { %>
                           <p class="text-stone-500 col-span-3 text-center py-10">No books found in your inventory.</p>
                        <% } %>
                    </div>
                </div>

                <!-- TAB: Add Book -->
                <div id="tab-addbook" class="dashboard-tab hidden bg-white dark:bg-stone-800 p-8 rounded-2xl shadow-lg border border-stone-200 dark:border-stone-700 min-h-[500px]">
                    <div class="mb-6 border-b border-stone-100 dark:border-stone-700 pb-4">
                        <h3 class="text-2xl font-bold text-stone-800 dark:text-white font-playfair"><i class="fas fa-plus-circle text-indigo-600 mr-2"></i> Add New Book</h3>
                    </div>
                    
                    <form action="admin/saveBook" method="POST" enctype="multipart/form-data" class="space-y-6 max-w-2xl">
                        <input type="hidden" name="action" value="add">
                        <input type="hidden" name="activeTab" value="tab-inventory">
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <div class="md:col-span-2">
                                <label class="block text-sm font-medium text-stone-700 dark:text-stone-300 mb-1">Book Name</label>
                                <input type="text" name="name" required class="appearance-none block w-full px-4 py-3 border border-stone-300 dark:border-stone-600 rounded-lg shadow-sm bg-white dark:bg-stone-700 text-stone-900 dark:text-white focus:ring-indigo-500 focus:border-indigo-500">
                            </div>
                            <div class="md:col-span-2">
                                <label class="block text-sm font-medium text-stone-700 dark:text-stone-300 mb-1">Author Name</label>
                                <input type="text" name="author" required class="appearance-none block w-full px-4 py-3 border border-stone-300 dark:border-stone-600 rounded-lg shadow-sm bg-white dark:bg-stone-700 text-stone-900 dark:text-white focus:ring-indigo-500 focus:border-indigo-500">
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-stone-700 dark:text-stone-300 mb-1">Price (₹)</label>
                                <input type="number" name="price" required class="appearance-none block w-full px-4 py-3 border border-stone-300 dark:border-stone-600 rounded-lg shadow-sm bg-white dark:bg-stone-700 text-stone-900 dark:text-white focus:ring-indigo-500 focus:border-indigo-500">
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-stone-700 dark:text-stone-300 mb-1">Quantity</label>
                                <input type="number" name="quantity" required class="appearance-none block w-full px-4 py-3 border border-stone-300 dark:border-stone-600 rounded-lg shadow-sm bg-white dark:bg-stone-700 text-stone-900 dark:text-white focus:ring-indigo-500 focus:border-indigo-500">
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-stone-700 dark:text-stone-300 mb-1">Book Cover Image</label>
                                <input type="file" name="image" accept="image/*" class="appearance-none block w-full px-4 py-2 border border-stone-300 dark:border-stone-600 rounded-lg shadow-sm bg-white dark:bg-stone-700 text-stone-900 dark:text-white focus:ring-indigo-500 focus:border-indigo-500">
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-stone-700 dark:text-stone-300 mb-1">Book PDF File</label>
                                <input type="file" name="pdf" accept="application/pdf" class="appearance-none block w-full px-4 py-2 border border-stone-300 dark:border-stone-600 rounded-lg shadow-sm bg-white dark:bg-stone-700 text-stone-900 dark:text-white focus:ring-indigo-500 focus:border-indigo-500">
                            </div>
                        </div>
                        <div class="pt-4 flex justify-end border-t border-stone-100 dark:border-stone-700 mt-6">
                            <button type="submit" class="bg-indigo-600 hover:bg-indigo-700 text-white font-bold py-3 px-8 rounded-lg shadow-lg transition transform hover:-translate-y-0.5">
                                Publish Book
                            </button>
                        </div>
                    </form>
                </div>

                <!-- TAB: Profile -->
                <div id="tab-profile" class="dashboard-tab hidden bg-white dark:bg-stone-800 p-8 rounded-2xl shadow-lg border border-stone-200 dark:border-stone-700 min-h-[500px]">
                    <div class="mb-6 border-b border-stone-100 dark:border-stone-700 pb-4">
                        <h3 class="text-2xl font-bold text-stone-800 dark:text-white font-playfair"><i class="fas fa-store text-indigo-600 mr-2"></i> Store Profile</h3>
                    </div>
                    <div class="p-6 bg-amber-50 dark:bg-amber-900/20 text-amber-800 dark:text-amber-400 rounded-xl mb-6 flex items-center border border-amber-200 dark:border-amber-900">
                        <i class="fas fa-info-circle text-2xl mr-4"></i>
                        <div>
                            <h4 class="font-bold">Important Commission Notice</h4>
                            <p class="text-sm">Please note that <strong>5% of every sale</strong> is automatically deducted and transferred to the Admin Account as platform commission. The remaining 95% will be deposited into your seller account.</p>
                        </div>
                    </div>
                    <!-- Form placeholder for store profile updates -->
                    <form action="customer/profile" method="POST" class="space-y-6 max-w-2xl">
                        <input type="hidden" name="activeTab" value="tab-profile">
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <div>
                                <label class="block text-sm font-medium text-stone-700 dark:text-stone-300 mb-1">First Name</label>
                                <input type="text" name="firstName" value="<%= userObj != null ? userObj.getFirstName() : "" %>" required class="appearance-none block w-full px-4 py-3 border border-stone-300 dark:border-stone-600 rounded-lg shadow-sm bg-white dark:bg-stone-700 text-stone-900 dark:text-white focus:ring-indigo-500 focus:border-indigo-500">
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-stone-700 dark:text-stone-300 mb-1">Last Name</label>
                                <input type="text" name="lastName" value="<%= userObj != null ? userObj.getLastName() : "" %>" required class="appearance-none block w-full px-4 py-3 border border-stone-300 dark:border-stone-600 rounded-lg shadow-sm bg-white dark:bg-stone-700 text-stone-900 dark:text-white focus:ring-indigo-500 focus:border-indigo-500">
                            </div>
                            <div class="md:col-span-2">
                                <label class="block text-sm font-medium text-stone-700 dark:text-stone-300 mb-1">Email ID (Store ID)</label>
                                <input type="text" value="<%= sellerEmail %>" readonly class="appearance-none block w-full px-4 py-3 border border-stone-200 dark:border-stone-700 rounded-lg shadow-sm bg-stone-100 dark:bg-stone-800 text-stone-500 dark:text-stone-400 cursor-not-allowed">
                            </div>
                        </div>
                        <div class="pt-4 flex justify-end border-t border-stone-100 dark:border-stone-700 mt-6">
                            <button type="submit" class="bg-indigo-600 hover:bg-indigo-700 text-white font-bold py-3 px-8 rounded-lg shadow-lg transition transform hover:-translate-y-0.5">
                                Save Details
                            </button>
                        </div>
                    </form>
                </div>

            </div>
        </div>
    </div>
</div>
<jsp:include page="WEB-INF/views/footer.jsp" />
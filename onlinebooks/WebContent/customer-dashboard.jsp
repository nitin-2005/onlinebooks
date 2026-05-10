<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>

<%@ page import="java.util.ArrayList" %>
<%@ page import="com.bittercode.model.Order" %>
<%@ page import="com.bittercode.dao.OrderDAO" %>

<%@ page import="com.bittercode.model.User" %>
<%@ page import="com.bittercode.model.Book" %>
<%@ page import="com.bittercode.model.Cart" %>
<%@ page import="com.bittercode.service.UserService" %>
<%@ page import="com.bittercode.service.impl.UserServiceImpl" %>
<%@ page import="com.bittercode.service.BookService" %>
<%@ page import="com.bittercode.service.impl.BookServiceImpl" %>
<%@ page import="com.bittercode.util.StoreUtil" %>
<% 
  String customerEmail = (String) session.getAttribute("USERNAME");
  if(session.getAttribute("CUSTOMER") == null) { 
      response.sendRedirect(request.getContextPath() + "/login.jsp"); 
      return; 
  }
%>
<jsp:include page="WEB-INF/views/header.jsp" />
  
  // Track active tab for postbacks
  String activeTab = request.getParameter("activeTab");
  if(activeTab == null || activeTab.isEmpty()) {
      activeTab = "tab-orders";
  }

  // Update Cart Session if add/remove requested
  StoreUtil.updateCartItems(request);
  
  // Handle Wishlist Remove Action from Dashboard
  String action = request.getParameter("action");
  String wishlistBookId = request.getParameter("wishlistBookId");
  List<String> wishlist = (List<String>) session.getAttribute("wishlistItems");
  if ("removeWishlist".equals(action) && wishlistBookId != null && wishlist != null) {
      wishlist.remove(wishlistBookId);
      session.setAttribute("wishlistItems", wishlist);
  }

  UserService userService = new UserServiceImpl();
  User userObj = userService.getUserByEmailId(customerEmail);
  String profileImage = (userObj != null && userObj.getProfileImage() != null) ? userObj.getProfileImage() : "https://ui-avatars.com/api/?name=" + (userObj != null ? userObj.getFirstName() : "U") + "&background=random";

  // Fetch Cart Items
  BookService bookService = new BookServiceImpl();
  String bookIds = (String) session.getAttribute("items");
  if (bookIds == null) bookIds = "";
  List<Book> cartBooks = bookService.getBooksByCommaSeperatedBookIds(bookIds);
  List<Cart> cartItemsList = new ArrayList<Cart>();
  double totalCartAmount = 0;
  
  if (cartBooks != null) {
      for (Book b : cartBooks) {
          Object qtyObj = session.getAttribute("qty_" + b.getBarcode());
          int qty = (qtyObj != null) ? (Integer) qtyObj : 1;
          Cart cartItem = new Cart(b, qty);
          cartItemsList.add(cartItem);
          totalCartAmount += (qty * b.getPrice());
      }
  }
  session.setAttribute("cartItems", cartItemsList);
  session.setAttribute("amountToPay", totalCartAmount);
  int cartItemCount = cartItemsList.size();
  
  // Fetch Wishlist Items
  // Fetch Wishlist Items
List<Book> wishlistBooks = new ArrayList<Book>();
if (wishlist != null && !wishlist.isEmpty()) {
    String wishlistIds = String.join(",", wishlist);
    wishlistBooks = bookService.getBooksByCommaSeperatedBookIds(wishlistIds);
}

// Fetch My Orders from Database
OrderDAO dao = new OrderDAO();
List<Order> myOrders = dao.getOrdersByUser(customerEmail);


String paymentSuccessMessage = (String) session.getAttribute("paymentSuccessMessage");
%>

<!-- Dashboard Script for Tabs & Theme -->
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

    // Load saved theme
    if (localStorage.getItem('theme') === 'dark' || (!('theme' in localStorage) && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
        document.documentElement.classList.add('dark');
    } else {
        document.documentElement.classList.remove('dark');
    }

    // Auto-switch to active tab on load
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
                    <!-- User Profile Snippet -->
                    <div class="p-6 text-center border-b border-stone-200 dark:border-stone-700 relative">
                        <button onclick="toggleTheme()" class="absolute top-4 right-4 text-stone-400 hover:text-amber-500 transition" title="Toggle Theme">
                            <i class="fas fa-moon dark:hidden"></i>
                            <i class="fas fa-sun hidden dark:inline"></i>
                        </button>
                        
                        <div class="relative w-24 h-24 mx-auto mb-4">
                            <img src="<%= profileImage %>" alt="Profile" class="w-24 h-24 rounded-full object-cover border-4 border-indigo-100 dark:border-indigo-900 shadow-md">
                            <button onclick="switchTab('tab-profile')" class="absolute bottom-0 right-0 bg-indigo-600 text-white rounded-full w-8 h-8 flex items-center justify-center shadow hover:bg-indigo-700 border-2 border-white dark:border-stone-800 transition">
                                <i class="fas fa-camera text-xs"></i>
                            </button>
                        </div>
                        <h2 class="text-xl font-bold text-stone-800 dark:text-white font-playfair"><%= userObj != null ? userObj.getFirstName() + " " + userObj.getLastName() : "Customer" %></h2>
                        <p class="text-stone-500 dark:text-stone-400 text-sm"><%= customerEmail %></p>
                    </div>

                    <!-- Navigation Links -->
                    <div class="py-2">
                        <button id="nav-tab-orders" onclick="switchTab('tab-orders')" class="nav-link w-full text-left px-6 py-3 font-medium transition flex items-center bg-indigo-50 text-indigo-700 dark:bg-indigo-900 dark:text-indigo-300 border-r-4 border-indigo-600">
                            <i class="fas fa-box-open w-6 text-center mr-2"></i> My Orders
                        </button>
                        <button id="nav-tab-cart" onclick="switchTab('tab-cart')" class="nav-link w-full text-left px-6 py-3 font-medium text-stone-600 hover:bg-stone-50 dark:text-stone-300 dark:hover:bg-stone-700 transition flex items-center justify-between">
                            <div class="flex items-center">
                                <i class="fas fa-shopping-cart w-6 text-center mr-2"></i> My Cart
                            </div>
                            <% if (cartItemCount > 0) { %>
                            <span class="bg-indigo-600 text-white text-xs font-bold px-2 py-1 rounded-full"><%= cartItemCount %></span>
                            <% } %>
                        </button>
                        <button id="nav-tab-profile" onclick="switchTab('tab-profile')" class="nav-link w-full text-left px-6 py-3 font-medium text-stone-600 hover:bg-stone-50 dark:text-stone-300 dark:hover:bg-stone-700 transition flex items-center">
                            <i class="fas fa-user-circle w-6 text-center mr-2"></i> Manage Profile
                        </button>
                        <button id="nav-tab-wishlist" onclick="switchTab('tab-wishlist')" class="nav-link w-full text-left px-6 py-3 font-medium text-stone-600 hover:bg-stone-50 dark:text-stone-300 dark:hover:bg-stone-700 transition flex items-center">
                            <i class="fas fa-heart w-6 text-center mr-2"></i> Wishlist
                        </button>
                        <button id="nav-tab-settings" onclick="switchTab('tab-settings')" class="nav-link w-full text-left px-6 py-3 font-medium text-stone-600 hover:bg-stone-50 dark:text-stone-300 dark:hover:bg-stone-700 transition flex items-center">
                            <i class="fas fa-cog w-6 text-center mr-2"></i> Settings
                        </button>
                        <a href="logout" class="w-full text-left px-6 py-3 font-medium text-red-600 hover:bg-red-50 dark:hover:bg-red-900/20 transition flex items-center border-t border-stone-100 dark:border-stone-700 mt-2">
                            <i class="fas fa-sign-out-alt w-6 text-center mr-2"></i> Logout
                        </a>
                    </div>
                </div>
            </div>

            <!-- Content Area -->
            <div class="w-full md:w-3/4">
                
                <!-- TAB: Orders -->
                <div id="tab-orders" class="dashboard-tab bg-white dark:bg-stone-800 p-8 rounded-2xl shadow-lg border border-stone-200 dark:border-stone-700 min-h-[500px]">
                    <div class="flex justify-between items-center mb-6 border-b border-stone-100 dark:border-stone-700 pb-4">
                        <h3 class="text-2xl font-bold text-stone-800 dark:text-white font-playfair"><i class="fas fa-shopping-bag text-indigo-600 mr-2"></i> My Order History</h3>
                        <a href="viewbook" class="text-indigo-600 dark:text-indigo-400 hover:text-indigo-800 dark:hover:text-indigo-300 font-bold text-sm bg-indigo-50 dark:bg-indigo-900/30 px-4 py-2 rounded-full transition">Browse More Books</a>
                    </div>
                    
                    <% if (paymentSuccessMessage != null && !paymentSuccessMessage.isEmpty()) { %>
                        <div class="mb-6 bg-green-50 dark:bg-green-900/20 border-l-4 border-green-500 p-4 rounded-r-lg shadow-sm">
                            <div class="flex items-center">
                                <div class="flex-shrink-0">
                                    <i class="fas fa-check-circle text-green-500 text-xl"></i>
                                </div>
                                <div class="ml-3">
                                    <p class="text-sm font-bold text-green-800 dark:text-green-300">
                                        <%= paymentSuccessMessage %>
                                    </p>
                                </div>
                            </div>
                        </div>
                        <% session.removeAttribute("paymentSuccessMessage"); %>
                    <% } %>
                    
                    <% if (myOrders.isEmpty()) { %>
                        <div class="flex flex-col items-center justify-center text-center py-16">
                            <div class="w-24 h-24 bg-stone-100 dark:bg-stone-700 text-stone-400 rounded-full flex items-center justify-center text-4xl mb-4">
                                <i class="fas fa-box-open"></i>
                            </div>
                            <h3 class="text-2xl font-bold text-stone-800 dark:text-white font-playfair mb-2">No Orders Yet</h3>
                            <p class="text-stone-500 dark:text-stone-400 mb-6 max-w-md">Looks like you haven't placed any orders. Start browsing our collection and find your next favorite book!</p>
                            <a href="viewbook" class="bg-indigo-600 hover:bg-indigo-700 text-white font-bold py-3 px-8 rounded-lg shadow transition">Browse Books</a>
                        </div>
                    <% } else { %>
                        <div class="space-y-6">
                            <% for (Order order : myOrders) { %>
                            <div class="border border-stone-200 dark:border-stone-700 rounded-xl overflow-hidden transition hover:shadow-md">
                                <div class="bg-stone-50 dark:bg-stone-700/50 px-6 py-4 flex flex-col md:flex-row justify-between md:items-center border-b border-stone-200 dark:border-stone-700 space-y-4 md:space-y-0">
                                    <div class="flex space-x-8">
                                        <div>
                                            <p class="text-xs text-stone-500 dark:text-stone-400 uppercase font-bold">Order Placed</p>
                                            <p class="text-sm font-semibold text-stone-800 dark:text-white"><%= order.getDate() %></p>
                                        </div>
                                        <div>
                                            <p class="text-xs text-stone-500 dark:text-stone-400 uppercase font-bold">Total</p>
                                            <p class="text-sm font-semibold text-stone-800 dark:text-white">₹ <%= order.getTotalAmount() %></p>
                                        </div>
                                    </div>
                                    <div class="md:text-right">
                                        <p class="text-xs text-stone-500 dark:text-stone-400 uppercase font-bold">Order #</p>
                                        <p class="text-sm font-mono font-semibold text-stone-800 dark:text-white"><%= order.getOrderId() %></p>
                                    </div>
                                </div>
                                
                                <div class="divide-y divide-stone-100 dark:divide-stone-700/50">
                                    <% for (Cart item : order.getItems()) { Book b = item.getBook(); %>
                                    <div class="p-6 flex items-center justify-between">
                                        <div class="flex items-center space-x-6">
                                            <% if (b.getImagePath() != null && !b.getImagePath().isEmpty()) { %>
                                                <img src="<%= b.getImagePath() %>" class="w-16 h-24 object-cover rounded shadow border border-stone-200 dark:border-stone-700">
                                            <% } else { %>
                                                <div class="w-16 h-24 bg-stone-200 dark:bg-stone-700 rounded shadow flex items-center justify-center text-stone-400"><i class="fas fa-book"></i></div>
                                            <% } %>
                                            <div>
                                                <h4 class="font-bold text-lg text-stone-800 dark:text-white hover:text-indigo-600 transition cursor-pointer line-clamp-1"><%= b.getName() %></h4>
                                                <p class="text-stone-500 dark:text-stone-400 mb-1">Author: <%= b.getAuthor() %></p>
                                                <p class="text-sm font-semibold text-stone-600 dark:text-stone-300">Qty: <%= item.getQuantity() %> × ₹<%= b.getPrice() %></p>
                                            </div>
                                        </div>
                                        <div class="text-right hidden sm:block">
                                            <span class="inline-flex items-center bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-400 px-4 py-2 rounded-full text-xs font-bold border border-green-200 dark:border-green-800">
                                                <i class="fas fa-truck mr-2"></i> Processing
                                            </span>
                                        </div>
                                    </div>
                                    <% } %>
                                </div>
                            </div>
                            <% } %>
                        </div>
                    <% } %>
                </div>

                <!-- TAB: Cart -->
                <div id="tab-cart" class="dashboard-tab hidden bg-white dark:bg-stone-800 p-8 rounded-2xl shadow-lg border border-stone-200 dark:border-stone-700 min-h-[500px]">
                    <div class="flex justify-between items-center mb-6 border-b border-stone-100 dark:border-stone-700 pb-4">
                        <h3 class="text-2xl font-bold text-stone-800 dark:text-white font-playfair"><i class="fas fa-shopping-cart text-indigo-600 mr-2"></i> My Shopping Cart</h3>
                    </div>
                    
                    <% if (cartItemsList.isEmpty()) { %>
                        <div class="flex flex-col items-center justify-center text-center py-16">
                            <div class="w-24 h-24 bg-stone-100 dark:bg-stone-700 text-stone-400 rounded-full flex items-center justify-center text-4xl mb-4">
                                <i class="fas fa-shopping-basket"></i>
                            </div>
                            <h3 class="text-2xl font-bold text-stone-800 dark:text-white font-playfair mb-2">Your Cart is Empty</h3>
                            <p class="text-stone-500 dark:text-stone-400 mb-6 max-w-md">Looks like you haven't added anything to your cart yet.</p>
                            <a href="viewbook" class="bg-indigo-600 hover:bg-indigo-700 text-white font-bold py-3 px-8 rounded-lg shadow transition">Start Shopping</a>
                        </div>
                    <% } else { %>
                        <div class="overflow-x-auto">
                            <table class="w-full text-left border-collapse">
                                <thead>
                                    <tr class="border-b-2 border-stone-200 dark:border-stone-700">
                                        <th class="py-4 px-2 font-bold text-stone-800 dark:text-stone-200">Book Details</th>
                                        <th class="py-4 px-2 font-bold text-stone-800 dark:text-stone-200 text-center">Price</th>
                                        <th class="py-4 px-2 font-bold text-stone-800 dark:text-stone-200 text-center">Quantity</th>
                                        <th class="py-4 px-2 font-bold text-stone-800 dark:text-stone-200 text-right">Subtotal</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (Cart cItem : cartItemsList) { 
                                           Book b = cItem.getBook(); 
                                           double subtotal = b.getPrice() * cItem.getQuantity();
                                    %>
                                    <tr class="border-b border-stone-100 dark:border-stone-700/50 hover:bg-stone-50 dark:hover:bg-stone-700/20 transition">
                                        <td class="py-4 px-2">
                                            <div class="flex items-center space-x-4">
                                                <div class="w-12 h-16 bg-stone-200 dark:bg-stone-700 rounded overflow-hidden flex-shrink-0">
                                                    <% if (b.getImagePath() != null && !b.getImagePath().isEmpty()) { %>
                                                        <img src="<%= b.getImagePath() %>" class="w-full h-full object-cover">
                                                    <% } else { %>
                                                        <div class="w-full h-full flex items-center justify-center text-stone-400"><i class="fas fa-book"></i></div>
                                                    <% } %>
                                                </div>
                                                <div>
                                                    <h4 class="font-bold text-stone-800 dark:text-white"><%= b.getName() %></h4>
                                                    <p class="text-xs text-stone-500 dark:text-stone-400"><%= b.getAuthor() %></p>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="py-4 px-2 text-center text-stone-600 dark:text-stone-300 font-medium">₹<%= b.getPrice() %></td>
                                        <td class="py-4 px-2">
                                            <div class="flex items-center justify-center space-x-2">
                                                <form method="post" action="customer-dashboard.jsp" class="inline">
                                                    <input type="hidden" name="activeTab" value="tab-cart">
                                                    <input type="hidden" name="selectedBookId" value="<%= b.getBarcode() %>">
                                                    <button type="submit" name="removeFromCart" class="w-8 h-8 rounded-full bg-stone-100 dark:bg-stone-700 hover:bg-red-100 dark:hover:bg-red-900/40 text-stone-600 dark:text-stone-300 hover:text-red-600 dark:hover:text-red-400 transition flex items-center justify-center">
                                                        <i class="fas fa-minus text-xs"></i>
                                                    </button>
                                                </form>
                                                <span class="font-bold w-6 text-center text-stone-800 dark:text-white"><%= cItem.getQuantity() %></span>
                                                <form method="post" action="customer-dashboard.jsp" class="inline">
                                                    <input type="hidden" name="activeTab" value="tab-cart">
                                                    <input type="hidden" name="selectedBookId" value="<%= b.getBarcode() %>">
                                                    <button type="submit" name="addToCart" class="w-8 h-8 rounded-full bg-stone-100 dark:bg-stone-700 hover:bg-green-100 dark:hover:bg-green-900/40 text-stone-600 dark:text-stone-300 hover:text-green-600 dark:hover:text-green-400 transition flex items-center justify-center">
                                                        <i class="fas fa-plus text-xs"></i>
                                                    </button>
                                                </form>
                                            </div>
                                        </td>
                                        <td class="py-4 px-2 text-right font-bold text-indigo-600 dark:text-indigo-400">₹<%= subtotal %></td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                        
                        <div class="mt-8 bg-stone-50 dark:bg-stone-700/30 p-6 rounded-xl border border-stone-200 dark:border-stone-700 flex flex-col items-end">
                            <div class="text-stone-600 dark:text-stone-400 mb-2">Total Amount to Pay</div>
                            <div class="text-3xl font-bold text-stone-900 dark:text-white font-mono mb-6">₹<%= totalCartAmount %></div>
                            <form action="checkout.jsp" method="post">
                                <input type="hidden" name="pay" value="Proceed to Pay">
                                <button type="submit" class="bg-indigo-600 hover:bg-indigo-700 text-white font-bold py-3 px-8 rounded-lg shadow-lg transition transform hover:-translate-y-0.5 flex items-center">
                                    Proceed to Checkout <i class="fas fa-arrow-right ml-2"></i>
                                </button>
                            </form>
                        </div>
                    <% } %>
                </div>

                <!-- TAB: Profile -->
                <div id="tab-profile" class="dashboard-tab hidden bg-white dark:bg-stone-800 p-8 rounded-2xl shadow-lg border border-stone-200 dark:border-stone-700 min-h-[500px]">
                    <div class="mb-6 border-b border-stone-100 dark:border-stone-700 pb-4">
                        <h3 class="text-2xl font-bold text-stone-800 dark:text-white font-playfair"><i class="fas fa-user-edit text-indigo-600 mr-2"></i> Manage Profile</h3>
                    </div>

                    <form action="customer/profile" method="POST" enctype="multipart/form-data" class="space-y-6 max-w-2xl">
                        <input type="hidden" name="activeTab" value="tab-profile">
                        <input type="hidden" name="action" value="updateProfile">
                        
                        <div class="flex items-center space-x-6 mb-8 bg-stone-50 dark:bg-stone-700/30 p-6 rounded-xl border border-stone-100 dark:border-stone-700">
                            <img src="<%= profileImage %>" class="w-20 h-20 rounded-full object-cover shadow border-2 border-white dark:border-stone-600">
                            <div>
                                <label for="profileImage" class="block text-sm font-medium text-stone-700 dark:text-stone-300 mb-2">Update Profile Photo</label>
                                <input type="file" id="profileImage" name="profileImage" accept="image/*" class="block w-full text-sm text-stone-500 dark:text-stone-400 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-indigo-50 file:text-indigo-700 hover:file:bg-indigo-100 dark:file:bg-indigo-900/50 dark:file:text-indigo-300 transition">
                            </div>
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <div>
                                <label class="block text-sm font-medium text-stone-700 dark:text-stone-300 mb-1">First Name</label>
                                <input type="text" name="firstName" value="<%= userObj != null ? userObj.getFirstName() : "" %>" required class="appearance-none block w-full px-4 py-3 border border-stone-300 dark:border-stone-600 rounded-lg shadow-sm bg-white dark:bg-stone-700 text-stone-900 dark:text-white focus:ring-indigo-500 focus:border-indigo-500">
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-stone-700 dark:text-stone-300 mb-1">Last Name</label>
                                <input type="text" name="lastName" value="<%= userObj != null ? userObj.getLastName() : "" %>" required class="appearance-none block w-full px-4 py-3 border border-stone-300 dark:border-stone-600 rounded-lg shadow-sm bg-white dark:bg-stone-700 text-stone-900 dark:text-white focus:ring-indigo-500 focus:border-indigo-500">
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-stone-700 dark:text-stone-300 mb-1">Phone Number</label>
                                <input type="number" name="phone" value="<%= userObj != null ? userObj.getPhone() : "" %>" required class="appearance-none block w-full px-4 py-3 border border-stone-300 dark:border-stone-600 rounded-lg shadow-sm bg-white dark:bg-stone-700 text-stone-900 dark:text-white focus:ring-indigo-500 focus:border-indigo-500">
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-stone-700 dark:text-stone-300 mb-1">Email ID (Read Only)</label>
                                <input type="text" value="<%= customerEmail %>" readonly class="appearance-none block w-full px-4 py-3 border border-stone-200 dark:border-stone-700 rounded-lg shadow-sm bg-stone-100 dark:bg-stone-800 text-stone-500 dark:text-stone-400 cursor-not-allowed">
                            </div>
                            <div class="md:col-span-2">
                                <label class="block text-sm font-medium text-stone-700 dark:text-stone-300 mb-1">Delivery Address</label>
                                <textarea name="address" rows="3" required class="appearance-none block w-full px-4 py-3 border border-stone-300 dark:border-stone-600 rounded-lg shadow-sm bg-white dark:bg-stone-700 text-stone-900 dark:text-white focus:ring-indigo-500 focus:border-indigo-500"><%= userObj != null ? userObj.getAddress() : "" %></textarea>
                            </div>
                        </div>
                        
                        <div class="pt-4 flex justify-end border-t border-stone-100 dark:border-stone-700 mt-6">
                            <button type="submit" class="bg-indigo-600 hover:bg-indigo-700 text-white font-bold py-3 px-8 rounded-lg shadow-lg transition transform hover:-translate-y-0.5">
                                Save Profile Changes
                            </button>
                        </div>
                    </form>
                </div>

                <!-- TAB: Wishlist -->
                <div id="tab-wishlist" class="dashboard-tab hidden bg-white dark:bg-stone-800 p-8 rounded-2xl shadow-lg border border-stone-200 dark:border-stone-700 min-h-[500px]">
                    <div class="mb-6 border-b border-stone-100 dark:border-stone-700 pb-4 flex justify-between items-center">
                        <h3 class="text-2xl font-bold text-stone-800 dark:text-white font-playfair"><i class="fas fa-heart text-red-500 mr-2"></i> My Wishlist</h3>
                        <span class="bg-red-50 text-red-600 text-sm font-bold px-3 py-1 rounded-full"><%= wishlistBooks.size() %> Items Saved</span>
                    </div>

                    <% if (wishlistBooks.isEmpty()) { %>
                    <div class="flex flex-col items-center justify-center text-center py-16">
                        <div class="w-24 h-24 bg-red-50 dark:bg-red-900/20 text-red-500 rounded-full flex items-center justify-center text-4xl mb-4">
                            <i class="fas fa-heart"></i>
                        </div>
                        <h3 class="text-2xl font-bold text-stone-800 dark:text-white font-playfair mb-2">Your Wishlist is Empty</h3>
                        <p class="text-stone-500 dark:text-stone-400 mb-6 max-w-md">Save items you want to buy later by clicking the heart icon on any book's page.</p>
                        <a href="viewbook.jsp" class="bg-indigo-600 hover:bg-indigo-700 text-white font-bold py-3 px-8 rounded-lg shadow transition">Browse Books</a>
                    </div>
                    <% } else { %>
                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                        <% for (Book wBook : wishlistBooks) { %>
                        <div class="bg-stone-50 dark:bg-stone-700/30 rounded-xl p-4 border border-stone-100 dark:border-stone-700 flex flex-col hover:shadow-md transition">
                            <div class="flex space-x-4 mb-4">
                                <div class="w-16 h-24 bg-stone-200 dark:bg-stone-800 rounded overflow-hidden flex-shrink-0">
                                    <% if(wBook.getImagePath() != null && !wBook.getImagePath().isEmpty()) { %>
                                        <img src="<%= wBook.getImagePath() %>" class="w-full h-full object-cover">
                                    <% } else { %>
                                        <div class="w-full h-full flex items-center justify-center text-stone-400"><i class="fas fa-book"></i></div>
                                    <% } %>
                                </div>
                                <div class="flex-grow">
                                    <h4 class="font-bold text-stone-800 dark:text-white line-clamp-2"><%= wBook.getName() %></h4>
                                    <p class="text-xs text-stone-500 dark:text-stone-400 mb-2"><%= wBook.getAuthor() %></p>
                                    <span class="font-black text-amber-600 dark:text-amber-500 text-lg">₹ <%= wBook.getPrice() %></span>
                                </div>
                            </div>
                            <div class="flex space-x-2 mt-auto">
                                <form method="post" action="customer-dashboard.jsp" class="flex-grow">
                                    <input type="hidden" name="activeTab" value="tab-wishlist">
                                    <input type="hidden" name="selectedBookId" value="<%= wBook.getBarcode() %>">
                                    <input type="hidden" name="addToCart" value="true">
                                    <button type="submit" class="w-full bg-indigo-600 hover:bg-indigo-700 text-white font-bold py-2 rounded-lg transition text-sm flex items-center justify-center">
                                        <i class="fas fa-cart-plus mr-2"></i> Move to Cart
                                    </button>
                                </form>
                                <form method="post" action="customer-dashboard.jsp" class="flex-shrink-0">
                                    <input type="hidden" name="activeTab" value="tab-wishlist">
                                    <input type="hidden" name="wishlistBookId" value="<%= wBook.getBarcode() %>">
                                    <input type="hidden" name="action" value="removeWishlist">
                                    <button type="submit" class="w-10 h-10 bg-red-100 dark:bg-red-900/30 hover:bg-red-200 dark:hover:bg-red-900/60 text-red-600 dark:text-red-400 font-bold rounded-lg transition flex items-center justify-center">
                                        <i class="fas fa-trash-alt"></i>
                                    </button>
                                </form>
                            </div>
                        </div>
                        <% } %>
                    </div>
                    <% } %>
                </div>

                <!-- TAB: Settings -->
                <div id="tab-settings" class="dashboard-tab hidden bg-white dark:bg-stone-800 p-8 rounded-2xl shadow-lg border border-stone-200 dark:border-stone-700 min-h-[500px]">
                    <div class="mb-6 border-b border-stone-100 dark:border-stone-700 pb-4">
                        <h3 class="text-2xl font-bold text-stone-800 dark:text-white font-playfair"><i class="fas fa-cog text-indigo-600 mr-2"></i> Account Settings</h3>
                    </div>
                    
                    <div class="space-y-6 max-w-2xl">
                        <div class="flex items-center justify-between p-4 border border-stone-200 dark:border-stone-700 rounded-xl bg-stone-50 dark:bg-stone-800/50">
                            <div>
                                <h4 class="font-bold text-stone-800 dark:text-white">Email Notifications</h4>
                                <p class="text-sm text-stone-500 dark:text-stone-400">Receive order updates and offers.</p>
                            </div>
                            <label class="relative inline-flex items-center cursor-pointer">
                                <input type="checkbox" id="emailNotifToggle" class="sr-only peer" onchange="toggleEmailNotifications()">
                                <div class="w-11 h-6 bg-stone-300 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-indigo-300 dark:peer-focus:ring-indigo-800 rounded-full peer dark:bg-stone-600 peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all dark:border-gray-600 peer-checked:bg-indigo-600"></div>
                            </label>
                        </div>
                        
                        <div class="p-6 border border-red-200 dark:border-red-900/50 rounded-xl bg-red-50 dark:bg-red-900/10">
                            <h4 class="font-bold text-red-800 dark:text-red-400 mb-2">Danger Zone</h4>
                            <p class="text-sm text-red-600 dark:text-red-300 mb-4">Once you delete your account, there is no going back. Please be certain.</p>
                            <form action="customer/profile" method="POST" enctype="multipart/form-data" onsubmit="return confirm('Are you completely sure you want to permanently delete your account? This action cannot be undone.');">
                                <input type="hidden" name="action" value="deleteAccount">
                                <button type="submit" class="bg-red-600 hover:bg-red-700 text-white font-bold py-2 px-6 rounded transition text-sm">Delete Account</button>
                            </form>
                        </div>
                    </div>
                </div>

                <script>
                    // Email Notification settings persistence via localStorage
                    const notifToggle = document.getElementById('emailNotifToggle');
                    if(localStorage.getItem('emailNotif') !== 'false') {
                        notifToggle.checked = true;
                    } else {
                        notifToggle.checked = false;
                    }
                    
                    function toggleEmailNotifications() {
                        localStorage.setItem('emailNotif', notifToggle.checked);
                        
                        // Show a temporary visual feedback
                        const originalText = notifToggle.parentElement.previousElementSibling.firstElementChild.innerText;
                        notifToggle.parentElement.previousElementSibling.firstElementChild.innerText = notifToggle.checked ? "Notifications Enabled!" : "Notifications Disabled";
                        notifToggle.parentElement.previousElementSibling.firstElementChild.classList.add("text-indigo-600", "dark:text-indigo-400");
                        setTimeout(() => {
                            notifToggle.parentElement.previousElementSibling.firstElementChild.innerText = originalText;
                            notifToggle.parentElement.previousElementSibling.firstElementChild.classList.remove("text-indigo-600", "dark:text-indigo-400");
                        }, 2000);
                    }
                </script>

            </div>
        </div>
    </div>
</div>
<jsp:include page="WEB-INF/views/footer.jsp" />
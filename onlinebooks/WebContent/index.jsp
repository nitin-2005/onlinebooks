<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.bittercode.model.Book" %>
<%@ page import="com.bittercode.service.BookService" %>
<%@ page import="com.bittercode.service.impl.BookServiceImpl" %>
<jsp:include page="WEB-INF/views/header.jsp" />
<%
    BookService bookService = new BookServiceImpl();
    List<Book> allBooks = bookService.getAllBooks();
%>

<!-- Hero Section with Library Background -->
<div class="relative bg-stone-100 overflow-hidden dark:bg-stone-900 transition-colors duration-300">
    <div class="absolute inset-0 z-0">
        <img src="https://images.unsplash.com/photo-1481627834876-b7833e8f5570?ixlib=rb-4.0.3&auto=format&fit=crop&w=2000&q=80" alt="Beautiful Library" class="w-full h-full object-cover opacity-20 dark:opacity-10">
    </div>
    
    <div class="relative z-10 mx-auto max-w-7xl px-6 pb-24 pt-20 sm:pb-32 lg:flex lg:px-8 lg:py-40 items-center">
        <div class="mx-auto max-w-2xl flex-shrink-0 lg:mx-0 lg:max-w-xl">
            <div class="mb-6 inline-flex items-center rounded-full px-3 py-1 text-sm font-semibold text-amber-800 dark:text-amber-400 ring-1 ring-inset ring-amber-800/30 dark:ring-amber-400/30 bg-amber-50 dark:bg-amber-900/20">
                Over <%= allBooks != null ? allBooks.size() : 0 %> Premium Books Available
            </div>
            <h1 class="text-5xl font-bold tracking-tight text-stone-900 dark:text-white sm:text-7xl font-playfair leading-tight">
                Fuel your mind, <br><span class="text-amber-800 dark:text-amber-500 italic">elevate your soul.</span>
            </h1>
            <p class="mt-8 text-lg leading-8 text-stone-700 dark:text-stone-300 font-medium">
                Step into our digital sanctuary. From advanced IT programming guides to deep spiritual texts, preview full PDFs and listen to audio books before you buy.
            </p>
            <div class="mt-10 flex items-center gap-x-6">
                <a href="viewbook.jsp" class="rounded-full bg-amber-800 px-8 py-4 text-md font-bold text-white shadow-xl hover:bg-amber-900 dark:bg-amber-600 dark:hover:bg-amber-700 transition hover:-translate-y-1">Start Reading Now</a>
            </div>
        </div>
        <div class="mx-auto mt-16 flex max-w-2xl sm:mt-24 lg:ml-10 lg:mt-0 lg:mr-0 lg:max-w-none lg:flex-none xl:ml-32">
            <div class="max-w-3xl flex-none sm:max-w-5xl lg:max-w-none">
                <img src="https://images.unsplash.com/photo-1544947950-fa07a98d237f?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80" alt="Books Collection" class="w-[36rem] rounded-2xl shadow-2xl hover-lift">
            </div>
        </div>
    </div>
</div>

<!-- Motivation Section -->
<div class="bg-amber-900 dark:bg-stone-950 py-16 text-center border-y border-amber-800/50">
    <h2 class="text-3xl font-playfair italic text-amber-100 dark:text-amber-500 max-w-3xl mx-auto leading-relaxed px-4">
        "Read a thousand books, and your words will flow like a river. Programming or spirituality, the pursuit of knowledge is the highest virtue."
    </h2>
</div>

<!-- Category Sliders Section -->
<div class="max-w-7xl mx-auto px-6 py-24 sm:py-32 lg:px-8 bg-white dark:bg-stone-900 transition-colors duration-300">
    
    <!-- Featured Books -->
    <div class="mb-20">
        <div class="flex justify-between items-end mb-8 border-b border-stone-200 dark:border-stone-700 pb-4">
            <h2 class="text-4xl font-bold font-playfair text-stone-900 dark:text-white">Featured Books</h2>
            <a href="viewbook.jsp" class="text-amber-700 dark:text-amber-500 font-bold hover:underline flex items-center"><i class="fas fa-arrow-right mr-2"></i>View All Collection</a>
        </div>
        
        <div class="flex space-x-8 overflow-x-auto pb-8 snap-x smooth-scroll px-2">
            <% 
               if(allBooks != null && !allBooks.isEmpty()) {
                   for(int i=0; i<Math.min(10, allBooks.size()); i++) { 
                       Book b = allBooks.get(i);
            %>
            <div class="min-w-[300px] bg-white dark:bg-stone-800 rounded-xl shadow-md overflow-hidden hover-lift snap-start border border-gray-100 dark:border-stone-700">
                <div class="h-48 w-full bg-stone-200 dark:bg-stone-700 overflow-hidden flex items-center justify-center">
                    <% if(b.getImagePath() != null && !b.getImagePath().isEmpty()) { %>
                        <img src="<%= b.getImagePath() %>" class="w-full h-full object-cover">
                    <% } else { %>
                        <i class="fas fa-book text-4xl text-stone-400"></i>
                    <% } %>
                </div>
                <div class="p-6">
                    <h3 class="font-bold text-xl mb-2 text-stone-800 dark:text-white line-clamp-1" title="<%= b.getName() %>"><%= b.getName() %></h3>
                    <p class="text-stone-500 dark:text-stone-400 text-sm mb-4"><%= b.getAuthor() %></p>
                    <div class="flex justify-between items-center mt-4">
                        <span class="font-bold text-lg text-amber-700 dark:text-amber-400">₹ <%= b.getPrice() %></span>
                        <a href="viewbook.jsp" class="bg-stone-900 dark:bg-stone-700 text-white px-4 py-2 rounded-lg text-sm font-bold hover:bg-amber-800 dark:hover:bg-amber-600 transition">View Details</a>
                    </div>
                </div>
            </div>
            <% 
                   }
               } else { 
            %>
            <div class="w-full py-12 text-center text-stone-500 dark:text-stone-400">
                <i class="fas fa-books text-4xl mb-4"></i>
                <p>No books currently available in the featured collection.</p>
            </div>
            <% } %>
        </div>
    </div>
</div>

<jsp:include page="WEB-INF/views/footer.jsp" />
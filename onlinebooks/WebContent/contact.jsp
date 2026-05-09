<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="WEB-INF/views/header.jsp" />

<div class="relative overflow-hidden bg-stone-900 pt-32 pb-24 sm:pt-40 sm:pb-32 lg:pb-40">
  <div class="absolute inset-0 bg-gradient-to-br from-stone-900 via-stone-800 to-amber-900 opacity-90"></div>
  <div class="absolute inset-0 bg-[url('https://www.transparenttextures.com/patterns/stardust.png')] opacity-30"></div>
  <div class="relative mx-auto max-w-7xl px-6 lg:px-8 text-center">
    <div class="mx-auto max-w-3xl">
      <h1 class="text-4xl font-bold tracking-tight text-transparent bg-clip-text bg-gradient-to-r from-amber-200 to-amber-500 sm:text-6xl font-playfair drop-shadow-lg">
        Get in Touch
      </h1>
      <p class="mt-6 text-lg leading-8 text-stone-300">
        We'd love to hear from you. Whether you have a question about books, pricing, or our platform, our team is ready to answer all your questions.
      </p>
    </div>
  </div>
</div>

<div class="bg-stone-50 py-24 sm:py-32">
  <div class="mx-auto max-w-7xl px-6 lg:px-8">
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-16">
      
      <!-- Contact Information -->
      <div>
        <h2 class="text-3xl font-bold tracking-tight text-stone-900 font-playfair mb-8">Contact Information</h2>
        <p class="text-lg text-stone-600 mb-8">
          Fill out the form and our team will get back to you within 24 hours.
        </p>
        
        <div class="space-y-8 text-stone-600">
          <div class="flex items-start">
            <div class="flex-shrink-0 flex items-center justify-center h-12 w-12 rounded-xl bg-amber-100 text-amber-600">
              <i class="fas fa-phone-alt text-xl"></i>
            </div>
            <div class="ml-6">
              <h3 class="text-lg font-medium text-stone-900">Phone</h3>
              <p class="mt-1">+1 (555) 123-4567</p>
            </div>
          </div>
          
          <div class="flex items-start">
            <div class="flex-shrink-0 flex items-center justify-center h-12 w-12 rounded-xl bg-indigo-100 text-indigo-600">
              <i class="fas fa-envelope text-xl"></i>
            </div>
            <div class="ml-6">
              <h3 class="text-lg font-medium text-stone-900">Email</h3>
              <p class="mt-1">support@onlinebooks.com</p>
            </div>
          </div>
          
          <div class="flex items-start">
            <div class="flex-shrink-0 flex items-center justify-center h-12 w-12 rounded-xl bg-green-100 text-green-600">
              <i class="fas fa-map-marker-alt text-xl"></i>
            </div>
            <div class="ml-6">
              <h3 class="text-lg font-medium text-stone-900">Headquarters</h3>
              <p class="mt-1">123 Library Street<br>Silicon Valley, CA 94025</p>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Contact Form -->
      <div class="bg-white rounded-3xl shadow-xl border border-stone-100 p-10 lg:p-12">
        <c:if test="${not empty requestScope.message}">
            <div class="mb-6 p-4 rounded-md bg-green-50 border border-green-200 text-green-800 text-sm font-medium">
                ${requestScope.message}
            </div>
        </c:if>
        <c:if test="${not empty requestScope.error}">
            <div class="mb-6 p-4 rounded-md bg-red-50 border border-red-200 text-red-800 text-sm font-medium">
                ${requestScope.error}
            </div>
        </c:if>
      
        <form action="${pageContext.request.contextPath}/contactus" method="POST" class="space-y-6">
          <div>
            <label for="name" class="block text-sm font-medium leading-6 text-stone-900">Full Name</label>
            <div class="mt-2">
              <input type="text" name="name" id="name" required class="block w-full rounded-md border-0 py-3 text-stone-900 shadow-sm ring-1 ring-inset ring-stone-300 placeholder:text-stone-400 focus:ring-2 focus:ring-inset focus:ring-amber-600 sm:text-sm sm:leading-6 px-4 transition-shadow">
            </div>
          </div>
          
          <div>
            <label for="email" class="block text-sm font-medium leading-6 text-stone-900">Email Address</label>
            <div class="mt-2">
              <input type="email" name="email" id="email" required class="block w-full rounded-md border-0 py-3 text-stone-900 shadow-sm ring-1 ring-inset ring-stone-300 placeholder:text-stone-400 focus:ring-2 focus:ring-inset focus:ring-amber-600 sm:text-sm sm:leading-6 px-4 transition-shadow">
            </div>
          </div>
          
          <div>
            <label for="message" class="block text-sm font-medium leading-6 text-stone-900">Message</label>
            <div class="mt-2">
              <textarea id="message" name="message" rows="4" required class="block w-full rounded-md border-0 py-3 text-stone-900 shadow-sm ring-1 ring-inset ring-stone-300 placeholder:text-stone-400 focus:ring-2 focus:ring-inset focus:ring-amber-600 sm:text-sm sm:leading-6 px-4 transition-shadow"></textarea>
            </div>
          </div>
          
          <div>
            <button type="submit" class="w-full flex justify-center rounded-md bg-amber-700 px-3 py-3.5 text-sm font-semibold leading-6 text-white shadow-sm hover:bg-amber-600 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-amber-600 transition-colors">
              Send Message
            </button>
          </div>
        </form>
      </div>
      
    </div>
  </div>
</div>

<jsp:include page="WEB-INF/views/footer.jsp" />

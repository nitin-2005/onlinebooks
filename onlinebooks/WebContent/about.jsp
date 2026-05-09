<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="WEB-INF/views/header.jsp" />
<style>
  @keyframes float {
    0% { transform: translateY(0px); }
    50% { transform: translateY(-15px); }
    100% { transform: translateY(0px); }
  }
  @keyframes glow {
    0% { box-shadow: 0 0 15px rgba(245, 158, 11, 0.1); }
    50% { box-shadow: 0 0 35px rgba(245, 158, 11, 0.4); }
    100% { box-shadow: 0 0 15px rgba(245, 158, 11, 0.1); }
  }
  .animate-float { animation: float 6s ease-in-out infinite; }
  .animate-glow { animation: glow 4s ease-in-out infinite; }
</style>

<div class="relative overflow-hidden bg-stone-900 pt-32 pb-24 sm:pt-40 sm:pb-32 lg:pb-40">
  <div class="absolute inset-0 bg-gradient-to-br from-stone-900 via-stone-800 to-amber-900 opacity-90"></div>
  <div class="absolute inset-0 bg-[url('https://www.transparenttextures.com/patterns/stardust.png')] opacity-30"></div>
  <div class="relative mx-auto max-w-7xl px-6 lg:px-8 text-center">
    <div class="mx-auto max-w-3xl">
      <h1 class="text-4xl font-bold tracking-tight text-transparent bg-clip-text bg-gradient-to-r from-amber-200 to-amber-500 sm:text-6xl font-playfair drop-shadow-lg">
        The Future of Reading
      </h1>
      <p class="mt-6 text-lg leading-8 text-stone-300">
        We are more than just a digital bookstore. We are a sanctuary for knowledge seekers, providing a seamless and immersive reading experience tailored for the modern mind.
      </p>
    </div>
  </div>
</div>

<div class="bg-stone-50 py-24 sm:py-32">
  <div class="mx-auto max-w-7xl px-6 lg:px-8">
    <div class="mx-auto max-w-2xl lg:text-center mb-16">
      <h2 class="text-base font-semibold leading-7 text-amber-700 uppercase tracking-widest">Our Story</h2>
      <p class="mt-2 text-3xl font-bold tracking-tight text-stone-900 sm:text-4xl font-playfair">Born from a passion for knowledge</p>
      <p class="mt-6 text-lg leading-8 text-stone-600">
        OnlineBooks started with a simple idea: access to high-quality IT and Spiritual literature shouldn't be constrained by physical boundaries. We've built a platform that bridges the gap between avid readers and life-changing content.
      </p>
    </div>

    <div class="mx-auto mt-16 max-w-2xl sm:mt-20 lg:mt-24 lg:max-w-none">
      <dl class="grid max-w-xl grid-cols-1 gap-x-8 gap-y-16 lg:max-w-none lg:grid-cols-2">
        <div class="flex flex-col bg-white rounded-2xl shadow-xl hover:shadow-2xl transition-all duration-300 p-10 hover:-translate-y-2 border border-stone-100 group">
          <dt class="flex items-center gap-x-3 text-2xl font-bold leading-7 text-stone-900 font-playfair">
            <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-amber-50 text-amber-600 group-hover:bg-amber-100 transition-colors">
              <i class="fas fa-eye text-xl"></i>
            </div>
            Our Vision
          </dt>
          <dd class="mt-6 flex flex-auto flex-col text-base leading-7 text-stone-600">
            <p class="flex-auto">To become the world's most accessible and premium digital library, empowering minds globally with seamless access to transformative literature.</p>
          </dd>
        </div>
        <div class="flex flex-col bg-white rounded-2xl shadow-xl hover:shadow-2xl transition-all duration-300 p-10 hover:-translate-y-2 border border-stone-100 group">
          <dt class="flex items-center gap-x-3 text-2xl font-bold leading-7 text-stone-900 font-playfair">
            <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-indigo-50 text-indigo-600 group-hover:bg-indigo-100 transition-colors">
              <i class="fas fa-rocket text-xl"></i>
            </div>
            Our Mission
          </dt>
          <dd class="mt-6 flex flex-auto flex-col text-base leading-7 text-stone-600">
            <p class="flex-auto">To curate an unparalleled collection of IT and Spiritual books, delivered through an intuitive, beautiful, and highly responsive platform.</p>
          </dd>
        </div>
      </dl>
    </div>
  </div>
</div>

<div class="bg-stone-900 py-24 sm:py-32 relative overflow-hidden">
  <div class="absolute -top-24 -left-24 w-96 h-96 bg-amber-900/20 rounded-full blur-3xl"></div>
  <div class="absolute -bottom-24 -right-24 w-96 h-96 bg-indigo-900/20 rounded-full blur-3xl"></div>
  
  <div class="mx-auto max-w-7xl px-6 lg:px-8 relative z-10">
    <div class="mx-auto max-w-2xl lg:mx-0 mb-16">
      <h2 class="text-3xl font-bold tracking-tight text-white sm:text-4xl font-playfair">Project Architecture</h2>
      <p class="mt-6 text-lg leading-8 text-stone-300">A robust, scalable, and premium platform engineered for an unmatched digital reading experience.</p>
    </div>

    <div class="relative mx-auto w-full max-w-5xl animate-float">
      <div class="absolute inset-0 bg-gradient-to-r from-amber-500 to-indigo-600 blur-xl opacity-20 rounded-3xl"></div>
      <div class="relative bg-stone-800/80 border border-stone-700/50 rounded-3xl p-8 sm:p-12 shadow-2xl animate-glow backdrop-blur-sm">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-12 items-center">
          <div>
            <h3 class="text-2xl font-bold text-transparent bg-clip-text bg-gradient-to-r from-amber-200 to-amber-500 font-playfair mb-4">Under the Hood</h3>
            <p class="text-stone-300 leading-relaxed mb-6">
              OnlineBooks is powered by a robust backend, delivering lightning-fast page loads and secure data transactions. Our platform utilizes advanced templating, robust database integration, and a highly responsive Tailwind CSS frontend to guarantee a flawless experience across all devices.
            </p>
            <ul class="space-y-4">
              <li class="flex items-center text-stone-300">
                <div class="flex-shrink-0 h-8 w-8 rounded-full bg-amber-500/20 flex items-center justify-center mr-4 border border-amber-500/30">
                    <i class="fas fa-shield-alt text-amber-500 text-sm"></i>
                </div>
                Advanced Role-Based Access Control
              </li>
              <li class="flex items-center text-stone-300">
                <div class="flex-shrink-0 h-8 w-8 rounded-full bg-indigo-500/20 flex items-center justify-center mr-4 border border-indigo-500/30">
                    <i class="fas fa-file-pdf text-indigo-400 text-sm"></i>
                </div>
                Seamless PDF Integration
              </li>
              <li class="flex items-center text-stone-300">
                <div class="flex-shrink-0 h-8 w-8 rounded-full bg-green-500/20 flex items-center justify-center mr-4 border border-green-500/30">
                    <i class="fas fa-chart-line text-green-400 text-sm"></i>
                </div>
                Real-time Analytics & Dashboard
              </li>
            </ul>
          </div>
          <div class="grid grid-cols-2 gap-4">
            <div class="bg-stone-900/60 p-6 rounded-2xl border border-stone-700/50 hover:border-amber-500/50 hover:bg-stone-800 transition-all duration-300 flex flex-col items-center justify-center text-center group">
              <i class="fab fa-java text-4xl text-stone-500 group-hover:text-amber-500 transition-colors mb-3"></i>
              <span class="text-sm font-semibold text-stone-400 group-hover:text-stone-200 transition-colors">Java MVC</span>
            </div>
            <div class="bg-stone-900/60 p-6 rounded-2xl border border-stone-700/50 hover:border-indigo-500/50 hover:bg-stone-800 transition-all duration-300 flex flex-col items-center justify-center text-center group">
              <i class="fas fa-database text-4xl text-stone-500 group-hover:text-indigo-400 transition-colors mb-3"></i>
              <span class="text-sm font-semibold text-stone-400 group-hover:text-stone-200 transition-colors">SQL Database</span>
            </div>
            <div class="bg-stone-900/60 p-6 rounded-2xl border border-stone-700/50 hover:border-blue-500/50 hover:bg-stone-800 transition-all duration-300 flex flex-col items-center justify-center text-center group">
              <i class="fab fa-css3-alt text-4xl text-stone-500 group-hover:text-blue-400 transition-colors mb-3"></i>
              <span class="text-sm font-semibold text-stone-400 group-hover:text-stone-200 transition-colors">Tailwind CSS</span>
            </div>
            <div class="bg-stone-900/60 p-6 rounded-2xl border border-stone-700/50 hover:border-green-500/50 hover:bg-stone-800 transition-all duration-300 flex flex-col items-center justify-center text-center group">
              <i class="fas fa-server text-4xl text-stone-500 group-hover:text-green-400 transition-colors mb-3"></i>
              <span class="text-sm font-semibold text-stone-400 group-hover:text-stone-200 transition-colors">Tomcat Server</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<jsp:include page="WEB-INF/views/footer.jsp" />
</main>

<footer class="bg-stone-900 text-stone-300 border-t border-stone-800 mt-24">
    <div class="max-w-7xl mx-auto py-16 px-4 sm:px-6 lg:px-8">
        <div class="grid grid-cols-1 md:grid-cols-4 gap-12">
            <div class="col-span-1 md:col-span-2">
                <span class="text-3xl font-bold font-playfair text-amber-500">OnlineBooks</span>
                <p class="mt-6 text-sm leading-relaxed text-stone-400 max-w-md">
                    "A room without books is like a body without a soul."<br>
                    Experience the ultimate digital library. Dive into 500+ curated IT and Spiritual books with full PDF previews, audio listening, and lightning-fast delivery.
                </p>
            </div>
            <div>
                <h3 class="text-sm font-bold text-white tracking-widest uppercase mb-6">Explore</h3>
                <ul class="space-y-3 text-sm">
                    <li><a href="${pageContext.request.contextPath}/" class="hover:text-amber-400 transition">Home</a></li>
                    <li><a href="${pageContext.request.contextPath}/viewbook" class="hover:text-amber-400 transition">IT & Programming</a></li>
                    <li><a href="${pageContext.request.contextPath}/viewbook" class="hover:text-amber-400 transition">Spiritual Books</a></li>
                </ul>
            </div>
            <div>
                <h3 class="text-sm font-bold text-white tracking-widest uppercase mb-6">Legal</h3>
                <ul class="space-y-3 text-sm">
                    <li><a href="#" class="hover:text-amber-400 transition">Privacy Policy</a></li>
                    <li><a href="#" class="hover:text-amber-400 transition">Terms of Service</a></li>
                    <li><a href="${pageContext.request.contextPath}/about" class="hover:text-amber-400 transition">About Nitin Tiwari</a></li>
                </ul>
            </div>
        </div>
        <div class="mt-12 pt-8 border-t border-stone-800 text-center">
            <style>
                @keyframes shine {
                    0% { background-position: 0% 50%; }
                    50% { background-position: 100% 50%; }
                    100% { background-position: 0% 50%; }
                }
                .text-shiny {
                    background: linear-gradient(90deg, #f59e0b, #fde68a, #f59e0b);
                    background-size: 200% auto;
                    color: transparent;
                    -webkit-background-clip: text;
                    background-clip: text;
                    animation: shine 3s linear infinite;
                    font-weight: bold;
                    letter-spacing: 0.05em;
                }
            </style>
            <p class="text-sm text-stone-500 mb-2">&copy; 2026 OnlineBooks Library. Designed with passion for readers.</p>
            <p class="text-lg mt-2">
                <span class="text-shiny">All Rights Reserved By Er Nitin Tiwari</span>
            </p>
        </div>
    </div>
</footer>
<script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/js/all.min.js"></script>
</body>
</html>
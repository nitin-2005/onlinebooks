<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="WEB-INF/views/header.jsp" />
<div class="bg-stone-50 py-20 min-h-screen text-stone-800">
    <div class="max-w-4xl mx-auto p-8 bg-white rounded-2xl shadow-xl border border-stone-100">
        <h2 class="text-4xl font-bold mb-8 font-playfair text-amber-900 border-b pb-4">Secure Checkout</h2>
        
        <div class="mb-10">
            <h3 class="text-2xl font-semibold mb-4 text-stone-700">1. Delivery Address</h3>
            <p class="text-stone-500 mb-4">Please drop a pin on the map to set your precise delivery location.</p>
            <div id="map" class="w-full h-80 bg-stone-100 rounded-xl flex flex-col items-center justify-center border-2 border-dashed border-stone-300 cursor-pointer hover:bg-stone-50 transition group">
                <i class="fas fa-map-marker-alt text-4xl text-red-500 mb-3 group-hover:scale-110 transition-transform duration-300"></i>
                <p class="text-stone-600 font-medium">Click to drop pin (Google Maps API)</p>
            </div>
            <div id="address-display" class="mt-4 p-4 bg-green-50 border border-green-200 rounded-lg hidden">
                <p class="text-green-800 font-semibold flex items-center"><i class="fas fa-check-circle mr-2"></i> Address confirmed: Lat 28.6139, Lng 77.2090</p>
            </div>
        </div>

        <div>
            <h3 class="text-2xl font-semibold mb-6 text-stone-700">2. Payment details</h3>
            <div class="bg-stone-50 p-6 rounded-xl border border-stone-200 mb-6">
                <div class="flex justify-between items-center mb-2">
                    <span class="text-stone-600">Subtotal</span>
                    <span class="font-semibold">₹ 525.00</span>
                </div>
                <div class="flex justify-between items-center mb-4 pb-4 border-b border-stone-200">
                    <span class="text-stone-600">Shipping</span>
                    <span class="font-semibold text-green-600">Free</span>
                </div>
                <div class="flex justify-between items-center text-xl">
                    <span class="font-bold text-stone-800">Total</span>
                    <span class="font-bold text-amber-700">₹ 525.00</span>
                </div>
            </div>
            
            <button id="rzp-button" class="bg-stone-900 hover:bg-stone-800 text-white font-bold text-lg py-4 px-6 rounded-xl w-full transition shadow-lg hover:shadow-xl flex items-center justify-center">
                <i class="fas fa-qrcode mr-3"></i> Pay securely with Razorpay (UPI)
            </button>
            <div id="payment-success" class="mt-6 p-6 bg-green-50 border border-green-200 rounded-xl hidden text-center">
                <i class="fas fa-check-circle text-5xl text-green-500 mb-3"></i>
                <h4 class="text-xl font-bold text-green-800 mb-1">Payment Successful!</h4>
                <p class="text-green-600">Your order has been placed and is being processed.</p>
            </div>
        </div>
    </div>
</div>

<script>
    document.getElementById('map').addEventListener('click', function() {
        this.innerHTML = '<img src="https://maps.googleapis.com/maps/api/staticmap?center=New+Delhi&zoom=13&size=800x400&markers=color:red%7CNew+Delhi" alt="Map" class="w-full h-full object-cover rounded-xl shadow-inner">';
        this.classList.remove('border-dashed');
        document.getElementById('address-display').classList.remove('hidden');
    });

    document.getElementById('rzp-button').addEventListener('click', function() {
        if(document.getElementById('address-display').classList.contains('hidden')) {
            alert('Please select a delivery address first!');
            return;
        }
        this.innerHTML = '<i class="fas fa-spinner fa-spin mr-3"></i> Processing Payment...';
        this.disabled = true;
        this.classList.replace('bg-stone-900', 'bg-stone-400');
        setTimeout(() => {
            this.classList.add('hidden');
            document.getElementById('payment-success').classList.remove('hidden');
            
            // Actually submit the order to backend!
            setTimeout(() => {
                var form = document.createElement("form");
                form.method = "POST";
                form.action = "pay";
                document.body.appendChild(form);
                form.submit();
            }, 1500); // Wait 1.5 seconds so user can see success message before redirect
        }, 2500);
    });
</script>
<jsp:include page="WEB-INF/views/footer.jsp" />
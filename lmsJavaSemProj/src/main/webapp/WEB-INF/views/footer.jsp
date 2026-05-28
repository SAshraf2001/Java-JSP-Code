<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!-- Bootstrap JS CDN -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/js/bootstrap.bundle.min.js?v=2"></script>
    <script>
        if (typeof bootstrap === 'undefined') {
            alert('CRITICAL ERROR: Bootstrap JavaScript failed to load. Your network is blocking the script. Please check your internet connection or disable strict ad-blockers/firewalls.');
        } else {
            console.log('Bootstrap loaded successfully.');
        }
    </script>
</body>
</html>

// Main JavaScript file for Flask App

// Add smooth scrolling
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        const target = document.querySelector(this.getAttribute('href'));
        if (target) {
            target.scrollIntoView({
                behavior: 'smooth'
            });
        }
    });
});

// Add animation on scroll
const observerOptions = {
    threshold: 0.1,
    rootMargin: '0px 0px -50px 0px'
};

const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            entry.target.style.opacity = '1';
            entry.target.style.transform = 'translateY(0)';
        }
    });
}, observerOptions);

// Observe all cards
document.addEventListener('DOMContentLoaded', () => {
    const cards = document.querySelectorAll('.feature-card, .form-card, .info-card');
    cards.forEach(card => {
        card.style.opacity = '0';
        card.style.transform = 'translateY(20px)';
        card.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
        observer.observe(card);
    });
});

// Add form validation feedback
const forms = document.querySelectorAll('form');
forms.forEach(form => {
    const inputs = form.querySelectorAll('input, textarea');
    inputs.forEach(input => {
        input.addEventListener('blur', function() {
            if (this.value.trim() === '' && this.hasAttribute('required')) {
                this.style.borderColor = 'var(--error)';
            } else {
                this.style.borderColor = 'var(--success)';
            }
        });

        input.addEventListener('focus', function() {
            this.style.borderColor = 'var(--secondary-blue)';
        });
    });
});

// Console welcome message
console.log('%c🚀 Flask CI/CD App', 'color: #3b82f6; font-size: 20px; font-weight: bold;');
console.log('%cPowered by ONDIA Academy', 'color: #1e3a8a; font-size: 14px;');
console.log('%cAuto-deployed with Jenkins Pipeline', 'color: #6b7280; font-size: 12px;');

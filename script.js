// DOM Elements
const loginForm = document.getElementById('loginForm');
const registrationInput = document.getElementById('registrationNumber');
const passwordInput = document.getElementById('password');
const togglePasswordBtn = document.getElementById('togglePassword');
const signupBtn = document.getElementById('signupBtn');
const notification = document.getElementById('notification');
const rememberMe = document.getElementById('rememberMe');

// Liquid Glass Cursor Effect
const loginBox = document.querySelector('.login-box');

if (loginBox) {
    // Track cursor position and update CSS variables
    document.addEventListener('mousemove', (e) => {
        const rect = loginBox.getBoundingClientRect();
        const x = ((e.clientX - rect.left) / rect.width) * 100;
        const y = ((e.clientY - rect.top) / rect.height) * 100;
        
        loginBox.style.setProperty('--cursor-x', `${x}%`);
        loginBox.style.setProperty('--cursor-y', `${y}%`);
    });
    
    // Add subtle tilt effect based on cursor position
    document.addEventListener('mousemove', (e) => {
        const rect = loginBox.getBoundingClientRect();
        const centerX = rect.left + rect.width / 2;
        const centerY = rect.top + rect.height / 2;
        
        const rotateX = (e.clientY - centerY) / 30;
        const rotateY = (centerX - e.clientX) / 30;
        
        loginBox.style.transform = `perspective(1000px) rotateX(${rotateX}deg) rotateY(${rotateY}deg) scale(1.02)`;
    });
    
    // Reset on mouse leave
    loginBox.addEventListener('mouseleave', () => {
        loginBox.style.transform = 'perspective(1000px) rotateX(0deg) rotateY(0deg) scale(1)';
    });
}

// Toggle Password Visibility
togglePasswordBtn.addEventListener('click', function(e) {
    e.preventDefault();
    const type = passwordInput.type === 'password' ? 'text' : 'password';
    passwordInput.type = type;
    
    // Change icon
    this.textContent = type === 'password' ? '👁️' : '👁️‍🗨️';
    
    // Add animation
    this.style.animation = 'none';
    setTimeout(() => {
        this.style.animation = 'rotateIcon 0.6s ease';
    }, 10);
});

// Add CSS animation for icon rotation
const style = document.createElement('style');
style.textContent = `
    @keyframes rotateIcon {
        0% { transform: rotateY(0deg); }
        50% { transform: rotateY(90deg); }
        100% { transform: rotateY(0deg); }
    }
`;
document.head.appendChild(style);

// Form Submission
loginForm.addEventListener('submit', function(e) {
    e.preventDefault();
    
    const regNum = registrationInput.value.trim();
    const pwd = passwordInput.value.trim();
    
    // Validation
    if (!regNum) {
        showNotification('Please enter your registration number', 'error');
        shakeElement(registrationInput);
        return;
    }
    
    if (!pwd) {
        showNotification('Please enter your password', 'error');
        shakeElement(passwordInput);
        return;
    }
    
    if (pwd.length < 6) {
        showNotification('Password must be at least 6 characters', 'error');
        shakeElement(passwordInput);
        return;
    }
    
    // Simulate login process
    const loginBtn = document.querySelector('.login-btn');
    const originalText = loginBtn.querySelector('.btn-text').textContent;
    
    loginBtn.disabled = true;
    loginBtn.style.opacity = '0.7';
    loginBtn.querySelector('.btn-text').textContent = 'LOGGING IN...';
    
    // Simulate API call (remove this in production and replace with actual backend call)
    setTimeout(() => {
        // Success scenario
        showNotification('✓ Login Successful! Redirecting...', 'success');
        
        // Save registration number if "Remember Me" is checked
        if (rememberMe.checked) {
            localStorage.setItem('rememberedRegNum', regNum);
        } else {
            localStorage.removeItem('rememberedRegNum');
        }
        
        // Redirect after delay
        setTimeout(() => {
            // window.location.href = 'dashboard.html'; // Uncomment in production
            console.log('Login successful for:', regNum);
            alert('Login successful! (Dashboard redirect would happen here)');
        }, 1500);
        
    }, 2000);
    
    // Reset button after a delay
    setTimeout(() => {
        loginBtn.disabled = false;
        loginBtn.style.opacity = '1';
        loginBtn.querySelector('.btn-text').textContent = originalText;
    }, 3500);
});

// Sign Up Button
signupBtn.addEventListener('click', function(e) {
    e.preventDefault();
    showNotification('Sign up feature coming soon!', 'success');
    
    // Add ripple effect
    addRippleEffect(this, e);
});

// Show Notification
function showNotification(message, type = 'info') {
    notification.textContent = message;
    notification.className = `notification ${type} show`;
    
    setTimeout(() => {
        notification.classList.remove('show');
    }, 4000);
}

// Shake Element Animation
function shakeElement(element) {
    element.style.animation = 'shake 0.5s ease';
    
    setTimeout(() => {
        element.style.animation = '';
    }, 500);
}

// Ripple Effect for Buttons
function addRippleEffect(button, event) {
    const ripple = document.createElement('span');
    const rect = button.getBoundingClientRect();
    const size = Math.max(rect.width, rect.height);
    const x = event.clientX - rect.left - size / 2;
    const y = event.clientY - rect.top - size / 2;
    
    ripple.style.width = ripple.style.height = size + 'px';
    ripple.style.left = x + 'px';
    ripple.style.top = y + 'px';
    ripple.classList.add('ripple');
    
    button.appendChild(ripple);
    
    setTimeout(() => ripple.remove(), 600);
}

// Add ripple CSS
const rippleStyle = document.createElement('style');
rippleStyle.textContent = `
    button {
        position: relative;
        overflow: hidden;
    }
    
    .ripple {
        position: absolute;
        border-radius: 50%;
        background: rgba(255, 255, 255, 0.6);
        transform: scale(0);
        animation: ripple-animation 0.6s ease-out;
        pointer-events: none;
    }
    
    @keyframes ripple-animation {
        to {
            transform: scale(4);
            opacity: 0;
        }
    }
    
    @keyframes shake {
        0%, 100% { transform: translateX(0); }
        10%, 30%, 50%, 70%, 90% { transform: translateX(-8px); }
        20%, 40%, 60%, 80% { transform: translateX(8px); }
    }
`;
document.head.appendChild(rippleStyle);

// Load remembered registration number
window.addEventListener('load', function() {
    const remembered = localStorage.getItem('rememberedRegNum');
    if (remembered) {
        registrationInput.value = remembered;
        rememberMe.checked = true;
    }
});

// Input Real-time Validation
registrationInput.addEventListener('input', function() {
    validateInput(this);
});

passwordInput.addEventListener('input', function() {
    validateInput(this);
});

function validateInput(input) {
    if (input.value.trim() === '') {
        input.style.borderColor = 'rgba(255, 255, 255, 0.3)';
    } else {
        input.style.borderColor = 'rgba(102, 126, 234, 0.5)';
    }
}

// Add floating label animation on focus
document.querySelectorAll('.form-input').forEach(input => {
    input.addEventListener('focus', function() {
        this.parentElement.parentElement.classList.add('focused');
    });
    
    input.addEventListener('blur', function() {
        if (!this.value) {
            this.parentElement.parentElement.classList.remove('focused');
        }
    });
});

// Keyboard shortcuts
document.addEventListener('keydown', function(e) {
    // Alt + S for Sign Up
    if (e.altKey && e.key === 's') {
        e.preventDefault();
        signupBtn.click();
    }
    
    // Enter on password field submits form
    if (e.key === 'Enter' && document.activeElement === passwordInput) {
        e.preventDefault();
        loginForm.dispatchEvent(new Event('submit'));
    }
});

// Add hover effect to input icons
document.querySelectorAll('.input-icon').forEach(icon => {
    icon.addEventListener('mouseenter', function() {
        this.style.transform = 'scale(1.2) rotate(10deg)';
    });
    
    icon.addEventListener('mouseleave', function() {
        this.style.transform = 'scale(1) rotate(0deg)';
    });
});

// Log for debugging
console.log('🚀 Library Management System - Login Interface Loaded');
console.log('Tip: Use keyboard shortcut Alt+S to sign up');

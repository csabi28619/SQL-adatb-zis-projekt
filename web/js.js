document.addEventListener('DOMContentLoaded', function() {
    const description = document.getElementById('gameDescription');
    
    setTimeout(() => {
        description.classList.add('typewriter-active');
    }, 1500);
    
    setTimeout(() => {
        description.classList.remove('typewriter-active');
        description.classList.add('typewriter-complete');
        
        const text = description.textContent;
        const formattedText = text.replace(/([.!?])\s*([A-ZÁÉÍÓÖŐÚÜŰ])/g, '$1\n\n$2');
        description.textContent = formattedText;
    }, 7000);
    
    const contentWrapper = document.querySelector('.content-wrapper');
    
    contentWrapper.addEventListener('mouseenter', function() {
        this.style.transform = 'translateY(-5px)';
        this.style.boxShadow = '0 12px 40px rgba(0, 0, 0, 0.4), inset 0 1px 0 rgba(255, 255, 255, 0.3)';
        this.style.transition = 'all 0.3s ease';
    });
    
    contentWrapper.addEventListener('mouseleave', function() {
        this.style.transform = 'translateY(0)';
        this.style.boxShadow = '0 8px 32px rgba(0, 0, 0, 0.3), inset 0 1px 0 rgba(255, 255, 255, 0.2)';
    });
});

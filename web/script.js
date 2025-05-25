// Navigációs linkek sima görgetése
document.addEventListener('DOMContentLoaded', function() {
    const navLinks = document.querySelectorAll('.nav-links a[href^="#"]');
    
    navLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            const targetId = this.getAttribute('href');
            const targetSection = document.querySelector(targetId);
            
            if (targetSection) {
                targetSection.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });

    // Fejléc háttérváltásosságos görgetésre
    const header = document.querySelector('header');
    
    window.addEventListener('scroll', function() {
        if (window.scrollY > 100) {
            header.style.background = 'rgba(26, 26, 46, 0.95)';
            header.style.backdropFilter = 'blur(10px)';
        } else {
            header.style.background = 'linear-gradient(135deg, #1a1a2e, #16213e)';
            header.style.backdropFilter = 'none';
        }
    });

    // Csapattag kártyáinak interakciós bigyuszai
    const teamMembers = document.querySelectorAll('.team-member');
    
    teamMembers.forEach(member => {
        member.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-10px) scale(1.02)';
            this.style.boxShadow = '0 20px 40px rgba(0,0,0,0.2)';
        });
        
        member.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(0) scale(1)';
            this.style.boxShadow = '0 8px 25px rgba(0,0,0,0.1)';
        });
    });

    // Nyomozó kártyák interakciói
    const detectives = document.querySelectorAll('.detective');
    
    detectives.forEach(detective => {
        detective.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-8px) scale(1.03)';
            this.style.boxShadow = '0 15px 35px rgba(0,0,0,0.2)';
        });
        
        detective.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(0) scale(1)';
            this.style.boxShadow = '0 8px 25px rgba(0,0,0,0.1)';
        });
    });

    // Cégstatisztikák animált számlálója
    const stats = document.querySelectorAll('.stat h3');
    let hasAnimated = false;

    function animateStats() {
        if (hasAnimated) return;
        
        stats.forEach(stat => {
            const finalValue = stat.textContent;
            const isNumber = !isNaN(parseInt(finalValue));
            
            if (isNumber) {
                const numericValue = parseInt(finalValue.replace(/\D/g, ''));
                const suffix = finalValue.replace(/[\d\s]/g, '');
                let currentValue = 0;
                const increment = numericValue / 50;
                
                const timer = setInterval(() => {
                    currentValue += increment;
                    if (currentValue >= numericValue) {
                        stat.textContent = finalValue;
                        clearInterval(timer);
                    } else {
                        stat.textContent = Math.floor(currentValue) + suffix;
                    }
                }, 30);
            }
        });
        
        hasAnimated = true;
    }

    const statsSection = document.querySelector('.company-stats');
    if (statsSection) {
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    animateStats();
                }
            });
        }, { threshold: 0.5 });
        
        observer.observe(statsSection);
    }

    // Idővonal animáció
    const timelineItems = document.querySelectorAll('.timeline-item');
    
    const timelineObserver = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.style.opacity = '1';
                entry.target.style.transform = 'translateY(0)';
            }
        });
    }, { threshold: 0.3 });

    timelineItems.forEach(item => {
        item.style.opacity = '0';
        item.style.transform = 'translateY(30px)';
        item.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
        timelineObserver.observe(item);
    });

    // Titkos nyomozási mód (Easter egg)
    let secretSequence = [];
    const secretCode = ['i', 'n', 'v', 'e', 's', 't', 'i', 'g', 'a', 't', 'e'];
    
    document.addEventListener('keydown', function(e) {
        secretSequence.push(e.key.toLowerCase());
        
        if (secretSequence.length > secretCode.length) {
            secretSequence.shift();
        }
        
        if (JSON.stringify(secretSequence) === JSON.stringify(secretCode)) {
            activateInvestigationMode();
            secretSequence = [];
        }
    });

    function activateInvestigationMode() {
        document.body.style.filter = 'sepia(20%) contrast(120%)';
        
        // Nyomozási átfedés hozzáadása
        const overlay = document.createElement('div');
        overlay.innerHTML = `
            <div style="position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); 
                        background: rgba(0,0,0,0.9); color: #00ff00; padding: 2rem; 
                        border-radius: 10px; z-index: 10000; font-family: monospace;
                        border: 2px solid #00ff00;">
                <h3>🔍 A NYOMOZÁSI MÓD AKTIVÁLVA</h3>
                <p>Titkos információk felfedve...</p>
                <p>Nyomd meg az Esc gombot a módból való kilépéshez</p>
            </div>
        `;
        document.body.appendChild(overlay);
        
        // Gyanús csapattagokat piros kerettel jelzi
        const suspiciousMembers = document.querySelectorAll('.team-member.executive, .team-member.finance, .team-member.it');
        suspiciousMembers.forEach(member => {
            member.style.border = '3px solid #ff0000';
            member.style.boxShadow = '0 0 20px rgba(255,0,0,0.5)';
        });
        
        document.addEventListener('keydown', function escHandler(e) {
            if (e.key === 'Escape') {
                document.body.removeChild(overlay);
                document.body.style.filter = 'none';
                suspiciousMembers.forEach(member => {
                    member.style.border = '';
                    member.style.boxShadow = '';
                });
                document.removeEventListener('keydown', escHandler);
            }
        });
    }

    // Dinamikus gépelés effekt (az univerzum legjobb dolga)
    const heroText = document.querySelector('.hero-content p');
    if (heroText) {
        const originalText = heroText.textContent;
        heroText.textContent = '';
        
        let i = 0;
        const typeWriter = () => {
            if (i < originalText.length) {
                heroText.textContent += originalText.charAt(i);
                i++;
                setTimeout(typeWriter, 50);
            }
        };
        
        setTimeout(typeWriter, 1000);
    }

    // Random nyomozási felugró cuccok
    const investigationUpdates = [
        "🔍 Új bizonyíték található...",
        "📊 Pénzügyi adatok elemzése folyamatban...",
        "🕵️ Tanúk kihallgatása...",
        "💼 Offshore számlák nyomozása...",
        "📱 Digitális nyomok követése..."
    ];

    function showRandomUpdate() {
        const update = investigationUpdates[Math.floor(Math.random() * investigationUpdates.length)];
        
        const notification = document.createElement('div');
        notification.innerHTML = update;
        notification.style.cssText = `
            position: fixed;
            top: 100px;
            right: 20px;
            background: #2c3e50;
            color: white;
            padding: 1rem;
            border-radius: 5px;
            z-index: 1000;
            opacity: 0;
            transition: opacity 0.3s ease;
            max-width: 300px;
        `;
        
        document.body.appendChild(notification);
        
        setTimeout(() => notification.style.opacity = '1', 100);
        setTimeout(() => {
            notification.style.opacity = '0';
            setTimeout(() => document.body.removeChild(notification), 300);
        }, 3000);
    }

    // Véletlenszerű frissítések 30 másodpercenként
    setInterval(showRandomUpdate, 30000);


    const memberPhotos = document.querySelectorAll('.photo-placeholder');
    memberPhotos.forEach(photo => {
        photo.addEventListener('click', function() {
            this.style.transform = 'scale(0.9)';
            setTimeout(() => {
                this.style.transform = 'scale(1)';
            }, 150);
            
            const memberName = this.closest('.team-member').querySelector('h3').textContent;
            showRandomUpdate(`🔍 ${memberName} profil megtekintve...`);
        });
    });

    window.addEventListener('scroll', function() {
        const scrolled = window.pageYOffset;
        const hero = document.querySelector('#hero');
        if (hero) {
            hero.style.transform = `translateY(${scrolled * 0.5}px)`;
        }
    });

    console.log('🔍 Meridian Solutions - Investigation System Loaded');
    console.log('💡 Tip: Type "investigate" to activate secret mode');
});

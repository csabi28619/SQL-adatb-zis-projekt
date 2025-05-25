function copyToClipboard(elementId) {
            const element = document.getElementById(elementId);
            const text = element.textContent;
            
            navigator.clipboard.writeText(text).then(function() {
                const btn = element.parentElement.querySelector('.copy-btn');
                const originalText = btn.textContent;
                btn.textContent = 'Másolva!';
                btn.classList.add('copied');
                
                setTimeout(() => {
                    btn.textContent = originalText;
                    btn.classList.remove('copied');
                }, 2000);
            }).catch(function(err) {
                const textArea = document.createElement('textarea');
                textArea.value = text;
                document.body.appendChild(textArea);
                textArea.select();
                document.execCommand('copy');
                document.body.removeChild(textArea);
                
                const btn = element.parentElement.querySelector('.copy-btn');
                const originalText = btn.textContent;
                btn.textContent = 'Másolva!';
                btn.classList.add('copied');
                
                setTimeout(() => {
                    btn.textContent = originalText;
                    btn.classList.remove('copied');
                }, 2000);
            });
        }

        function downloadSQL() {
            const sqlContent = document.getElementById('sql-code').textContent;
            const element = document.createElement('a');
            element.setAttribute('href', 'data:text/plain;charset=utf-8,' + encodeURIComponent(sqlContent));
            element.setAttribute('download','detective_game_database.sql');
            element.style.display = 'none';
            document.body.appendChild(element);
            element.click();
            document.body.removeChild(element);
        }

        function revealSolution() {
            const overlay = document.getElementById('spoiler-overlay');
            const content = document.getElementById('spoiler-content');
            
            const confirmed = confirm('Biztosan meg akarod nézni a megoldást? Ez elronthatja a játék élményét!');
            
            if (confirmed) {
                overlay.classList.add('hidden');
                content.style.display = 'block';
                
                content.scrollIntoView({ behavior: 'smooth', block: 'start' });
                
                content.style.animation = 'fadeIn 1s ease-in';
            }
        }

        const style = document.createElement('style');
        style.textContent = `
            @keyframes fadeIn {
                from { opacity: 0; transform: translateY(20px); }
                to { opacity: 1; transform: translateY(0); }
            }
        `;
        document.head.appendChild(style);

        // Ctrl+Shift+S hogy előhozd a megoldást, mi az értelme? semmi csak jól néz ki.
        document.addEventListener('keydown', function(e) {
            if (e.ctrlKey && e.shiftKey && e.key === 'S') {
                const overlay = document.getElementById('spoiler-overlay');
                if (!overlay.classList.contains('hidden')) {
                    const confirmed = confirm('Billentyűparancs észlelve! Biztosan meg akarod nézni a megoldást?');
                    if (confirmed) {
                        revealSolution();
                    }
                }
            }
        });


        document.getElementById('spoiler-overlay').addEventListener('contextmenu', function(e) {
            e.preventDefault();
            alert('🕵️ Okos próbálkozás, de a megoldást csak a gombbal lehet felfedni! 😉');
        });


        document.getElementById('spoiler-overlay').addEventListener('selectstart', function(e) {
            e.preventDefault();
        });
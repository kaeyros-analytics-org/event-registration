document.addEventListener('DOMContentLoaded', function () {
    const themeToggleButton1 = document.getElementById('theme-toggle1');
    const themeToggleButton2 = document.getElementById('theme-toggle2');

    const currentTheme = localStorage.getItem('theme');
    const rootElement = document.documentElement;
  
    // Appliquer le thème enregistré dans localStorage (s'il y en a un)
    if (currentTheme) {
      rootElement.classList.toggle('dark', currentTheme === 'dark');
    }
  
    // Écouter le clic sur le bouton pour basculer de thème
    themeToggleButton1.addEventListener('click', function () {
      const isDarkMode = rootElement.classList.toggle('dark'); // Ajouter/supprimer la classe 'dark'
  
      // Stocker le choix dans localStorage
      localStorage.setItem('theme', isDarkMode ? 'dark' : 'light');
    });

    themeToggleButton2.addEventListener('click', function () {
        const isDarkMode = rootElement.classList.toggle('dark'); // Ajouter/supprimer la classe 'dark'
    
        // Stocker le choix dans localStorage
        localStorage.setItem('theme', isDarkMode ? 'dark' : 'light');
      });
  });
  
let latitude;
let longitude;

document.addEventListener('DOMContentLoaded', () => {
    const elementForm = document.getElementById('form-submit')
    const btnSubmit = document.getElementById('send-form')
    const btnLocation = document.getElementById('localisation')
    const typeProspecting = document.getElementById('prospecting_type')

    elementForm.addEventListener('submit', (e) => {
        e.preventDefault();

        btnSubmit.innerText = 'Chargement...'
        btnSubmit.setAttribute('disabled', 'true')

        const formData = new FormData(elementForm)
        const values = {}

        formData.forEach((value, key) => {
            values[key] = value
        })

        if(values['prospecting_type'] == 'Physique'){

          if(!btnLocation.checked || !latitude || !longitude){
            Toastify({
              text: "Veuillez activer la localisation.",
              className: "info",
              style: {
                background: "linear-gradient(90deg, rgba(207,25,62,1) 41%, rgba(255,195,195,1) 100%)",
              }
            }).showToast();
            btnSubmit.innerText = 'Envoyer'
            btnSubmit.removeAttribute('disabled')
            return;
          }
          
        }


        if(btnLocation.checked){
          values['latitude'] = latitude
          values['longitude'] = longitude
        }

        // console.log('values =', values);


        fetch('/', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(values) // Convertir les données du formulaire en JSON
        })
        .then(response => response.json())
        .then(data => {
            console.log('Success:', data);
            Toastify({
                text: "Formulaire soumis avec succès!",
                className: "info",
                style: {
                  background: "linear-gradient(to right, #2B45D8, ##E9EFFF)",
                }
              }).showToast();
              elementForm.reset()
                btnSubmit.innerText = 'Envoyer'
              btnSubmit.removeAttribute('disabled')
        })
        .catch((error) => {
            console.error('Error:', error);
            Toastify({
                text: "Erreur lors de la soumission du formulaire.",
                className: "info",
                style: {
                  background: "linear-gradient(90deg, rgba(207,25,62,1) 41%, rgba(255,195,195,1) 100%)",
                }
              }).showToast();
              btnSubmit.innerText = 'Envoyer'
              btnSubmit.removeAttribute('disabled')
        });
    })

    btnLocation.addEventListener('click', (e) => {
      // console.log('btnLocation =', document.getElementById('localisation').checked);
      if(btnLocation.checked){
        navigator.geolocation.getCurrentPosition((position) => {
            latitude = position.coords.latitude;
            longitude = position.coords.longitude;
  
            console.log(JSON.stringify({ latitude, longitude }));
            dataPosition = JSON.stringify({ latitude, longitude });
  
        });
      }
    })

    typeProspecting.addEventListener('change', (e) => { 
      e.preventDefault()

      const value = e.target.value
      console.log('value =', value);

      if(value == 'Physique'){
        document.getElementById('switch-localisation').style.display = 'flex'
        document.getElementById('localisation').setAttribute('required', 'true')
      }
      else{
        document.getElementById('switch-localisation').style.display = 'none'
        document.getElementById('localisation').removeAttribute('required')
      } 
    })

})

document.addEventListener("DOMContentLoaded", function() {
  // Sélectionner tous les éléments <select> avec la classe "custom-select"
  const selectElements = document.querySelectorAll('.custom-select');

  // Itérer sur chaque <select>
  selectElements.forEach(select => {
    // Trouver la flèche correspondante pour chaque <select>
    const arrowIcon = select.parentElement.querySelector('.arrow-icon');
    const downArrow = arrowIcon.querySelector('.down-arrow');
    const upArrow = arrowIcon.querySelector('.up-arrow');

    // Gérer l'événement focus (quand l'utilisateur clique sur le <select>)
    select.addEventListener('focus', () => {
      downArrow.classList.add('hidden');
      upArrow.classList.remove('hidden');
    });

    // Gérer l'événement blur (quand l'utilisateur clique en dehors ou sélectionne une option)
    select.addEventListener('blur', () => {
      upArrow.classList.add('hidden');
      downArrow.classList.remove('hidden');
    });
  });
});

let latitude;
let longitude;

document.addEventListener('DOMContentLoaded', () => {
    const elementForm = document.getElementById('form-submit')
    const btnSubmit = document.getElementById('send-form')
    const linkForm = document.getElementById('link_form_data')
    // const btnLocation = document.getElementById('localisation')
    // const typeProspecting = document.getElementById('prospecting_type')

    elementForm.addEventListener('submit', (e) => {
        e.preventDefault();

        btnSubmit.innerText = 'Chargement...'
        btnSubmit.setAttribute('disabled', 'true')

        const formData = new FormData(elementForm)
        const values = {}

        formData.forEach((value, key) => {
            values[key] = value
        })

        // console.log('values =', values);

        fetch('/sales-representative/create', {
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
              console.log('data.link ==', data.link);
              
              linkForm.value = data.link
              document.getElementById("link_form_data").value = data.link;
              linkForm.style.display = 'block'
              // elementForm.reset()
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

})
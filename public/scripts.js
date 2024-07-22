
document.addEventListener('DOMContentLoaded', () => {
    const elementForm = document.getElementById('form-submit')
    const btnSubmit = document.getElementById('send-form')

    window.addEventListener('submit', (e) => {
        e.preventDefault();

        btnSubmit.innerText = 'Chargement...'
        btnSubmit.setAttribute('disabled', 'true')

        const formData = new FormData(elementForm)
        const values = {}

        formData.forEach((value, key) => {
            values[key] = value
        })


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
              btnSubmit.setAttribute('disabled', 'false')
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
              btnSubmit.setAttribute('disabled', 'false')
        });
    })

})
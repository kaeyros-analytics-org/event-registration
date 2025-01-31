let latitude;
let longitude;

document.addEventListener('DOMContentLoaded', () => {
    const elementForm = document.getElementById('form-submit')
    const btnSubmit = document.getElementById('send-form')
    const btnLocation = document.getElementById('localisation')
    const typeProspecting = document.getElementById('prospecting_type')
    const errorPhoneNumber = document.getElementById('phone-error')
    const inputAutComplete = document.getElementById('autocomplete')

    const customer_status = document.getElementById('customer_status');
    const customer_status_placeholder = document.getElementById('customer_status_placeholder');

    // const business_name = document.getElementById('business_name');
    const business_name_autocomplete = document.getElementById('autocomplete');
    const visit_objective = document.getElementById('visit_objective');
    const visit_objective_placeholder = document.getElementById('visit_objective_placeholder');

    const customer_decision_placeholder = document.getElementById('customer_decision_placeholder');
    // const promesse_placeholder = document.getElementById('promesse_placeholder');

    // const promesse = document.getElementById('promesse');
    const customer_decision = document.getElementById('customer_decision');
    const achievement = document.getElementById('achievement');
    const achievement_placeholder = document.getElementById('achievement_placeholder');

    const comment = document.getElementById('comment');
    const visit_carried_out = document.getElementById('visit_carried_out');
    const phone = document.getElementById('phone')

    const suggested_introductory_priceInput = document.getElementById('suggested_introductory_price');
    const proposed_monthly_priceInput = document.getElementById('proposed_monthly_price');


    elementForm.addEventListener('submit', (e) => {
        e.preventDefault();

        const phoneInput = document.getElementById("phone").value;
        const sale_representative_code = document.getElementById('sale_representative_code').value;
        
        
        if(typeProspecting.value == 'Physique'){

          // Exemple de regex pour un numéro de téléphone français
          const phoneRegex = /^(\+237|00237)?[26]\d{8}$/;

          if (!phoneRegex.test(phoneInput)) {
            errorPhoneNumber.style.display = 'block';
            alert("Veuillez entrer un numéro de téléphone valide.");
            return;
          }
          errorPhoneNumber.style.display = 'none';

        }

        btnSubmit.innerText = 'Chargement...'
        btnSubmit.setAttribute('disabled', 'true')

        const formData = new FormData(elementForm)
        const values = {}

        formData.forEach((value, key) => {
            values[key] = value
        })

        values['suggested_introductory_price'] = values['suggested_introductory_price'] ? values['suggested_introductory_price'] : suggested_introductory_priceInput.value
        values['proposed_monthly_price'] = values['proposed_monthly_price'] ? values['proposed_monthly_price'] : proposed_monthly_priceInput.value


        // console.log('values =', values)

        values['business_name'] = inputAutComplete.value

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
        // console.log('sale_representative_code =', sale_representative_code)


        fetch(`/${sale_representative_code}/visit/create`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(values) // Convertir les données du formulaire en JSON
        })
        .then(response => response.json())
        .then(data => {
            // console.log('Success:', data);
            Toastify({
                text: "Formulaire soumis avec succès!",
                className: "info",
                style: {
                  background: "linear-gradient(to right, #2B45D8, ##E9EFFF)",
                },
                duration: 7 * 1000
              }).showToast();
              elementForm.reset()
              customer_status.setAttribute('required', true);
              business_name_autocomplete.setAttribute('required', true);
              visit_objective.setAttribute('required', true);
              customer_decision.setAttribute('required', true);
              achievement.setAttribute('required', true);
              comment.setAttribute('required', true);
              visit_carried_out.setAttribute('required', true);
              phone.setAttribute('required', true);

              customer_status_placeholder.textContent =  customer_status_placeholder.textContent.endsWith('*') ? customer_status_placeholder.textContent : customer_status_placeholder.textContent+"*"
              business_name_autocomplete.placeholder =  business_name_autocomplete.placeholder.endsWith('*') ? business_name_autocomplete.placeholder : business_name_autocomplete.placeholder+"*"
              visit_objective_placeholder.textContent =  visit_objective_placeholder.textContent.endsWith('*') ? visit_objective_placeholder.textContent : visit_objective_placeholder.textContent+"*"
              customer_decision_placeholder.textContent =  customer_decision_placeholder.textContent.endsWith('*') ? customer_decision_placeholder.textContent : customer_decision_placeholder.textContent+"*"
              achievement_placeholder.textContent =  achievement_placeholder.textContent.endsWith('*') ? achievement_placeholder.textContent : achievement_placeholder.textContent+"*"

              // achievement.placeholder =  achievement.placeholder.endsWith('*') ? achievement.placeholder : achievement.placeholder+"*"
              comment.placeholder =  comment.placeholder.endsWith('*') ? comment.placeholder : comment.placeholder+"*"
              visit_carried_out.placeholder =  visit_carried_out.placeholder.endsWith('*') ? visit_carried_out.placeholder : visit_carried_out.placeholder+"*"
              phone.placeholder =  phone.placeholder.endsWith('*') ? phone.placeholder : phone.placeholder+"*"

              suggested_introductory_priceInput.disabled = false
              proposed_monthly_priceInput.disabled = false

                btnSubmit.innerText = 'Envoyer'
              btnSubmit.removeAttribute('disabled')
        })
        .catch((error) => {
            // console.error('Error:', error);
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
      // console.log('value =', value);

      if(value == 'Physique'){
        customer_status.setAttribute('required', true);
        business_name_autocomplete.setAttribute('required', true);
        visit_objective.setAttribute('required', true);
        customer_decision.setAttribute('required', true);
        // promesse.setAttribute('required', true);
        achievement.setAttribute('required', true);
        comment.setAttribute('required', true);
        visit_carried_out.setAttribute('required', true);
        phone.setAttribute('required', true);

        customer_status_placeholder.textContent =  customer_status_placeholder.textContent.endsWith('*') ? customer_status_placeholder.textContent : customer_status_placeholder.textContent+"*"
        business_name_autocomplete.placeholder =  business_name_autocomplete.placeholder.endsWith('*') ? business_name_autocomplete.placeholder : business_name_autocomplete.placeholder+"*"
        visit_objective_placeholder.textContent =  visit_objective_placeholder.textContent.endsWith('*') ? visit_objective_placeholder.textContent : visit_objective_placeholder.textContent+"*"
        customer_decision_placeholder.textContent =  customer_decision_placeholder.textContent.endsWith('*') ? customer_decision_placeholder.textContent : customer_decision_placeholder.textContent+"*"
        achievement_placeholder.textContent =  achievement_placeholder.textContent.endsWith('*') ? achievement_placeholder.textContent : achievement_placeholder.textContent+"*"

        // achievement.placeholder =  achievement.placeholder.endsWith('*') ? achievement.placeholder : achievement.placeholder+"*"
        comment.placeholder =  comment.placeholder.endsWith('*') ? comment.placeholder : comment.placeholder+"*"
        visit_carried_out.placeholder =  visit_carried_out.placeholder.endsWith('*') ? visit_carried_out.placeholder : visit_carried_out.placeholder+"*"
        phone.placeholder =  phone.placeholder.endsWith('*') ? phone.placeholder : phone.placeholder+"*"

        // business_name_autocomplete.placeholder =  business_name_autocomplete.placeholder.replace('*', '')
        // visit_objective_placeholder.value =  visit_objective_placeholder.value.replace('*', '')
        // customer_decision_placeholder.value =  customer_decision_placeholder.value.replace('*', '')
        // achievement.placeholder =  achievement.placeholder.replace('*', '')
        // comment.placeholder =  comment.placeholder.replace('*', '')
        // visit_carried_out.placeholder =  visit_carried_out.placeholder.replace('*', '')

        document.getElementById('switch-localisation').style.display = 'flex'
        document.getElementById('localisation').setAttribute('required', 'true')
      }
      else{
          customer_status.removeAttribute('required');
          business_name_autocomplete.removeAttribute('required');
          visit_objective.removeAttribute('required');
          customer_decision.removeAttribute('required');
          // promesse.removeAttribute('required');

          achievement.removeAttribute('required');
          comment.removeAttribute('required');
          visit_carried_out.removeAttribute('required');
          phone.removeAttribute('required');

          customer_status_placeholder.textContent =  customer_status_placeholder.textContent.replace('*', '')
          business_name_autocomplete.placeholder =  business_name_autocomplete.placeholder.replace('*', '')


          visit_objective_placeholder.textContent =  visit_objective_placeholder.textContent.replace('*', '')
          customer_decision_placeholder.textContent =  customer_decision_placeholder.textContent.replace('*', '')
          achievement_placeholder.textContent =  achievement_placeholder.textContent.replace('*', '')

          // achievement.placeholder =  achievement.placeholder.replace('*', '')
          comment.placeholder =  comment.placeholder.replace('*', '')
          visit_carried_out.placeholder =  visit_carried_out.placeholder.replace('*', '')
          phone.placeholder =  phone.placeholder.replace('*', '')

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

    //autocomplete

    const input = document.getElementById('autocomplete');
    const resultsContainer = document.getElementById('results');
    const companyName = document.getElementById('company_name');
    const suggested_introductory_priceInput = document.getElementById('suggested_introductory_price');
    const proposed_monthly_priceInput = document.getElementById('proposed_monthly_price');

    // const name_of_representant = document.getElementById('name_of_representant');
    // const title_respresentant = document.getElementById('title_respresentant');
    // const redevance_month = document.getElementById('redevance_month');
    // const city = document.getElementById('city');
    // const date = document.getElementById('date');
    // const phone_number = document.getElementById('phone_number');

    // Fonction pour rechercher les résultats depuis l'API
    async function search(query) {
      if (query.length < 2) {
        resultsContainer.classList.add('hidden'); // Cacher les résultats si la requête est trop courte
        return;
      }

      try {
          const response = await fetch(`/${sale_representative_code}/visit/search?q=${query}`);
          const results = await response.json();

          // Afficher les résultats dans la liste déroulante
          if (results.length > 0) {
              resultsContainer.innerHTML = results.map(item => `
                  <li class="p-2 cursor-pointer hover:bg-gray-200 search-color-box" 
                  onclick="selectResult('${item.business_name}', '${item.suggested_introductory_price}', '${item.proposed_monthly_price}')">${item.business_name}</li>
              `).join('');
              resultsContainer.classList.remove('hidden'); // Montrer la liste déroulante
          } else {
              resultsContainer.classList.add('hidden'); // Cacher s'il n'y a pas de résultats
          }
      } catch (error) {
          console.error('Erreur lors de la recherche:', error);
      }
    }

    // Fonction pour sélectionner un résultat et le mettre dans l'input
    window.selectResult = function (company_name, suggested_introductory_price, proposed_monthly_price) {
      // const Date = new Date('2024-09-10')
        input.value = company_name;
        suggested_introductory_priceInput.value = Number(suggested_introductory_price) > 0 ? Number(suggested_introductory_price): ''
        proposed_monthly_priceInput.value = Number(proposed_monthly_price) > 0 ? Number(proposed_monthly_price): ''

        if (Number(suggested_introductory_price) > 0) {
          suggested_introductory_priceInput.disabled = true
        }
        else {
          suggested_introductory_priceInput.disabled = false
        }

        if (Number(proposed_monthly_price) > 0) {
          proposed_monthly_priceInput.disabled = true
        }
        else {
          proposed_monthly_priceInput.disabled = false
        }

        // companyName.value = company_name;
        // address.value = district;
        // name_of_representant.value = `${first_name} ${last_name}`;
        // title_respresentant.value = poste;
        // redevance_month.value = '10000 FCFA';
        // city.value = 'Douala';
        // date.value = '2024-09-10';
        // phone_number.value = phone_number_whatsapp;
        resultsContainer.classList.add('hidden');
    }

    // Écouteur d'événement pour afficher les résultats lorsque l'utilisateur tape
    input.addEventListener('input', (e) => {
        search(e.target.value);
    });

    // Afficher les résultats lorsque l'utilisateur clique sur le champ
    input.addEventListener('focus', () => {
        if (input.value.length > 1) {
            resultsContainer.classList.remove('hidden'); // Montrer la liste si des résultats existent
        }
    });

    // Masquer les résultats lorsqu'on clique en dehors du champ ou des résultats
    document.addEventListener('click', (e) => {
        if (!input.contains(e.target) && !resultsContainer.contains(e.target)) {
            resultsContainer.classList.add('hidden'); // Masquer la liste si l'utilisateur clique en dehors
        }
    });
});

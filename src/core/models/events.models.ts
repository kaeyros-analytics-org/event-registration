export type EventModel = {
    first_name: string;
    last_name: string;
    company_name: string;
    poste: string;
    email: string;
    phone_number_whatsapp: string;
  };
    
    // Interface Mongoose pour le modèle de Users
  export interface EventDoc extends Document, EventModel {
    createdAt: Date;
    updatedAt: Date;
  }
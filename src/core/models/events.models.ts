export type EventModel = {
    first_name: string;
    last_name: string;
    company_name: string;
    sector_of_activity: string;
    district: string;
    poste: string;
    email?: string;
    phone_number_whatsapp: string;
    is_promotion: boolean;
    collaborate_name: string;
    creneau: string;
    latitude?: string;
    longitude?: string;
  };
    
    // Interface Mongoose pour le modèle de Users
  export interface EventDoc extends Document, EventModel {
    createdAt: Date;
    updatedAt: Date;
  }
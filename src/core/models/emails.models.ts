export type EmailModel = {
    first_name: string;
    email: string;
  };
    
    // Interface Mongoose pour le modèle de Users
  export interface EventDoc extends Document, EmailModel {
    createdAt: Date;
    updatedAt: Date;
  }
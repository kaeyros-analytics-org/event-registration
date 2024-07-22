
import mongoose, { Schema } from "mongoose";
import { EventDoc } from "../../models/events.models";

const eventSchema = new Schema<EventDoc>(
  {
    first_name: {
      type: String,
      required: true,
    },
    last_name: {
        type: String,
        required: true,
    },
    company_name: {
        type: String,
        required: true,
    },
    poste: {
      type: String,
      required: true,
    },
    email: {
      type: String,
      required: true
    },
    phone_number_whatsapp: {
        type: String,
        required: true
    },
    latitude: {
      type: String,
      required: false
    },
    longitude: {
        type: String,
        required: false
    }
  },
  {
    timestamps: true,
  }
);

const Event = mongoose.model<EventDoc>('events', eventSchema);

export default Event;

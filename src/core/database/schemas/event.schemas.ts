
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
      required: false
    },
    sector_of_activity: {
      type: String,
      required: true
    },
    district: {
      type: String,
      required: true
    },
    phone_number_whatsapp: {
        type: String,
        required: true
    },
    is_promotion: {
      type: Boolean,
      required: false,
      default: false
  },
    creneau: {
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

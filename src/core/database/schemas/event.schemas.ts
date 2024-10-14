import mongoose, { Schema } from "mongoose";
import { EventDoc } from "../../models/events.models";

const eventSchema = new Schema<EventDoc>(
  {
    company_name: {
      type: String,
      required: true,
    },
    type_of_business: {
      type: String,
      required: true,
    },
    promoter_name: {
      type: String,
      required: false,
    },
    opening_time: {
      type: String,
      required: false,
      default: "",
    },
    phone_number_whatsapp: {
      type: String,
      required: true,
    },
    location: {
      type: String,
      required: true,
    },
    latitude: {
      type: String,
      required: false,
    },
    longitude: {
      type: String,
      required: false,
    },
  },
  {
    timestamps: true,
  }
);

const Event = mongoose.model<EventDoc>("eventsnew2", eventSchema);

export default Event;

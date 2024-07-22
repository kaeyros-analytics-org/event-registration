
import mongoose, { Schema } from "mongoose";
import { EventDoc } from "../../models/events.models";

const emailSchema = new Schema<EventDoc>(
  {
    first_name: {
      type: String,
      required: true,
    },
    email: {
      type: String,
      required: true
    },
  },
  {
    timestamps: true,
  }
);

const Email = mongoose.model<EventDoc>('emails', emailSchema);

export default Email;


import mongoose, { Schema } from "mongoose";
import { EmailDoc } from "../../models/emails.models";

const emailSchema = new Schema<EmailDoc>(
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

const Email = mongoose.model<EmailDoc>('emails', emailSchema);

export default Email;

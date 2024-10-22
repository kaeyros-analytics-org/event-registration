import mongoose, { Schema } from "mongoose";
import { SalesFormDoc } from "../../models/sales-form.models";

const SalesFormSchema = new Schema<SalesFormDoc>(
  {
    sale_representative_id: {
      type: String,
      required: true,
      ref: "salesRepresentative",
    },
    sale_representative_code: {
      type: String,
      required: true,
    },
    type_of_outlet: {
      type: String,
      required: true,
    },
    city: {
      type: String,
      required: true,
    },
    pos_name: {
      type: String,
      required: true,
    },
    owner_name: {
      type: String,
      required: false,
      default: "",
    },
    owner_phone_number: {
      type: Number,
      required: true,
    },
    visit_note: {
      type: String,
      required: true,
    },
    prospecting_type: {
      type: String,
      required: true,
    },
    customer_decision: {
      type: String,
      required: true,
    },
    longitude: {
      type: String,
      required: false,
    },
    latitude: {
      type: String,
      required: false,
    },
  },
  {
    timestamps: true,
  }
);

const SalesForm = mongoose.model<SalesFormDoc>("salesForm", SalesFormSchema);

export default SalesForm;

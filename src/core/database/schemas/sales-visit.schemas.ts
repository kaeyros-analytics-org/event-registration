import mongoose, { Schema } from "mongoose";
import { SalesVisitDoc } from "../../models/sales-visit.models";

const SalesVisitSchema = new Schema<SalesVisitDoc>(
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
    zone: {
      type: String,
      required: false,
    },
    city: {
      type: String,
      required: true,
    },
    customer_name: {
      type: String,
      required: true,
    },
    business_name: {
      type: String,
      required: false,
    },
    prospecting_type: {
      type: String,
      required: true,
    },
    customer_decision: {
      type: String,
      required: false,
    },
    suggested_introductory_price: {
      type: Number,
      required: true,
    },
    proposed_monthly_price: {
      type: Number,
      required: true,
    },
    contact: {
      type: String,
      required: false,
    },
    category: {
      type: String,
      required: true,
    },
    type_of_business: {
      type: String,
      required: true,
    },
    customer_status: {
      type: String,
      required: false,
    },
    address: {
      type: String,
      required: true,
    },
    achievement: {
      type: String,
      required: false,
    },
    visit_objective: {
      type: String,
      required: false,
    },
    comment: {
      type: String,
      required: false,
    },
    visit_carried_out: {
      type: String,
      required: false,
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

const SalesVisit = mongoose.model<SalesVisitDoc>("salesVisit", SalesVisitSchema);

export default SalesVisit;

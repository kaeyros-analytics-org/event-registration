import mongoose, { Schema } from "mongoose";
import { SalesRepresentativeDoc } from "../../models/sales-representative.models";

const SalesRepresentativeSchema = new Schema<SalesRepresentativeDoc>(
  {
    name: {
      type: String,
      required: true,
    },
    code: {
      type: String,
      required: true,
    },
  },
  {
    timestamps: true,
  }
);

const SalesRepresentative = mongoose.model<SalesRepresentativeDoc>("salesRepresentative", SalesRepresentativeSchema);

export default SalesRepresentative;

import { EventBridgeClient } from "@aws-sdk/client-eventbridge";
// Set the AWS Region.
// Create an Amazon EventBridge service client object.
export const ebClient = new EventBridgeClient({ region: "ap-south-1" });
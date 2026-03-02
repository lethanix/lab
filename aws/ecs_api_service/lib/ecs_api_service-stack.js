const { Stack, Duration } = require("aws-cdk-lib/core");
const ec2 = require("aws-cdk-lib/aws-ec2");
// const sqs = require('aws-cdk-lib/aws-sqs');

class EcsApiServiceStack extends Stack {
  /**
   *
   * @param {Construct} scope
   * @param {string} id
   * @param {StackProps=} props
   */
  constructor(scope, id, props) {
    super(scope, id, props);

    const vpc = new ec2.Vpc(this, "ApiVpc", {
      maxAzs: 2,
      subnetConfiguration: [
        {
          cidrMask: 24,
          name: "First",
          subnetType: ec2.SubnetType.PUBLIC,
        },
        {
          cidrMask: 24,
          name: "Second",
          subnetType: ec2.SubnetType.PUBLIC,
        },
      ],
    });
  }
}

module.exports = { EcsApiServiceStack };

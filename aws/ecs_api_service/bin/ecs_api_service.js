#!/usr/bin/env node

const cdk = require('aws-cdk-lib/core');
const { EcsApiServiceStack } = require('../lib/ecs_api_service-stack');

const app = new cdk.App();
new EcsApiServiceStack(app, 'EcsApiServiceStack', {
  // env: { 
  //   account: process.env.CDK_DEFAULT_ACCOUNT, 
  //   region: process.env.CDK_DEFAULT_REGION,
  //  },

  env: { account: '000000000000', region: 'us-east-1' },

});

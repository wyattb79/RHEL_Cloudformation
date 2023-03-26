#! /bin/bash

source stack_config

echo "Validating template"

aws cloudformation validate-template --template-body file://cluster_template.yaml

if [ "$?" -ne "0" ]; then
  echo "Invalid template.  Exiting"
  exit 1 
fi

echo "Do you wish to create this stack?"
echo "Type YES in all uppercase to create it.  All other input exits"
read create

if [ "${create}" == "YES" ]; then
  aws cloudformation create-stack --template-body file://cluster_template.yaml \
    --stack-name ${cfn_stack_name} \
    --parameters ParameterKey=MyIp,ParameterValue=${source_ip} \
                 ParameterKey=VpcCidrBlock,ParameterValue=${vpc_cidr_block} \
                 ParameterKey=SubnetCidrBlock,ParameterValue=${subnet_cidr} \
                 ParameterKey=InstanceType,ParameterValue=${ec2_instance_type} \
                 ParameterKey=LoginKey,ParameterValue=${login_key} \
                 ParameterKey=Ami,ParameterValue=${ami} 
else
  echo "Exiting"
  exit 0   
fi

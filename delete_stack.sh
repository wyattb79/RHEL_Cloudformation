#! /bin/bash

source stack_config

aws cloudformation delete-stack --stack-name ${cfn_stack_name}

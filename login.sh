#! /usr/bin/bash

source stack_config

check_stack_cmd="aws cloudformation describe-stacks --stack-name=${cfn_stack_name}"
cfn_output=`${check_stack_cmd} 2>/dev/null`
shell_result=$?

# no stack
if [ ${shell_result} != 0 ]; then
	echo "Stack not found"
	exit 1
fi

creating=1
while [ ${creating} -eq 1 ]; do
	if [[ ${cfn_output} =~ CREATE_IN_PROGRESS ]]; then
		creating=1
		echo "Stack creation in progress.  Retrying in 3s..."
		sleep 3
		cfn_output=`${check_stack_cmd} 2>/dev/null`
	else
		creating=0
	fi
done

cfn_output=`aws cloudformation describe-stacks --stack-name=${cfn_stack_name} --query 'Stacks[0].Outputs[?OutputKey==\`LoginIp\`].OutputValue' --output text`

echo "ssh -i ${login_key}.pem ec2-user@${cfn_output}"

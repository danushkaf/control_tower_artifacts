function switchAccount {
    aws sts get-caller-identity
    ACC=$1
	  PROFILE=$2
    temp_role=$(aws sts assume-role --role-arn "arn:aws:iam::$ACC:role/AWSControlTowerExecution" --role-session-name "userAct-$ACC")
    AWS_ACCESS_KEY_ID=$(echo $temp_role | jq .Credentials.AccessKeyId | xargs)
    AWS_SECRET_ACCESS_KEY=$(echo $temp_role | jq .Credentials.SecretAccessKey | xargs)
    AWS_SESSION_TOKEN=$(echo $temp_role | jq .Credentials.SessionToken | xargs)
	  aws configure --profile $PROFILE set aws_access_key_id $AWS_ACCESS_KEY_ID
	  aws configure --profile $PROFILE set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
	  aws configure --profile $PROFILE set aws_session_token $AWS_SESSION_TOKEN
    aws --profile $PROFILE sts get-caller-identity
}

alias upKubeDev='aws --profile dev eks --region us-east-1 update-kubeconfig --name dev-eks-cluster'

alias switchDev='switchAccount 111111111111 dev && upKubeDev'

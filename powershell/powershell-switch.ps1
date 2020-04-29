function Un-Set-Env {
    $env:AWS_ACCESS_KEY_ID=""
    $env:AWS_SECRET_ACCESS_KEY=""
    $env:AWS_SESSION_TOKEN=""
}

function Switch-Account {
    param(
        $ACC
    )
    aws sts get-caller-identity
    $temp_role=$(aws sts assume-role --role-arn "arn:aws:iam::$($ACC):role/AWSControlTowerExecution" --role-session-name "userAct-$($ACC)")
    $env:AWS_ACCESS_KEY_ID=$(echo $temp_role | jq .Credentials.AccessKeyId)
    $env:AWS_ACCESS_KEY_ID=$env:AWS_ACCESS_KEY_ID -replace '"', ""
    $env:AWS_SECRET_ACCESS_KEY=$(echo $temp_role | jq .Credentials.SecretAccessKey)
    $env:AWS_SECRET_ACCESS_KEY=$env:AWS_SECRET_ACCESS_KEY -replace '"', ""
    $env:AWS_SESSION_TOKEN=$(echo $temp_role | jq .Credentials.SessionToken)
    $env:AWS_SESSION_TOKEN=$env:AWS_SESSION_TOKEN -replace '"', ""
    aws sts get-caller-identity
}

function Update-Kube-Config-Dev {
    aws eks --region us-east-1 update-kubeconfig --name dev-eks
}

function Switch-Dev {
    Un-Set-Env
    Switch-Account 111111111111
	Update-Kube-Config-Dev
}

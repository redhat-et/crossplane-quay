AWS_PROFILE=default && echo -e "[default]\naws_access_key_id = $(aws configure get aws_access_key_id --profile $AWS_PROFILE)\naws_secret_access_key = $(aws configure get aws_secret_access_key --profile $AWS_PROFILE)" > creds.conf
    
kubectl create secret generic aws-creds -n crossplane-system --from-file=key=./creds.conf

kubectl create secret generic cluster-config -n crossplane-system --from-file=kubeconfig=./kubeconfig

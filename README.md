# Quay Deployment on Kubernetes via Crossplane

## Prerequisites

You need the follow items setup prior to development

- KUBECONFIG - You need to have a valid KUBECONFIG environment variable, currently this needs to be an Openshift Cluster running on EC2.
- AWS Credentials - You can find instructions [here](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html) for setting up the standard AWS credentials for the aws-cli.
- S3 Bucket Name - S3 Bucket names must be globally unique, you need to provide a name inside of the helm/values.yaml file.
- VPC and Gateway ID - Both of this IDs need to also be provided in the helm/values.yaml file. These can be found on the AWS console.

## Setup

To set up the project you need to run clone this [github repository](https://github.com/krishchow/crossplane-quay) and prepare the helm/values.yaml as described in [Prerequisites](##Prerequisites). After this you can run the following commands one by one.

- `make build` - This will generate the CRs using HELM
- `make crossplane` - This will install crossplane into the Kubernetes cluster in the `crossplane-system` namespace
- `make provider` - This will install the AWS Provider into the `crossplane-system` namespace, but the CRs will be available in the entire cluster.

## Running Quay

In order to get Quay up and running you will need to run `make quay`. This will create the compositions, requirements, and QuayEcosystem CR. You can validate this is working by looking at the AWS console where you will see that Redis, S3 and Postgres are being launched. If you do not see any of these, refer to [Known Issues](##Known-Issues).

Once all the dependencies have been created, the script will create the Quay Operator. After this point you can refer to the steps from the offical [Quay Operator docs](https://access.redhat.com/documentation/en-us/red_hat_quay/3.3/html/deploy_red_hat_quay_on_openshift_with_quay_operator/deploying_red_hat_quay#deploy_a_red_hat_quay_ecosystem).

TL;DR - You will see the pods come up in the default name space, once the quay-config and quay-pods are up, you can navigate to the Networking section in the left navbar and find the Route/URL for the Quay instance.

## Clean Up

When you are done with the quay instance, you need to delete the contents of the S3 Bucket via the AWS Console. Then you can run `make clean` which will delete Quay and all the dependencies (Quay, Redis, Postgres). This will leave the compositions, crossplane and the aws provider installed. You can delete everything by running `make clean-all` or `make clean-crossplane` based on what is most appropiate for your needs.

## Known Issues

Currently it seems like there is an issue with deploying the AWS provider. The deployment will fail to create any pods citing an invaldi fsGroup. The current fix for this requires editing the YAML for the deployment and removing the offending line (typically line 62) under the securityContext.fsGroup.

An issue has been opened on the upstream [provider-aws](https://github.com/crossplane/provider-aws/issues/316).

In order to delete the dependencies, you will need to empty the S3 Bucket manually via the AWS console. You cannot delete a bucket that has objects in it, so Crossplane will not be able to delete that CR or Bucket. It does not seem like there is a simple work around for this issue.

## Future Work

- Allowing for dynamically created VPCs/IGWs, currently we required that the user passes in a VPC ID and IGW ID.
- Support for VPC Peering, one potential method may use [Submariner](https://github.com/submariner-io/submariner)

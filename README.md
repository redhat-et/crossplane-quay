# Quay Deployment on Kubernetes via Crossplane

## Objective

The goal of this project is to demonstrate what production-like deployment using the [Crossplane Operator](http://crossplane.io/) will look like. By utilizing the [AWS Provider](https://github.com/crossplane/provider-aws) we can create and configure managed resources on AWS, these can then be consumed by other services and deployments in our Openshift Cluster.

In this deployment, we will be creating the following resources in AWS:

- Networking Resources - We create Subnets, a Route Table, Subnet groups and optionally a VPC.
- RDS Instance - We create an RDS Instance for the PostgreSQL instance to be used by Quay.
- ElastiCache Cluster - We create an elastic cluster with Redis to be used by Quay.
- S3 Bucket - We will be creating an S3 Bucket along with the corresponding generated policy for that Bucket. S3 will form the actual registry backend for Quay.

The S3 Bucket, RDS Instance and ElastiCache Cluster will all create secrets that are in turn consumed by the [Quay Operator](https://github.com/redhat-cop/quay-operator). All of the compositions are combined in one Component compositiion, which will create the subresources. Additionally the component composition creates the Quay Operator itself, along with the Helm chart for configuring Quay.

## Prerequisites

You need the follow items setup prior to development

- KUBECONFIG - You need to have a valid KUBECONFIG environment variable, currently this needs to be an Openshift Cluster running on EC2.
- AWS Credentials - You can find instructions [here](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html) for setting up the standard AWS credentials for the aws-cli.
- S3 Bucket Name - S3 Bucket names must be globally unique, you need to provide a name inside of the helm/values.yaml file.
- VPC and Gateway ID - Both of this IDs need to also be provided in the helm/values.yaml file. These can be found on the AWS console.

The credentials (kubeconfig, AWS) are both mounted using secrets,and these are passed into the respective ProviderConfigs. The S3 bucket name, VPC ID and Gateway ID are passed in using the [requirements.yaml](manifests/requirements.yaml) manifest.

## Setup

To set up the project you need to run clone this [github repository](https://github.com/redhat-et/crossplane-quay) and prepare the helm/values.yaml as described in [Prerequisites](##Prerequisites). After this you can run the following commands one by one.

- `make crossplane` - This will install crossplane into the Kubernetes cluster in the `crossplane-system` namespace
- `make provider` - This will install the AWS, Helm and In Cluster Providers into the `crossplane-system` namespace, but the CRs will be available in the entire cluster.
- `make catalog` - This will install the custom catalog source into your cluster, note that you may need to change the namespace based on your configuration.

### Verifying Status

Although the setup scripts will provide some output, for more detailed information, open a second shell and set the KUBECONFIG variable to point to the appropriate cluster.

When `make provider` completes, you call the following commands, this will allow you to get check if the provider and operator pods are up.
```
$ oc get provider.aws
NAME           REGION      AGE
aws-provider   us-east-2   XdXXh
$ oc get pods -n crossplane-system
NAME                                          READY   STATUS      RESTARTS   AGE
crossplane-xxxxxxxxx-xxxxx                    1/1     Running     0          XdXXh
crossplane-package-manager-xxxxxxxxxx-xxxxx   1/1     Running     0          XdXXh
provider-aws-controller-xxxxxxxxxx-xxxxx      1/1     Running     0          XdXXh
```

If all three pods are up and running, then Crossplane and the AWS Provider are setup, if the provider pod is missing, check the [Known Issues](#known-issues) section

## Running Quay

In order to get Quay up and running you will need to run `make quay`. This will create the compositions, requirements, Quay Operator, and eventually the QuayEcosystem CR. You can validate this is working by looking at the AWS console where you will see that Redis, S3 and Postgres are being launched. If you do not see any of these, refer to [Known Issues](##Known-Issues).

Once all the dependencies have been created, the script will create the Quay Operator. After this point you can refer to the steps from the offical [Quay Operator docs](https://access.redhat.com/documentation/en-us/red_hat_quay/3.3/html/deploy_red_hat_quay_on_openshift_with_quay_operator/deploying_red_hat_quay#deploy_a_red_hat_quay_ecosystem).

### Verifying Dependency Status

Similar to the previous, ensure you have a second shell up before running `make quay`. The setup scripts will first create each of the compositions, these are the abstractions which wrap the cloud infrastructure resources. After this, each requirement will be created, and the script will block until they are finish. In your 2nd shell, you can validate this behaviour:

```
$ oc get s3bucket
NAME                     READY   SYNCED   PREDEFINED-ACL   LOCAL-PERMISSION   AGE
s3buckettestquayredhat   True    True     private          ReadWrite          20s
$ oc get rdsinstance
NAME                READY   SYNCED   STATE       ENGINE     VERSION   AGE
my-db-x8jvx-glclx   False   False    creating    postgres   9.6       26s
$ oc get replicationgroup
NAME                   READY   SYNCED   STATE      VERSION   AGE
my-redis-m6lw6-zpk8v   False   True     creating   5.0.6     38s
```

Typically the S3 Bucket will finish completing first, followed by the Redis Cluster (replicationgroup) and then the Postgres Instance (rdsinstance). There is a slight delay between the creation of each resource and when the script signifies the resource is complete, this is because Crossplane takes a few seconds longer to create and propogate the secret.

Each resource will populate a secret in the target namespace, the contents of each secret contains the information necessary for the Quay Operator to connect and use the resource.

```
$ oc get secrets -n $NAMESPACE
bucket-conn           connection.crossplane.io/v1alpha1     3      XmXXs
db-conn               connection.crossplane.io/v1alpha1     6      XmXXs
redis-conn            connection.crossplane.io/v1alpha1     2      XmXXs
```

At this point all the dependencies have been created, and the Makefile will begin to create the Quay Operator, and the `QuayEcosystem` resource. The Operator is typically created fairly quickly, it is easiest to validate from the Openshift interface.

First the operator will come up, followed by the `quay-config` pod and then the `quay` pod.

![pods](https://github.com/krishchow/crossplane-quay/blob/master/imgs/pods.png?raw=true)

Next, we can see the different routes in Openshift.

![routes](https://github.com/krishchow/crossplane-quay/blob/master/imgs/routes.png?raw=true)

By going to the endpoint listed in the route, we can access the Quay instance.

![quay](https://github.com/krishchow/crossplane-quay/blob/master/imgs/quay.png?raw=true)

TL;DR - You will see the pods come up in the target name space, once the quay-config and quay-pods are up, you can navigate to the Networking section in the left navbar and find the Route/URL for the Quay instance.

## Clean Up

When you are done with the quay instance, you need to delete the contents of the S3 Bucket via the AWS Console. Then you can run `make clean` which will delete Quay and all the dependencies (Quay, Redis, Postgres). This will leave the compositions, crossplane and the aws provider installed. You can delete everything by running `make clean-all` or `make clean-crossplane` based on what is most appropiate for your needs.

## Known Issues

Currently it seems like there is an issue with deploying the AWS provider. The deployment will fail to create any pods citing an invaldi fsGroup. The current fix for this requires editing the YAML for the deployment and removing the offending line (typically line 62) under the securityContext.fsGroup.

An issue has been opened on the upstream [provider-aws](https://github.com/crossplane/provider-aws/issues/316).

In order to delete the dependencies, you will need to empty the S3 Bucket manually via the AWS console. You cannot delete a bucket that has objects in it, so Crossplane will not be able to delete that CR or Bucket. It does not seem like there is a simple work around for this issue.

If the health check probe for the quay pod fails, then it is likely that the cluster isn't powerful enough to support the Quay instance. It is reccomended that you clean up the current cluster and try again with a more powerful cluster. For example, CRCs and Minikube/Kind will often not be powerful enough.

## Future Work

- Allowing for dynamically created VPCs/IGWs, currently we required that the user passes in a VPC ID and IGW ID.
- Support for VPC Peering, one potential method may use [Submariner](https://github.com/submariner-io/submariner)

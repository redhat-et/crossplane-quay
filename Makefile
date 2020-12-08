quay:
	oc apply -f manifests/requirements.yaml

crossplane:
	./scripts/crossplane.sh

provider:
	./scripts/provider.sh

compositions:
	./scripts/compositions.sh

clean-compositions:
	oc delete -f manifests/requirements.yaml
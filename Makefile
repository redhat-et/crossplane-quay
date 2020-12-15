quay:
	oc apply -f manifests/requirements.yaml

crossplane:
	./scripts/crossplane.sh

provider:
	./scripts/provider.sh

compositions:
	./scripts/compositions.sh

clean:
	oc delete -f manifests/requirements.yaml

catalog:
	oc apply -f manifests/catalog.yaml
	oc apply -f manifests/quay-secret.yaml
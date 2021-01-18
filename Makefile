crossplane:
	./scripts/crossplane.sh

provider:
	./scripts/provider.sh

.PHONY: configuration

configuration:
	./scripts/configuration.sh

catalog:
	kubectl create namespace olm || true
	kubectl apply -f manifests/catalog.yaml
	kubectl apply -f manifests/quay-secret.yaml

quay:
	oc apply -f manifests/requirements.yaml

watch:
	./scripts/watch.sh

clean:
	kubectl delete -f manifests/requirements.yaml
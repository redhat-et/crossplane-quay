
all: build crossplane provider quay

build:
	cd helm; helm template . --output-dir output

quay: dependencies prepquay
	oc apply -f helm/output/quay-cp/templates/quay.yaml

prepquay:
	./quay/setup_quay.sh

crossplane:
	./scripts/crossplane.sh

provider:
	./scripts/provider.sh

compositions:
	./scripts/compositions.sh

dependencies: compositions
	./make_dependencies.sh

clean-resources:
	oc delete -f helm/output/quay-cp/templates/requirements.yaml

clean-quay:
	oc delete -f helm/output/quay-cp/templates/quay.yaml

clean: clean-quay clean-resources

clean-all: clean-quay
	./quay/teardown_quay.sh
	./force_clean.sh
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

compositions: build
	./scripts/compositions.sh

dependencies: compositions
	./make_dependencies.sh

clean-compositions:
	oc delete -f helm/output/quay-cp/templates/compositions

clean-dependencies:
	oc delete -f helm/output/quay-cp/templates/requirements.yaml

clean-quay:
	oc delete -f helm/output/quay-cp/templates/quay.yaml&
	./quay/teardown_quay.sh&

clean: clean-quay clean-dependencies

clean-crossplane:
	./force_clean.sh

clean-all: clean-quay
	./force_clean.sh
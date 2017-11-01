oe/README:  .repo/manifest.xml
	./bin/repo sync -j3

sync:  .repo/manifest.xml
	./bin/repo sync -j3

.repo/manifest.xml: bin/repo
	./bin/repo init -u . -m manifests/default.xml -b $(shell git rev-parse --abbrev-ref HEAD)

bin/repo:
	wget https://storage.googleapis.com/git-repo-downloads/repo -O bin/repo
	chmod a+x bin/repo

clean:
	git clean -fXd

bump_version:
	$(eval release_version := $(shell git describe --tags --always)) 
	@echo "Version bumped to: "$(release_version)
	@sed -i 's/DISTRO_VERSION = .*/DISTRO_VERSION = "$(release_version)"/' conf/local.conf 
	@sed -i 's/MENDER_ARTIFACT_NAME = .*/MENDER_ARTIFACT_NAME = "$(release_version)"/' conf/local.conf

.PHONY: clean sync

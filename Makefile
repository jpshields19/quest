plan:
	terraform -chdir=terraform/ plan

apply:
	terraform -chdir=terraform/ apply

diff:
	helmfile -f helmfiles/quest.yaml --selector release=quest diff upgrade

deploy:
	helmfile -f helmfiles/quest.yaml --selector release=quest sync
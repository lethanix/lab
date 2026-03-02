.PHONY: start-ls stop-ls bootstrap deploy destroy up down logs health synth diff clean

CONTAINER_NAME="localstack"

start-ls:
	./scripts/start.sh
	@echo "Waiting for LocalStack to be ready..."
	@until curl -s http://localhost:4566/_localstack/health | grep -q '"pro"'; do \
		sleep 2; \
		echo "  ...waiting"; \
	done
	@echo "LocalStack is ready."

stop-ls:
	sudo podman stop $$CONTAINER_NAME && sudo podman rm $$CONTAINER_NAME

bootstrap:
	cdklocal bootstrap 

deploy:
	cdklocal deploy --require-approval never 

destroy:
	cdklocal destroy --force 

synth:
	cdklocal synth 

diff:
	cdklocal diff 

up: start-ls bootstrap deploy

down: destroy stop-ls

logs:
	sudo podman logs -f $$CONTAINER_NAME 

health:
	curl -s http://localhost:4566/_localstack/health | python3 -m json.tool

clean:
	rm -rf cdk.out 

all: devbox

.PHONY: devbox run

devbox:
	docker build --pull -t devbox .

run:
	docker run -it --rm devbox

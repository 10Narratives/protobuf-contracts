PROTO_DIR=contracts/
PROTO_OUT_DIR=generated/go
GOOGLEAPIS=/tmp/googleapis
PGV_DIR=/tmp/protoc-gen-validate

clean:
	@echo "Cleaning generated protobuf files..."
	@rm -rf $(PROTO_OUT_DIR)

install:
	@echo "Installing dependencies..."
	@go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
	@go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
	@go install github.com/envoyproxy/protoc-gen-validate@latest

deps:
	@[ -d $(GOOGLEAPIS) ] || git clone https://github.com/googleapis/googleapis.git     $(GOOGLEAPIS)
	@[ -d $(PGV_DIR) ] || git clone https://github.com/envoyproxy/protoc-gen-validate.git     $(PGV_DIR)

generate: clean install deps
	@echo "Generating files..."
	@mkdir -p $(PROTO_OUT_DIR)
	protoc -I$(PROTO_DIR) \
			-I$(GOOGLEAPIS) \
			-I$(PGV_DIR) \
		$(PROTO_DIR)order-tracker/v1/*.proto \
		--go_out=$(PROTO_OUT_DIR) --go_opt=paths=source_relative \
		--go-grpc_out=$(PROTO_OUT_DIR) --go-grpc_opt=paths=source_relative \
		--validate_out="lang=go,paths=source_relative:$(PROTO_OUT_DIR)"

.PHONY: clean install deps generate
APP        := micah
TARGET     := dark-matter

export CGO_CXXFLAGS_ALLOW:=.*
export CGO_LDFLAGS_ALLOW:=.*
export CGO_CFLAGS_ALLOW:=.*
# 跨平台开发，设置交叉编译
#export GOOS=linux
#export GOARCH=amd64

.PHONY: all test clean

all: build
check:
ifeq ($(strip $(BK_CI_PIPELINE_NAME)),)
	@echo "\033[32m <============== 合法性校验 app ${app} =============> \033[0m"
	goimports -format-only -w -local micah.wiki .
	gofmt -s -w .
	golangci-lint run
endif

build:
	@echo "\033[32m <============== making app ${app} =============> \033[0m"
	go build -ldflags='-w -s' $(FLAGS) -o ./${TARGET} ./cmd

unit-test: $(DEPENDENCIES)
	@echo -e "\033[32m ============== making unit test =============> \033[0m"
	go test `go list ./... |grep -v api_test` -v -run='^Test' -covermode=count -gcflags=all=-l ./...

clean:
	@echo -e "\033[32m ============== cleaning files =============> \033[0m"
	rm -fv ${TARGET}
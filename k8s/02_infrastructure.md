### Installation of kubectl
Download the kubectl Executable

Download `kubectl` from the Kubernetes release artifact site with the curl tool.

The linux kubectl binary can be fetched with a command like:

```
curl -O https://storage.googleapis.com/kubernetes-release/release/v1.4.0/bin/linux/amd64/kubectl
```
On an OS X workstation, replace linux in the URL above with darwin:
```
curl -O https://storage.googleapis.com/kubernetes-release/release/v1.3.6/bin/darwin/amd64/kubectl
```
After downloading the binary, ensure it is executable and move it into your PATH:

```
chmod +x kubectl
mv kubectl /usr/local/bin/kubectl
```

---

### minikube

The generic download path is: 
https://storage.googleapis.com/kubernetes-release/release/${K8S_VERSION}/bin/${GOOS}/${GOARCH}/${K8S_BINARY}

On an OS X workstation:
```
curl -Lo minikube https://storage.googleapis.com/minikube/releases/v0.11.0/minikube-darwin-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/
```
On Linux:
```
curl -Lo minikube https://storage.googleapis.com/minikube/releases/v0.11.0/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/
```
Feel free to leave off the sudo mv minikube /usr/local/bin if you would like to add minikube to your path manually.

----

### Start minikube  
`minikube start`
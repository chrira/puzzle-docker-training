### OpenShift local dev
Developers have a lot of choices when deciding how to start using OpenShift and Kubernetes locally — without going through a native OS installation.

----

### oc cluster up
There’s a new feature that was introduced in OpenShift Origin 1.3 and Enterprise 3.3, this option downloads a containerized version of OpenShift and execute it locally.

Given that it executes OpenShift in a container, the only requirement needed, besides the oc 1.3.x+ CLI, is to have a docker daemon running. This command will start a local OpenShift instance:
```
oc cluster up --create-machine=true   \
                --use-existing-config   \
                --host-data-dir=/mydata \
                --metrics=true
```

----

“oc cluster up” also allows you to try Openshift Container Platform (previously called OpenShift Enterprise)  by specifying Red Hat registry and the proper image and version. Example:

```
oc cluster up --create-machine=true   \
                --use-existing-config   \
                --host-data-dir=/mydata \
                --metrics=true          \
                --image=registry.access.redhat.com/openshift3/ose \
                --version=latest
```
Both methods creates a ~/.kube/config file that allows you also to use the kubectl command to interact with the Kubernetes cluster on which OpenShift is running on.

----

### Minishift

To provide a seamless experience to people who are already familiarized with Minikube, Jimmi Dyson from Red Hat, created a project  called Minishift https://github.com/jimmidyson/minishift.

```
minishift start --cpus=2 --deploy-router=true --memory=2048
```

----

### All-In-One Virtual Machine

The OpenShift community also provides a “All-In-One Virtual Machine”.  It’s essentially a Vagrant file that will automatically download and execute a VirtualBox VM image. Two commands and you will have an Openshift cluster running:

```
vagrant init openshift/origin-all-in-one
vagrant up --provider=virtualbox
```

Note that  this option only supports VirtualBox at this moment.

----

### CDK

CDK means Container Development Kit. Just like the “All-In-One Virtual Machine”, it’s a Vagrant file that support different providers (VirtualBox, HyperV and libvirt). The provided image runs OpenShift Enterprise (OSE).

You can download CDK from http://developers.redhat.com/products/cdk/download/. 

Start CDK:
```
vagrant up
````

----

### Conclusion

Among these options, CDK and “oc cluster up”  are the only two options that allow the developer to execute the enterprise version of Openshift.


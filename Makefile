start:
	chmod +x pre-run.sh
	./pre-run.sh

clean:
	echo Deletes all local Kubernetes cluster. This command deletes the VM, and removes all associated files.
	minikube stop
	minikube delete --all

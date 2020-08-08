set -e
# TODO: Check gCloud has the cluster. If present then delete.
TRANSLATOR=`kubectl config get-contexts -o name | grep translator`
echo "To Delete-" $TRANSLATOR
if [ -z $TRANSLATOR ]; then
	echo "No clusters to delete"
else
	# gke_translator-258700_us-central1-f_translator3
	kubectl config delete-cluster $TRANSLATOR
	kubectl config delete-context $TRANSLATOR
fi
# kubectl config delete-cluster gke_translator-258700_us-central1-f_translator3
# deleted cluster gke_translator-258700_us-central1-f_translator3 from /Users/maheshrajannan/.kube/config
yes | gcloud container clusters delete translator3
echo "Successfully deleted gCloud Cluster"
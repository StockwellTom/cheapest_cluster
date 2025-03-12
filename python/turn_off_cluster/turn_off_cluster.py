from azure.identity import DefaultAzureCredential
from azure.mgmt.containerservice import ContainerServiceClient

# Initialize the credential and client
credential = DefaultAzureCredential()
subscription_id = "<YourSubscriptionId>"
resource_group = "<YourResourceGroupName>"
cluster_name = "<YourClusterName>"

# Create a ContainerServiceClient
client = ContainerServiceClient(credential, subscription_id)

# Stop the AKS cluster
client.managed_clusters.begin_stop(resource_group, cluster_name)
print(f"Cluster {cluster_name} in resource group {resource_group} is stopping.")
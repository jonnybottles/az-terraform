# Azure Terraform Scripts

This project consists of a series of Terraform scripts to automate the buildout of Azure environments. A description of each set of scripts is as follows:

## Create Azure Resource Group:

These Terraform scripts are designed to create a new Azure Resource Group using a service principal for authentication.

### Pre-Conditions to Run Any of the Scripts in this Project

1. **Azure Subscription**: You must have an active Azure subscription.
2. **Service Principal**: A service principal with sufficient permissions to manage resources in your Azure subscription.
3. **Azure Key Vault**: Store the service principal credentials (client ID, client secret, tenant ID) in an Azure Key Vault.
4. **Terraform**: Terraform must be installed on your local machine.

### Instructions for all Terraform Scripts

1. Clone this repo to your local machine.
2. Change directories to the desired Terraform script directory (e.g., `create_azure_resource_group`).
3. Rename the `terraform.tfvars.template` file in that directory to `terraform.tfvars`.
4. Assign the appropriate values to each variable in the `terraform.tfvars` file.
5. Run the Terraform commands below:

### Terraform Commands

1. **Initialize the Terraform working directory**:
   ```sh
   terraform init
2. **Validate the Configuration**:
   ```sh
   terraform validate
3. **Generate and Show Execution Plan**:
      ```sh
   terraform plan -out=tfplan
4. **Apply the changes required to reach the desired state of the configuration**:
      ```sh
   terraform apply tfplan
5. **(Optional) Destroy the infrastructure**:
      ```sh
   terraform destroy

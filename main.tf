# ------- Root/main.tf -----

module "networking" {
    source = "./modules/networking"
    vpc_cidr = "10.0.0.0/16"
    public_sn_count = 2
    private_app_sn_count = 2
    private_data_sn_count = 2
    public_cidrs = [for i in range(2, 11, 2) : cidrsubnet("10.0.0.0/16", 8, i)]
    private_cidrs = [for i in range(1, 10, 2) : cidrsubnet("10.0.0.0/16", 8, i)]
    private_data_cidrs = [for i in range(12, 15, 1) : cidrsubnet("10.0.0.0/16", 8, i)]
}
module "dev" {
  source = "./modules/infra"

  name = "youtube"
  #network settings
  vpc_cidr = "10.0.0.0/16"
  private_subnets = ["10.0.10.0/24", "10.0.20.0/24", "10.0.30.0/24"]
  public_subnets = ["10.0.60.0/24", "10.0.70.0/24", "10.0.80.0/24"]
  
  #Server settings
  create_key_pair = true
  public_server_count  = 0 #no public server
  private_server_count = 1

  tags = {
    "Environment" = "dev"
  }
}

module "github" {
  source = "github.com/davejfranco/youtube-tf-infra"

  name = "github"
  #network settings
  vpc_cidr = "10.0.0.0/16"
  private_subnets = ["10.0.10.0/24", "10.0.20.0/24", "10.0.30.0/24"]
  public_subnets = ["10.0.60.0/24", "10.0.70.0/24", "10.0.80.0/24"]
  
  #Server settings
  create_key_pair = true
  public_server_count  = 0 #no public server
  private_server_count = 1

  tags = {
    "Environment" = "demo"
  }
}